const express = require('express');
const path = require('path');
const router = express.Router();

const isAuthenticated = (req, res, next) => {
    if (!req.session.user) {
        return res.redirect('/?error=Please login first');
    }
    next();
};

router.get('/agency', isAuthenticated, (req, res) => {
    if (req.session.user.role !== 'agency') {
        return res.redirect('/?error=Unauthorized access');
    }
    res.sendFile(path.join(__dirname, '../views', 'agency-dashboard.html'));
});

router.get('/staff', isAuthenticated, (req, res) => {
    if (req.session.user.role !== 'staff') {
        return res.redirect('/?error=Unauthorized access');
    }
    res.sendFile(path.join(__dirname, '../views', 'staff-dashboard.html'));
});

router.get('/client', isAuthenticated, (req, res) => {
    if (req.session.user.role !== 'client') {
        return res.redirect('/?error=Unauthorized access');
    }
    res.sendFile(path.join(__dirname, '../views', 'client-dashboard.html'));
});

module.exports = router;
