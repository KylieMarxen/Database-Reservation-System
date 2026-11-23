-- ==========================================
-- User Story 4 Testing (KAN-23)
-- ==========================================

-- View the reservation beofre cancellation 
SELECT reservation_id, customer_id, table_id, res_date, res_time, party_size, status
FROM Reservation
WHERE reservation_id = 3;

-- Verify the cancellation was successful
SELECT reservation_id, customer_id, table_id, res_date, res_time, party_size, status
FROM Reservation
WHERE reservation_id = 3;

-- Table is now available for a new booking
INSERT INTO Reservation (customer_id, table_id, res_date, res_time, party_size, status)
VALUES (5, 4, '2026-11-13', '17:00:00', 4, 'Booked');

SELECT reservation_id, customer_id, table_id, res_date, res_time, status
FROM Reservation
WHERE table_id = 4 AND res_date = '2026-11-13'
ORDER BY res_time;