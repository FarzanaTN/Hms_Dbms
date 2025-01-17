const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '1234',
    database: 'hms',
});

db.connect(err => {
    if (err) throw err;
    console.log('Connected to database');
});

// API to execute SQL queries
app.get('/query', (req, res) => {
    const sql = 'SELECT * FROM Department'; // Replace with your SQL query
    db.query(sql, (err, result) => {
        if (err) return res.status(500).send(err);
        res.json(result);
    });
});

app.listen(3000, () => console.log('Server running on http://localhost:3000'));
