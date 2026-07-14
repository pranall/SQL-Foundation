/* Window Functions Basics: Performs calculations (eg: aggregations) on a specific subset of data without losing 
the level of detail of rows

+----------------------+----------------------------------+----------------------------------+
| Feature              | GROUP BY                         | WINDOW FUNCTIONS                 |
+----------------------+----------------------------------+----------------------------------+
| Calculation Level    | Group-Level                      | Row-Level                        |
| Row Count            | Reduces Rows                     | Preserves Rows                   |
| Output               | One Row Per Group                | Every Original Row Remains       |
| Aggregation Result   | One Aggregate Per Group          | Aggregate Repeated Per Row       |
| Detail Rows          | Lost                             | Retained                         |
+----------------------+----------------------------------+----------------------------------+

Example

Input Data

+----+---------+-------+
| ID | Product | Sales |
+----+---------+-------+
| 1  | Caps    | 10    |
| 2  | Caps    | 30    |
| 3  | Gloves  | 5     |
| 4  | Gloves  | 20    |
+----+---------+-------+

GROUP BY

+---------+------------+
| Product | TotalSales |
+---------+------------+
| Caps    | 40         |
| Gloves  | 25         |
+---------+------------+

WINDOW FUNCTION

+----+---------+-------+------------+
| ID | Product | Sales | TotalSales |
+----+---------+-------+------------+
| 1  | Caps    | 10    | 40         |
| 2  | Caps    | 30    | 40         |
| 3  | Gloves  | 5     | 25         |
| 4  | Gloves  | 20    | 25         |
+----+---------+-------+------------+

Mental Model

GROUP BY
→ Collapses groups of rows into a single row.

WINDOW FUNCTION
→ Does not collapse rows.
→ Attaches group calculations back to each row. */

--Task: Find total sales across all orders. The below code shows output without aggregation 
SELECT SUM(Sales) AS sumofsales
FROM Sales.Orders

--Task: Find the total sales for each product
SELECT SUM(Sales) AS sumofsales,ProductID
FROM Sales.Orders
GROUP BY ProductID 

--Task: Find the total sales for each product additionally provide details such as order id and order date. 
--The below code will give an error because GROUP BY demands same column names in its syntax like SELECT
SELECT OrderID,OrderDate,ProductID,SUM(Sales) AS sumofsales
FROM Sales.Orders
GROUP BY ProductID

/* The below query works, but GROUP BY did not aggregate based on products as 101 product apprears multiple times 
and shows sales of each product thus destroying the aggregation.
GROUP BY cannot do aggregations and provide details at the same time. */
SELECT OrderID,OrderDate,ProductID,SUM(Sales) AS sumofsales
FROM Sales.Orders
GROUP BY OrderID,OrderDate,ProductID

/* Above limitations of GROUP BY are solved using Window Functions.
In the below code, result granularity is maintained and window funtions returns a result for each row */
SELECT SUM(Sales) OVER()
FROM Sales.Orders

/* In the below code, PARTITION is like a GROUP BY. In the result, we can see that 101 productid is displayed 4 times 
with the total sales. This maintained the granularity. */
SELECT 
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesbyProducts
FROM Sales.Orders 

-- This enables us to add more columns and details in the SELECT statement.
SELECT 
	OrderID,OrderDate,ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesbyProducts
FROM Sales.Orders

/* Conclusion: 
1) GROUP BY is used for Simple Data Analysis (Aggregations)
2) WINDOW functions are used for advanced data analysis (Aggregations + Details) */

/* Synatx of Windows Function:
windows funtion f(x) | Partition Clause | Order Clause | Frame Clause
Partition,order and frame clause together make up the OVER() clause. 
OVER() clause is used to indicate SQL that window functions are used. 

Partition Clause has three types: NOTE: the column names are not real and are only used for understanding.
1) SUM(Sales) OVER(): In this nothing is mentioned after OVER(). SQL performs SUM() over the entire table in this case.
2) SUM(Sales) OVER(PARTITION BY Product): PARTITION is mentioned which means SQL now divided, partitions, makes windows. Column name
is mentioned as well which is Product in this case. SQL now performs SUM() operation only on the Product Table.
2) SUM(Sales) OVER(PARTITION BY Product,ShippingSales): PARTITION is mentioned which means SQL now divided, partitions, makes windows. 
Column names are mentioned which are Product and ShippingSales in this case. SQL now performs SUM() operation on both 
Product and ShippingSales Table. */

--Task: Find the total sales across all orders additionally provide details such as order id and order date
SELECT OrderID,OrderDate,ProductId,
SUM(Sales) OVER() AS TotalSales
FROM Sales.Orders 

--Task: Find the total sales for each product and additionaly provide details such as order id and order date
SELECT OrderID,OrderDate,ProductId,
SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSales
FROM Sales.Orders 

--Task: Find the total sales across all orders additionally provide details such as order id and order date.
-- Find the total sales for each product and additionaly provide details such as order id and order date.
-- Find the total sales for each combination of product and order sales 
SELECT OrderID,OrderDate,ProductId,Sales,
SUM(Sales) OVER() AS TotalSales,
SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProduct,
SUM(Sales) OVER(PARTITION BY ProductID,OrderStatus) AS TotalSalesByProductandORderStatus
FROM Sales.Orders

-- ORDER BY is used to sort the data within the window using ASC and DESC. 
--They are optional for aggregate functions but mandatory for Rank and Value Functions.

--Task: Rank each order based on their sales from highest to lowest along with order_id and order_date
SELECT OrderID,OrderDate,
RANK() OVER(ORDER BY Sales) AS RankSales
FROM Sales.Orders

--Window Frame: Define a subset of rows within each window that is relevant for the calculation.
SELECT OrderID,OrderDate,OrderStatus,Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) TotalSales
FROM Sales.Orders

/* Compact Frame: For only PRECEDING, the current rows can be skipped
Normal form: ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
Short From: ROWS 2 FOLLOWING
Default Frame: ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
If ORDER BY is used, FRAME will be used. if frame is not mentioned,the default frame like above will be used.

Window Function Rules
1) WINDOW Functions must only be used in the SELECT and ORDER BY clause
2) NESTED WINDOW FUNCTIONS are not allowed.
3) SQL will execute the windows function after executing the WHERE clause
4) WINDOW Functions will only be used with GROUP BY in the same query if the same columns are used */

/*Conceptual Questions.Q1) Why does this return 2 rows?
SELECT ProductID,
       SUM(Sales)
FROM Sales.Orders
GROUP BY ProductID

while this returns 100 rows?

SELECT ProductID,
       Sales,
       SUM(Sales) OVER(PARTITION BY ProductID)
FROM Orders

ANSWER:There is no gurantee that the forst code will return two rows. Row count will depend on how many productIDs are present. Since 
GROUP BY is used,it collapses the rows into groups and since GROUP BY is used with product id, it groups according to the productid which
means that SUM(Sales) is calculated per productid. Granularity is not preserved by GROUP BY. The second code will return more rows since
granularity is preserved by WINDOW Functions and SUM(Sales) is calculated for every row irrespective of the grouping. It does not collapse
the rows.

Q2) True or False? GROUP BY preserves row granularity.
Answer: False

Q3) rue or False? Window functions preserve row granularity.
Answer: True

Q4) If a table has 1,000 rows, how many rows are returned?
SELECT *,
       SUM(Sales) OVER()
FROM Orders
Aswer: 1000 rows will be returned

Q5) What is the difference between: SUM(Sales) and SUM(Sales) OVER()
Answer: SUM(Sales) is used with GROUP BY and is used for basic queries. Column names used in GROUP BY must be present in the SELECT
Statement. SUM(Sales) OVER() indicates use of windows functions since OVER() is used and it is used for complex analysis and it 
allows multiple column names in the SELECT statement. 

Q6) What does PARTITION BY do?
Answer: PARTITION BY indicates the SQL that window functions must be applied only on a specific set of data. Column names must be
included in order to state on which subset of data function must be applied (eg: SUM,RANK) etc

Q7) Does PARTITION BY reduce rows?
ANSWER: No. 

Q8) What happens if PARTITION BY is omitted? SUM(Sales) OVER()
Answer: Similar answer to Question 1

Q9) Suppose:Product A,Product A,Product B,Product B. How many partitions are created by:PARTITION BY Product
ANSWER: 2. Product A and Product B

Q10) Why is this valid?
SELECT OrderID,
       OrderDate,
       ProductID,
       SUM(Sales) OVER(PARTITION BY ProductID)
FROM Orders

but this is not?

SELECT OrderID,
       OrderDate,
       ProductID,
       SUM(Sales)
FROM Orders
GROUP BY ProductID

ANSWER: In GROUP BY, aggregations are performed based on the mentioned column name which is productId in this case. The drawback of 
GROUP BY is that it is mandatory to have same column names in the SELECT statement as in the GROUP BY. The second code will give an error.
Also, if more columns are added in the GROUP BY, the code won't give an error, it will just destroy the aggregation by aggregating every
column wise. This drawback is overcome by Windows functions since the aggregations are performed row wise which preserves row granularity.
And it allows us to have multiple columns in the SELECT Statement.

Tiny Coding Questions Q11) Show every order together with total sales of the entire table. */
SELECT OrderID,Sales,
SUM(Sales) OVER () AS TotalSales
FROM Sales.Orders

-- Q12) Show every order together with total sales of its product.
SELECT OrderID,Sales,
SUM(Sales) OVER (PARTITION BY ProductID) AS TotalSalesOfProduct
FROM Sales.Orders

/* Q13) Show every employee together with average salary of all employees.
SELECT emp_id,salary
AVG(salary) OVER() AS AverageSalary
FROM employees

Q14) Show every employee together with average salary of their department.
SELECT emp_id,salary,department
AVG(salary) OVER(PARTITION BY department) AS AverageSalary

Q15) Show every order together with count of orders for its customer.
SELECT OrderID,COUNT(*)
FROM employees
Umm, I did not quite understand th 14th and 15th one.

Q16) Predict output rows:

ID Product Sales

1  A      10
2  A      20
3  B      30
4  B      40
SELECT ID,
       Product,
       Sales,
       SUM(Sales)
       OVER(PARTITION BY Product)
FROM T
Answer: 4 rows

Q17) Predict output rows:
SELECT ID,
       Sales,
       SUM(Sales)
       OVER()
FROM T
Answer: It depends upon how many IDs are present. Difficult to predict without data.

Q18) What business problem is impossible with GROUP BY but easy with window functions? Give one example.
Answer: Mostly all business problems. I have given the reason why in previous answers.

Q19) Why are window functions called "window" functions?
Answer: Because they do partition (a window) and perform operation only on that 'window' or 'part'

Q20) Complete the sentence:

GROUP BY aggregates and collapses rows.

WINDOW FUNCTIONS aggregate and maintains row granularity rows. */