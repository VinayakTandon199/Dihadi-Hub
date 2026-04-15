const express = require('express');
const session = require('express-session');
const bodyParser = require('body-parser');
const path = require('path');
const db = require('./config/db');
const PDFDocument = require('pdfkit');

const app = express();

process.on('unhandledRejection', (reason) => {
    console.error('Unhandled Promise Rejection:', reason);
});

process.on('uncaughtException', (error) => {
    console.error('Uncaught Exception:', error);
});

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));
app.use(session({
    secret: 'agency_secret_key',
    resave: false,
    saveUninitialized: false,
    cookie: { maxAge: 1000 * 60 * 60 }
}));

const authRoutes = require('./routes/auth');
const dashboardRoutes = require('./routes/dashboard');
const clientRoutes = require('./routes/client');
const agencyRoutes = require('./routes/agency');

app.use('/auth', authRoutes);
app.use('/dashboard', dashboardRoutes);
app.use('/client', clientRoutes);
app.use('/agency', agencyRoutes);

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

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'views', 'landing.html'));
});

app.get('/login.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'views', 'login.html'));
});

app.get('/login', (req, res) => {
    res.sendFile(path.join(__dirname, 'views', 'login.html'));
});

app.get('/register.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'views', 'register.html'));
});

app.get('/register', (req, res) => {
    res.sendFile(path.join(__dirname, 'views', 'register.html'));
});

app.get('/dashboard/client', (req, res) => {
    if (!req.session.user || req.session.user.role !== 'client') {
        return res.redirect('/?error=Please login first');
    }
    res.sendFile(path.join(__dirname, 'views', 'client-dashboard.html'));
});

app.get('/dashboard/agency', (req, res) => {
    if (!req.session.user || req.session.user.role !== 'agency') {
        return res.redirect('/?error=Please login first');
    }
    res.sendFile(path.join(__dirname, 'views', 'agency-dashboard.html'));
});

app.get('/dashboard/staff', (req, res) => {
    if (!req.session.user || req.session.user.role !== 'staff') {
        return res.redirect('/?error=Please login first');
    }
    res.sendFile(path.join(__dirname, 'views', 'staff-dashboard.html'));
});

app.get('/marketplace/receipt/:id', async (req, res) => {
    try {
        if (!req.session.user || req.session.user.role !== 'client') {
            return res.status(401).json({ success: false, message: 'Unauthorized' });
        }

        const orderId = Number(req.params.id);
        const clientId = req.session.user.id;

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

        const document = new PDFDocument({ size: 'A4', margin: 42 });
        document.pipe(res);

        const gold = '#D4AF37';
        const cream = '#F2F0E4';
        const charcoal = '#141414';
        const deepBlack = '#0A0A0A';

        document.rect(0, 0, document.page.width, document.page.height).fill(deepBlack);

        document.save();
        document.lineWidth(1).strokeColor(gold).rect(42, 42, 511, 757).stroke();
        document.lineWidth(0.5).strokeOpacity(0.35).strokeColor(gold).rect(52, 52, 491, 737).stroke();
        document.restore();

        document.fillColor(gold).font('Helvetica-Bold').fontSize(10).text('AGENCY MANAGEMENT SYSTEM', 42, 48, { align: 'center' });
        document.font('Times-Bold').fontSize(22).fillColor(gold).text('RECEIPT', 42, 70, { align: 'center', letterSpacing: 2 });
        document.font('Helvetica').fontSize(9).fillColor(cream).text(`Order #${order.id}`, 42, 96, { align: 'center' });

        document.moveTo(42, 118).lineTo(553, 118).strokeColor(gold).lineWidth(1).stroke();

        document.fillColor(cream).font('Helvetica-Bold').fontSize(11).text('CLIENT', 42, 136);
        document.font('Helvetica').fontSize(10).text(order.client_username || 'Client', 42, 152);
        document.font('Helvetica-Bold').fillColor(cream).text('DATE', 320, 136);
        document.font('Helvetica').fillColor(cream).text(new Date(order.created_at).toLocaleString(), 320, 152);
        document.font('Helvetica-Bold').fillColor(cream).text('STORE TYPE', 42, 178);
        document.font('Helvetica').fillColor(cream).text(order.store_type || 'General', 42, 194);
        document.font('Helvetica-Bold').fillColor(cream).text('DELIVERY TIME', 320, 178);
        document.font('Helvetica').fillColor(cream).text(order.delivery_time || 'N/A', 320, 194);
        document.font('Helvetica-Bold').fillColor(cream).text('STATUS', 42, 220);
        document.font('Helvetica').fillColor(cream).text(order.status || 'Pending', 42, 236);

        document.fillColor(gold).font('Times-Bold').fontSize(12).text('ORDER ITEMS', 42, 268);
        document.moveTo(42, 284).lineTo(553, 284).strokeColor(gold).lineWidth(1).stroke();

        const tableStartY = 300;
        const tableX = 42;
        const colWidths = [230, 80, 80, 110];
        const colX = [tableX, tableX + colWidths[0], tableX + colWidths[0] + colWidths[1], tableX + colWidths[0] + colWidths[1] + colWidths[2]];

        document.save();
        document.fillColor(charcoal).strokeColor(gold).lineWidth(1);
        document.rect(tableX, tableStartY, 511, 24).fillAndStroke();
        document.fillColor(gold).font('Helvetica-Bold').fontSize(10);
        document.text('Item', colX[0] + 6, tableStartY + 7, { width: colWidths[0] - 12 });
        document.text('Qty', colX[1] + 6, tableStartY + 7, { width: colWidths[1] - 12, align: 'center' });
        document.text('Rate', colX[2] + 6, tableStartY + 7, { width: colWidths[2] - 12, align: 'right' });
        document.text('Amount', colX[3] + 6, tableStartY + 7, { width: colWidths[3] - 12, align: 'right' });
        document.restore();

        let cursorY = tableStartY + 24;
        let itemsTotal = 0;

        if (!itemRows.length) {
            document.fillColor(cream).font('Helvetica').fontSize(10).text('No line items found for this order.', tableX, cursorY + 10);
            cursorY += 28;
        } else {
            itemRows.forEach((item) => {
                const amount = Number(item.quantity || 0) * Number(item.price_at_purchase || 0);
                itemsTotal += amount;
                const rowHeight = 26;

                document.save();
                document.fillColor(charcoal).strokeOpacity(0.18).strokeColor(gold).lineWidth(0.5);
                document.rect(tableX, cursorY, 511, rowHeight).fillAndStroke();
                document.restore();

                document.fillColor(cream).font('Helvetica').fontSize(9);
                document.text(item.name || 'Item', colX[0] + 6, cursorY + 8, { width: colWidths[0] - 12 });
                document.text(String(item.quantity || 0), colX[1] + 6, cursorY + 8, { width: colWidths[1] - 12, align: 'center' });
                document.text(`₹${Number(item.price_at_purchase || 0).toFixed(2)}`, colX[2] + 6, cursorY + 8, { width: colWidths[2] - 12, align: 'right' });
                document.text(`₹${amount.toFixed(2)}`, colX[3] + 6, cursorY + 8, { width: colWidths[3] - 12, align: 'right' });

                cursorY += rowHeight;
            });
        }

        const grandTotal = Number(order.total_price || itemsTotal || 0);
        cursorY += 18;
        document.moveTo(42, cursorY).lineTo(553, cursorY).strokeColor(gold).lineWidth(1).stroke();
        cursorY += 14;
        document.fillColor(cream).font('Helvetica-Bold').fontSize(11).text(`Grand Total: ₹${grandTotal.toFixed(2)}`, 320, cursorY, { align: 'right', width: 233 });
        cursorY += 24;
        document.fillColor(gold).font('Helvetica-Oblique').fontSize(9).text('Thank you for choosing Agency Management System.', 42, cursorY, { align: 'center', width: 511 });

        document.end();
    } catch (error) {
        console.error('Marketplace receipt error:', error.message);
        return res.status(500).json({ success: false, message: 'Failed to generate receipt' });
    }
});

async function startServer() {
    try {
        const rawPort = process.env.PORT || '3000';
        const PORT = Number(rawPort);

        if (!Number.isInteger(PORT) || PORT <= 0) {
            throw new Error('Missing or invalid PORT environment variable: ' + rawPort);
        }

        await db.connectDb();
        console.log('✅ MySQL Connected Successfully');

        await new Promise((resolve, reject) => {
            const server = app.listen(PORT, () => {
                console.log('🚀 Server running at http://localhost:' + PORT);
                resolve();
            });

            server.on('error', (error) => {
                if (error.code === 'EADDRINUSE') {
                    console.error('Port conflict: Port ' + PORT + ' is already in use.');
                } else {
                    console.error('Server startup error:', error.message);
                }
                reject(error);
            });
        });
    } catch (error) {
        console.error('Application failed to start:', error.message);
        process.exit(1);
    }
}

startServer();