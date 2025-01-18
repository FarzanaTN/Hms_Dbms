show databases;
drop database hms;

create database hms;

use hms;

create table hotel_login(
	username varchar(10),
    password int
);

select * from hotel_login;

INSERT INTO hotel_login (username, password) VALUES
("admin", 1234);



-- 1. Department Table
CREATE TABLE Department (
    name VARCHAR(100) PRIMARY KEY,
    budget DECIMAL(10,2) NOT NULL
);

-- 2.Employee Table
CREATE TABLE Employee (
    emp_id int PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    date_of_birth DATE NOT NULL,
    date_of_join DATE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    house_no VARCHAR(5) ,
    street_name VARCHAR(20) ,
    city VARCHAR(15) ,
    postal_code VARCHAR(15) ,
    district VARCHAR(15) not null,
    division VARCHAR(15) not null ,
    NID VARCHAR(50),
    dept_name VARCHAR(100),
    FOREIGN KEY (dept_name) REFERENCES Department(name)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
salary DECIMAL(10,2) NOT NULL DEFAULT 23000
);

describe table Employee;

-- 3.Security Guard Table
CREATE TABLE Security_Guard (
    emp_id int PRIMARY KEY,
    shift ENUM('day', 'night'),
    location int CHECK (location >= 1 AND location <= 5),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 4. Chef Table
CREATE TABLE Chef (
    emp_id int PRIMARY KEY,
    experience FLOAT,
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 5.Receptionist Table
CREATE TABLE Receptionist (
    emp_id int PRIMARY KEY,
    shift ENUM('day', 'night'),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 6. Room Service Table
CREATE TABLE Room_Service (
    emp_id int PRIMARY KEY,
    floor_no INT CHECK (floor_no >= 1 AND floor_no <= 8),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- 7.Driver Table
CREATE TABLE Driver (
    emp_id int PRIMARY KEY,
    experience INT,
    driving_license VARCHAR(50) NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 8.Room Table
CREATE TABLE Room (
    room_id int PRIMARY KEY,
    status ENUM('clean', 'dirty') NOT NULL,
    available ENUM('yes', 'no') NOT NULL,
    type ENUM('single bed', 'double bed') NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    profit_per_room DECIMAL(10,2) NOT NULL
);

-- 9.Customer Table
CREATE TABLE Customer (
    cus_id int auto_increment PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    rating INT DEFAULT 0 CHECK (rating >= 0 AND rating <= 5)
);

-- 10.Cancel Table
CREATE TABLE Cancel (
    cus_id int,
    c_id int,
    room_id int,
    PRIMARY KEY (cus_id, c_id),
    FOREIGN KEY (cus_id) REFERENCES Customer(cus_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES Room(room_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE Reserve (
    cus_id INT,
    r_id INT,
    room_id INT,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_bill DECIMAL(10,2) not null check (total_bill > 0),
    PRIMARY KEY (cus_id, r_id),
    FOREIGN KEY (cus_id) REFERENCES Customer(cus_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES Room(room_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 12. Payment Table
CREATE TABLE Payment (
    id int PRIMARY KEY,
    cus_id int,
    total_amount DECIMAL(10,2) CHECK (total_amount > 0),
    paid DECIMAL(10,2) CHECK (paid >= 0),
    due DECIMAL(10,2) GENERATED ALWAYS AS (total_amount - paid) STORED,
    FOREIGN KEY (cus_id) REFERENCES Customer(cus_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- Insert into Department Table
INSERT INTO Department (name, budget) VALUES
('Housekeeping', 200000.00),
('Transport', 300000.00),
('Reception', 150000.00),
('Security', 100000.00),
('Management', 500000.00);

select * from Department;

-- Insert into Employee Table
INSERT INTO Employee (emp_id, first_name, last_name, gender, date_of_birth, date_of_join, phone, email, house_no, street_name, city, postal_code, district, division, NID, dept_name, salary) VALUES
(1, 'Ahmed', 'Khan', 'Male', '1980-05-15', '2020-01-01', '01711112222', 'ahmed.khan@example.com', '12', 'Banani', 'Dhaka', '1213', 'Dhaka', 'Dhaka', '1234567890', 'Management', 60000),
(2, 'Rahim', 'Uddin', 'Male', '1990-07-20', '2021-05-10', '01811113333', 'rahim.uddin@example.com', '34', 'Dhanmondi', 'Dhaka', '1205', 'Dhaka', 'Dhaka', '2345678901', 'Security', 25000),
(3, 'Fatima', 'Begum', 'Female', '1995-03-10', '2022-03-01', '01622224444', 'fatima.begum@example.com', '22', 'Chawk Bazar', 'Chittagong', '4000', 'Chattogram', 'Chattogram', '3456789012', 'Transport', 30000),
(4, 'Sumaiya', 'Akter', 'Female', '1988-09-17', '2021-08-15', '01933335555', 'sumaiya.akter@example.com', '19', 'Sholoshohor', 'Chittagong', '4200', 'Chattogram', 'Chattogram', '4567890123', 'Reception', 28000),
(5, 'Hasan', 'Mahmud', 'Male', '1982-02-25', '2019-12-20', '01544446666', 'hasan.mahmud@example.com', '50', 'Motijheel', 'Dhaka', '1000', 'Dhaka', 'Dhaka', '5678901234', 'Housekeeping', 22000);


INSERT INTO Employee (emp_id, first_name, last_name, gender, date_of_birth, date_of_join, phone, email, house_no, street_name, city, postal_code, district, division, NID, dept_name, salary) VALUES
(6, '', 'Khan', 'Male', '1980-05-15', '2020-01-01', '01711112222', 'ahmed.khan@example.com', '12', 'Banani', 'Dhaka', '1213', 'Dhaka', 'Dhaka', '1234567890', 'Management', 60000),
(7, 'Rahim', 'Uddin', 'Male', '1990-07-20', '2021-05-10', '01811113333', 'rahim.uddin@example.com', '34', 'Dhanmondi', 'Dhaka', '1205', 'Dhaka', 'Dhaka', '2345678901', 'Security', 25000),
(8, 'Fatima', 'Begum', 'Female', '1995-03-10', '2022-03-01', '01622224444', 'fatima.begum@example.com', '22', 'Chawk Bazar', 'Chittagong', '4000', 'Chattogram', 'Chattogram', '3456789012', 'Transport', 30000),
(9, 'Sumaiya', 'Akter', 'Female', '1988-09-17', '2021-08-15', '01933335555', 'sumaiya.akter@example.com', '19', 'Sholoshohor', 'Chittagong', '4200', 'Chattogram', 'Chattogram', '4567890123', 'Reception', 28000),
(10, 'Hasan', 'Mahmud', 'Male', '1982-02-25', '2019-12-20', '01544446666', 'hasan.mahmud@example.com', '50', 'Motijheel', 'Dhaka', '1000', 'Dhaka', 'Dhaka', '5678901234', 'Housekeeping', 22000);


select * from Employee;

-- Insert into Security_Guard Table
INSERT INTO Security_Guard (emp_id, shift, location) VALUES
(2, 'day', 1);

-- Insert into Chef Table
INSERT INTO Chef (emp_id, experience) VALUES
(3, 5.5);

select * from Chef;

-- Insert into Receptionist Table
INSERT INTO Receptionist (emp_id, shift) VALUES
(4, 'day');

select * from Receptionist;

-- Insert into Room_Service Table
INSERT INTO Room_Service (emp_id, floor_no) VALUES
(5, 2);

select * from Room_Service;

-- Insert into Driver Table
INSERT INTO Driver (emp_id, experience, driving_license) VALUES
(1, 10, 'DL1234567');

select * from Driver;

-- Insert data into Room table
INSERT INTO Room (room_id, status, available, type, price, profit_per_room) VALUES
(101, 'clean', 'yes', 'single bed', 2000.00, 500.00),
(102, 'dirty', 'no', 'double bed', 3000.00, 800.00),
(103, 'clean', 'yes', 'single bed', 2000.00, 500.00);

select * from Room;

-- Insert data into Customer table
INSERT INTO Customer (cus_id, first_name, last_name, gender, email, phone, rating) VALUES
(1, 'Rafiq', 'Ahmed', 'Male', 'rafiq.ahmed@example.com', '01855000001', 4),
(2, 'Nusrat', 'Jahan', 'Female', 'nusrat.jahan@example.com', '01866000002', 5);

select * from Customer;

-- Insert data into Reserve table
INSERT INTO Reserve (cus_id, r_id, room_id, check_in_date, check_out_date, total_bill) VALUES
(1, 1, 101, '2025-01-01', '2025-01-03', 3000.00),
(2, 2, 102, '2025-01-02', '2025-01-05', 9000.00);

select * from Reserve;

-- Insert data into Cancel table
INSERT INTO Cancel (cus_id, c_id, room_id) VALUES
(1, 1, 101);

select * from Cancel;

-- Insert data into Payment table
INSERT INTO Payment (id, cus_id, total_amount, paid) VALUES
(1, 1, 4000.00, 3000.00),
(2, 2, 9000.00, 9000.00);

select * from Payment;




-- 1. Service length of employees (in years)
SELECT
    e.emp_id,
    TIMESTAMPDIFF(YEAR, e.date_of_join, CURDATE()) as service_years
FROM Employee e;

-- 2. Driver details with license
SELECT
    e.*,
    d.driving_license,
    d.experience
FROM Employee e
JOIN Driver d ON e.emp_id = d.emp_id;

-- 3. Count employees in each department
SELECT
    dept_name,
    COUNT(*) as employee_count
FROM Employee
GROUP BY dept_name;

-- 4. Department wise maximum salary with employee details
SELECT
    e.dept_name,
    e.emp_id,
    s.salary
FROM Employee e
JOIN (
    SELECT dept_name, MAX(salary) as salary
    FROM Employee
    GROUP BY dept_name
) s ON e.dept_name = s.dept_name AND e.salary = s.salary
ORDER BY e.dept_name;


-- 5. Department wise average salary
SELECT
    dept_name,
    AVG(salary) as avg_salary
FROM Employee
GROUP BY dept_name;

-- 6. View for available rooms
CREATE VIEW available_rooms AS
SELECT room_id, price, type
FROM Room
WHERE available = 'yes';

select * from available_rooms;

-- 7. View for dirty rooms
CREATE VIEW dirty_rooms AS
SELECT room_id, type
FROM Room
WHERE status = 'dirty';

select * from dirty_rooms;

-- 8. Current customers with reservations
SELECT
    c.*,
    r.room_id,
    r.check_in_date,
    r.check_out_date
FROM Customer c
JOIN Reserve r ON c.cus_id = r.cus_id
WHERE r.check_out_date >= CURDATE();


-- 9. Delete customers who canceled all reservations
DELETE FROM Customer
WHERE cus_id IN (
    SELECT c.cus_id
    FROM Cancel c
    LEFT JOIN Reserve r ON c.cus_id = r.cus_id
    WHERE r.cus_id IS NULL
);

-- 10. Delete specific reservation if canceled
DELETE FROM Reserve
WHERE cus_id IN (SELECT cus_id FROM Cancel);


-- 11. Update salary for employees with 5+ years service
UPDATE Employee
SET salary = salary * 1.10
WHERE TIMESTAMPDIFF(YEAR, date_of_join, CURDATE()) >= 5;

-- 12. Average customer rating
SELECT AVG(rating) as average_rating
FROM Customer;

-- 13. Monthly profit calculation
SELECT
    DATE_FORMAT(r.check_out_date, '%Y-%m') as month,
    SUM(rm.profit_per_room) as total_profit
FROM Reserve r
JOIN Room rm ON r.room_id = rm.room_id
GROUP BY DATE_FORMAT(r.check_out_date, '%Y-%m')
ORDER BY month;

-- 14. Sort departments by budget
SELECT name, budget
FROM Department
ORDER BY budget DESC;

-- 15. Delete checked-out customers (older than one month)
DELETE FROM Customer
WHERE cus_id IN (
    SELECT DISTINCT r.cus_id
    FROM Reserve r
    WHERE r.check_out_date < DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
    AND NOT EXISTS (
        SELECT 1
        FROM Reserve r2
        WHERE r2.cus_id = r.cus_id
        AND r2.check_out_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
    )
);










