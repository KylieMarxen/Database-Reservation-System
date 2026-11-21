use tableready;

-- ==========================================
-- The NULL Exceptions
-- Sprint 2 - KAN-15
-- Prevent Conflicting Active Reservations
-- ==========================================

USE tableready;

-- Run once, after checking for existing active conflicts

ALTER TABLE Reservation
ADD COLUMN active_booking TINYINT
GENERATED ALWAYS AS (
    CASE
        WHEN status = 'Booked' THEN 1
        ELSE NULL
    END
) STORED;

ALTER TABLE Reservation
ADD CONSTRAINT uq_active_reservation
UNIQUE (
    table_id,
    res_date,
    res_time,
    active_booking
);