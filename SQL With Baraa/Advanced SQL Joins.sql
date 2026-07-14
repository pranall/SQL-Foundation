-- LEFT ANTI JOIN: Returns rows from left that has no match in right. The order of the table matters. 
/* SYNTAX
SELECT *
FROM table A
LEFT JOIN table B
ON A.key = B.key
WHERE B.key IS NULL */

-- Get all customers who have not placed any orders
SELECT *
FROM customers 
LEFT JOIN orders 
ON customers.id = orders.customer_id 
WHERE orders.customer_id IS NULL

-- RIGHT ANTI JOIN: Returns rows from right that has no match in left. The order of the table matters. 
/* SYNTAX
SELECT *
FROM table A
RIGHT JOIN table B
ON A.key = B.key
WHERE A.key IS NULL */

-- Get all orders without matching customers
SELECT *
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL

-- Solving the same task using LEFT JOIN
-- Get all orders without matching customers
SELECT *
FROM orders AS o
LEFT JOIN customers AS c
ON c.id = o.customer_id
WHERE c.id IS NULL

-- FULL ANTI JOIN: Returns rows that don't match in either rows. The order of the table does not matter. 
/* SYNTAX
SELECT *
FROM table A
LEFT JOIN table B
ON A.key = B.key
WHERE A.key OR B.key IS NULL */

-- Find customers without orders and orders without customers 
SELECT *
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id 
WHERE c.id IS NULL OR o.customer_id IS NULL

-- Get all customers along with their orders but only for customers who have placed an order (no INNER JOIN used)
SELECT *
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NOT NULL AND o.customer_id IS NOT NULL

SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL

--GENERATE all possible combinations of customers and orders 
SELECT *
FROM customers 
CROSS JOIN orders 