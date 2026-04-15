const express = require('express');
const router = express.Router();
const db = require('../config/db');

router.post('/login', (req, res) => {
    const { username, password, role } = req.body;

    if (!username || !password || !role) {
        return res.redirect('/?error=All fields are required');
    }

    const loginQuery = 'SELECT * FROM users WHERE username = ? AND password = ? AND role = ?';

    db.query(loginQuery, [username, password, role], (err, results) => {
        if (err) {
            return res.redirect('/?error=Server error');
        }

        if (!results || results.length === 0) {
            return res.redirect('/?error=Invalid username password or role');
        }

        req.session.user = {
            id: results[0].id,
            username: results[0].username,
            role: results[0].role,
        };

        if (results[0].role === 'agency') {
            return res.redirect('/dashboard/agency');
        }

        if (results[0].role === 'staff') {
            return res.redirect('/dashboard/staff');
        }

        if (results[0].role === 'client') {
            return res.redirect('/dashboard/client');
        }

        return res.redirect('/?error=Invalid username password or role');
    });
});

router.post('/register', (req, res) => {
    const {
        username,
        password,
        role,
        name,
        age,
        gender,
        experience,
        type,
        address,
        contact,
        work_shift,
        expected_salary,
    } = req.body;

    if (!username || !password || !role || !name) {
        return res.redirect('/register.html?error=All required fields are missing');
    }

    const checkUserQuery = 'SELECT * FROM users WHERE username = ?';

    db.query(checkUserQuery, [username], (checkErr, checkResults) => {
        if (checkErr) {
            return res.redirect('/register.html?error=Registration failed please try again');
        }

        if (checkResults && checkResults.length > 0) {
            return res.redirect('/register.html?error=Username already taken');
        }

        const insertUserQuery = 'INSERT INTO users (username, password, role) VALUES (?, ?, ?)';

        db.query(insertUserQuery, [username, password, role], (insertErr, insertResult) => {
            if (insertErr) {
                return res.redirect('/register.html?error=Registration failed please try again');
            }

            const userId = insertResult.insertId;
            let detailQuery = '';
            let values = [];

            if (role === 'agency') {
                detailQuery = 'INSERT INTO agency (user_id, name, age, gender, experience, type, address, contact, work_shift) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';
                values = [userId, name, age, gender, experience, type, address, contact, work_shift];
            } else if (role === 'staff') {
                detailQuery = `INSERT INTO staff 
(user_id, name, age, gender, experience, type, address, contact, work_shift, expected_salary) 
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

                values = [userId, name, age || null, gender || null, 
experience || null, type || null, address || null, 
contact || null, work_shift || null, expected_salary || null];
            } else if (role === 'client') {
                detailQuery = 'INSERT INTO client (user_id, name, age, gender, experience, type, address, contact, work_shift) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';
                values = [userId, name, age, gender, experience, type, address, contact, work_shift];
            } else {
                return res.redirect('/register.html?error=Registration failed please try again');
            }

            db.query(detailQuery, values, (roleInsertErr) => {
                if (roleInsertErr) {
                    return res.redirect('/register.html?error=Registration failed please try again');
                }

                return res.redirect('/?success=Registration successful. Please login.');
            });
        });
    });
});

router.get('/logout', (req, res) => {
    req.session.destroy(() => {
        res.redirect('/');
    });
});

module.exports = router;
