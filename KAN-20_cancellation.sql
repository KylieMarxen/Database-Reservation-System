-- ==========================================
-- The NULL Exceptions
-- Sprint 2 - KAN-20
-- Implement Reservation Cancellation
-- ==========================================

USE tableready;

-- View the reservation before cancellation 
SELECT
    reservation_id,
    customer_id,
    table_id,
    res_date,
    res_time,
    party_size,
    status
FROM Reservation
WHERE reservation_id = 3;

-- Cancel the reservation
UPDATE Reservation
SET status = 'Cancelled'
WHERE reservation_id = 3
  AND status = 'Booked';

-- Verify that the reservation was cancelled
SELECT
    reservation_id,
    customer_id,
    table_id,
    res_date,
    res_time,
    party_size,
    status
FROM Reservation
WHERE reservation_id = 3;