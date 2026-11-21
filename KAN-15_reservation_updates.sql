-- ==========================================
-- The NULL Exceptions
-- Sprint 2 - KAN-15
-- Reservation UPDATE Validation
-- ==========================================

USE tableready;

-- Prevent updates that exceed table capacity
DROP TRIGGER IF EXISTS trg_check_capacity_update;

DELIMITER //

CREATE TRIGGER trg_check_capacity_update
BEFORE UPDATE ON Reservation
FOR EACH ROW
BEGIN
    DECLARE max_capacity INT;

    SELECT capacity
    INTO max_capacity
    FROM RestaurantTable
    WHERE table_id = NEW.table_id;

    IF NEW.party_size > max_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Update failed: Party size exceeds table capacity';
    END IF;
END//

DELIMITER ;