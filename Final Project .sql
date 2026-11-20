-- ----------------------
-- The Null Exceptions
-- ----------------------
-- Sprint 1 : 3 Tables
--

DROP DATABASE IF EXISTS tableready;
CREATE DATABASE tableready;
USE tableready;

-- --------------
-- Customer 
-- --------------
CREATE table Customer (
    customer_id int AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(50) not null,
    phone varchar(15) NOT NULL,
    email varchar(100) NULL,
    CONSTRAINT uq_customer_phone UNIQUE (phone)
);

-- --------------------
-- RestaurantTable table
-- --------------------
CREATE table RestaurantTable (
    table_id int AUTO_INCREMENT PRIMARY KEY,
    table_number int not null,
    capacity int not null,
    CONSTRAINT uq_table_number UNIQUE (table_number),
    CONSTRAINT chk_capacity CHECK (capacity BETWEEN 1 and 16)
);

-- -----------------
-- Reservation table
-- -----------------

CREATE table Reservation (
    reservation_id int AUTO_INCREMENT PRIMARY KEY,
    customer_id int not null,
    table_id int not null,
    res_date DATE not null,
    res_time TIME not null,
    party_size int not null,
    status ENUM('Booked', 'Cancelled') not null default 'Booked',
    created_at TIMESTAMP not null default CURRENT_TIMESTAMP,
    CONSTRAINT fk_res_customer foreign key (customer_id) 
        REFERENCES Customer(customer_id),
    CONSTRAINT fk_res_table FOREIGN KEY (table_id)
        REFERENCES RestaurantTable (table_id),
    CONSTRAINT chk_party_size CHECK (party_size >= 1),
    CONSTRAINT chk_res_hours  CHECK (res_time BETWEEN '10:00:00' AND '22:00:00')
 
);


-- kan 12

CREATE TRIGGER trg_check_capacity
BEFORE INSERT ON Reservation
FOR EACH ROW
SET NEW.party_size = IF(
    NEW.party_size > (SELECT capacity FROM RestaurantTable WHERE table_id = NEW.table_id),
    NULL,
    NEW.party_size);

-- Sample Data 
INSERT INTO RestaurantTable (table_number, capacity) VALUES
    (1, 2), (2, 2), (3, 2),
    (4, 4), (5, 4), (6, 4), (7, 4),
    (8, 6), (9, 6),
    (10, 8);


INSERT INTO Customer (first_name, last_name, phone, email) VALUES
    ('Maria',   'Lopez',    '951-555-0101', 'maria.lopez@example.com'),
    ('James',   'Carter',   '951-555-0102', 'jcarter@example.com'),
    ('Aisha',   'Patel',    '951-555-0103', 'apatel@example.com'),
    ('Daniel',  'Kim',      '951-555-0104', NULL),
    ('Sofia',   'Nguyen',   '951-555-0105', 'sofia.n@example.com'),
    ('Ethan',   'Brooks',   '951-555-0106', 'ebrooks@example.com'),
    ('Grace',   'Thompson', '951-555-0107', NULL),
    ('Lucas',   'Rivera',   '951-555-0108', 'lrivera@example.com'),
    ('Hannah',  'Scott',    '951-555-0109', 'hscott@example.com'),
    ('Noah',    'Bennett',  '951-555-0110', 'nbennett@example.com');


INSERT INTO Reservation (customer_id, table_id, res_date, res_time, party_size, status) VALUES
    -- Friday, Nov 13, 2026

    (1,  1, '2026-11-13', '17:00:00', 2, 'Booked'),
    (2,  1, '2026-11-13', '19:00:00', 2, 'Booked'),
    (3,  4, '2026-11-13', '17:00:00', 4, 'Booked'),
    (4,  5, '2026-11-13', '19:00:00', 3, 'Booked'),
    (5,  8, '2026-11-13', '19:00:00', 5, 'Booked'),
    (6, 10, '2026-11-13', '17:00:00', 8, 'Booked'),
    (7,  2, '2026-11-13', '21:00:00', 1, 'Booked'),
    -- Saturday, Nov 14, 2026

    (8,  4, '2026-11-14', '17:00:00', 4, 'Booked'),
    (9,  6, '2026-11-14', '19:00:00', 2, 'Booked'),
    (10, 9, '2026-11-14', '17:00:00', 6, 'Booked'),
    (1,  3, '2026-11-14', '21:00:00', 2, 'Booked'),
    (2,  7, '2026-11-14', '21:00:00', 3, 'Cancelled');


-- TESTS - kan 14
SHOW TRIGGERS;
USE tableready;
SHOW TABLES;

-- add a reservation test
INSERT INTO Reservation (customer_id, table_id, res_date, res_time, party_size)
 VALUES (3, 5, '2026-11-14', '19:00:00', 4);

-- see all reservations
SELECT reservation_id, customer_id, table_id,
       DATE_FORMAT(res_date, '%Y-%m-%d') AS res_date,
       res_time, party_size, status
FROM Reservation;

--
SELECT reservation_id, customer_id, table_id,
       DATE_FORMAT(res_date, '%Y-%m-%d') AS res_date,
       res_time, party_size, status
FROM Reservation
WHERE res_date = '2026-11-13'
ORDER BY res_time;

-- failed test - party size of 5 at table 1 which only seats 2
-- INSERT INTO Reservation (customer_id, table_id, res_date, res_time, party_size)
-- VALUES (3, 1, '2026-11-14', '17:00:00', 5);

-- failed test - party size of 0 people
-- INSERT INTO Reservation (customer_id, table_id, res_date, res_time, party_size)
-- VALUES (3, 4, '2026-11-14', '17:00:00', 0);

-- failed test - missing reservation time
-- INSERT INTO Reservation (customer_id, table_id, res_date, res_time, party_size)
-- VALUES (3, 1, '2026-11-14', NULL, 2);


-- ===========================================================
-- Sprint 2: User Story 3 - Update Reservation / Customer Info 
-- =========================================================== 
-- Trigger to prevent capacity overflow on UPDATE 
DROP TRIGGER IF EXISTS trg_check_capacity_update;
DELIMITER //
CREATE TRIGGER trg_check_capacity_update 
BEFORE UPDATE ON Reservation 
FOR EACH ROW
BEGIN
    IF NEW.party_size > (SELECT capacity FROM RestaurantTable WHERE table_id = NEW.table_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Update failed: Party size exceeds table capacity';
    END IF;
END;
//
DELIMITER ;

-- =======================================================
-- Test - Update a reservation's time and party size 
-- (Aisha Patel's Nov 14 reservation, table 5, capacity 4)
-- =======================================================
SELECT '-- Before Update: Reservation --' AS step;
SELECT r.reservation_id, c.first_name, c.last_name,
       r.table_id, r.res_date, r.res_time, r.party_size, r.status
FROM Reservation r
JOIN Customer c ON r.customer_id = c.customer_id
WHERE r.customer_id = 3
    AND r.table_id = 5
    AND r.res_date = '2026-11-14';

UPDATE Reservation
SET res_time = '20:00:00', party_size = 2
WHERE customer_id = 3
    AND table_id = 5
    AND res_date = '2026-11-14';

SELECT '-- After Update: Reservation --' AS step;
SELECT r.reservation_id, c.first_name, c.last_name,
       r.table_id, r.res_date, r.res_time, r.party_size, r.status
FROM Reservation r
JOIN Customer c ON r.customer_id = c.customer_id
WHERE r.customer_id = 3
    AND r.table_id = 5
    AND r.res_date = '2026-11-14';


-- ===================================================
-- Test - Update customer contact info (phone + email)
-- =================================================== 
SELECT '-- Before Update: Customer --' AS step;
SELECT customer_id, first_name, last_name, phone, email
FROM Customer
WHERE customer_id = 3;

UPDATE Customer
SET phone = '951-555-0199',
    email = 'aisha.patel@newemail.com'
WHERE customer_id = 3;

SELECT '-- After Update: Customer --' AS step;
SELECT customer_id, first_name, last_name, phone, email
FROM Customer
WHERE customer_id = 3; 


-- ===============================================
-- Failed Test - Party size exceeds table capacity
-- Table 1 has capacity 2 but party size is 5
-- ===============================================
UPDATE Reservation
SET party_size = 5
WHERE customer_id = 1
    AND table_id = 1
    AND res_date = '2026-11-13';


-- ====================================================
-- Failed Test - Update to invalid time (outside hours)
-- ====================================================
UPDATE Reservation
SET res_time = '23:30:00'
WHERE customer_id = 1
    AND table_id = 1
    AND res_date = '2026-11-13';