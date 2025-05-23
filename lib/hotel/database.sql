show databases;

create database hms;

use hms;

drop database hms;

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
    phone VARCHAR(20) NOT NULL

);



select*
from customer;

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

ALTER TABLE Reserve
ADD COLUMN status ENUM('active', 'cancel') NOT NULL DEFAULT 'active';

-- 12. Payment Table
CREATE TABLE Payment (
    id int  auto_increment PRIMARY KEY,
    cus_id int,
    total_amount DECIMAL(10,2) CHECK (total_amount > 0),
    paid DECIMAL(10,2) CHECK (paid >= 0),
    FOREIGN KEY (cus_id) REFERENCES Customer(cus_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


select*
from Payment;

select*
from cpayment;

CREATE TABLE cpayment LIKE Payment;
INSERT INTO cpayment (id, cus_id, total_amount, paid)
SELECT id, cus_id, total_amount, paid FROM Payment;

ALTER TABLE cpayment DROP COLUMN due;




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
(6, 'Jalal', 'Khan', 'Male', '1980-05-15', '2020-01-01', '01711112222', 'ahmed.khan@example.com', '12', 'Banani', 'Dhaka', '1213', 'Dhaka', 'Dhaka', '1234567890', 'Management', 60000),
(7, 'Rahim', 'Uddin', 'Male', '1990-07-20', '2021-05-10', '01811113333', 'rahim.uddin@example.com', '34', 'Dhanmondi', 'Dhaka', '1205', 'Dhaka', 'Dhaka', '2345678901', 'Security', 25000),
(8, 'Fatima', 'Begum', 'Female', '1995-03-10', '2022-03-01', '01622224444', 'fatima.begum@example.com', '22', 'Chawk Bazar', 'Chittagong', '4000', 'Chattogram', 'Chattogram', '3456789012', 'Transport', 30000),
(9, 'Sumaiya', 'Akter', 'Female', '1988-09-17', '2021-08-15', '01933335555', 'sumaiya.akter@example.com', '19', 'Sholoshohor', 'Chittagong', '4200', 'Chattogram', 'Chattogram', '4567890123', 'Reception', 28000),
(10, 'Hasan', 'Mahmud', 'Male', '1982-02-25', '2019-12-20', '01544446666', 'hasan.mahmud@example.com', '50', 'Motijheel', 'Dhaka', '1000', 'Dhaka', 'Dhaka', '5678901234', 'Housekeeping', 22000);


UPDATE Employee
SET first_name = 'Moin', last_name = 'Ali'
WHERE emp_id = 2;

UPDATE Employee
SET salary = 30000
WHERE emp_id IN (5, 10);


INSERT INTO Employee (emp_id, first_name, last_name, gender, date_of_birth, date_of_join, phone, email, house_no, street_name, city, postal_code, district, division, NID, dept_name, salary) VALUES
(11, 'Nawaz', 'Khan', 'Male', '1987-05-15', '2024-01-01', '01711112112', 'nawaz.khan@example.com', '14', 'Old town', 'Dhaka', '1213', 'Dhaka', 'Dhaka', '1234567890', 'Management', 60000),
(12, 'Ramiz', 'Uddin', 'Male', '1980-07-20', '2022-05-10', '01890113333', 'ramiz.uddin@example.com', '54', 'Keraniganj', 'Dhaka', '1205', 'Dhaka', 'Dhaka', '2345678901', 'Security', 25000),
(13, 'Najnin', 'Begum', 'Female', '1999-03-10', '2025-03-01', '01689224444', 'naznin.begum@example.com', '22', 'Chawk Bazar', 'Chittagong', '4000', 'Chattogram', 'Chattogram', '3456789012', 'Transport', 30000),
(14, 'Sharmin', 'Akter', 'Female', '1988-09-17', '2021-08-15', '01933335555', 'sharmin.akter@example.com', '19', 'Sholoshohor', 'Chittagong', '4200', 'Chattogram', 'Chattogram', '4567890123', 'Reception', 28000),
(15, 'Altaf', 'Mahmud', 'Male', '1982-02-25', '2019-12-20', '01544346666', 'altaf.mahmud@example.com', '50', 'Motijheel', 'Dhaka', '1000', 'Dhaka', 'Dhaka', '5678901234', 'Housekeeping', 22000);

UPDATE Employee
SET first_name = 'Fahim', last_name = 'Beg', gender = 'Male'
WHERE emp_id = 3;

UPDATE Employee
SET first_name = 'Farhan', last_name = 'Beg', gender = 'Male'
WHERE emp_id = 8;

UPDATE Employee
SET first_name = 'Nadeem', last_name = 'Beg', gender = 'Male'
WHERE emp_id = 13;

select * from Employee;


-- Insert into Security_Guard Table
INSERT INTO Security_Guard (emp_id, shift, location) VALUES
(2, 'day', 1),
(7, 'night', 3),
(12, 'day', 4);

select*
from Security_Guard;



-- Insert into Chef Table
INSERT INTO Chef (emp_id, experience) VALUES
(1, 5),
(6, 3),
(11, 9);


select * from Chef;


-- Insert into Receptionist Table
INSERT INTO Receptionist (emp_id, shift) VALUES
(4, 'day');

INSERT INTO Receptionist (emp_id, shift) VALUES
(9, 'night');
INSERT INTO Receptionist (emp_id, shift) VALUES
(14, 'day');


select * from Receptionist;




-- Insert into Room_Service Table
INSERT INTO Room_Service (emp_id, floor_no) VALUES
(5, 2);
INSERT INTO Room_Service (emp_id, floor_no) VALUES
(10, 3);
INSERT INTO Room_Service (emp_id, floor_no) VALUES
(15, 4);

select * from Room_Service;



-- Insert into Driver Table
INSERT INTO Driver (emp_id, experience, driving_license) VALUES
(3, 10, 'DL9234597'),
(8, 4, 'DL1245567'),
(13, 7, 'DL123452');




select * from Driver;



delete from driver



-- Insert data into Room table
INSERT INTO Room (room_id, status, available, type, price, profit_per_room) VALUES
(101, 'clean', 'yes', 'single bed', 2100.00, 500.00),
(102, 'clean', 'yes', 'single bed', 2500.00, 800.00),
(103, 'clean', 'yes', 'single bed', 2000.00, 500.00),
(104, 'clean', 'yes', 'single bed', 2000.00, 500.00);

select *
from room;

INSERT INTO Room (room_id, status, available, type, price, profit_per_room) VALUES
(201, 'clean', 'yes', 'double bed', 4000.00, 800.00),
(202, 'clean', 'yes', 'double bed', 3000.00, 400.00),
(203, 'clean', 'yes', 'double bed', 3500.00, 500.00),
(204, 'clean', 'yes', 'double bed', 3500.00, 500.00);


-- Insert data into Room table
INSERT INTO Room (room_id, status, available, type, price, profit_per_room) VALUES
(301, 'clean', 'yes', 'single bed', 2100.00, 500.00),
(302, 'clean', 'yes', 'single bed', 2500.00, 800.00),
(303, 'clean', 'yes', 'single bed', 2000.00, 500.00),
(304, 'clean', 'yes', 'single bed', 2000.00, 500.00);

INSERT INTO Room (room_id, status, available, type, price, profit_per_room) VALUES
(401, 'clean', 'yes', 'double bed', 4000.00, 800.00),
(402, 'clean', 'yes', 'double bed', 3000.00, 400.00),
(403, 'clean', 'yes', 'double bed', 3500.00, 500.00),
(404, 'clean', 'yes', 'double bed', 3500.00, 500.00);

-- Insert data into Room table
INSERT INTO Room (room_id, status, available, type, price, profit_per_room) VALUES
(501, 'dirty', 'yes', 'single bed', 2100.00, 500.00),
(502, 'clean', 'yes', 'single bed', 2500.00, 800.00),
(503, 'clean', 'yes', 'single bed', 2000.00, 500.00),
(504, 'dirty', 'yes', 'single bed', 2000.00, 500.00);

INSERT INTO Room (room_id, status, available, type, price, profit_per_room) VALUES
(601, 'dirty', 'yes', 'double bed', 4000.00, 800.00),
(602, 'clean', 'yes', 'double bed', 3000.00, 400.00),
(603, 'clean', 'yes', 'double bed', 3500.00, 500.00),
(604, 'dirty', 'yes', 'double bed', 3500.00, 500.00);

INSERT INTO Room (room_id, status, available, type, price, profit_per_room) VALUES
(701, 'clean', 'yes', 'single bed', 2100.00, 500.00),
(702, 'clean', 'yes', 'single bed', 2500.00, 800.00),
(703, 'clean', 'yes', 'single bed', 2000.00, 500.00),
(704, 'clean', 'yes', 'single bed', 2000.00, 500.00);

INSERT INTO Room (room_id, status, available, type, price, profit_per_room) VALUES
(801, 'clean', 'yes', 'double bed', 4000.00, 800.00),
(802, 'clean', 'yes', 'double bed', 3000.00, 400.00),
(803, 'clean', 'yes', 'double bed', 3500.00, 500.00),
(804, 'clean', 'yes', 'double bed', 3500.00, 500.00);

select * from Room;

-- Insert data into Customer table
INSERT INTO Customer (cus_id, first_name, last_name, gender, email, phone, rating) VALUES
(1, 'Rafiq', 'Ahmed', 'Male', 'rafiq.ahmed@example.com', '01855000001', 4),
(2, 'Nusrat', 'Jahan', 'Female', 'nusrat.jahan@example.com', '01866000002', 5);

INSERT INTO Customer (first_name, last_name, gender, email, phone, rating) VALUES
('farzana', 'Ahmed', 'Male', 'rafiq.ahmed@example.com', '01855000001', 4),
('amina', 'Jahan', 'Female', 'nusrat.jahan@example.com', '01866000002', 5);

INSERT INTO Customer (first_name, last_name, gender, email, phone, rating) VALUES
('jenny', 'Ahmed', 'Male', 'rafiq.ahmed@example.com', '01855000001', 4),
('ammmmmm', 'Jahan', 'Female', 'nusrat.jahan@example.com', '01866000002', 5);


select * from Customer;


-- Insert data into Reserve table
INSERT INTO Reserve (cus_id, r_id, room_id, check_in_date, check_out_date, total_bill,status) VALUES
(89, 1, 101, '2025-01-01', '2025-01-03', 4200.00,'cancel'),
(88, 1, 102, '2025-01-02', '2025-01-05', 6300.00,'cancel'),
(87, 1, 104, '2025-02-01', '2025-02-02', 2100.00,'cancel');

INSERT INTO Payment (id, cus_id, total_amount, paid) VALUES
(19, 89, 4200.00, 00.00),
(20, 88, 6300.00, 00.00),
(21, 87, 2100.00, 00.00);




INSERT INTO Reserve (cus_id, r_id, room_id, check_in_date, check_out_date, total_bill) VALUES
( 1,1, 102, '2025-01-01', '2025-01-03', 3000.00);


INSERT INTO Reserve (cus_id, r_id, room_id, check_in_date, check_out_date, total_bill) VALUES
( 80,1, 101, '2025-01-01', '2025-01-02', 2100.00),
( 82,1, 201, '2025-02-01', '2025-02-02', 4000.00);

INSERT INTO Reserve (cus_id, r_id, room_id, check_in_date, check_out_date, total_bill,status) VALUES
( 5,1, 510, '2025-01-01', '2025-02-03', 3000.00,'cancel'),
( 6,1, 510, '2025-01-01', '2025-03-03', 3000.00,'cancel');



delete
from Reserve;

delete
from room;

delete
from customer;


select* from customer;

select * from Reserve;



-- Insert data into Payment table
INSERT INTO Payment (id, cus_id, total_amount, paid) VALUES
(17, 80, 2100.00, 2100.00),
(18, 82, 4000.00, 4000.00);

select * from Payment;




-- 1. Service length of employees (in years)
SELECT
    e.emp_id,
    TIMESTAMPDIFF(YEAR, e.date_of_join, CURDATE()) as service_years
FROM Employee e;

CREATE VIEW EmployeeService AS
SELECT
    e.emp_id,
    TIMESTAMPDIFF(YEAR, e.date_of_join, CURDATE()) AS service_years
FROM Employee e;


select * from EmployeeService;

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
    e.first_name,
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
WHERE r.check_out_date >= CURDATE() and r.status='active';


-- 9. Delete customers who canceled all reservations
DELETE FROM Customer
WHERE cus_id IN (
    SELECT cus_id
    FROM Reserve
    GROUP BY cus_id
    HAVING COUNT(*) = SUM(status = 'cancel')
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

create table hotel_login(
	username varchar(10),
    password int
);

select * from hotel_login;

INSERT INTO hotel_login (username, password) VALUES
("admin", 1234);

select *
from customer;

delete
from customer
where cus_id=64;

select*
from reserve;

select*
from room;




-- 16. Retrieve customer names and their reservation details.
SELECT CONCAT(first_name, " " , last_name) AS name,
       r_id,
       room_id,
       check_in_date,
       check_out_date
FROM Customer
NATURAL JOIN Reserve;


-- 17.Retrieve employees along with their respective department details.
SELECT e.emp_id,  CONCAT(first_name, " " , last_name) AS employee_name, d.name as dept_name, d.budget
FROM Employee e JOIN Department d
ON e.dept_name = d.name;


-- 18. Find customers who have made at least one reservation.
SELECT CONCAT(first_name, " " , last_name) as customer_name FROM Customer c
WHERE EXISTS (
    SELECT 1 FROM Reserve r WHERE c.cus_id = r.cus_id
);

-- 19.Find rooms that are more expensive than all currently reserved rooms.
SELECT * FROM Room r1
WHERE Price > ALL (SELECT total_bill FROM Reserve);


-- 20.Find the total number of reservations per customer
SELECT CONCAT(first_name, " " , last_name) as customer_name, r.Total_Reservations
FROM Customer c,
     (SELECT cus_id, COUNT(*) AS Total_Reservations FROM Reserve GROUP BY cus_id) r
WHERE c.cus_id = r.cus_id;

-- 21.Retrieve employee names along with the department budget they belong to.
SELECT CONCAT(first_name, " " , last_name) as employee_name, (SELECT budget FROM Department d WHERE d.name = e.dept_name) AS Dept_Budget
FROM Employee e;

-- 22.Get the number of reservations per room, ordered by the number of reservations.
SELECT room_id, COUNT(*) AS Total_Reservations
FROM Reserve
GROUP BY room_id
HAVING COUNT(*) > 1
ORDER BY Total_Reservations DESC;

-- 23.Find the total revenue generated from reservations.
WITH ReservationTotals AS (
    SELECT room_id, SUM(total_bill) AS Total_Revenue
    FROM Reserve
    GROUP BY room_id
)
SELECT * FROM ReservationTotals;

-- 24.Find all customers who have made a reservation but have not made a payment.
SELECT cus_id FROM Customer
EXCEPT
SELECT cus_id FROM Payment;

-- 25. find employee who use gp phone
SELECT * FROM Employee WHERE phone LIKE '017%';


SELECT DISTINCT c.cus_id
FROM Customer c
JOIN Payment p ON c.cus_id = p.cus_id
WHERE p.due = 0;



INSERT INTO Customer (first_name, last_name, gender, email, phone) VALUES
('Abdul', 'Karim', 'Male', 'abdul.karim@example.com', '01711112222'),
('Sumaiya', 'Akter', 'Female', 'sumaiya.akter@example.com', '01811113333'),
('Rakib', 'Hasan', 'Male', 'rakib.hasan@example.com', '01622224444'),
('Jannat', 'Ferdous', 'Female', 'jannat.ferdous@example.com', '01933335555'),
('Shahidul', 'Islam', 'Male', 'shahidul.islam@example.com', '01544446666'),
('Nasrin', 'Sultana', 'Female', 'nasrin.sultana@example.com', '01355557777'),
('Mehedi', 'Hasan', 'Male', 'mehedi.hasan@example.com', '01766668888'),
('Rafsan', 'Jani', 'Male', 'rafsan.jani@example.com', '01877779999'),
('Fahmida', 'Rahman', 'Female', 'fahmida.rahman@example.com', '01688880000'),
('Imran', 'Hossain', 'Male', 'imran.hossain@example.com', '01999991111');


-- 11.Get Employees Who Work in Departments With a Budget Greater Than Any Other Department
SELECT emp_id, first_name, last_name, dept_name
FROM Employee
WHERE dept_name IN (SELECT name
                    FROM Department
                    WHERE budget > ANY (SELECT budget
                                        FROM Department));


-- 12.Get Employees Earning More Than the Average Salary.
WITH AvgSalary AS (
    SELECT dept_name, AVG(salary) AS avg_sal FROM Employee GROUP BY dept_name
)
SELECT e.emp_id, e.first_name, e.last_name, e.salary, e.dept_name
FROM Employee e
JOIN AvgSalary a ON e.dept_name = a.dept_name
WHERE e.salary > a.avg_sal;


SELECT emp_id, first_name, last_name, dept_name
FROM Employee
WHERE dept_name IN (SELECT name FROM Department WHERE budget > any (SELECT budget FROM Department));

SELECT e.emp_id, e.first_name, e.last_name, e.dept_name, d.budget
FROM Employee e
JOIN Department d ON e.dept_name = d.name
WHERE d.budget = (SELECT Max(budget),name FROM Department);


select* from department;

-- 20.Find the total number of reservations per customer
SELECT CONCAT(first_name, " " , last_name) as customer_name, r.Total_Reservations
FROM Customer c,
     (SELECT cus_id, COUNT(*) AS Total_Reservations FROM Reserve GROUP BY cus_id) r
WHERE c.cus_id = r.cus_id;

