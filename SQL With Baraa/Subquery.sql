/* Subquery: It is a query inside a query. In this case the query inside gets executed first. The result is not known to the user. This 
result is then used by the main query to give the final result which is seen by the user. 

+----------------------+---------------------------------------------------+
| SUBQUERY             | DESCRIPTION                                       |
+----------------------+---------------------------------------------------+
| Definition           | A query written inside another query              |
| Main Query           | Also called Outer Query                           |
| Subquery             | Also called Inner Query                           |
| Alternate Name       | Nested Query                                      |
| Execution Order      | Innermost query executes first                    |
| Result Flow          | Inner → Parent → Main Query                       |
+----------------------+---------------------------------------------------+

Execution Flow

+---------+------------------+--------------------------------------+
| Step    | Operation        | Purpose                              |
+---------+------------------+--------------------------------------+
| Step 1  | JOIN Tables      | Combine data from multiple tables    |
| Step 2  | FILTERING        | Apply WHERE conditions               |
| Step 3  | TRANSFORMATIONS  | CASE, Functions, Calculations        |
| Step 4  | AGGREGATIONS     | COUNT, SUM, AVG, MIN, MAX            |
+---------+------------------+--------------------------------------+

Query Structure

+-----------------------------------------------------+
|                    MAIN QUERY                       |
|                                                     |
|   +---------------------------------------------+   |
|   |                 SUBQUERY                    |   |
|   |                                             |   |
|   |   +-------------------------------------+   |   |
|   |   |             SUBQUERY                |   |   |
|   |   |                                     |   |   |
|   |   |   +-----------------------------+   |   |   |
|   |   |   |         SUBQUERY            |   |   |   |
|   |   |   +-----------------------------+   |   |   |
|   |   +-------------------------------------+   |   |
|   +---------------------------------------------+   |
+-----------------------------------------------------+

Execution Order

+------------------------------+
| Deepest Subquery             |
+------------------------------+
              |
              v
+------------------------------+
| Parent Subquery              |
+------------------------------+
              |
              v
+------------------------------+
| Parent Subquery              |
+------------------------------+
              |
              v
+------------------------------+
| Main Query                   |
+------------------------------+

Mental Model

+------------------------------+
| Do NOT read top to bottom    |
+------------------------------+
              |
              v
+------------------------------+
| Read from inside out         |
+------------------------------+
              |
              v
+------------------------------+
| Deepest query executes first |
+------------------------------+
              |
              v
+------------------------------+
| Main query executes last     |
+------------------------------+ */

--Subquery result types: 
-- Scalar Subquery: If we need just one value, scalar subquery is used. The below code returns all columns and rows
SELECT *
FROM Sales.Orders

--The below code returns only one value, one column and one row
SELECT AVG(Sales) AS averagesales
FROM Sales.Orders 

-- Row Subquery: Returns multiple rows of single column.The below code returns multiple columns and rows
SELECT *
FROM Sales.Orders

--Select any row for row. subquery. Returns one column,multiple rows.
SELECT ShipAddress 
FROM Sales.Orders

--Table Subquery: Returns multiple rows and multiple columns like any other table.
SELECT *
FROM Sales.Orders

SELECT SalesPersonID,ShipDate
FROM Sales.Orders 

/* Subquery in FROM Clause: Used as a temporary table for the main query
Syntax:
SELECT column1,column2,...
FROM (SELECT column FROM table1 WHERE condition) AS alias */

--Task: Find products that have a price higher than the average price of all products

-- Main Query
SELECT *
FROM (
    --SubQuery
    SELECT ProductID,Price,AVG(Price) OVER () AS AveragePriceOfProduct
    FROM Sales.Products
)AS T -- T is an alias
WHERE Price > AveragePriceOfProduct

--Task: Rank the customers based on the total amount of sales.
SELECT *,
RANK() OVER(ORDER BY TotalSales DESC) AS CustomerRank
FROM (
    SELECT CustomerID,SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
) T

/* Use GROUP BY + Window Function together when aggregation is needed first and then need another 
calculation on top of that aggregation.

Example:
Step 1: Get total sales per customer.

SELECT
    CustomerID,
    SUM(Sales) AS CustomerSales
FROM Orders
GROUP BY CustomerID

Output:
CustomerID | CustomerSales
A          | 380
B          | 200
C          | 100

Step 2: Rank customers based on total sales.

SELECT
    CustomerID,
    SUM(Sales) AS CustomerSales,
    RANK() OVER(ORDER BY SUM(Sales) DESC) AS SalesRank
FROM Orders
GROUP BY CustomerID

Output:

CustomerID | CustomerSales | SalesRank
A          | 380           | 1
B          | 200           | 2
C          | 100           | 3


Notice:

GROUP BY created customer totals
↓
RANK() ranked those totals

Another example: Find monthly sales and running total.

SELECT
    OrderMonth,
    SUM(Sales) AS MonthlySales,
    SUM(SUM(Sales))
        OVER(ORDER BY OrderMonth)
        AS RunningTotal
FROM Orders
GROUP BY OrderMonth

Think: GROUP BY → Monthly Sales 

Window Function → Running Total of Monthly Sales

RULE: Question asks: Aggregate raw data then use GROUP BY
Question asks: Aggregate result of an aggregation use GROUP BY + Window Function

Common examples:
1) Sales per customer then rank customers
2) Sales per month then running total
3) Sales per department then percentage contribution
4) Orders per customer then rank customers
5) Average salary per department then compare departments

When there is: First calculate X per group. Then do something with X expect GROUP BY + Window Function. */

/*SELECT SubQuery: Used to aggregate data side by side with the main query's data allowing for direct comparison
SYNTAX: 
SELECT
    Column 1,
    (SELECT column FROM table1 FROM table1 WHERE condition) AS Alias
FROM table 1 

RULE: The result of (SELECT column FROM table1 FROM table1 WHERE condition) AS Alias must be Scalar/single value */

--Show the productid, names,prices and total number of orders 
-- Main Query
SELECT 
    ProductID,
    Product,
    Price,
        (SELECT COUNT(OrderID) FROM Sales.Orders) AS TotalOrders --SubQuery
FROM Sales.Products

-- JOIN Subquery: Used to prepare the data(filtering or aggregating) before joining it with other tables.
-- Show all customer details and find the total orders for each customer.
SELECT c.*,o.TotalOrders
FROM Sales.Customers AS c
LEFT JOIN (
    SELECT
    CustomerID,
    COUNT(*) AS TotalOrders
    FROM Sales.Orders
    GROUP BY CustomerID) AS o
ON c.CustomerID = o.CustomerID

/* Subquery in WHERE Clause: Comparison Operators
Syntax: 
SELECT column1,column2
FROM table1
WHERE column = (SELECT column FROM table2 WHERE condition)
NOTE: (SELECT column FROM table2 WHERE condition) must be a scalar quantity */

-- Find the products that have a higher price than the average of all the products 
SELECT *
FROM (
  SELECT ProductID, Product,Price,AVG(Price) OVER () AS AveragePriceOfProducts
  FROM Sales.Products 
) T WHERE price > AveragePriceOfProducts

--Another Method:
--Main Query
SELECT ProductID,Price,(SELECT AVG(Price) FROM Sales.Products) AS AveragePrice
FROM Sales.Products
WHERE price > (SELECT AVG(Price) FROM Sales.Products)

/* IN Operator SubQuery: Checks whether a value matches any value from the list. Used for multiple value comparison.
SYNTAX: 
SELECT Column1, Column2,..
FROM table1
WHERE Column IN (SELECT Column FROM table2 WHERE condition) */

--Task: Show the details of orders made by customers in Germany
SELECT *
FROM Sales.Orders
WHERE CustomerID IN (
                    SELECT
                    CustomerID
                    FROM Sales.Customers
                    WHERE Country = 'Germany')

--Task: Show the details of orders made by customers who are not from Germany
SELECT *
FROM Sales.Orders
WHERE CustomerID NOT IN(
                    SELECT
                    CustomerID
                    FROM Sales.Customers
                    WHERE Country = 'Germany')

/*SubQuery: ANY and ALL
--ANY Operator: Checks if the value matches ANY value within the list. Used to check if a value is true for AT LEAST one
of the values in a list.
SYNTAX: 
SELECT column1, column2,..
FROM table1
WHERE column < ANY (SELECT column FROM table1 WHERE condition)

Similarly for ALL
SYNTAX: 
SELECT column1, column2,..
FROM table1
WHERE column < ALL (SELECT column FROM table1 WHERE condition) */

--Task: Find female employees whose salaries are greater than the salaries of any male employee
-- Main Query
SELECT EmployeeID,
       FirstName,
       Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

SELECT FirstName, Salary 
FROM Sales.Employees WHERE Gender = 'M'

-- ALL Operator: Checks if a value matches all values within the list
--Task: Find female employees whose salaries are greater than the salaries of all male employee
SELECT EmployeeID,
       FirstName,
       Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

SELECT FirstName, Salary 
FROM Sales.Employees WHERE Gender = 'M'

/* Non-Correlated and Correlated SubQueries
+----------------+------------------------------------------------------+------------------------------------------------------+
| Attribute      | Non-Correlated Subquery                             | Correlated Subquery                                  |
+----------------+------------------------------------------------------+------------------------------------------------------+
| Definition     | Subquery is independent of the main query           | Subquery is dependent on the main query              |
+----------------+------------------------------------------------------+------------------------------------------------------+
| Execution      | Executed once and its result is used by main query  | Executed for each row processed by the main query    |
|                | Can be executed on its own                          | Cannot be executed on its own                        |
+----------------+------------------------------------------------------+------------------------------------------------------+
| Ease of Use    | Easier to read                                      | Harder to read and more complex                      |
+----------------+------------------------------------------------------+------------------------------------------------------+
| Performance    | Executed only once                                  | Executed multiple times                              |
|                | Better performance                                  | Usually worse performance                            |
+----------------+------------------------------------------------------+------------------------------------------------------+
| Usage          | Static comparisons                                  | Row-by-row comparisons                               |
|                | Filtering with constants                            | Dynamic filtering                                    |
+----------------+------------------------------------------------------+------------------------------------------------------+.

Rule of Thumb:
Non-Correlated: "Give me a single result, then use it."

Correlated: "For each row, calculate something based on that row." */

-- Task: Show all customer details and find the total orders for each customer.
SELECT *,
(SELECT COUNT(*) FROM Sales.Orders AS o WHERE o.CustomerID = c.CustomerID) AS TotalSales
FROM Sales.Customers AS c

/* Exists Operator: Check if a subquery returns any rows 
SELECT column1, column2,..
FROM table2
WHERE EXISTS (SELECT 1
              FROM table1
              WHERE table1.ID = table2.ID */

-- Task: Show the order details for customers in Germany
SELECT *
FROM Sales.Orders AS o
WHERE EXISTS (SELECT 1
              FROM Sales.Customers AS c
              WHERE Country = 'Germany'
              AND o.CustomerID = c.CustomerID)

-- Task: Show the order details for customers in Germany
SELECT *
FROM Sales.Orders AS o
WHERE NOT EXISTS (SELECT 1
              FROM Sales.Customers AS c
              WHERE Country = 'Germany'
              AND o.CustomerID = c.CustomerID)

-- In the below case, there is no output shown for the subquery because customer with customerID 2 in customers table does not exists
SELECT *
FROM Sales.Orders AS o
WHERE NOT EXISTS (SELECT 1
              FROM Sales.Customers AS c
              WHERE Country = 'Germany'
              AND c.CustomerID = 2)

/* Core Conceptual Questions
Q1) What is the difference between:

SELECT AVG(Salary)
FROM Employees

and

SELECT *
FROM Employees
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM Employees
)
Answer: the first code is a single query which executes row by row and then returns the output. In this code, the output
is visible to the user. In the second code, (SELECT AVG(Salary)FROM Employees) is a subquery which executes first and the
result is not visible. The value of this query is then used by the main query SELECT * FROM Employees WHERE Salary > in order
to give a correct answer while overcoming limitations certain concepts have which can be overcomed by the usage of subquery.

Q2) Why must this return only one value?WHERE Salary >(SELECT ...)
Answer: it would give an error if the output of the subquery is not scalar since it is used in WHERE Clause

Q3) What is the difference between:IN and = for subqueries?
Answer: = is used to compare just one value. Eg: WHERE AVG = 2. Writing WHERE = 2,3,4 will result in an error. To solve this,
IN is used where a list is defined in which multiple values are stored. WHERE year IN (1997,1998,1999,2000) is correct and
gives more options for comparison.

Q4) Explain ANY: ANY operator is used when at least one of the multiple conditions must be satisfied. 

Q5) Explain ALL: ALL operator is used when all of the multiple conditions must be satisfied

Q6) which is easier to satify ANY or ALL? ANY operator is easier to satisfiy because the results are displayed even if one
of the condition is satisfied. ALL is restrictive in which all the conditions must be satisfied.

Q7) Difference between: Non-Correlated Subquery and Correlated Subquery in one sentence.
Answer: Non-correlated subquery is independent and does not rely on other queries values.
Correlated subquery is dependent on the main query and is executed first and its value is then used to perform further tasks.

Q8) When would you use: EXISTS instead of IN
Answer: EXISTS is used to check whether the query returns any value or not. the value returned could be scalar, a row,
few rows, columns, or a table. IN checks whether the value given for comparison exists in the list of IN

Output Prediction
Male Salaries: 1000,2000,3000

Q9) Does salary = 1500 satisfy? Salary > ANY(...)
Answer: Yes. 

Q10) Does salary = 1500 satisfy? Salary > ALL(...)
Answer: No

Q11) Predict: SELECT COUNT(*) FROM Orders returns: Scalar, Row, Table
Answer: Scalar

Q12) Predict: SELECT CustomerID FROM Orders returns: Scalar, Row, Table
Answer: Row

Q21) Correlated. */

