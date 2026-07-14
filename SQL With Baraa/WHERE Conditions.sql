-- WHERE Condition

--Comparison Operators
-- = : Checks if two values are equal 
-- Retrieve all customers from Germany
SELECT *
FROM customers 
WHERE country = 'Germany'

-- Retrieve all customers who are not from Germany
-- <> != : Checks if two values are not equal
SELECT *
FROM customers 
WHERE country <> 'Germany'

-- Retrieve all customers with score greater than 500
-- > : Checks if a value is greater than another value. 
SELECT *
FROM customers 
WHERE score > 500

-- Retrieve all customers with score of 500 or more
-- >= : Checks if a value is greater than or equal to another value
SELECT *
FROM customers 
WHERE score >=500

-- Retrieve all customers with score less than 500
-- < : Checks if a value is less than another value
SELECT *
FROM customers 
WHERE score < 500

-- Retrieve all customers with a score of 500 or less
-- <= : Checks if a value is less than or equal to another value
SELECT *
FROM customers 
WHERE score <= 500

-- Logical operators
-- AND operator: All the coditions must be true
-- Retrieve all the customers who are from USA AND have a score above 500
SELECT *
FROM customers 
WHERE country = 'USA' AND score > 500

-- OR operator: At least one condition must be true
-- Retrieve all the customers who are either from USA OR have a score greater than 500 
SELECT *
FROM customers 
WHERE country = 'USA' OR score > 500

-- NOT Operator: (Reverse) Excludes matching values 
-- Retrieve customers with score not less than 500 
SELECT *
FROM customers 
WHERE NOT score < 500 

-- Range operator
-- BETWEEN operator: Check if a value is within a range 
-- Retrieve all the customers whose score falls in the range of 100 to 500 
SELECT *
FROM customers 
WHERE score BETWEEN 100 AND 500

-- Another method. It must be noted that the range boundaries in 'BETWEEN' are inclusive, which means 100 and 500 are included.
SELECT *
FROM customers 
WHERE score >=100 AND score <= 500

-- Membership Operator
-- IN operator: Check if a value exists in a list 
-- Retrieve all customers from either Germany or USA
SELECT *
FROM customers 
WHERE country IN ('Germany', 'USA')

--Another method
SELECT *
FROM customers 
WHERE country = 'Germany' OR country = 'USA'

-- LIKE operator: Search for a pattern in text 
-- Find all the customers whose first name starts with 'M'
SELECT *
FROM customers 
WHERE first_name LIKE 'M%'

--Find out all the customers whose first name ends with 'n'
SELECT *
FROM customers 
WHERE first_name LIKE '%n'

-- Find all customers whose first name contains 'r'
SELECT *
FROM customers 
WHERE first_name LIKE '%r%'

-- Find all customers whose first name has 'r' in the third position
SELECT *
FROM customers 
WHERE first_name LIKE '__r%'