-- No Join: Returns the data from tables without joining them
-- Retrieve all data from customers and orders and display in two different results
SELECT * 
FROM customers 

SELECT *
FROM orders

-- INNER JOIN: Returns only matching rows from both tables
-- Get all customers along with their orders, but only for customers who have placed an order
SELECT customers.id, customers.first_name,orders.customer_id, orders.sales
FROM customers 
INNER JOIN orders 
ON customers.id = orders.customer_id

-- Using aliases
SELECT c.id, c.first_name,o.customer_id, o.sales
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id

/* LEFT JOIN: Returns all the rows from the left table and only the matching row from the right table. Here the 'FROM' table is 
considered as LEFT table. Hence the order of the tables matter */
-- Get all customers along with their orders, including those without orders
SELECT c.id,c.first_name,o.order_id, o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id

/* RIGHT JOIN: Returns all the rows from the right table and only the matching row from the right table. Here the 'FROM' table is 
considered as LEFT table. Hence the order of the tables matter */
-- Get all customers along with their orders including orders without matching customers 
SELECT c.id,c.first_name,o.order_id, o.sales
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id

-- Alternate method
SELECT c.id,c.first_name,o.order_id, o.sales
FROM orders AS o
LEFT JOIN customers AS c
ON c.id = o.customer_id

-- FULL JOIN: Returns all the rows from both tables. The order of the tables do not matter
-- Get all customers and all orders even if there is no match
SELECT *
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id
