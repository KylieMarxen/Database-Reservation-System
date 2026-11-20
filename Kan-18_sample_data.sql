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