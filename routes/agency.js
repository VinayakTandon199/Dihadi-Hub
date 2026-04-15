const express = require('express');
const router = express.Router();
const db = require('../config/db');

function isAgency(req, res, next) {
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'Unauthorized' });
    }

    if (req.session.user.role !== 'agency') {
        return res.status(403).json({ success: false, message: 'Forbidden' });
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

router.get('/requests', isAgency, async (req, res) => {
    try {
        const sessionAgencyId = req.session.user_id || req.session.user?.id;
        if (sessionAgencyId != 10) {
            return res.status(403).send('Unauthorized Agency');
        }

        const agencyRows = await runQuery(
            `SELECT name FROM agency WHERE user_id = ? LIMIT 1`,
            [10]
        );
        const agencyName = agencyRows[0]?.name || null;

        const requests = await runQuery(
            `SELECT cr.*, u.username AS client_name
             FROM contract_requests cr
             JOIN users u ON cr.client_id = u.id
             WHERE cr.agency_id = 10
               AND cr.status = 'pending'
             ORDER BY cr.created_at DESC`,
            []
        );

        const requestsWithAgency = (requests || []).map((requestRow) => ({
            ...requestRow,
            agency_name: agencyName
        }));

        return res.json(requestsWithAgency);
    } catch (err) {
        return res.status(500).json({ success: false, message: err.message });
    }
});

router.post('/requests/:id/accept', isAgency, async (req, res) => {
    try {
        const sessionAgencyId = req.session.user_id || req.session.user?.id;
        if (sessionAgencyId != 10) {
            return res.status(403).send('Unauthorized Agency');
        }

        const agencyId = 10;
        const requestId = Number(req.params.id);
        const { selectedStaffIds } = req.body;
        const normalizedStaffIds = [...new Set(
            (Array.isArray(selectedStaffIds) ? selectedStaffIds : [])
                .map((value) => Number(value))
                .filter((value) => Number.isInteger(value) && value > 0)
        )];

        // Validate input
        if (!normalizedStaffIds.length) {
            return res.status(400).json({ success: false, message: 'selectedStaffIds array is required and must not be empty' });
        }

        // Execute transaction
        const result = await new Promise((resolve, reject) => {
            db.beginTransaction((err) => {
                if (err) {
                    return reject(err);
                }

                // Step A: Update contract_requests status to 'accepted'
                db.query(
                    `UPDATE contract_requests SET status = 'accepted' WHERE id = ? AND agency_id = ? AND status = 'pending'`,
                    [requestId, agencyId],
                    (err, updateResult) => {
                        if (err) {
                            return db.rollback(() => reject(err));
                        }

                        if (updateResult.affectedRows === 0) {
                            return db.rollback(() => 
                                reject(new Error('Contract request not found or already processed'))
                            );
                        }

                        // Step B: Fetch request details
                        db.query(
                            `SELECT client_id, staff_type, staff_count, is_permanent, start_date, end_date 
                             FROM contract_requests WHERE id = ?`,
                            [requestId],
                            (err, requestRows) => {
                                if (err) {
                                    return db.rollback(() => reject(err));
                                }

                                if (requestRows.length === 0) {
                                    return db.rollback(() => 
                                        reject(new Error('Request details not found'))
                                    );
                                }

                                const requestRow = requestRows[0];
                                if (normalizedStaffIds.length !== Number(requestRow.staff_count || 0)) {
                                    return db.rollback(() =>
                                        reject(new Error(`Please select exactly ${requestRow.staff_count} staff members`))
                                    );
                                }

                                // Step C: Insert new contract
                                db.query(
                                    `INSERT INTO contracts (client_id, agency_id, staff_type, staff_count, start_date, end_date, is_permanent, status)
                                     VALUES (?, ?, ?, ?, ?, ?, ?, 'active')`,
                                    [
                                        requestRow.client_id,
                                        agencyId,
                                        requestRow.staff_type,
                                        requestRow.staff_count,
                                        requestRow.start_date,
                                        requestRow.end_date,
                                        requestRow.is_permanent ? 1 : 0
                                    ],
                                    (err, contractResult) => {
                                        if (err) {
                                            return db.rollback(() => reject(err));
                                        }

                                        const contractId = contractResult.insertId;

                                        // Step D: Process each staff member
                                        let staffProcessed = 0;

                                        normalizedStaffIds.forEach((staffId) => {
                                            db.query(
                                                `SELECT id, expected_salary FROM staff WHERE id = ? AND agency_id = ? LIMIT 1`,
                                                [staffId, agencyId],
                                                (err, staffRows) => {
                                                    if (err) {
                                                        return db.rollback(() => reject(err));
                                                    }

                                                    if (staffRows.length === 0) {
                                                        return db.rollback(() => 
                                                            reject(new Error(`Staff member with ID ${staffId} not found`))
                                                        );
                                                    }

                                                    const staffRow = staffRows[0];

                                                    db.query(
                                                        `INSERT INTO contract_staff (contract_id, staff_id, salary)
                                                         VALUES (?, ?, ?)`,
                                                        [contractId, staffRow.id, staffRow.expected_salary],
                                                        (err) => {
                                                            if (err) {
                                                                return db.rollback(() => reject(err));
                                                            }

                                                            staffProcessed++;

                                                            // All staff processed, create notification
                                                            if (staffProcessed === normalizedStaffIds.length) {
                                                                // Step E: Create notification
                                                                db.query(
                                                                    `INSERT INTO notifications (user_id, message, is_read) VALUES (?, ?, FALSE)`,
                                                                    [
                                                                        requestRow.client_id,
                                                                        `Your contract request for ${requestRow.staff_type} has been accepted!`
                                                                    ],
                                                                    (err) => {
                                                                        if (err) {
                                                                            return db.rollback(() => reject(err));
                                                                        }

                                                                        // Commit transaction
                                                                        db.commit((err) => {
                                                                            if (err) {
                                                                                return db.rollback(() => reject(err));
                                                                            }
                                                                            resolve({
                                                                                success: true,
                                                                                contractId: contractId,
                                                                                staffCount: normalizedStaffIds.length
                                                                            });
                                                                        });
                                                                    }
                                                                );
                                                            }
                                                        }
                                                    );
                                                }
                                            );
                                        });
                                    }
                                );
                            }
                        );
                    }
                );
            });
        });

        return res.json({ success: true, message: 'Request accepted successfully and staff deployed', data: result });
    } catch (err) {
        return res.status(500).json({ success: false, message: err.message });
    }
});

router.post('/requests/:id/reject', isAgency, async (req, res) => {
    try {
        const requestId = Number(req.params.id);

        const result = await runQuery(
            `UPDATE contract_requests SET status = 'rejected' WHERE id = ?`,
            [requestId]
        );

        if (!result.affectedRows) {
            return res.status(404).json({ success: false, message: 'Contract request not found' });
        }

        return res.json({ success: true, message: 'Request rejected successfully' });
    } catch (err) {
        return res.status(500).json({ success: false, message: err.message });
    }
});

router.get('/available-staff', isAgency, async (req, res) => {
    try {
        const sessionAgencyId = req.session.user_id || req.session.user?.id;
        if (sessionAgencyId != 10) {
            return res.status(403).send('Unauthorized Agency');
        }

        const requestedType = String(req.query.type || '').trim();

        if (!requestedType) {
            return res.status(400).json({ success: false, message: 'type query parameter is required' });
        }

            const agencyUserId = 10;

        const staffRows = await runQuery(
            `SELECT
                s.id AS id,
                s.name,
                s.age,
                s.expected_salary
            FROM staff s
                        WHERE s.agency_id = ?
                            AND LOWER(s.type) = LOWER(?)
            ORDER BY s.name ASC`,
                        [agencyUserId, requestedType]
        );

        return res.json(staffRows || []);
    } catch (err) {
        return res.status(500).json({ success: false, message: err.message });
    }
});

module.exports = router;