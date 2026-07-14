CREATE TABLE students (
	student_id INT PRIMARY KEY NOT NULL,
	student_name VARCHAR (50) NOT NULL,
	country VARCHAR (50) NOT NULL,
	age INT,
	GPA DECIMAL (3,2)
)

CREATE TABLE courses (
	course_id INT PRIMARY KEY NOT NULL,
	course_name VARCHAR (50),
	credits INT
)

CREATE TABLE enrollments (
	enroll_id INT PRIMARY KEY NOT NULL,
	student_id INT,
	course_id INT,
	score INT,
	enroll_date DATE
)

SELECT * 
FROM students 

SELECT * 
FROM courses 

SELECT *
FROM enrollments 

INSERT INTO students VALUES
(1, 'Aarav','India',21,8.5),
(2,'Liam','USA',22,7.2),
(3,'Noah','Canada',20,9.1),
(4,'Emma','UK',23,6.),
(5,'Olivia','India',21, NULL)

INSERT INTO courses VALUES
(101,'Math',4),
(102,'Physics',3),
(103,'CS',5)

INSERT INTO enrollments VALUES
(1,1,101,85,'2024-01-01'),
(2,2,102,70,'2024-02-01'),
(3,3,103,95,'2024-03-01'),
(4,1,103,88,'2024-02-15'),
(5,5,101,NULL,'2024-04-01');

SELECT * 
FROM students 

SELECT * 
FROM courses 

SELECT *
FROM enrollments 

-- Practice Questions
-- 1. Basic SELECT
-- Retrieve all columns from students.
SELECT *
FROM students 

-- Retrieve only name, country, and gpa.
SELECT student_name,country,GPA 
FROM students 

-- Retrieve students where gpa is NULL.
SELECT *
FROM students 
WHERE GPA IS NULL

-- Retrieve students from India with age > 20.
SELECT *
FROM students 
WHERE country = 'India' AND age > 20

---------------------------------------------------------------------

-- 2. WHERE + Conditions
-- Find students with GPA between 7 and 9.
SELECT *
FROM students 
WHERE GPA BETWEEN 7 AND 9

-- Retrieve students not from India.
SELECT *
FROM students 
WHERE country != 'India'
-- <> is safer than !=

-- Get enrollments where score is not NULL.
SELECT *
FROM enrollments 
WHERE score IS NOT NULL

-- Find students whose name starts with 'A'.
SELECT *
FROM students 
WHERE student_name LIKE 'A%'

-- 3. ORDER BY
-- Sort students by GPA descending.
SELECT *
FROM students 
ORDER BY GPA DESC

-- Sort students by country ascending, then GPA descending.
SELECT *
FROM students 
ORDER BY country ASC, GPA DESC

-- Get enrollments ordered by most recent date.
SELECT *
FROM enrollments 
ORDER BY enroll_date DESC

-- 4. GROUP BY + Aggregation
-- Find average GPA per country.
SELECT country, AVG(GPA) AS average_GPA
FROM students 
GROUP BY country

-- Count number of students per country.
SELECT country,COUNT(student_id) AS total_students
FROM students 
GROUP BY country 

-- Find total enrollments per course.
SELECT course_id, COUNT(enroll_id) AS total_enrollments
FROM enrollments 
GROUP BY course_id

-- Find max score per course.
SELECT course_id, MAX(score) AS maximum_score
FROM enrollments
GROUP BY course_id

-- 5. HAVING
-- Find countries with average GPA > 7.5.
SELECT country, AVG(GPA) AS average_GPA
FROM students 
GROUP BY country 
HAVING AVG(GPA) > 7.5

-- Find courses with more than 1 enrollment.
SELECT course_id,COUNT(enroll_id) AS total_enrollments
FROM enrollments
GROUP BY course_id 
HAVING COUNT(enroll_id) > 1

-- Find countries where count of students ≥ 2.
SELECT country,COUNT(student_id) AS total_students
FROM students 
GROUP BY country 
HAVING COUNT(student_id) >= 2

-- 6. DISTINCT
-- Get unique list of countries from students.
SELECT DISTINCT country
FROM students 

-- Get unique course_ids from enrollments.
-- Question makes no sense cause course ids are always unique no matter what. Using DISTINCT is pointless

--7. LIMIT / TOP
--(SQL Server: TOP, MySQL/Postgres: LIMIT)
-- Get top 3 students by GPA.
SELECT TOP 3 *
FROM students 
ORDER BY GPA DESC

-- Get lowest 2 scores from enrollments.
SELECT TOP 2 *
FROM enrollments 
ORDER BY score ASC

-- Get 2 most recent enrollments.
SELECT TOP 2 *
FROM enrollments 
ORDER BY enroll_date DESC

--If NULL exists NULL may appear first depending on DBMS
-- Best Practice:

SELECT TOP 2 *
FROM enrollments
WHERE score IS NOT NULL
ORDER BY score ASC

------------------------------------------------------------------
-- Comparison Operators
-- 1: Retrieve all customers whose score is exactly 900.
SELECT *
FROM customers 
WHERE score = 900

--2: Retrieve all customers whose score is greater than 500.
SELECT * 
FROM customers 
WHERE score > 500

-- 3. Retrieve all customers whose score is less than 500
SELECT *
FROM customers 
WHERE score < 500

-- 4. Retrieve all customers whose score is not equal to 0.
SELECT *
FROM customers 
WHERE score <> 0

-- 5. Retrieve all orders with sales greater than or equal to 20.
SELECT *
FROM orders 
WHERE sales >= 20

-- 6. Retrieve all orders with sales less than or equal to 15.
SELECT *
FROM orders 
WHERE sales <= 15

-- AND
-- 7. Retrieve customers from Germany whose score is greater than 400.
SELECT * 
FROM customers 
WHERE country = 'Germany' AND score > 400

-- 8. Retrieve customers from USA whose score is less than 500.
SELECT *
FROM customers 
WHERE country = 'USA' AND score < 500

-- 9. Retrieve orders with sales greater than 10 and less than 30.
SELECT *
FROM orders 
WHERE sales > 10 AND sales < 30

-- 10. Retrieve customers whose score is at least 350 and whose country is Germany.
SELECT *
FROM customers 
WHERE score >= 350 AND country = 'Germany'

-- OR
-- 11. Retrieve customers from Germany or USA.
SELECT *
FROM customers 
WHERE country = 'Germany' OR country = 'USA'

-- 12. Retrieve customers whose score is 0 or 900.
SELECT *
FROM customers 
WHERE score = 0 OR score = 900

-- 13. Retrieve orders whose sales are 15 or 35.
SELECT *
FROM orders 
WHERE sales = 15 OR sales = 35

-- 14. Retrieve customers from UK or whose score is greater than 800.
SELECT *
FROM customers 
WHERE country = 'UK' OR score > 800

-- NOT
-- 15. Retrieve customers who are not from Germany.
SELECT *
FROM customers 
WHERE NOT country = 'Germany'

-- 16. Retrieve customers whose score is not greater than 500.
SELECT *
FROM customers 
WHERE NOT score > 500

-- 17. Retrieve orders whose sales are not equal to 20.
SELECT *
FROM orders 
WHERE NOT sales = 20

-- 18. Retrieve customers whose country is not USA.
SELECT *
FROM customers 
WHERE NOT country = 'USA'

-- BETWEEN
-- 19. Retrieve customers whose score is between 300 and 800.
SELECT *
FROM customers 
WHERE score BETWEEN 300 AND 800

-- 20. Retrieve customers whose score is between 500 and 900.
SELECT *
FROM customers 
WHERE score BETWEEN 500 AND 900

-- 21. Retrieve orders whose sales are between 10 and 20.
SELECT *
FROM orders
WHERE sales BETWEEN 10 AND 20

-- 22. Retrieve orders placed between '2021-01-01' and '2021-06-30'.
SELECT *
FROM orders
WHERE order_date BETWEEN '2021-01-01' AND '2021-06-30'

-- IN
-- 23.Retrieve customers from Germany, USA, or UK.
SELECT *
FROM customers 
WHERE country IN ('Germany', 'USA', 'UK')

-- 24. Retrieve customers whose score is in (0, 350, 900).
SELECT *
FROM customers 
WHERE score IN (0, 350, 900)

-- 25. Retrieve orders whose sales are in (10, 20).
SELECT *
FROM orders 
WHERE sales in (10,20)

-- 26. Retrieve orders whose customer_id is in (1, 3).
SELECT *
FROM orders 
WHERE customer_id IN (1,3)

-- NOT IN
-- 27. Retrieve customers not from Germany or USA.
SELECT *
FROM customers 
WHERE country NOT IN ('Germany','USA')

--28. Retrieve customers whose score is not in (0, 350).
SELECT *
FROM customers 
WHERE score NOT IN (0,350)

-- 29. Retrieve orders whose customer_id is not in (1, 2).
SELECT *
FROM orders 
WHERE customer_id NOT IN (1,2)

-- 30. Retrieve orders whose sales are not in (10, 15).
SELECT *
FROM orders 
WHERE sales NOT IN (10,15)

-- LIKE
-- 31. Retrieve customers whose first name starts with 'M'.
SELECT *
FROM customers 
WHERE first_name LIKE 'M%'

-- 32. Retrieve customers whose first name starts with 'P'.
SELECT *
FROM customers 
WHERE first_name LIKE 'P%'

-- 33. Retrieve customers whose first name ends with 'n'.
SELECT *
FROM customers 
WHERE first_name LIKE '%n'

-- 34. Retrieve customers whose first name contains 'ar'.
SELECT *
FROM customers 
WHERE first_name LIKE '%ar%'

-- 35. Retrieve customers whose first name has exactly 5 characters.
SELECT *
FROM customers 
WHERE first_name LIKE '_____'

-- 36. Retrieve customers whose country starts with 'G'.
SELECT *
FROM customers 
WHERE country LIKE 'G%'

-- Mixed Problems
-- 37. Retrieve customers from Germany whose score is between 300 and 600.
SELECT *
FROM customers 
WHERE country = 'Germany' AND score BETWEEN 300 AND 600

-- 38. Retrieve customers from Germany or USA whose score is greater than 300.
SELECT *
FROM customers 
WHERE (country = 'Germany' OR country = 'USA') AND score > 300

-- 39. Retrieve customers whose first name starts with 'M' and whose score is greater than 400.
SELECT *
FROM customers 
WHERE first_name LIKE 'M%' AND score > 400

-- 40. Retrieve orders with sales between 10 and 35 and customer_id not equal to 2.
SELECT *
FROM orders 
WHERE sales BETWEEN 10 AND 35 AND customer_id <> 2

-- 41. Retrieve customers whose country is in ('Germany','UK') and whose score is not 750.
SELECT *
FROM customers 
WHERE country IN ('Germany','UK') AND score <> 750

-- 42. Retrieve customers whose first name contains 'o' and whose score is at least 500.
SELECT *
FROM customers 
WHERE first_name LIKE '%o%' AND score >= 500

-- 43. Retrieve orders placed after '2021-04-01' and whose sales are in (10,20).
SELECT *
FROM orders 
WHERE order_date > '2021-04-01' AND sales IN (10,20)

-- 44. Retrieve customers who are not from USA and whose score is greater than 300.
SELECT *
FROM customers 
WHERE NOT country = 'USA' AND score > 300

-- 45. Retrieve customers whose first name starts with 'M' or whose country is UK.
SELECT *
FROM customers 
WHERE first_name LIKE 'M%' OR country = 'UK'

-- 46. Retrieve orders whose customer_id is in (1,2,3) and sales are between 15 and 35.
SELECT *
FROM orders 
WHERE customer_id IN (1,2,3) AND sales BETWEEN 15 AND 35

-----------------------------------------------------------------------------------
-- JOINS Basics (INNER, LEFT, RIGHT, FULL)
-- Part 1: INNER JOIN
-- 1. Show all customer names along with their order IDs.
SELECT c.first_name, o.order_id
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id

-- 2. Show customer name, country, and sales amount for each order.
SELECT c.first_name, c.country,o.sales 
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id
-- Do you mean to say I must use group by?

-- 3. Show only customers who have placed orders.
SELECT c.first_name
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id

-- 4. Show all orders made by customers from Germany.
SELECT o.order_id, c.first_name,c.country
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id
WHERE c.country = 'Germany'

-- 5. Show customer names and order dates where sales are greater than 15.
SELECT c.first_name, o.order_date,o.sales
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id
WHERE o.sales > 15

-- Part 2: LEFT JOIN
-- 6. Show all customers and any orders they may have.
SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id

-- 7. Find customers who have never placed an order.
SELECT c.first_name
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id 
WHERE o.order_id IS NULL

-- 8. Show customer names and order IDs, including customers without orders.
SELECT c.first_name, o.order_id
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id 

-- 9. Show all customers and sales amounts. Include customers without sales.
SELECT c.first_name, o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id

-- 10. Find customers whose order_id is NULL after a LEFT JOIN.
SELECT o.order_id
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.order_id IS NULL

-- Part 3: RIGHT JOIN
-- 11. Show all orders and matching customer information.
SELECT o.order_id, c.first_name
FROM orders AS o
RIGHT JOIN customers AS c
ON o.customer_id = c.id 

--12. Find orders that do not have a matching customer.
SELECT c.first_name, o.order_id 
FROM customers AS c
RIGHT JOIN orders AS o
ON o.customer_id = c.id
