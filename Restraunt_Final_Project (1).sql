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
INSERT INTO Reservation (customer_id, table_id, res_date, res_time, party_size)
VALUES (3, 1, '2026-11-14', '17:00:00', 5);

-- failed test - party size of 0 people
INSERT INTO Reservation (customer_id, table_id, res_date, res_time, party_size)
VALUES (3, 4, '2026-11-14', '17:00:00', 0);

-- failed test - missing reservation time
INSERT INTO Reservation (customer_id, table_id, res_date, res_time, party_size)
VALUES (3, 1, '2026-11-14', NULL, 2);



