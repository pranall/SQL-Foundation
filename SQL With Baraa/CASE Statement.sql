--CASE WHEN Statement
-- CASE Statement: Evaluates a list of conditions and returns a value when the conditions are met.
/* SYNTAX

CASE                             ---->Start of the logic
	WHEN condition1 THEN result1 -----> Here WHEN is the condition to be evaluated and result1 if the condition is true
	WHEN condition2 THEN result2
	----
	ELSE RESULT                  -----> DEFAULT VALUE if none of the conditions are true.
END                              --------> END of logic */

--Use case 1: 
--Categorizing data: The main purpose is Data Transformation,to derive new information and to create new columns based on existing data
--Categorizing Data: Group the data into different categories based on certain conditions.

/* Task: Generate a report showing the total sales for each category:
1) High: if the sales are higher than 50
2) Medium: If the sales are between 20 and 50
3) Low: If the sales are lower than 20
Sort the result from lowest to highest */

SELECT
    Category,
    SUM(Sales) AS TotalSales
FROM (
    SELECT
        OrderID,
        Sales,
        CASE
            WHEN Sales > 50 THEN 'High'
            WHEN Sales > 20 THEN 'Medium'
            ELSE 'Low'
        END AS Category
    FROM Sales.Orders
) AS t
GROUP BY Category
ORDER BY TotalSales DESC

--Case Rules. The datatypes of the results, ELSE and conditionals must be the same. There are no other rules 
-- eg,the below codes will give an error 
SELECT
    Category,
    SUM(Sales) AS TotalSales
FROM (
    SELECT
        OrderID,
        Sales,
        CASE
            WHEN Sales > 50 THEN 'High' --This is a string
            WHEN Sales > 20 THEN 2 --This is an integer
            ELSE 'Low'
        END AS Category
    FROM Sales.Orders
) AS t
GROUP BY Category
ORDER BY TotalSales DESC

-- the below code will give an error as well
SELECT
    Category,
    SUM(Sales) AS TotalSales
FROM (
    SELECT
        OrderID,
        Sales,
        CASE
            WHEN Sales > 50 THEN 'High' ---> A String
            WHEN Sales > 20 THEN 'Medium'
            ELSE 1 --->This is an integer
        END AS Category
    FROM Sales.Orders
) AS t
GROUP BY Category
ORDER BY TotalSales DESC

--Use Case: Mapping Values
--Task: Retrieve employee details with gender displayed as full text
SELECT 
EmployeeID,
FirstName,
LastName,
Gender,
CASE 
    WHEN Gender = 'M' THEN 'Male'
    WHEN Gender = 'F' THEN 'Female'
    ELSE 'Unknown'
END AS FullGender
FROM Sales.Employees

--Task: Retrieve customer details with abbreviated country code
SELECT
CustomerID,
FirstName,
LastName,
Country,
CASE 
    WHEN Country = 'Germany' THEN 'DE'
    WHEN Country = 'USA' THEN 'US'
    ELSE 'Unknown'
END AS abbcountry
FROM Sales.Customers

SELECT DISTINCT Country --Used to understand how many values are there which are useful for mapping
FROM Sales.Customers

/* Case Statement: Quick Form
The below code repeats the column name 'Country' too many times. Notice that = is used for every comparison. 

CASE 
    WHEN Country = 'India' THEN 'IND'
    WHEN Country = 'Japan' THEN 'JP'
    WHEN Country = 'France' THEN 'FR'
    WHEN Country = 'Italy' THEN 'IT'
    WHEN Country = 'Germany' THEN 'DE'
    ELSE 'Unknown'
END AS abbcountry

This repetitive code can be fixed by quick form as follows:
CASE Country
    WHEN 'India' THEN 'IND'
    WHEN 'Japan' THEN 'JP'
    WHEN 'France' THEN 'FR'
    WHEN 'Italy' THEN 'IT'
    WHEN 'Germany' THEN 'DE'
    ELSE 'Unknown'
END AS abbcountry

Quick forms can only take one column and only one comparision operator, It does not allow complex CASE,multiples columns and multiple
comparison operators */

--Handling NULLs: Replace NULLs with specific value. NULLs can lead to inaccurate results which can lead to wrong decision making
--Task: Find the average scores of customers and treat NULLs as zero,display CustomerID and LastName
SELECT
    CustomerID,
    LastName,
    Score,
    CASE
        WHEN Score IS NULL THEN 0
        ELSE Score
    END AS ScoreClean,
    AVG(
        CASE
            WHEN Score IS NULL THEN 0
            ELSE Score
        END
    ) OVER () AS AvgCustomerClean,
    AVG(Score) OVER () AS AvgCustomer
FROM Sales.Customers;

--Conditional aggregation: Apply aggregate functions only on subsets of data that fulfill certain conditions
-- TASK 5: Count how many orders each customer made with sales greater than 30
SELECT
    CustomerID,
    SUM(
        CASE
            WHEN Sales > 30 THEN 1
            ELSE 0
        END
    ) AS TotalOrdersHighSales,
    COUNT(*) AS TotalOrders
FROM Sales.Orders
GROUP BY CustomerID

/* Dataset: Employees
| emp_id | department | salary | gender |
| ------ | ---------- | ------ | ------ |
| 1      | Data       | 80000  | M      |
| 2      | Data       | 65000  | F      |
| 3      | HR         | 45000  | M      |
| 4      | Finance    | 95000  | F      |
| 5      | NULL       | NULL   | M      |

Q1) Create a column: High,Medium,Low
Rules:
salary > 80000     -> High
salary > 50000     -> Medium
otherwise          -> Low

SELECT emp_id,salary,
CASE salary
    WHEN > 80000 THEN 'High'
    sWHEN > 50000 THEN 'Medium' 
    ELSE 'Low'
END AS SalaryClassification
FROM Employees

Q2) Replace: M -> Male, F -> Female
SELECT emp_id,gender,
CASE gender
    WHEN 'M' THEN 'Male'
    WHEN 'F' THEN 'Female'
END AS FullGender
FROM Employees

Q3) Replace: Data-> DS, HR-> HR, Finance-> FIN, NULL-> Unknown
SELECT emp_id, department
CASE department
    WHEN 'Data' THEN 'DS'
    WHEN 'HR' THEN 'HR'
    WHEN 'Finance' THEN 'FIN'
    WHEN 'NULL' THEN 'Unknown' -- should I write WHEN IS NULL THEN 'Unknown'?
END AS abbdept
FROM Employees

Q4) Create: Has Salary,No Salary based on NULL.
SELECT emp_id, salary
CASE salary
    WHEN IS NULL THEN 'No Salary'
    ELSE 'Salary'
END AS salarynull
FROM Employees

Q5) Count employees in each salary category. Output: Category, EmployeeCount
uses subquery ig

