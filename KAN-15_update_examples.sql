
-- ==========================================
-- The NULL Exceptions
-- Sprint 2 - KAN-15
-- Reservation UPDATE Examples
-- ==========================================

USE tableready;

-- View reservation before updating
SELECT *
FROM Reservation
WHERE reservation_id = 3;

-- Update reservation time
UPDATE Reservation
SET res_time = '18:00:00'
WHERE reservation_id = 3
  AND status = 'Booked';

-- Update party size
UPDATE Reservation
SET party_size = 3
WHERE reservation_id = 3
  AND status = 'Booked';

-- Update reservation date
UPDATE Reservation
SET res_date = '2026-11-14'
WHERE reservation_id = 3
  AND status = 'Booked';

-- Update assigned table
UPDATE Reservation
SET table_id = 5
WHERE reservation_id = 3
  AND status = 'Booked';

-- Verify updated reservation
SELECT
    r.reservation_id,
    c.first_name,
    c.last_name,
    t.table_number,
    t.capacity,
    r.res_date,
    r.res_time,
    r.party_size,
    r.status
FROM Reservation r
JOIN Customer c
    ON r.customer_id = c.customer_id
JOIN RestaurantTable t
    ON r.table_id = t.table_id
WHERE r.reservation_id = 3;