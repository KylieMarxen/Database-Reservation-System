-- ----------------------
-- The Null Exceptions
-- ----------------------
-- Sprint 2 : Customer Updates

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

