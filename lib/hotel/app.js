const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json()); // To parse incoming JSON requests


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

// API to add a new customer and reservation
//app.post('/addCustomer', (req, res) => {
//    const { first_name, last_name, gender, email, phone, rating, room_id, check_in_date, check_out_date, total_bill } = req.body;
//
//    // Insert customer into Customer table
//    const customerSql = `
//        INSERT INTO Customer (first_name, last_name, gender, email, phone, rating)
//        VALUES (?, ?, ?, ?, ?, ?)
//    `;
//
//    db.query(customerSql, [first_name, last_name, gender, email, phone, rating || 0], (err, customerResult) => {
//        if (err) {
//            console.error(err);
//            return res.status(500).send('Failed to add customer');
//        }
//
//        const cus_id = customerResult.insertId; // Get the inserted customer ID
//
//        // Insert reservation into Reserve table
////        const reserveSql = `
////            INSERT INTO Reserve (cus_id, r_id, room_id, check_in_date, check_out_date, total_bill, status)
////            VALUES (?, ?, ?, ?, ?, ?, ?)
////        `;
//
////        const r_id = Date.now(); // Use a unique value for `r_id`, or generate it based on your business logic
////        db.query(reserveSql, [cus_id, r_id, room_id, check_in_date, check_out_date, total_bill, 'active'], (err, reserveResult) => {
////            if (err) {
////                console.error(err);
////                return res.status(500).send('Failed to create reservation');
////            }
//
//            res.status(201).send('Customer and reservation added successfully');
//  //      });
//    });
//});

// app.post('/addCustomer', (req, res) => {
//    const { first_name, last_name, gender, email, phone, rating } = req.body;
//
//     const findCustomerQuery = `SELECT cus_id FROM Customer WHERE email = ? OR phone = ? LIMIT 1`;
//         db.query(findCustomerQuery, [email, phone], (err, customerResult) => {
//             if (err) {
//                 console.error(err);
//                 return res.status(500).send('Failed to find customer');
//             }
//
//             let cus_id;
//             if (customerResult.length > 0) {
//                 cus_id = customerResult[0].cus_id; // Existing customer
//                 console.log(`Existing customer found with cus_id=${cus_id}`);
//             } else {
//                 // Insert new customer
//                 const customerQuery = `
//                     INSERT INTO Customer (first_name, last_name, gender, email, phone, rating)
//                     VALUES (?, ?, ?, ?, ?, ?)
//                 `;
//                 db.query(customerQuery, [first_name, last_name, gender, email, phone, rating || 0], (err, insertResult) => {
//                     if (err) {
//                         console.error(err);
//                         return res.status(500).send('Failed to add customer');
//                     }
//                     cus_id = insertResult.insertId; // New customer ID
//                     console.log(`New customer added with cus_id=${cus_id}`);
//                 });
//             }
//
////    const customerSql = `
////        INSERT INTO Customer (first_name, last_name, gender, email, phone, rating)
////        VALUES (?, ?, ?, ?, ?, ?)
////    `;
//
////    db.query(customerSql, [first_name, last_name, gender, email, phone, rating || 0], (err, result) => {
////        if (err) {
////            console.error(err);
////            return res.status(500).json({ error: 'Failed to add customer' });
////        }
////
////        res.status(201).json({
////            message: 'Customer added successfully',
////            cus_id: result.insertId, // Send the inserted customer ID
////        });
////    });
//});


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

//app.post('/addReservation', (req, res) => {
//    const { cus_id, room_type, check_in_date, check_out_date, total_bill } = req.body;
//
//    console.log(`Request received for reservation: cus_id=${cus_id}, room_type=${room_type}`);
//
//    // Step 1: Find the next `r_id` for this `cus_id`
//    const maxRIdQuery = `
//        SELECT COALESCE(MAX(r_id), 0) + 1 AS next_r_id
//        FROM Reserve
//        WHERE cus_id = ?
//    `;
//
//    db.query(maxRIdQuery, [cus_id], (err, maxResult) => {
//        if (err) {
//            console.error(`Error fetching next r_id: ${err}`);
//            return res.status(500).send('Failed to fetch reservation ID');
//        }
//
//        const r_id = maxResult[0].next_r_id;
//        console.log(`Next r_id for cus_id=${cus_id}: ${r_id}`);
//
//        // Step 2: Find an available and clean room of the given type
//        const findRoomQuery = `
//            SELECT room_id
//            FROM Room
//            WHERE type = ? AND status = 'clean' AND available = 'yes'
//            LIMIT 1
//        `;
//
//        db.query(findRoomQuery, [room_type], (err, roomResult) => {
//            if (err) {
//                console.error(`Error fetching available room: ${err}`);
//                return res.status(500).send('Failed to fetch available room');
//            }
//
//            if (roomResult.length === 0) {
//                console.warn(`No available room found for type=${room_type}`);
//                return res.status(404).send('No available room of the selected type');
//            }
//
//            const room_id = roomResult[0].room_id;
//            console.log(`Room found: room_id=${room_id}`);
//
//            // Step 3: Add the reservation
//            const reserveQuery = `
//                INSERT INTO Reserve (cus_id, r_id, room_id, check_in_date, check_out_date, total_bill, status)
//                VALUES (?, ?, ?, ?, ?, ?, 'active')
//            `;
//
//            db.query(
//                reserveQuery,
//                [cus_id, r_id, room_id, check_in_date, check_out_date, total_bill,],
//                (err, reserveResult) => {
//                    if (err) {
//                        console.error(`Error inserting reservation: ${err}`);
//                        return res.status(500).send('Failed to create reservation');
//                    }
//
//                    console.log(`Reservation created: cus_id=${cus_id}, r_id=${r_id}, room_id=${room_id}`);
//
//                    // Step 4: Update the room to unavailable
//                    const updateRoomQuery = `
//                        UPDATE Room
//                        SET available = 'no'
//                        WHERE room_id = ?
//                    `;
//                    db.query(updateRoomQuery, [room_id], (err, updateResult) => {
//                        if (err) {
//                            console.error(`Error updating room availability: ${err}`);
//                            return res.status(500).send('Failed to update room availability');
//                        }
//
//                        console.log(`Room availability updated: room_id=${room_id}`);
//                        res.status(201).send('Reservation created successfully');
//                    });
//                }
//            );
//        });
//    });
//});

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
