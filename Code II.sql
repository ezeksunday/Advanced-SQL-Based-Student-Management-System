-- ----------------------------------------------
-- 1. CREATING VIEWS
-- ----------------------------------------------

-- Q1. Use the student_management database. 
USE student_management;

-- Q2. Create a view named student_overview that shows the ID, name, and grade columns from the students table.
CREATE VIEW student_overview AS
SELECT id, name, grade FROM Students;

-- Q3. Query the student_overview view to verify it displays the correct data.
-- To Verify the view:
SELECT * FROM student_overview;

-- Q4. Modify the view to include a calculated field that shows age categorised as 'Minor' if the age is less than 18, and 'Adult' otherwise.
-- Note: To modify an existing view, you typically use CREATE OR REPLACE VIEW or DROP VIEW and then CREATE VIEW.
-- We'll use CREATE OR REPLACE VIEW for simplicity.
CREATE OR REPLACE VIEW student_overview AS
SELECT 
	id, 
    name, 
    age, 
    grade, 
    CASE
		WHEN age < 18 THEN 'Minor'
        ELSE 'Adult'
	END AS AgeCategory
FROM Students;
-- To verify the modified view that include age category
SELECT * FROM student_overview;

-- ----------------------------------------------
-- 2. STORED PROCEDURES
-- ----------------------------------------------
-- Q1. Create a stored procedure named add_student that takes the name, age, and grade as parameters and
-- 	  inserts a new record into the students table.

DELIMITER //
CREATE PROCEDURE add_student(
    IN student_name VARCHAR(100),
    IN student_age INT,
    IN student_grade VARCHAR(50)
)
BEGIN
    INSERT INTO Students (name, age, grade)
    VALUES (student_name, student_age, student_grade);
END //
DELIMITER ;

-- Q2. Run the stored procedure to add a new student.
CALL add_student('Dino Black', 12, '7th Grade'); 

-- To Verify the new student has been added
SELECT * FROM Students
WHERE name = 'Dino Black';

-- Q3. Modify the stored procedure to return the id of the newly added student after insertion.
DROP PROCEDURE IF EXISTS add_student;

DELIMITER //
CREATE PROCEDURE add_student(
    IN student_name VARCHAR(100),
    IN student_age INT,
    IN student_grade VARCHAR(50),
    OUT new_student_id INT
)
BEGIN
    INSERT INTO Students (name, age, grade)
    VALUES (student_name, student_age, student_grade);
    
    SET new_student_id = LAST_INSERT_ID();
END //
DELIMITER ;

-- Q4. Verify that the stored procedure works as expected.
SET @student_id = 0;
CALL add_student('Joe Baron', 15, '10th Grade', @student_id);
SELECT @student_id;

-- ----------------------------------------------
-- 2. USER DEFINED FUNCTIONS (UDFs)
-- ----------------------------------------------

-- Q1. Create a user-defined function named calculate_discount that takes a price and a discount percentage as input and returns the discounted price.

DELIMITER //
CREATE FUNCTION calculate_discount(
    p_price DECIMAL(10, 2),        -- Input: Original price
    p_discount_percentage DECIMAL(5, 2) -- Input: Discount percentage (e.g., 15 for 15%)
)
RETURNS DECIMAL(10, 2)
DETERMINISTIC -- Indicates that the function always returns the same result for the same input parameters
BEGIN
    DECLARE discounted_price DECIMAL(10, 2);
    SET discounted_price = p_price - (p_price * (p_discount_percentage / 100));
    RETURN discounted_price;
END //
DELIMITER ;

-- Q2. Write a query to test the function by calculating the discounted price for an item with a price of 100 and a discount of 15%.
--  Test the discount function
SELECT calculate_discount(100, 15) AS discounted_price;




