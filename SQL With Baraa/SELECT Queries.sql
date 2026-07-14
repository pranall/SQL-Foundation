-- Retrieve All Customer Data

SELECT *
FROM customers

-- Retrieve All Customer's name, country and score
SELECT first_name, country, score
FROM customers

-- WHERE Clause
-- Retrieve Customers with score not equal to zero
SELECT *
FROM customers
WHERE score !=0

-- Retrieve Customers from Germany
SELECT *
FROM customers
WHERE country = 'Germany'

-- ORDER BY Clause
-- Retrieve all the customers and sort the results by the highest score first
SELECT *
FROM customers 
ORDER BY score DESC

-- Retrieve all the customers and sort the results by the lowest score first
SELECT *
FROM customers 
ORDER BY score ASC

-- Nested ORDR BY
-- Retrieve all the customers and sort the results by the country and then by the highest score
SELECT *
FROM customers 
ORDER BY country ASC, score DESC

-- GROUP BY Clause
-- Find the total score from each country
SELECT country, SUM(score) AS total_score
FROM customers
GROUP BY country 

-- Find total score and total number of customers for each country
SELECT country, SUM(score) AS total_score, COUNT(id) AS total_customers
FROM customers 
GROUP BY country

-- HAVING Clause
-- Find the average score for each country considering only customers with a score not equal to 0 
-- and return only those countries with and average score greater than 430
SELECT country, AVG(score) AS average_score
FROM customers 
WHERE score !=0 
GROUP BY country 
HAVING AVG(score) > 430

-- DISTINCT Clause
-- Return unique list of all countries
SELECT DISTINCT country 
FROM customers

-- TOP (Limit) Clause
-- Retrieve only three customers
SELECT TOP 3 *
FROM customers 

-- Retrieve top 3 customers with highest scores
SELECT TOP 3 *
FROM customers 
ORDER BY score DESC

-- Retrieve the lowest 2 customers based on scores
SELECT TOP 2 *
FROM customers 
ORDER BY score ASC

-- Get the two most recent orders
SELECT TOP 2 *
FROM orders
ORDER BY order_date ASC