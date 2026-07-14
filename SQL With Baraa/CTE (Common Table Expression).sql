/* CTE (Common Table Expression): Temporary names result set (virtual table) that can be used multiple times within your
query to simplify and organize complex query.

Differences between CTE and Subquery:
1) The result in Subquery is temporary and can be used only once. after the value is used by the main query to give the 
result, the value vanishes. */

/* CTEs support all types of aggregations and clauses. Literally everything. Except for ORDER BY, we cannot sort data using
ORDER BY in CTE. It has to be used at the end of the main query */
--Task: Step 1: Find the total sales per customer 
WITH CTE_Total_Sales AS
(
	SELECT CustomerID, SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
	--ORDER BY CustomerID -- Gives an error
)
--Main Query
SELECT 
c.CustomerID, --Comes from physical table
c.FirstName,  --Comes from physical table
c.LastName,   --Comes from physical table
cts.TotalSales --This comes from the CTE table.
FROM Sales.Customers AS c
LEFT JOIN CTE_Total_Sales AS cts -- This joins the CTE table with the physical table Customers
ON cts.CustomerID = c.CustomerID
ORDER BY CustomerID -- Sorts the data and does not give error

/* Multiple CTEs: These CTEs are standalone CTEs and are independent. They do not rely on each other for outputs. They 
reside in Databases and when a particular main query needs their output, they are included.
+--------------------------------------------------+
|                 CTE Query                         |
|               (CTE Definition)                    |
+--------------------------------------------------+

WITH CTE_Name1 AS
(
    SELECT ...
    FROM ...
    WHERE ...
)

, CTE_Name2 AS
(
    SELECT ...
    FROM ...
    WHERE ...
)

+--------------------------------------------------+
|                  Main Query                       |
|                  (CTE Usage)                      |
+--------------------------------------------------+

SELECT ...
FROM CTE_Name1
JOIN CTE_Name2
WHERE ...

            +------------------+
            |    CTE_Name1     |
            +------------------+
                    |
                    |
                    v

            +------------------+
            |    CTE_Name2     |
            +------------------+
                    |
                    |
                    v

        +--------------------------+
        |        Main Query        |
        +--------------------------+
        | FROM CTE_Name1           |
        | JOIN CTE_Name2           |
        +--------------------------+ */

-- Step 1: Find the total sales per customer
WITH CTE_Total_Sales AS
(
	SELECT CustomerID, SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
	--ORDER BY CustomerID -- Gives an error
)
-- Step 2: Find the last order date for each customer
, CTE_Last_Order AS 
(
SELECT 
    CustomerID,
    MAX(OrderDate) AS LastOrder
FROM Sales.Orders
GROUP BY CustomerID
)
--Main Query
SELECT 
c.CustomerID, --Comes from physical table
c.FirstName,  --Comes from physical table
c.LastName,   --Comes from physical table
cts.TotalSales, --This comes from the CTE table.
clo.LastOrder
FROM Sales.Customers AS c
LEFT JOIN CTE_Total_Sales AS cts -- This joins the CTE table with the physical table Customers
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order AS clo
ON clo.CustomerID = c.CustomerID

/* Nested CTE: It is a CTE inside another CTE. A nested CTE uses the result of another CTE so it cannot run independently.
In this case, the CTE which is directly connected to the database is considered as standalone CTE and the rest CTEs are 
considered as nested CTE's cause their output depends on the first CTE 

+--------------------------------------------------+
|                 Standalone CTE                   |
|                (CTE Definition)                  |
+--------------------------------------------------+

WITH CTE_Name1 AS
(
    SELECT ...
    FROM ...
    WHERE ...
)

                    ↓

+--------------------------------------------------+
|                   Nested CTE                     |
|                (CTE Definition)                  |
+--------------------------------------------------+

, CTE_Name2 AS
(
    SELECT ...
    FROM CTE_Name1
    WHERE ...
)

                    ↓

+--------------------------------------------------+
|                    Main Query                    |
|                   (CTE Usage)                    |
+--------------------------------------------------+

SELECT ...
FROM CTE_Name2
WHERE ...

---------------------------
Dependency Flow

CTE_Name1
    ↓
CTE_Name2
    ↓
Main Query

---------------------------
WITH CTE_Name1 AS
(
    SELECT ...
    FROM ...
    WHERE ...
),
CTE_Name2 AS
(
    SELECT ...
    FROM CTE_Name1
    WHERE ...
)
SELECT ...
FROM CTE_Name2
WHERE ... */

-- Step 1: Find the total sales per customer
WITH CTE_Total_Sales AS
(
	SELECT CustomerID, SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
	--ORDER BY CustomerID -- Gives an error
)
-- Step 2: Find the last order date for each customer
, CTE_Last_Order AS 
(
SELECT 
    CustomerID,
    MAX(OrderDate) AS LastOrder
FROM Sales.Orders
GROUP BY CustomerID
)
/*Step 3: Rank customers based on Total Sales Per Customers. This step won't run independently because it uses the
CTE_Total_Sales CTE table in FROM clause */
,CTE_Customer_Rank AS
(
SELECT 
CustomerID,
TotalSales,
RANK() OVER(ORDER BY TotalSales DESC) AS CustomerRank
FROM CTE_Total_Sales
)
-- Step 4: Segment customers based on their total sales.
,CTE_Customer_Segments AS
(
SELECT
CustomerID,
TotalSales,
CASE WHEN TotalSales > 100 THEN 'High'
     WHEN TotalSales > 80 THEN 'Medium'
     ELSE 'Low'
END CustomerSegments
FROM CTE_Total_Sales
)
--Main Query
SELECT 
c.CustomerID, --Comes from physical table
c.FirstName,  --Comes from physical table
c.LastName,   --Comes from physical table
cts.TotalSales, --This comes from the CTE table.
clo.LastOrder,
ccr.CustomerRank,
ccs.CustomerSegments
FROM Sales.Customers AS c
LEFT JOIN CTE_Total_Sales AS cts -- This joins the CTE table with the physical table Customers
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order AS clo
ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Rank AS ccr
ON ccr.CustomerID = c.CustomerID 
LEFT JOIN CTE_Customer_Segments AS ccs
ON ccs.CustomerID = c.CustomerID

-- Best Practices: Don't use more than 5 CTEs in one query; otherwise,your code will be hard to understand and maintain.

/* Recursive CTE: Self referencing query that repeatedly processes data until a specific condition is met

+--------------------------------------------------+
|                 Recursive CTE                    |
|                (CTE Definition)                  |
+--------------------------------------------------+

WITH CTE_Name AS
(

    --------------------
    Anchor Query
    --------------------

    SELECT ...
    FROM ...
    WHERE ...

    UNION ALL

    --------------------
    Recursive Query
    --------------------

    SELECT ...
    FROM CTE_Name
    WHERE [Break Condition]

)

+--------------------------------------------------+
|                   Main Query                     |
|                   (CTE Usage)                    |
+--------------------------------------------------+

SELECT ...
FROM CTE_Name
WHERE ...

Key Components

+-------------------+------------------------------------+
| Component         | Purpose                            |
+-------------------+------------------------------------+
| Anchor Query      | Starting dataset                  |
| UNION ALL         | Combines iterations               |
| Recursive Query   | References the CTE itself         |
| Break Condition   | Stops infinite recursion          |
| Main Query        | Consumes final CTE result         |
+-------------------+------------------------------------+ */

-- Task: Generate a sequence of numbers from 1 to 20
WITH Series AS (
    -- Anchor Query
    SELECT 1 AS MyNumber
    UNION ALL
    -- Recursive Query
    SELECT
    MyNumber + 1
    FROM Series 
    WHERE MyNumber < 20
)
-- Main Query
SELECT * 
FROM Series 
OPTION (MAXRECURSION 25)

-- Task: Show the employee hierarchy by displaying each employee's level within the organization
WITH CTE_Emp_Hierarchy AS
( 
-- Anchor Query
    SELECT
    EmployeeID,
    FirstName,
    ManagerID,
    1 AS Level
FROM Sales.Employees
WHERE ManagerID IS NULL
UNION ALL
-- Recursive Query
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.ManagerID,
    Level + 1
FROM Sales.Employees AS e
INNER JOIN CTE_Emp_Hierarchy AS ceh
ON e.ManagerID = ceh.EmployeeID
)
-- Main Query
SELECT *
FROM CTE_Emp_Hierarchy

/* Conceptual Questions. Q1) What problem does a CTE solve that a subquery does not?
Answer: The output of subquery is always temporary, is not directly visible and is used only once. Once the subquery with
the main query is executed, SQL clears the subquery's result. subqueries cannot be used repeatedly. Output of subqueries
take up space temporarily. CTE is a virtual code of the table which does not exist in the database and once written, 
it can be used with the main query mainy times. It does take up some space even if it is vitual and hence using many CTEs
in a code is not the best coding practice.

Q2) True or False? A CTE stores data permanently in the database.
Answer: False.

Q3) True or False? A CTE exists only during execution of the query.
Answer: true

Q4) What is the main advantage of:
WITH SalesCTE AS (...)
instead of:
FROM
(
    ...
) T
Answer: The output of subquery is always temporary, is not directly visible and is used only once. Once the subquery with
the main query is executed, SQL clears the subquery's result. subqueries cannot be used repeatedly. Output of subqueries
take up space temporarily. CTE is a virtual code of the table which does not exist in the database and once written, 
it can be used with the main query mainy times. It does take up some space even if it is vitual and hence using many CTEs
in a code is not the best coding practice.

Q5) True or False? A CTE can be referenced multiple times inside the same query.
Answer: True.

Q6) Why does this fail?

WITH SalesCTE AS (...)
SELECT *
FROM SalesCTE

SELECT *
FROM SalesCTE
Answer: Incorrect syntax.SELECT * FROM SalesCTE at the bottom is not again required.

Q7) What is the difference between: Standalone CTE and Nested CTE
Answer: Standalone CTE is independent and does not require output from any query or CTE. It is accessed directly from the
database. Nested CTE is dependent on standalone and other CTEs depending upon task for output in order to give the correct
overall output.

Q8) Given:
WITH A AS (...),
B AS (
    SELECT *
    FROM A
)
Which CTE is dependent?
Answer: B AS (SELECT * FROM A) is dependent as FROM A indicates it needs values from Table A

Q9) Execution order:
WITH A AS (...),
B AS (...)
SELECT ...
Does SQL execute: Main Query first or CTEs first
Answer: CTEs First

Q10) Why is this useful?
WITH CustomerSales AS (...),
CustomerRanks AS (...)
instead of one huge query.
Answer: Small CTEs optimize performance than one huge query.

Recursive CTE Questions. Q11) What is the Anchor Query?
Answer: Anchor Query is a standalone query whoch defines the first output and other queries are dependent on it 

Q12) What is the Recursive Query?
Answer: A query which executes multiple times on the same logic till break condition is achieved is called a recursive query.

Q13) Why is: UNION ALL normally used in recursive CTEs?
Answer: using FROM tablename after the anchor query results in syntax error hence UNION ALL is used. UNION ALL is used if
duplicates are allowed, else UNION is used as well.

Q14) What happens if there is no break condition?
Answer: SQL will get into an infinite loop and will exhaust the servers.

Q15) In this query:

WITH Numbers AS
(
    SELECT 1

    UNION ALL

    SELECT Number + 1
    FROM Numbers
    WHERE Number < 20
)

Which part is the Anchor Query?
Answer: SELECT 1 is the anchor query.

Q16) Which part is the Recursive Query?
Answer: SELECT Number + 1 FROM Numbers WHERE Number < 20 is the recursive query

Q17) How many rows are produced?
Answer: 20

Q18) Why is: OPTION(MAXRECURSION 25) useful?
Answer: TO stop the script from entering the infinite loop.

Q19) What business problem is recursive CTE designed to solve? Give one example.
Answer: Managerial hierarchy.

Q20) True or False? Recursive CTEs are mainly used for hierarchical data.
Answer: True

Output Prediction
Q21) Predict:

WITH Numbers AS
(
    SELECT 1

    UNION ALL

    SELECT Number + 1
    FROM Numbers
    WHERE Number < 3
)
Output?
Answer: 1,2,3

Q22) Predict:

WITH Numbers AS
(
    SELECT 5

    UNION ALL

    SELECT Number + 5
    FROM Numbers
    WHERE Number < 20
)

Output?
Answer: 5,10,15,20

Business Thinking.Q23) Would you use:CTE or Subquery for a query containing: Aggregation,Ranking,Segmentation. Why?
Answer: Totally depends on how the data is structured. If an info or table is going to be used multiple times, then CTE
else subquery. However, for good readabilty and organization of code, CTE is preffered.

Q24) You have: CustomerSales, CustomerRanks, CustomerSegments. Would you prefer: 3 CTEs or 1 giant query Why?
Answer: 3 CTEs. improves code readabiltiy, performance and CTE is a better option than subquery.

Q25) Which topic is actually being tested here?

WITH CustomerSales AS
(
    SELECT CustomerID,
           SUM(Sales)
    FROM Orders
    GROUP BY CustomerID
)
SELECT *
FROM CustomerSales
A) CTE
B) GROUP BY
C) SUM
Answer: CTE */