const express = require('express');
const session = require('express-session');
const bodyParser = require('body-parser');
const path = require('path');
const db = require('./config/db');

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

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'views', 'login.html'));
});

app.get('/register.html', (req, res) => {
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