const mysql = require('mysql2');

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',         // your MySQL username
    password: 'MODIjiZ!ndab@d',   // your MySQL password here
    database: 'agency_db'
});

function connectDb() {
    return new Promise((resolve, reject) => {
        db.connect((err) => {
            if (err) {
                return reject(err);
            }
            return resolve();
        });
    });
}

module.exports = db;
module.exports.connectDb = connectDb;
