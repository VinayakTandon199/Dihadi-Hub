const express = require('express');
const router = express.Router();
const db = require('../config/db');
const path = require('path');
const PDFDocument = require('pdfkit');

function isClient(req, res, next) {
    if (!req.session.user) {
        return res.redirect('/?error=Please login first');
    }
    if (req.session.user.role !== 'client') {
        return res.redirect('/?error=Unauthorized access');
    }
    next();
}

function runQuery(query, values = []) {
    return new Promise((resolve, reject) => {
        db.query(query, values, (err, results) => {
            if (err) {
                return reject(err);
            }
            return resolve(results);
        });
    });
}

router.get('/agencies', (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ error: 'Unauthorized' });
    }

    const { type } = req.query;
    let query = `
        SELECT
            a.user_id,
            a.name,
            a.type,
            a.contact,
            a.address,
            a.work_shift
        FROM agency a
        JOIN users u ON a.user_id = u.id
    `;

    const values = [];
    if (type && String(type).trim() !== '') {
        query += ' WHERE LOWER(a.type) = LOWER(?)';
        values.push(String(type).trim());
    }

    db.query(query, values, (err, results) => {
        if (err) {
            console.error('Fetch agencies error:', err.message);
            return res.status(500).json({ error: 'Failed to fetch agencies' });
        }

        return res.json(results || []);
    });
});

router.get('/dashboard', isClient, (req, res) => {
    const userId = req.session.user.id;

    // Step 1: Get client profile
    const clientQuery = `
        SELECT c.*, u.username 
        FROM client c 
        JOIN users u ON c.user_id = u.id 
        WHERE c.user_id = ?
    `;

    db.query(clientQuery, [userId], (err, clientResults) => {
        if (err) {
            console.error('Client profile error:', err.message);
            return res.status(500).json({ error: 'Failed to load client profile' });
        }

        const clientProfile = clientResults[0] || { username: req.session.user.username };

        // Step 2: Get active contracts
        const contractQuery = `
    SELECT
        ct.*,
        a.name AS agency_name,
        a.contact AS agency_contact,
        a.contact AS contact_number,
        a.type AS agency_type,
        u.username AS agency_username
    FROM contracts ct
    JOIN agency a ON ct.agency_id = a.user_id
    JOIN users u ON ct.agency_id = u.id
    WHERE ct.client_id = ? AND ct.status = 'active'
    ORDER BY ct.id DESC
`;

        db.query(contractQuery, [7], (err, contractResults) => {
            if (err) {
                console.error('Contracts error:', err.message);
                return res.status(500).json({ error: 'Failed to load contracts' });
            }

            if (contractResults.length === 0) {
                // No contracts - return early with empty data
                return res.json({
                    client: clientProfile,
                    contracts: [],
                    notifications: []
                });
            }

            // Step 3: Fetch deployed staff per contract
            let contractsProcessed = 0;
            const contractsWithStaff = [];

            contractResults.forEach((contract) => {
                const deployedStaffQuery = `
                    SELECT s.id, s.name, s.contact, cs.salary, s.experience
                    FROM staff s
                    JOIN contract_staff cs ON s.id = cs.staff_id
                    WHERE cs.contract_id = ?
                `;

                db.query(deployedStaffQuery, [contract.id], (staffErr, deployedStaffRows) => {
                    if (staffErr) {
                        console.error('Staff error:', staffErr.message);
                    }

                    const deployedStaff = Array.isArray(deployedStaffRows)
                        ? deployedStaffRows.map((row) => ({
                            id: row.id,
                            name: row.name || 'N/A',
                            contact: row.contact || 'N/A',
                            salary: row.salary ?? 'N/A',
                            experience: row.experience ?? 'N/A'
                        }))
                        : [];

                    contractsWithStaff.push({
                        ...contract,
                        deployedStaff,
                        staff: deployedStaff,
                        staff_members: deployedStaff,
                        staffList: deployedStaff
                    });

                    contractsProcessed++;
                    if (contractsProcessed !== contractResults.length) {
                        return;
                    }

                    // Step 4: Get notifications
                    const notifQuery = `
                        SELECT * FROM notifications
                        WHERE user_id = 7
                          AND is_read = FALSE
                          AND message NOT LIKE 'New contract request received%'
                          AND (
                            LOWER(message) LIKE '%accepted%'
                            OR LOWER(message) LIKE '%deployed%'
                          )
                        ORDER BY created_at DESC
                    `;

                    db.query(notifQuery, [], (notifErr, notifResults) => {
                        if (notifErr) {
                            console.error('Notifications error:', notifErr.message);
                            notifResults = [];
                        }

                        return res.json({
                            client: clientProfile,
                            contracts: contractsWithStaff,
                            notifications: notifResults
                        });
                    });
                });
            });
        });
    });
});

router.get('/notifications', isClient, async (req, res) => {
    try {
        const sessionUserId = req.session.user_id || req.session.user?.id;
        if (sessionUserId != 7) {
            return res.status(403).json({ success: false, message: 'Unauthorized' });
        }

        const notifications = await runQuery(
            `SELECT * FROM notifications
             WHERE user_id = 7
               AND message NOT LIKE 'New contract request received%'
               AND (
                 LOWER(message) LIKE '%accepted%'
                 OR LOWER(message) LIKE '%deployed%'
               )
             ORDER BY created_at DESC`
        );

        return res.json(notifications || []);
    } catch (err) {
        return res.status(500).json({ success: false, message: err.message });
    }
});

router.post('/attendance/mark', isClient, async (req, res) => {
    try {
        const { contract_id, staff_id, date, status } = req.body;

        if (status !== 'present' && status !== 'absent') {
            return res.json({ success: false, message: "status must be either 'present' or 'absent'" });
        }

        const dateStr = String(date || '');
        const d = new Date(dateStr);
        if (Number.isNaN(d.getTime())) {
            return res.json({ success: false, message: 'Invalid date format. Use YYYY-MM-DD.' });
        }

        const month = d.getMonth() + 1;
        const year = d.getFullYear();
        const staffId = Number(staff_id);

        if (
            Number.isNaN(month) || Number.isNaN(year) || Number.isNaN(staffId)
        ) {
            return res.json({ success: false, message: 'Invalid date or staff ID value.' });
        }

        console.log('Marking Attendance:', dateStr, status);

        await runQuery(
            `INSERT INTO attendance (staff_id, contract_id, date, status, month, year)
             VALUES (?, ?, ?, ?, ?, ?)
             ON DUPLICATE KEY UPDATE status = VALUES(status)`,
            [staffId, contract_id, dateStr, status, month, year]
        );

        return res.json({ success: true, message: 'Attendance marked' });
    } catch (err) {
        return res.json({ success: false, message: err.message });
    }
});

router.get('/attendance/:contract_id/:staff_id/:month/:year', isClient, (req, res) => {
    const contractId = Number(req.params.contract_id);
    const staffId = Number(req.params.staff_id);
    const month = Number(req.params.month);
    const year = Number(req.params.year);

    if (!Number.isInteger(contractId) || !Number.isInteger(staffId) || !Number.isInteger(month) || !Number.isInteger(year)) {
        return res.status(400).json({ success: false, message: 'Invalid Staff ID' });
    }

    const attQuery = `
        SELECT * FROM attendance 
        WHERE contract_id = ? AND staff_id = ? AND month = ? AND year = ?
    `;

    db.query(attQuery, [contractId, staffId, month, year], (err, attResults) => {
        if (err) {
            console.error('Attendance fetch error:', err.message);
            return res.status(500).json({ success: false, message: err.message });
        }

        if (!Array.isArray(attResults) || attResults.length === 0) {
            return res.status(200).json([]);
        }

        const salaryQuery = `
            SELECT per_day_salary FROM contract_staff 
            WHERE contract_id = ? AND staff_id = ?
            LIMIT 1
        `;

        db.query(salaryQuery, [contractId, staffId], (err, salaryResults) => {
            if (err) {
                console.error('Salary fetch error:', err.message);
                return res.status(500).json({ success: false, message: err.message });
            }

            const perDaySalary = salaryResults.length > 0 ? 
                parseFloat(salaryResults[0].per_day_salary) : 0;

            const presentDays = attResults.filter(a => a.status === 'present').length;
            const absentDays = attResults.filter(a => a.status === 'absent').length;
            const baseSalary = presentDays * perDaySalary;
            let deduction = 0;
            if (absentDays >= 2) deduction += Math.floor(absentDays / 2) * perDaySalary;
            if (absentDays > 8) deduction += 1000;
            const totalSalary = baseSalary - deduction;

            return res.json({
                attendance: attResults,
                presentDays,
                absentDays,
                baseSalary,
                deduction,
                totalSalary,
                perDaySalary
            });
        });
    });
});

router.post('/contract/request', async (req, res) => {
    try {
        console.log('New Request Body:', req.body);

        if (!req.session.user) {
            return res.status(401).json({ success: false, message: 'Unauthorized' });
        }

        const sessionUserId = req.session.user_id || req.session.user.id;
        if (sessionUserId != 7) {
            return res.status(403).send('Only client2 can send requests for now');
        }

        const clientId = req.session.user.id;
        const fixedAgencyId = 10;
        const {
            staff_type,
            staff_count,
            min_age,
            max_salary,
            address,
            is_permanent,
            start_date,
            end_date
        } = req.body;

        const normalizedEndDate = is_permanent ? null : (end_date || null);
        const normalizedWorkShift = 'morning';

        await runQuery(
            `INSERT INTO contract_requests (
                client_id,
                agency_id,
                staff_type,
                staff_count,
                min_age,
                max_salary,
                work_shift,
                address,
                is_permanent,
                start_date,
                end_date,
                status
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending')`,
            [
                clientId,
                fixedAgencyId,
                staff_type,
                staff_count,
                min_age,
                max_salary,
                normalizedWorkShift,
                address,
                is_permanent,
                start_date,
                normalizedEndDate
            ]
        );

        await runQuery(
            'INSERT INTO notifications (user_id, message, is_read) VALUES (?, ?, FALSE)',
            [
                fixedAgencyId,
                'New contract request received from a client. Please review and deploy staff.'
            ]
        );

        return res.status(200).json({ success: true, message: 'Request submitted successfully' });
    } catch (err) {
        return res.status(500).json({ success: false, message: err.message });
    }
});

router.get('/contract/requests', async (req, res) => {
    try {
        if (!req.session.user) {
            return res.status(401).json({ error: 'Unauthorized' });
        }

        const clientId = req.session.user.id;

        const requests = await runQuery(
            `SELECT
                cr.id,
                cr.staff_type,
                cr.staff_count,
                cr.min_age,
                cr.max_salary,
                cr.work_shift,
                cr.address,
                cr.is_permanent,
                cr.start_date,
                cr.end_date,
                cr.status,
                cr.created_at,
                a.name AS agency_name,
                a.contact AS agency_contact
            FROM contract_requests cr
            JOIN agency a ON cr.agency_id = a.user_id
            WHERE cr.client_id = ?
            ORDER BY cr.created_at DESC`,
            [clientId]
        );

        return res.json(requests || []);
    } catch (err) {
        return res.status(500).json({ error: err.message });
    }
});

router.post('/client/contract/dismiss', isClient, async (req, res) => {
    try {
        const { contract_id } = req.body;

        const existingRequest = await runQuery(
            "SELECT * FROM dismiss_requests WHERE contract_id = ? AND status = 'pending'",
            [contract_id]
        );

        if (existingRequest.length > 0) {
            return res.json({ success: false, message: 'Dismiss request already sent' });
        }

        await runQuery(
            'INSERT INTO dismiss_requests (contract_id, requested_by) VALUES (?, ?)',
            [contract_id, req.session.user.id]
        );

        const contractRows = await runQuery(
            'SELECT agency_id FROM contracts WHERE id = ? LIMIT 1',
            [contract_id]
        );

        if (contractRows.length > 0) {
            await runQuery(
                'INSERT INTO notifications (user_id, message) VALUES (?, ?)',
                [contractRows[0].agency_id, 'Client has requested to dismiss contract #' + contract_id]
            );
        }

        return res.json({ success: true, message: 'Dismiss request sent to agency' });
    } catch (err) {
        return res.status(500).json({ success: false, message: err.message });
    }
});

router.post('/client/notifications/read', isClient, async (req, res) => {
    try {
        const { notification_id } = req.body;

        await runQuery(
            'UPDATE notifications SET is_read = TRUE WHERE id = ? AND user_id = ?',
            [notification_id, req.session.user.id]
        );

        return res.json({ success: true });
    } catch (err) {
        return res.status(500).json({ success: false, message: err.message });
    }
});

router.post('/notifications/mark-read/:id', isClient, async (req, res) => {
    try {
        const notificationId = Number(req.params.id);

        if (!Number.isInteger(notificationId) || notificationId <= 0) {
            return res.status(400).json({ success: false, message: 'Invalid notification id' });
        }

        const result = await runQuery(
            'UPDATE notifications SET is_read = TRUE WHERE id = ? AND user_id = ?',
            [notificationId, req.session.user.id]
        );

        if (!result.affectedRows) {
            return res.status(404).json({ success: false, message: 'Notification not found' });
        }

        return res.json({ success: true });
    } catch (err) {
        return res.status(500).json({ success: false, message: err.message });
    }
});

router.get('/marketplace/items', isClient, async (req, res) => {
    try {
        const { category } = req.query;

        let query = 'SELECT * FROM marketplace_items';
        const values = [];

        if (category && String(category).trim() !== '') {
            query += ' WHERE category = ?';
            values.push(String(category).trim());
        }

        query += ' ORDER BY id DESC';

        const items = await runQuery(query, values);
        return res.json(items || []);
    } catch (err) {
        console.error('Marketplace items fetch error:', err.message);
        return res.status(500).json({ success: false, message: 'Failed to fetch marketplace items' });
    }
});

router.post('/marketplace/order', isClient, (req, res) => {
    try {
        const connection = db;
        const clientId = req.session.user.id;
        const { items, total_price, store_type } = req.body;

        if (!Array.isArray(items) || items.length === 0) {
            return res.status(400).json({ success: false, message: 'items must be a non-empty array' });
        }

        if (total_price === undefined || total_price === null || !store_type) {
            return res.status(400).json({ success: false, message: 'total_price and store_type are required' });
        }

        const deliveryOptions = ['25 minutes', '35 minutes', '45 minutes', '55 minutes'];
        const delivery_time = deliveryOptions[Math.floor(Math.random() * deliveryOptions.length)];

        connection.beginTransaction((beginErr) => {
            if (beginErr) {
                console.error(beginErr);
                console.error('Marketplace order transaction begin error:', beginErr.message);
                return res.status(500).json({ success: false, message: 'Failed to start order transaction' });
            }

            const orderQuery = `
                INSERT INTO marketplace_orders (client_id, total_price, store_type, delivery_time)
                VALUES (?, ?, ?, ?)
            `;

            connection.query(orderQuery, [clientId, total_price, store_type, delivery_time], (orderErr, orderResult) => {
                if (orderErr) {
                    return connection.rollback(() => {
                        console.error(orderErr);
                        console.error('Marketplace order insert error:', orderErr.message);
                        return res.status(500).json({ success: false, message: 'Failed to create order' });
                    });
                }

                const orderId = orderResult.insertId;

                const normalizedItems = items.map((item) => ({
                    item_id: Number(item.id),
                    quantity: Number(item.quantity),
                    price_at_purchase: Number(item.price)
                }));

                const invalidItem = normalizedItems.find((item) => {
                    return Number.isNaN(item.item_id) || Number.isNaN(item.quantity) || Number.isNaN(item.price_at_purchase);
                });

                if (invalidItem) {
                    return connection.rollback(() => {
                        return res.status(400).json({ success: false, message: 'Invalid item data in request' });
                    });
                }

                const itemInsertQuery = `
                    INSERT INTO order_items (order_id, item_id, quantity, price_at_purchase)
                    VALUES (?, ?, ?, ?)
                `;

                const insertItemAt = (index) => {
                    if (index >= normalizedItems.length) {
                        return connection.commit((commitErr) => {
                            if (commitErr) {
                                return connection.rollback(() => {
                                    console.error(commitErr);
                                    console.error('Marketplace order commit error:', commitErr.message);
                                    return res.status(500).json({ success: false, message: 'Failed to finalize order' });
                                });
                            }

                            return res.json({
                                success: true,
                                order_id: orderId,
                                delivery_time
                            });
                        });
                    }

                    const currentItem = normalizedItems[index];

                    connection.query(
                        itemInsertQuery,
                        [orderId, currentItem.item_id, currentItem.quantity, currentItem.price_at_purchase],
                        (itemsErr) => {
                            if (itemsErr) {
                                return connection.rollback(() => {
                                    console.error(itemsErr);
                                    console.error('Order items insert error:', itemsErr.message);
                                    return res.status(500).json({ success: false, message: 'Failed to save order items' });
                                });
                            }

                            return insertItemAt(index + 1);
                        }
                    );
                };

                return insertItemAt(0);
            });
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ success: false, message: 'Unexpected server error while placing order' });
    }
});

router.get('/marketplace/receipt/:id', isClient, async (req, res) => {
    try {
        const orderId = Number(req.params.id);
        const clientId = req.session.user?.id || req.session.user_id;

        if (!Number.isInteger(orderId) || orderId <= 0) {
            return res.status(400).json({ success: false, message: 'Invalid receipt id' });
        }

        const orderRows = await runQuery(
            `SELECT
                mo.id,
                mo.client_id,
                mo.total_price,
                mo.store_type,
                mo.delivery_time,
                mo.status,
                mo.created_at,
                u.username AS client_username
             FROM marketplace_orders mo
             JOIN users u ON mo.client_id = u.id
             WHERE mo.id = ? AND mo.client_id = ?
             LIMIT 1`,
            [orderId, clientId]
        );

        if (!orderRows.length) {
            return res.status(404).json({ success: false, message: 'Receipt not found' });
        }

        const order = orderRows[0];

        const itemRows = await runQuery(
            `SELECT
                oi.quantity,
                oi.price_at_purchase,
                mi.name,
                mi.category
             FROM order_items oi
             JOIN marketplace_items mi ON oi.item_id = mi.id
             WHERE oi.order_id = ?
             ORDER BY mi.name ASC`,
            [orderId]
        );

        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename=receipt.pdf');

        const document = new PDFDocument({ size: 'A4', margin: 42, bufferPages: true });
        document.pipe(res);

        const ink = '#101827';
        const mutedInk = '#374151';
        const line = '#D1D5DB';
        const headerBlue = '#0F2A4D';

        const formatShortDate = (dateInput) => {
            const d = new Date(dateInput);
            const day = String(d.getDate());
            const month = String(d.getMonth() + 1);
            const year = String(d.getFullYear());
            return `${day}/${month}/${year}`;
        };

        const pageLeft = 42;
        const pageRight = 553;

        document.save();
        document.fillColor('#FFFFFF');
        document.rect(0, 0, document.page.width, document.page.height).fill();
        document.restore();

        document.fillColor(ink).font('Helvetica-Bold').fontSize(11).text('FROM', pageLeft, 52);
        document.font('Helvetica').fontSize(10).fillColor(mutedInk);
        document.text('Dihadi-Hub Agency', pageLeft, 70);
        document.text('Agency Management System', pageLeft, 86);

        document.fillColor(headerBlue).font('Helvetica-Bold').fontSize(24).text('RECEIPT', 360, 52, {
            width: 193,
            align: 'right'
        });
        document.fillColor(ink).font('Helvetica').fontSize(10).text(`Receipt #: ${order.id}`, 360, 82, {
            width: 193,
            align: 'right'
        });
        document.text(`Date: ${formatShortDate(order.created_at)}`, 360, 98, {
            width: 193,
            align: 'right'
        });

        document.strokeColor(line).lineWidth(1);
        document.moveTo(pageLeft, 128).lineTo(pageRight, 128).stroke();

        document.fillColor(ink).font('Helvetica-Bold').fontSize(11).text('TO', pageLeft, 146);
        document.font('Helvetica').fontSize(10).fillColor(mutedInk);
        document.text(order.client_username || 'client2', pageLeft, 164);

        const tableTop = 206;
        const rowHeight = 26;
        const colWidths = [60, 255, 98, 98];
        const colX = [
            pageLeft,
            pageLeft + colWidths[0],
            pageLeft + colWidths[0] + colWidths[1],
            pageLeft + colWidths[0] + colWidths[1] + colWidths[2]
        ];

        document.fillColor('#F8FAFC').strokeColor(line).lineWidth(1);
        document.rect(pageLeft, tableTop, pageRight - pageLeft, rowHeight).fillAndStroke();

        document.fillColor(ink).font('Helvetica-Bold').fontSize(9);
        document.text('QTY', colX[0] + 6, tableTop + 9, { width: colWidths[0] - 12, align: 'center' });
        document.text('DESCRIPTION', colX[1] + 6, tableTop + 9, { width: colWidths[1] - 12 });
        document.text('UNIT PRICE', colX[2] + 6, tableTop + 9, { width: colWidths[2] - 12, align: 'right' });
        document.text('TOTAL', colX[3] + 6, tableTop + 9, { width: colWidths[3] - 12, align: 'right' });

        let currentY = tableTop + rowHeight;
        let subtotal = 0;

        if (!itemRows.length) {
            document.strokeColor(line).lineWidth(1);
            document.rect(pageLeft, currentY, pageRight - pageLeft, rowHeight).stroke();
            document.fillColor(mutedInk).font('Helvetica').fontSize(10).text('No items found', pageLeft + 10, currentY + 8);
            currentY += rowHeight;
        } else {
            itemRows.forEach((item) => {
                // Explicit field mapping for the white receipt template:
                // DESCRIPTION <- item.name (e.g., "Masonry Thread (90m)")
                // QTY <- item.quantity (e.g., 1)
                // UNIT PRICE <- item.price_at_purchase (e.g., 1100.00)
                // TOTAL <- quantity * unitPrice (e.g., 1100.00)
                const description = String(item.name || '');
                const quantity = Number(item.quantity || 0);
                const unitPrice = Number(item.price_at_purchase || 0);
                const lineTotal = quantity * unitPrice;
                subtotal += lineTotal;

                document.strokeColor(line).lineWidth(1);
                document.rect(pageLeft, currentY, pageRight - pageLeft, rowHeight).stroke();

                document.fillColor(mutedInk).font('Helvetica').fontSize(9);
                document.text(String(quantity), colX[0] + 6, currentY + 9, { width: colWidths[0] - 12, align: 'center' });
                document.text(description || 'Item', colX[1] + 6, currentY + 9, { width: colWidths[1] - 12 });
                document.text(unitPrice.toFixed(2), colX[2] + 6, currentY + 9, { width: colWidths[2] - 12, align: 'right' });
                document.text(lineTotal.toFixed(2), colX[3] + 6, currentY + 9, { width: colWidths[3] - 12, align: 'right' });

                currentY += rowHeight;
            });
        }

        const grandTotal = Number(order.total_price || subtotal || 0);
        let salesTax = grandTotal - subtotal;
        if (salesTax < 0) salesTax = 0;

        const summaryStartY = Math.max(currentY + 22, 590);
        const labelX = 408;
        const valueWidth = 145;

        document.fillColor(mutedInk).font('Helvetica').fontSize(10).text('Subtotal', labelX, summaryStartY, {
            width: 80,
            align: 'left'
        });
        document.text(subtotal.toFixed(2), pageRight - valueWidth, summaryStartY, {
            width: valueWidth,
            align: 'right'
        });

        document.text('Sales Tax', labelX, summaryStartY + 18, {
            width: 80,
            align: 'left'
        });
        document.text(salesTax.toFixed(2), pageRight - valueWidth, summaryStartY + 18, {
            width: valueWidth,
            align: 'right'
        });

        document.strokeColor(line).lineWidth(1);
        document.moveTo(labelX, summaryStartY + 41).lineTo(pageRight, summaryStartY + 41).stroke();

        document.fillColor(ink).font('Helvetica-Bold').fontSize(11).text('Grand Total', labelX, summaryStartY + 50, {
            width: 90,
            align: 'left'
        });
        document.text(grandTotal.toFixed(2), pageRight - valueWidth, summaryStartY + 50, {
            width: valueWidth,
            align: 'right'
        });

        document.end();
    } catch (err) {
        console.error('Marketplace receipt error:', err.message);
        return res.status(500).json({ success: false, message: 'Failed to generate receipt' });
    }
});

module.exports = router;
