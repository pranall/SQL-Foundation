-- SETS retrive row wise information from 2 or more tables unlike JOINS who retrieve info from columns from 2 more more tables.
-- Syntax:
/*
SELECT row 1, row 2, (SELECT Statement from table 1)
FROM table 1

UNION (SET Operator)

SELECT row 1, row 2, (SELECT Statement from table 2)
FROM table 2
*/

-- Rules of SETS 
-- RULE 1: SET Operators can be used with all clauses (JOINS, WHERE, GROUP BY, HAVING). ORDER BY is used only once at the end of the query.
-- Syntax:
/* 
SELECT FirstName, LastName 
FROM customers
JOINS 
WHERE
GROUP BY
HAVING 

UNION 

SELECT FirstName, LastName
FROM employees
JOINS
WHERE
GROUP BY
HAVING

ORDER BY
*/

-- RULE 2: The number of columns in both the SELECT statements must be the same. 
-- Eg:The below code is correct since the number of columns in both the SELECT Statements are same.
SELECT FirstName, LastName 
FROM Sales.Customers 

UNION

SELECT FirstName, LastName 
FROM Sales.Employees 

--Eg:The below code is incorrect since the number of columns in both the SELECT Statements are not the same.
SELECT FirstName, LastName, Country
FROM Sales.Customers 

UNION

SELECT FirstName, LastName 
FROM Sales.Employees 

--RULE 3: The datatypes of the columns must be the same across the queries
/* Eg: The below code does not give an error since the datatype of FirstName from table Customers is compared with the datatype of FirstName
column from the table Employees. Since they both are varchar, the query is executed. Also notice that the number of columns are same */

SELECT FirstName, LastName
FROM Sales.Customers  
UNION
SELECT FirstName, LastName
FROM Sales.Employees 

/* Eg: The below code gives an error since the datatype of CustomerID from table Customers is compared with the datatype of FirstName
column from the table Employees. Since CustomerID's datatype is int and FirstName's datatype is varcher, the query throws and error. 
Also notice that the number of columns are not the same */

SELECT CustomerID, FirstName, LastName
FROM Sales.Customers  
UNION
SELECT FirstName, LastName
FROM Sales.Employees 

/* Eg: The below code does not give an error since the datatype of CustomerID from table Customers is compared with the datatype of EmployeeID
column from the table Employees. Since they both are int, the query is executed. Also notice that the number of columns are same */

SELECT CustomerID, FirstName, LastName
FROM Sales.Customers  
UNION
SELECT EmployeeID, FirstName, LastName
FROM Sales.Employees 

/* RULE 4: The order of the columns is extremely important in SETS. It is based on above rule since SQL matches the first column's datatype
from the first table to the first column's datatype from the second table. */

/* Eg: The below codes will give no errors since the first column's datatype from the first table is same to the first column's datatype 
from the second table.*/ 

SELECT CustomerID, FirstName, LastName
FROM Sales.Customers  
UNION
SELECT EmployeeID, FirstName, LastName
FROM Sales.Employees 

SELECT FirstName, LastName
FROM Sales.Customers  
UNION
SELECT FirstName, LastName
FROM Sales.Employees 

/* Eg: The below codes will give error since the first column's datatype from the first table is not same to the first column's datatype 
from the second table.*/ 
SELECT CustomerID,FirstName, LastName
FROM Sales.Customers  
UNION
SELECT FirstName, LastName
FROM Sales.Employees 

SELECT FirstName, LastName
FROM Sales.Customers  
UNION
SELECT EmployeeID, FirstName, LastName
FROM Sales.Employees 

--RULE 5: The aliases/column names will be taken only from the first SELECT statement query 
/* Eg: The below code's results displays CustomerID even after union since it appears in the first query. 
EmployeeID is ignored. */
SELECT CustomerID,FirstName, LastName
FROM Sales.Customers  
UNION
SELECT EmployeeID, FirstName, LastName
FROM Sales.Employees 

/*Eg: The below code's results displays only the alias of CustomerID even after union since it appears in the first query. 
EmployeeID is ignored*/
SELECT CustomerID AS ID,FirstName, LastName
FROM Sales.Customers  
UNION
SELECT EmployeeID AS EmpID, FirstName, LastName
FROM Sales.Employees 

/* RULE 6: Even if all the rules are satisfied, the results may still be incorrect. Incorrect column selection leads to 
incorrect results */

/* Eg: The below code satisfies all the rules like and same number of columns, same datatypes. However in the firstname column
we got the last name and in the last name column we got the first name. This is because the order was changed. */

SELECT FirstName, LastName
FROM Sales.Customers  
UNION
SELECT LastName, FirstName
FROM Sales.Employees 

-- SET Operator 1: 
-- UNION: this operator returns all the distinct rows from both tables. It removes duplicates.
--Task: Combine the data from Customers and Employees table
SELECT *
FROM Sales.Customers

SELECT *
FROM Sales.Employees

SELECT FirstName, LastName 
FROM Sales.Customers 
UNION
SELECT FirstName, LastName 
FROM Sales.Employees 

--SET OPERATOR 2
/* UNION ALL: Combines all the data from two tables and gives duplicates as well in the result. 
It is faster than UNION because it does not invest time in removing the duplicates. It is also used to see the duplicates
as well as quality issues */ 

SELECT FirstName, LastName 
FROM Sales.Customers 
UNION ALL
SELECT FirstName, LastName 
FROM Sales.Employees 

-- SET Operator 3
-- DISTINCT: Returns all distinct rows from the first query that are no found in the second query.
-- It is the only set operator where the order if the queries affects the final result.
-- Task: Find employees who are not customers at the same time.
SELECT FirstName, LastName 
FROM Sales.Employees 
EXCEPT
SELECT FirstName, LastName 
FROM Sales.Customers 

-- SET Operator 4: 
-- INTERSECT: Returns removes duplicates and returns common rows as the result. It is similar to INNER JOIN. The order of 
-- tables do not matter.
-- Task: Find employees who are also customers.
SELECT FirstName, LastName 
FROM Sales.Employees 
INTERSECT
SELECT FirstName, LastName 
FROM Sales.Customers 

-- SET Operators USE cases.
-- Task: Orders are stored in separate tables (Orders and OrdersArchive). Combine all orders into one report without duplicates
/* Best Practice: Never use *. Always list the column names in SELECT. In future if the order of the columns or the column
names changes, listing of all the column names will detect it immediately and reduce the chances of giving incorrect result
even if there are no errors */
SELECT *
FROM Sales.Orders 
UNION
SELECT *
FROM Sales.OrdersArchive 


/* How to add all the column names without manual work: 
STEP 1: On the Object Explorer click to see all the tables. Navigate to the tables which are used in the query.
STEP 2: Left click on the table and click on 'Select 1000 rows'. A new SQL file with the code will appear.
Step 3: Copy all the column names from the SQL script and add in the SELECT statement. */
SELECT [OrderID],[ProductID],[CustomerID],[SalesPersonID],[OrderDate],[ShipDate],[OrderStatus],[ShipAddress],[BillAddress],
[Quantity],[Sales],[CreationTime]
FROM Sales.Orders 
UNION
SELECT [OrderID],[ProductID],[CustomerID],[SalesPersonID],[OrderDate],[ShipDate],[OrderStatus],[ShipAddress],[BillAddress],
[Quantity],[Sales],[CreationTime]
FROM Sales.OrdersArchive 

/* NOTE: After executing the above code, the result might seem duplicate. It is not duplicate since the data has been taken
from Orders and OrdersArchive tables. To eliminate this confusion the source table's name before the query must be written. */

SELECT 
'Orders' AS SourceTable,
[OrderID],[ProductID],[CustomerID],[SalesPersonID],[OrderDate],[ShipDate],[OrderStatus],[ShipAddress],[BillAddress],
[Quantity],[Sales],[CreationTime]
FROM Sales.Orders 
UNION
SELECT 
'OrdersArchive' AS SourceTable,
[OrderID],[ProductID],[CustomerID],[SalesPersonID],[OrderDate],[ShipDate],[OrderStatus],[ShipAddress],[BillAddress],
[Quantity],[Sales],[CreationTime]
FROM Sales.OrdersArchive 
ORDER BY OrderID 

-- Delta Detection: SET Operator like EXCEPT help detect changes between datasets making it easier to identify new, updated or missing information during data integration.
-- Delta means the change of time before between the previous entry and current entry during ingestion. 
-- Refer to the PPT for more including info about data completeness.


/* 1. Generate a list of all people who have ever worked at the company.

Answer: 'Ever' worked in the company means both current and former employees are needed. UNION must be used. Also UNION does not consider duplicates.
SELECT emp_id, name
FROM current_employees
UNION
SELECT emp_id, name
FROM former_employees

2. Generate a list containing all employee records, including duplicates.
Answer: UNION ALL will be used since UNION ALL includes duplicates as well.
SELECT emp_id, name
FROM current_employees
UNION ALL
SELECT emp_id, name
FROM former_employees

3. How many rows would each of these return?
Answer: UNION will return 6 rows because it does not consider the duplicates. Charlie and David won't be repeated.
UNION ALL will return 8 rows, charlie and david will be included.

INTERSECT
4. Find employees who appear in both tables.
Answer: INTERSECT is like INNER JOIN. It gives you common rows unlike INNER JOIN who gives common columns.
SELECT emp_id, name
FROM current_employees
INTERSECT
SELECT emp_id, name
FROM former_employees
OUTPUT: 2 rows (emp_id:3, name: Charlie and emp_id:4, name: David) will be returned 

5.Find employees who are currently employed and were also previously employed.
Answer: Similar to the above question. Charlie and David will be returned as they appear in both tables.

6. Predict the result without executing:
SELECT name
FROM CurrentEmployees
INTERSECT
SELECT name
FROM FormerEmployees
Answer: Charlie, David

EXCEPT
7. Find employees who are currently employed but never appear in FormerEmployees.
Answer: Alice and Bob will appear. The order of the table matters here cause we want only the current employees hence 
current employees table is first. 
SELECT emp_id, name
FROM current_employees
EXCEPT
SELECT emp_id, name
FROM former_employees

8.Find employees who left the company and are not current employees.
Answer: Eva and Frank will appear. The order of the table matters here cause we only want the former employees hence former
employees table will be first.
SELECT emp_id, name
FROM former_employee
EXCEPT
SELECT emp_id, name
FROM current_employee

9) Predict:
CurrentEmployees
EXCEPT
FormerEmployees
Answer: Similar to 7th question 

10) Predict:
FormerEmployees
EXCEPT
CurrentEmployees
Why are they different?
Answer: Similar to the 8th question. they are different because except is particular about orders of the tables and hence
the output is different.

Understanding Column Order
Active Customers
| id | first_name | country |
| -- | ---------- | ------- |
| 1  | John       | USA     |
| 2  | Alice      | UK      |
Archived Customers
| id | first_name | country |
| -- | ---------- | ------- |
| 3  | Bob        | Germany |
| 4  | Maria      | Spain   |
Question: Will this produce correct results?
SELECT id, first_name, country
FROM ActiveCustomers
UNION
SELECT first_name, id, country
FROM ArchivedCustomers
Answer: The code will give an error. It satisfies the SET condition of having 3 columns in both SELECT statements, however
the order of the columns is not the same and the rule of consistency of datatypes accross the SELECT statement is violated. 
The comparison of datatype of 'id' column (int) will be done with the datatype of first_name from the second SELECT statement
which is likely varchar. since int <> varchar, the code will throw and error. 

Understanding Duplicates
STORE A
| product |
| ------- |
| Laptop  |
| Phone   |
| Tablet  |

Store B
| product |
| ------- |
| Laptop  |
| Phone   |
| Watch   |
11 Predict UNION result.
Answer: will return 4 rows: Laptop, phone, tablet and watch. UNION deletes duplicates.

12 Predict UNION ALL result.
Answer: will return 6 rows. laptop, phone, tablet, laptop, phone, watch. UNION ALL includes duplicates and hence it is faster
then UNION as UNION spends time in deleting duplicates.

13 Predict INTERSECT result.
Answer: will return laptop and phone since they are coomon in both the tables.

14 Predict:
StoreA
EXCEPT
StoreB
Result: Tablet will be returned as laptop and phone are included in store B as well.

15 Predict:
StoreB
EXCEPT
StoreA
Result: Watch will be returned as laptop and phone are included in store A as well.

Interview-Style Questions
16) You have: Users2024, Users2025
Find users present in both years.
Answer: INTERSECT will be used as it will give us users present in both the years 2024 and 2025

17) Find users who disappeared in 2025.
Answer: users who disappeared in 2025 are the users who exclusively appeared ONLY in 2024.
SELECT *
FROM Users 2024
EXCEPT
SELECT *
FROM Users 2025

18) Find users newly added in 2025.
Answer: Since Users2025 is first in order, only the newly added users in 2025 will be displayed. * is used in SELECT statements
since no rows are given. Ideally using * in SETS is kinda a dirty practice cause if in case there are changes in columns of the
tables in neear future, the results displayed will be wrong and will give errors.
SELECT *
FROM Users2025
EXCEPT
SELECT *
FROM Users2024

19) Combine both datasets while removing duplicates.
SELECT *
FROM Users2024
UNION
SELECT *
FROM Users2025

20) Combine both datasets while preserving duplicates.
SELECT *
FROM Users2024
UNION ALL 
SELECT *
FROM Users2025 */

