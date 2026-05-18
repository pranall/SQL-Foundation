INSERT INTO customers (id, first_name, country, score)
VALUES (6,'Ana','USA',NULL),
	(7,'Sam',NULL,100)

SELECT *
FROM customers

INSERT INTO customers (id, first_name,country,score)
VALUES (8,'Max','USA',NULL),
	(9,'Andreas','Germany',NULL)

-- DELETE FROM customers WHERE id = 8

SELECT *
FROM customers

INSERT INTO customers (id,first_name)
VALUES (10, 'Sahra')

SELECT *
FROM customers

-- INSERT using SELECT
INSERT INTO persons (id, person_name, birth_date, phone)
SELECT id,first_name,NULL, 'Unknown'
FROM customers 

SELECT *
FROM persons 

-- UPDATE
-- Change the score of the customer with ID 6 to 0
UPDATE customers
SET score = 0
WHERE id = 6

SELECT *
FROM customers

-- Change the score of the customer with id 10 to 0 and change the country to 'UK'
UPDATE customers 
SET score = 0, country = 'UK'
WHERE id = 10

SELECT *
FROM customers 
WHERE id = 10

-- Update all customers with a NULL score by setting the score to 0.
UPDATE customers 
SET score = 0
WHERE score IS NULL

SELECT *
FROM customers 

-- DELETE
-- Delete all the customers with an ID greater than 5
DELETE FROM customers
WHERE id > 5

SELECT *
FROM customers 

-- TRUNCATE
--Delete all data from persons
TRUNCATE TABLE persons 

SELECT *
FROM persons 