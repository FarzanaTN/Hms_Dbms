const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const moment = require('moment');
const bodyParser = require('body-parser');

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

// Fetch all departments
app.get('/department', (req, res) => {
    const sql = 'SELECT * FROM Department';
    db.query(sql, (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send('Error fetching departments');
        }
        res.status(200).json(result);
    });
});


// Fetch all departments sort by name
app.get('/department/sort', (req, res) => {
    const sql = 'SELECT * FROM Department sort by name';
    db.query(sql, (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send('Error fetching departments');
        }
        res.status(200).json(result);
    });
});




// Add a department
app.post('/department', (req, res) => {
     console.log(req.body); // Log the incoming request body
        const { name, budget} = req.body;

        const sql = `INSERT INTO Department (name, budget)
                     VALUES (?, ?)`;

        db.query(sql, [name, budget], (err, result) => {
            if (err) {
                console.error(err);
                return res.status(500).send('Failed to add Department');
            }
            res.status(201).send('Department added successfully');
        });
});

//delete department
app.delete('/department/:name', (req, res) => {
    const { name } = req.params;  // Extract name from URL parameters
    const sql = 'DELETE FROM Department WHERE name = ?';
    db.query(sql, [name], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send('Error deleting department');
        }
        if (result.affectedRows > 0) {
            res.status(200).send('Department deleted successfully');
        } else {
            res.status(404).send('Department not found');
        }
    });
});

//update department
app.put('/department', (req, res) => {
    const { name, budget } = req.body; // Access both from req.body
    const sql = 'UPDATE Department SET budget = ? WHERE name = ?';
    db.query(sql, [budget, name], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send('Error updating department');
        }
        if (result.affectedRows > 0) {
            res.status(200).send('Department updated successfully');
        } else {
            res.status(404).send('Department not found');
        }
    });
});

app.get('/employees', (req, res) => {
    const sql = 'SELECT * FROM Employee';
    db.query(sql, (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send('Error fetching employees');
        }
        res.status(200).json(result);
    });
});




//app.get('/employees/service', (req, res) => {
//    const sql = `
//        SELECT
//            e.emp_id,
//            CONCAT(e.first_name, ' ', e.last_name) AS name,
//            TIMESTAMPDIFF(YEAR, e.date_of_join, CURDATE()) AS service_years
//        FROM Employee e;
//    `;
//    db.query(sql, (err, result) => {
//        if (err) {
//            console.error(err);
//            return res.status(500).send('Error fetching employees');
//        }
//        res.status(200).json(result);
//    });
//});



// delete employee
app.delete('/employees/:emp_id', (req, res) => {
    const emp_id = req.params.emp_id;

    console.log(`Attempting to delete employee with ID: ${emp_id}`); // Added logging

    if (!emp_id) {
        return res.status(400).json({ error: 'Employee ID is required' });
    }

    const query = 'DELETE FROM Employee WHERE emp_id = ?';
    db.query(query, [emp_id], (err, results) => {
        if (err) {
            console.error('Database error:', err);
            return res.status(500).json({
                error: 'Database error',
                details: err.message
            });
        }

        console.log('Delete query results:', results); // Log results for debugging

        if (results.affectedRows === 0) {
            return res.status(404).json({ error: 'Employee not found' });
        }

        res.status(200).json({
            message: 'Employee deleted successfully',
            affectedRows: results.affectedRows
        });
    });
});

//app.put('/employees', (req, res) => {
//  console.log('Request body:', req.body);
//
//  const { service_length, percentage_increase } = req.body;
//
//  if (!service_length || !percentage_increase) {
//    return res.status(400).send('Missing service_length or percentage_increase');
//  }
//
//  res.status(200).send('Route is working');
//});


app.put('/employees', (req, res) => {
  console.log('Request body:', req.body);

  const { service_length, percentage_increase } = req.body;

  if (!service_length || !percentage_increase) {
    return res.status(400).send('Missing service_length or percentage_increase');
  }

  // SQL query to update employee salaries
  const query = `
    UPDATE Employee e
    JOIN (
      SELECT emp_id, TIMESTAMPDIFF(YEAR, date_of_join, CURDATE()) AS service_years
      FROM Employee
    ) es ON e.emp_id = es.emp_id
    SET e.salary = e.salary + (e.salary * ? / 100)
    WHERE es.service_years >= ?
  `;

  db.query(query, [parseFloat(percentage_increase), parseInt(service_length)], (err, results) => {
    if (err) {
      console.error('Error updating salaries:', err);
      return res.status(500).send('Error updating salaries');
    }

    res.status(200).send(`Updated ${results.affectedRows} employee salaries`);
  });
});



// add new employee You can install moment.js using npm install moment

app.post('/employees', (req, res) => {
    const { emp_id, first_name, last_name, gender, date_of_birth, date_of_join, phone, email, house_no, street_name, city, postal_code, district, division, NID, dept_name, salary } = req.body;

    console.log('Attempting to add new employee'); // Added logging

    // // Validate that all required fields are provided
    // if (!first_name || !last_name || !gender || !date_of_birth || !date_of_join || !phone || !email || !district || !division || !salary || !dept_name) {
    //     return res.status(400).json({ error: 'All fields (first_name, last_name, gender, date_of_birth, date_of_join, phone, email, district, division, salary, dept_name) are required' });
    // }

    // Log incoming dates to debug the issue
    console.log('Original date_of_birth:', date_of_birth);
    console.log('Original date_of_join:', date_of_join);

    // Convert date strings to YYYY-MM-DD format using moment.js
    const formattedDateOfBirth = moment(date_of_birth, 'DD-MM-YYYY').format('YYYY-MM-DD');
    const formattedDateOfJoin = moment(date_of_join, 'DD-MM-YYYY').format('YYYY-MM-DD');

    // Log formatted dates to verify
    console.log('Formatted date_of_birth:', formattedDateOfBirth);
    console.log('Formatted date_of_join:', formattedDateOfJoin);

    const query = `
        INSERT INTO Employee 
        (emp_id, first_name, last_name, gender, date_of_birth, date_of_join, phone, email, house_no, street_name, city, postal_code, district, division, NID, dept_name, salary)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;
    const values = [emp_id, first_name, last_name, gender, formattedDateOfBirth, formattedDateOfJoin, phone, email, house_no, street_name, city, postal_code, district, division, NID, dept_name, salary];

    db.query(query, values, (err, results) => {
        if (err) {
            console.error('Database error:', err);
            return res.status(500).json({
                error: 'Database error',
                details: err.message
            });
        }

        console.log('Insert query results:', results); // Log results for debugging

        res.status(201).json({
            message: 'Employee added successfully',
            employeeId: results.insertId
        });
    });
});





app.post('/addCustomer', (req, res) => {
    const { first_name, last_name, gender, email, phone, rating } = req.body;

    const findCustomerQuery = `SELECT cus_id FROM Customer WHERE email = ? OR phone = ? LIMIT 1`;
    db.query(findCustomerQuery, [email, phone], (err, customerResult) => {
        if (err) {
            console.error(err);
            return res.status(500).send('Failed to find customer');
        }

        let cus_id;
        if (customerResult.length > 0) {
            cus_id = customerResult[0].cus_id; // Existing customer
            console.log(`Existing customer found with cus_id=${cus_id}`);
            return res.status(200).json({
                message: 'Customer already exists',
                cus_id: cus_id,
            });
        } else {
            // Insert new customer
            const customerQuery = `
                INSERT INTO Customer (first_name, last_name, gender, email, phone, rating)
                VALUES (?, ?, ?, ?, ?, ?)
            `;
            db.query(customerQuery, [first_name, last_name, gender, email, phone, rating || 0], (err, insertResult) => {
                if (err) {
                    console.error(err);
                    return res.status(500).send('Failed to add customer');
                }
                cus_id = insertResult.insertId; // New customer ID
                console.log(`New customer added with cus_id=${cus_id}`);
                return res.status(201).json({
                    message: 'Customer added successfully',
                    cus_id: cus_id,
                });
            });
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

//delete room
app.delete('/rooms/:room_id', (req, res) => {
    const room_id = req.params.room_id;

    console.log(`Attempting to delete room with ID: ${room_id}`); // Added logging

    if (!room_id) {
        return res.status(400).json({ error: 'Room ID is required' });
    }

    const query = 'DELETE FROM Room WHERE room_id = ?';
    db.query(query, [room_id], (err, results) => {
        if (err) {
            console.error('Database error:', err);
            return res.status(500).json({
                error: 'Database error',
                details: err.message
            });
        }

        console.log('Delete query results:', results); // Log results for debugging

        if (results.affectedRows === 0) {
            return res.status(404).json({ error: 'Room not found' });
        }

        res.status(200).json({
            message: 'Room deleted successfully',
            affectedRows: results.affectedRows
        });
    });
});

//update room
app.put('/rooms', (req, res) => {
    const { room_id, price, status, available } = req.body;

    console.log('Received request body:', req.body); // Debug log

    // Validate fields and types
    if (!room_id || price === undefined || !status || available === undefined) {
        return res.status(400).send('Missing required fields');
    }

    if (
        typeof room_id !== 'string' ||
        typeof price !== 'number' ||
        typeof status !== 'string' ||
        typeof available !== 'boolean'
    ) {
        return res.status(400).send('Invalid field types');
    }

    const sql = 'UPDATE Room SET price = ?, status = ?, available = ? WHERE room_id = ?';

    db.query(sql, [price, status, available, room_id], (err, result) => {
        if (err) {
            console.error('Database error:', err); // Log detailed database error
            return res.status(500).send('Error updating room');
        }

        console.log('Update query results:', result); // Debug log for query results

        if (result.affectedRows > 0) {
            res.status(200).send('Room updated successfully');
        } else {
            res.status(404).send('Room not found');
        }
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


app.post('/addReservation', (req, res) => {
    const { cus_id, room_type, check_in_date, check_out_date, total_bill } = req.body;

    console.log(`Request received for reservation: cus_id=${cus_id}, room_type=${room_type}`);

    // Convert string dates to Date objects
    const parsedCheckInDate = new Date(check_in_date);
    const parsedCheckOutDate = new Date(check_out_date);

    // Validate date conversion
    if (isNaN(parsedCheckInDate) || isNaN(parsedCheckOutDate)) {
        return res.status(400).send('Invalid check-in or check-out date format');
    }

    // Step 1: Find the next `r_id` for this `cus_id`
    const maxRIdQuery = `
        SELECT COALESCE(MAX(r_id), 0) + 1 AS next_r_id
        FROM Reserve
        WHERE cus_id = ?
    `;

    db.query(maxRIdQuery, [cus_id], (err, maxResult) => {
        if (err) {
            console.error(`Error fetching next r_id: ${err}`);
            return res.status(500).send('Failed to fetch reservation ID');
        }

        const r_id = maxResult[0].next_r_id;
        console.log(`Next r_id for cus_id=${cus_id}: ${r_id}`);

        // Step 2: Find an available and clean room of the given type
        const findRoomQuery = `
            SELECT room_id
            FROM Room
            WHERE type = ? AND status = 'clean' AND available = 'yes'
            LIMIT 1
        `;

        db.query(findRoomQuery, [room_type], (err, roomResult) => {
            if (err) {
                console.error(`Error fetching available room: ${err}`);
                return res.status(500).send('Failed to fetch available room');
            }

            if (roomResult.length === 0) {
                console.warn(`No available room found for type=${room_type}`);
                return res.status(404).send('No available room of the selected type');
            }

            const room_id = roomResult[0].room_id;
            console.log(`Room found: room_id=${room_id}`);



            // Step 3: Add the reservation
            const reserveQuery = `
                INSERT INTO reserve (cus_id, r_id, room_id, check_in_date, check_out_date, total_bill, status)
                VALUES (?, ?, ?, ?, ?, ?, 'active')
            `;

            db.query(
                reserveQuery,
                [
                    cus_id,
                    r_id,
                    room_id,
                    parsedCheckInDate.toISOString().split('T')[0], // Format as YYYY-MM-DD
                    parsedCheckOutDate.toISOString().split('T')[0],
                    total_bill,
                ],
                (err, reserveResult) => {
                    if (err) {
                        console.error(`Error inserting reservation: ${err}`);
                        return res.status(500).send('Failed to create reservation');
                    }

                    console.log(`Reservation created: cus_id=${cus_id}, r_id=${r_id}, room_id=${room_id}`);

                    // Step 4: Update the room to unavailable
                    const updateRoomQuery = `
                        UPDATE Room
                        SET available = 'no'
                        WHERE room_id = ?
                    `;
                    db.query(updateRoomQuery, [room_id], (err, updateResult) => {
                        if (err) {
                            console.error(`Error updating room availability: ${err}`);
                            return res.status(500).send('Failed to update room availability');
                        }

                        console.log(`Room availability updated: room_id=${room_id}`);
                        res.status(201).send('Reservation created successfully');
                    });
                }
            );
        });
    });
});



app.post('/addCustomerAndReservation', (req, res) => {
    const { first_name, last_name, gender, email, phone, rating, room_type, check_in_date, check_out_date, total_bill } = req.body;

    const findCustomerQuery = `SELECT cus_id FROM Customer WHERE email = ? OR phone = ? LIMIT 1`;
    db.query(findCustomerQuery, [email, phone], (err, customerResult) => {
        if (err) {
            console.error(err);
            return res.status(500).send('Failed to find customer');
        }

        let cus_id;
        if (customerResult.length > 0) {
            cus_id = customerResult[0].cus_id; // Existing customer
            console.log(`Existing customer found with cus_id=${cus_id}`);
            addReservation(cus_id);
        } else {
            // Insert new customer
            const customerQuery = `
                INSERT INTO Customer (first_name, last_name, gender, email, phone, rating)
                VALUES (?, ?, ?, ?, ?, ?)
            `;
            db.query(customerQuery, [first_name, last_name, gender, email, phone, rating || 0], (err, insertResult) => {
                if (err) {
                    console.error(err);
                    return res.status(500).send('Failed to add customer');
                }
                cus_id = insertResult.insertId; // New customer ID
                console.log(`New customer added with cus_id=${cus_id}`);
                addReservation(cus_id);
            });
        }

        // Function to add a reservation
        function addReservation(cus_id) {
            // Convert string dates to Date objects
            const parsedCheckInDate = new Date(check_in_date);
            const parsedCheckOutDate = new Date(check_out_date);

            // Validate date conversion
            if (isNaN(parsedCheckInDate) || isNaN(parsedCheckOutDate)) {
                return res.status(400).send('Invalid check-in or check-out date format');
            }

            // Step 1: Find the next `r_id` for this `cus_id`
            const maxRIdQuery = `
                SELECT COALESCE(MAX(r_id), 0) + 1 AS next_r_id
                FROM Reserve
                WHERE cus_id = ?
            `;

            db.query(maxRIdQuery, [cus_id], (err, maxResult) => {
                if (err) {
                    console.error(`Error fetching next r_id: ${err}`);
                    return res.status(500).send('Failed to fetch reservation ID');
                }

                const r_id = maxResult[0].next_r_id;
                console.log(`Next r_id for cus_id=${cus_id}: ${r_id}`);

                // Step 2: Find an available and clean room of the given type
                const findRoomQuery = `
                    SELECT room_id
                    FROM Room
                    WHERE type = ? AND status = 'clean' AND available = 'yes'
                    LIMIT 1
                `;

                db.query(findRoomQuery, [room_type], (err, roomResult) => {
                    if (err) {
                        console.error(`Error fetching available room: ${err}`);
                        return res.status(500).send('Failed to fetch available room');
                    }

                    if (roomResult.length === 0) {
                        console.warn(`No available room found for type=${room_type}`);
                        return res.status(404).send('No available room of the selected type');
                    }

                    const room_id = roomResult[0].room_id;
                    console.log(`Room found: room_id=${room_id}`);

                    // Step 3: Add the reservation
                    const reserveQuery = `
                        INSERT INTO reserve (cus_id, r_id, room_id, check_in_date, check_out_date, total_bill, status)
                        VALUES (?, ?, ?, ?, ?, ?, 'active')
                    `;

                    db.query(
                        reserveQuery,
                        [
                            cus_id,
                            r_id,
                            room_id,
                            parsedCheckInDate.toISOString().split('T')[0], // Format as YYYY-MM-DD
                            parsedCheckOutDate.toISOString().split('T')[0],
                            total_bill,
                        ],
                        (err, reserveResult) => {
                            if (err) {
                                console.error(`Error inserting reservation: ${err}`);
                                return res.status(500).send('Failed to create reservation');
                            }

                            console.log(`Reservation created: cus_id=${cus_id}, r_id=${r_id}, room_id=${room_id}`);

                            // Step 4: Update the room to unavailable
                            const updateRoomQuery = `
                                UPDATE Room
                                SET available = 'no'
                                WHERE room_id = ?
                            `;
                            db.query(updateRoomQuery, [room_id], (err, updateResult) => {
                                if (err) {
                                    console.error(`Error updating room availability: ${err}`);
                                    return res.status(500).send('Failed to update room availability');
                                }

                                console.log(`Room availability updated: room_id=${room_id}`);
                                res.status(201).send('Customer and reservation created successfully');
                            });
                        }
                    );
                });
            });
        }
    });
});






app.listen(3000, () => console.log('Server running on http://localhost:3000'));
