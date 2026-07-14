-- NULLs: NULL is and unknown information. It is not equal to zero. Zero has value. NULL is a mystery.
-- ISNULL(): Replaces NULL with a specific value. 
-- SYNTAX: ISNULL(value,replacement_value)
-- Eg: ISNULL(Shipping_Address,'unknown') here unknown is the default value
/* eg2: ISNULL(Shipping_address,Billing_address) in this scenario if any value from shipping adress is NULL, it takes the
replacement value from billing address 

FACTS about ISNULL: 
1) It is limited to only two values
2) It is faster than COALESCE
3) It differs in different databases, like in SQL Server ISNULL is used, in Oracle NVL is used and in MySQL IFNULL is used.
The functionality and usage of the function across the databases does not change */

-- COALESCE: Returns the first non NULL value from the list
/* SYNTAX: COALESCE(value1,value2,value3...)
eg: COALESCE(Shipping_Address,'unknown'),COALESCE(Shipping_address,Billing_address),
COALESCE(Shipping_address,Billing_address,'unknown') 

FACTs about COALESCE
1) It can contain unlimited values.
2) Hence it is slower than ISNULL
3) COALESCE is available across all the databases unlike ISNULL hence it is preferred when multiple databases are used.*/

--Task: Find the average scores for the customers (Used windows functions)
SELECT CustomerID,Score,
COALESCE(Score,0) AS Score2,
AVG(Score) OVER () AS AvgScores,
AVG(COALESCE(Score,0)) OVER() AS AvgScores2
FROM Sales.Customers

-- USE CASE: Handling NULLs 
-- Mathematical Operations: NULLs must be handled before doing any mathematical operations
-- Anything added with NULL will give NULL value only.
-- Task: display full name of the customers in a single field by merging their first and last names and add 10 to their scores
SELECT CustomerID,FirstName,LastName,Score,
FirstName + ' ' + LastName AS FullName --Since there is NULL in Mary's surname, her fullname results in NULL as well.
FROM Sales.Customers 

-- COALESCE used the replacement '' to replace the surname and then merged.
SELECT CustomerID,FirstName,LastName,Score,
FirstName + ' ' + COALESCE(LastName,'') AS FullName, 
COALESCE(Score,'') + 10 AS NewScore
--Score + 10 AS AddedScore
FROM Sales.Customers 

/* -- Handling NULLs in JOINs
Table 1
| year | type | orders |
| ---- | ---- | ------ |
| 2024 | a    | 30     |
| 2024 | NULL | 40     |
| 2025 | b    | 50     |
| 2025 | NULL | 60     |

Table 2
| year | type | sales |
| ---- | ---- | ----- |
| 2024 | a    | 100   |
| 2024 | NULL | 200   |
| 2025 | b    | 300   |
| 2025 | NULL | 400   |

When these two tables are joined, SQL does not undertand NULL values and hence skips them entirely. This will result in
inaccurate info, missing information and thus business loss. 
To solve this, the NULLs are replaced with '' in order to let SQL know that the space is not NULL which will result in the 
JOINs results to display that row as well. A sample code is as follows:

SELECT a.year,a.type,a.orders,b.sales
FROM Table1 a
JOIN Table2 b
ON a.year = b.year
AND ISNULL(a.typ,'') = ISNULL(b.type,'') */

--Handling NULLs:
-- Sorting Data: Handling NULLs before sorting the data
--Task: Sort the customers from lowest to highest scores with NULLs appearing last
SELECT CustomerID,Score
FROM Sales.Customers
ORDER BY Score ASC 

--Method 1: this is a lazy way. Replace NULL with a huge value
SELECT CustomerID,Score,COALESCE(Score,10000)
FROM Sales.Customers
ORDER BY COALESCE(Score,10000) ASC 

--Method 2: Professional Way
SELECT CustomerID,Score,
CASE WHEN Score IS NULL THEN 1 ELSE 0 END AS Flag
FROM Sales.Customers 
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score

--NULL Function
-- NULLIF(): Compares two expressions and returns 1) NULL, if they are equal; 2)First Value if they are not equal
-- Syntax: NULLIF(Value1,Value2) Eg: NULLIF(Shipping_address,'unknown') OR NULLIF(Shipping_address,BillingAddress)
-- Refer to PPT for more info.

--NULLIF Use case:
--Division by zero: Preventing the error of dividing by zero
--Task: Find the sales price for each order by dividing the sales by the quantity
SELECT OrderID,Sales,Quantity,
Sales/Quantity AS Price --Gives and error because there is a NULL in Quantity
FROM Sales.Orders

SELECT OrderID,Sales,Quantity,
Sales/NULLIF(Quantity,0) AS Price --Anything divided by NULL will be NULL which is better than getting an error
FROM Sales.Orders

--ISNULL:Returns True id the value is NULL else returns False
-- Syntax: Value IS NULL/Value IS NOT NULL. EG: Shipping_Address IS NULL/Shipping_Address IS NOT NULL

--ISNULL use case: Filtering Data: Used to search for missing informations or NULLs
--Task: Identity the customers who have no scores
SELECT CustomerID,Score
FROM Sales.Customers
WHERE Score IS NULL

--Task: Show a list of all customers who have scores
SELECT CustomerID,Score
FROM Sales.Customers
WHERE Score IS NOT NULL

--ISNULL Use Case: Anti Joins
--LEFT ANTI JOIN AND RIGHT ANTI JOIN: Finding unmatched rows between two tables
--Task: Show the list of all the customers who have no placed an order (Anti Left Join)
/* Use MyDatabase for this query
SELECT *
FROM customers AS c

SELECT *
FROM orders AS o

SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id=o.customer_id 
WHERE o.customer_id IS NULL */

-- All rows from the left table without matches in the right table
SELECT *
FROM Sales.Customers AS c

SELECT *
FROM Sales.Orders AS o

SELECT *
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID 
WHERE o.CustomerID IS NULL

-- RIGHT ANTI JOIN
SELECT *
FROM Sales.Customers AS c

SELECT *
FROM Sales.Orders AS o

SELECT *
FROM Sales.Orders AS o
RIGHT JOIN Sales.Customers AS c
ON c.CustomerID = o.CustomerID 
WHERE c.CustomerID IS NULL

/* Dataset 1: Employees
| emp_id | first_name | last_name | department | salary |
| ------ | ---------- | --------- | ---------- | ------ |
| 1      | Alice      | Smith     | Data       | 80000  |
| 2      | Bob        | NULL      | Data       | 75000  |
| 3      | Charlie    | Brown     | HR         | NULL   |
| 4      | David      | Lee       | NULL       | 90000  |
| 5      | Eva        | Wilson    | Finance    | 0      |

Questions 1) Display a full name column.
SELECT emp_id,first_name + ' '+ last_name AS full_name,department,salary
FROM Employees

2) Display a full name column without returning NULL when last_name is NULL.
SELECT emp_id,first_name + ISNULL(last_name,'') AS full_name,department,salary -- ISNULL(Salary,0) + 5000 can be used as well
FROM Employees

3) Display salary + 5000 for every employee. Handle NULL salaries.
SELECT emp_id,first_name, salary, ISNULL(Salary,'') + 5000 AS new_salary ,department
FROM Employees

4) Display department. Replace NULL departments with: Unknown
SELECT department,ISNULL(department,'unknown') AS new_department
FROM Employees

5) Display: emp_id, department, salary. Sort salaries from highest to lowest with NULL salaries appearing last.
SELECT emp_id, department, salary, ISNULL(salary,0) AS new_salary
FROM Employees
ORDER BY ISNULL(salary,0), salary DESC
I used 0 here cause then NULL be become zero and will remain last while sorting. This is a lazy,unprofessional method,
the efficient method uses CASE and I have not yet reached it.

6) Find employees whose department is missing.
SELECT emp_id, department
FROM Employees
WHERE department IS NULL

7) Find employees whose department is known.
SELECT emp_id, department
FROM Employees
WHERE department IS NOT NULL

8) Display: salary,salary_or_zero
SELECT emp_id, salary, ISNULL(salary,0) AS salary_or_zero
FROM Employees
Idk what you wanted me to do, i tried my best with this one.

9) Display: salary, salary_or_1000 using COALESCE.
SELECT emp_id, salary, COALESCE(salary,1000) AS salary_or_1000
FROM Employees

10) Replace: Finance with NULL using NULLIF. Return: department, new_department
SELECT emp_id, department,NULLIF(department,'Finance') AS new_department
I am still getting an hang of NULLIF, tried my best

Dataset 2: Orders
| order_id | sales | quantity |
| -------- | ----- | -------- |
| 1        | 100   | 5        |
| 2        | 200   | 0        |
| 3        | 150   | 3        |
| 4        | 400   | NULL     |
| 5        | 250   | 10       |

Questions.11) Calculate: sales / quantity without causing divide-by-zero errors.
SELECT order_id,sales,quantity,
Sales/NULLIF(quantity,0) AS Price 
FROM Orders
Ig I still need practice with this one.

12) Calculate: sales / quantity while replacing NULL quantity with 1.
SELECT order_id,sales,quantity,
Sales/NULLIF(quantity,1) AS Price --Anything divided by 1 will give the same number hence it is a safe number.
FROM Orders
This needs genuine practice 

13) Identify orders with missing quantity.
SELECT order_id,quantity
FROM Orders
WHERE quantity IS NULL

14) Identify orders with available quantity.
SELECT order_id,quantity
FROM Orders
WHERE quantity IS NOT NULL

15) Display: quantity, quantity_or_zero
SELECT order_id, quantity,ISNULL(quantity,0) AS quantity_or_zero
FROM Orders

Dataset 3: Customers
| customer_id | country |
| ----------- | ------- |
| 1           | USA     |
| 2           | Germany |
| 3           | NULL    |
| 4           | USA     |
| 5           | NULL    |

Questions. 16) Replace NULL countries with: Unknown
SELECT customer_id, country, ISNULL(country,'Unknown') AS new_countries
FROM Customers

17) Count customers by country after replacing NULL with: Unknown
SELECT country, ISNULL(country,'Unknown') AS new_countries,COUNT(*) AS all_countries
FROM Customers
GROUP BY ISNULL(country,'Unknown')

18) Sort countries alphabetically with NULL countries appearing last.
SELECT customer_id,country,ISNULL(country,'Z') AS new_countries -- Z will by default always come last. 
FROM Customers
ORDER By ISNULL(country,'Z'),country ASC

19) Return only customers whose country is NULL.
SELECT customer_id,country
FROM Customers
WHERE country IS NULL

20) Return only customers whose country is NOT NULL.
SELECT customer_id,country
FROM Customers
WHERE country IS NOT NULL 

NULLIF practice

Dataset 1: Products
| product_id | quantity |
| ---------- | -------- |
| 1          | 10       |
| 2          | 0        |
| 3          | 5        |
| 4          | 0        |
| 5          | 20       |

Q1) Replace all zeros with NULL. Return: quantity,new_quantity
SELECT product_id,quantity,NULLIF(quantity,0) AS new_quantity --Used zero cause some quantity is 0 and 0=0 will return NULL
FROM Products

Q2) Calculate: 100 / quantity without divide-by-zero errors.
SELECT product_id, quantity,100/NULLIF(quantity,0) AS new_quantity
FROM Products

Q3) Return only rows where: NULLIF(quantity,0) produces NULL.
SELECT product_id,NULLIF(quantity,0) AS new_quantity 
FROM Products
WHERE NULLIF(quantity,0)

Q4) Return: product_id, quantity, NULLIF(quantity,5). Predict which rows become NULL.
SELECT product_id, quantity, NULLIF(quantity,5) AS new_quantity
FROM Products
Will return: product_id: 3, quantity: 5, new_quantity: NULL

Dataset 2
| employee_id | department |
| ----------- | ---------- |
| 1           | Data       |
| 2           | HR         |
| 3           | Finance    |
| 4           | Finance    |
| 5           | Data       |

Q5) Convert: Finance -> NULL. Leave everything else unchanged.
SELECT employee_id, department, NULLIF(department,'Finance') AS new_department
FROM Employees

Q6) Return only rows where: NULLIF(department,'Finance') becomes NULL.
SELECT employee_id, department, NULLIF(department,'Finance') AS new_department
FROM Employees
Will return 2 rows: employee_id: 3 department: Finance new_department: NULL 
and employee_id: 4 department: Finance new_department: NULL

Q7) Predict the result:
SELECT employee_id,
       department,
       NULLIF(department,'Data')
FROM Employees
Answer: | employee_id | department |
| ----------- | ---------- |
| 1           | Data       |
| 2           | HR         |
| 3           | Finance    |
| 4           | Finance    |
| 5           | NULL       |

Dataset 3: Orders
| order_id | sales |
| -------- | ----- |
| 1        | 100   |
| 2        | 0     |
| 3        | 250   |
| 4        | 0     |
| 5        | 500   |

Q8) Convert all zero sales to NULL.
SELECT order_id, sales, NULLIF(sales,'0) AS new_sales
FROM Orders

Q9) Return: sales,NULLIF(sales,250) Predict the output.
Answer: order_id: 3 sales: 250 will be NULL

Q10) Calculate: 1000 / sales without divide-by-zero errors.
SELECT order_id, sales, 1000/NULLIF(sales,0) AS new_sales
FROM Orders

Interview Style. Q11) What does this return? SELECT NULLIF(10,10)
Answer: returns NULL because both values are the same.

Q12) What does this return? SELECT NULLIF(10,5)
Answer: Returns 10 since both values are unequal and 10 is the first value. NULLIF returns the first value if values are inequal

Q13) What does this return? SELECT NULLIF('USA','USA')
Answer: returns NULL because both values are the same.

Q14) What does this return? SELECT NULLIF('USA','Germany')
Answer: Returns 'USA' 

Q15) Without executing: SELECT 100 / NULLIF(0,0) What is the result?
Answer: NULL. since both values are the same, NULL is returned. Anything added,subtracted,multiplied,
divided by NULL gives NULL as a result.

Q16) Without executing: SELECT 100 / NULLIF(5,0) What is the result?
Answer: 20. The values are not same hence 5 is returned since it is the first value. 100 divided by 5 is 20.

From the previous set
12) Calculate: sales / quantity while replacing NULL quantity with 1.
SELECT order_id,sales,quantity,
Sales/NULLIF(quantity,1) AS Price --Anything divided by 1 will give the same number hence it is a safe number.
FROM Orders
This needs genuine practice 