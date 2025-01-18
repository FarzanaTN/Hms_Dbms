const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json()); // To parse incoming JSON requests


const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'root',
    database: 'hms',
});

db.connect(err => {
    if (err) throw err;
    console.log('Connected to database');
});

// Endpoint to validate login credentials
app.post('/login', (req, res) => {
    const { username, password } = req.body;

    // SQL query to validate username and password
    const sql = 'SELECT * FROM hotel_login WHERE username = ? AND password = ?';
    db.query(sql, [username, password], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send('Server error');
        }
        if (result.length > 0) {
            res.status(200).send('Login successful');
        } else {
            res.status(401).send('Invalid credentials');
        }
    });
});


// // API to execute SQL queries
// app.get('/query', (req, res) => {
//     const sql = 'SELECT * FROM Department'; // Replace with your SQL query
//     db.query(sql, (err, result) => {
//         if (err) return res.status(500).send(err);
//         res.json(result);
//     });
// });

app.get('/query', (req, res) => {
    const tableName = req.query.table;
    const sql = `SELECT * FROM ${tableName}`; // Use the table name dynamically
    db.query(sql, (err, result) => {
        if (err) return res.status(500).send(err);
        res.json(result);
    });
});

// API to get all employees
app.get('/employees', (req, res) => {
    const sql = 'SELECT * FROM Employee';
    db.query(sql, (err, result) => {
        if (err) return res.status(500).send(err);
        res.json(result);
    });
});

// API to get all rooms
app.get('/rooms', (req, res) => {
    const sql = 'SELECT * FROM Room';
    db.query(sql, (err, result) => {
        if (err) return res.status(500).send(err);
        res.json(result);
    });
});

// API to add a new room
app.post('/rooms', (req, res) => {
    console.log(req.body); // Log the incoming request body
    const { room_id, status, available, type, price, profit_per_room } = req.body;

    const sql = `INSERT INTO Room (room_id, status, available, type, price, profit_per_room)
                 VALUES (?, ?, ?, ?, ?, ?)`;

    db.query(sql, [room_id, status, available, type, price, profit_per_room], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send('Failed to add room');
        }
        res.status(201).send('Room added successfully');
    });
});


// API to get employees who are drivers
app.get('/drivers', (req, res) => {
    const sql = `
        SELECT
            e.*,
            d.driving_license,
            d.experience
        FROM Employee e
        JOIN Driver d ON e.emp_id = d.emp_id
    `;
    db.query(sql, (err, result) => {
        if (err) return res.status(500).send(err);
        res.json(result);
    });
});



app.listen(3000, () => console.log('Server running on http://localhost:3000'));
