--Views
-- Task: Find the running total of sales of each month
WITH CTE_Monthly_Summary AS (
	SELECT 
	DATETRUNC(month,OrderDate) AS OrderMonth,
	SUM(Sales) AS TotalSales,
	COUNT(OrderID) AS TotalOrders,
	SUM(Quantity) AS TotalQuantities
	FROM Sales.Orders 
	GROUP BY DATETRUNC(month, OrderDate)
)
SELECT 
OrderMonth,
TotalSales,
SUM(TotalSales) OVER (ORDER BY OrderMonth) AS RunningTotal
FROM CTE_Monthly_Summary

/* In new SQL script:
CREATE VIEW V_Monthly_Summary AS
(
	SELECT 
	DATETRUNC(month,OrderDate) AS OrderMonth,
	SUM(Sales) AS TotalSales,
	COUNT(OrderID) AS TotalOrders,
	SUM(Quantity) AS TotalQuantities
	FROM Sales.Orders 
	GROUP BY DATETRUNC(month, OrderDate)
)

Ouput: Commands completed successfully.
Completion time: 2026-06-25T09:31:12.7563629+05:30

To see the above view:
In Object Explorer: Databases -> SalesDB -> Views -> dbo.V_Monthly_Summary

To Query the view, in new SQL script:
SELECT *
FROM V_Monthly_Summary

Output result will show the view.

To use the created view instead of CTE 
SELECT 
OrderMonth,
TotalSales,
SUM(TotalSales) OVER (ORDER BY OrderMonth) AS RunningTotal
FROM V_Monthly_Summary -- Replacing CTE_Monthly_Summary with V_Monthly_Summary

NOTE: When a view is created, by default its schema is dbo.ViewName. While creating the view we need to change the schema
name from dbo. to the schema we want. in this case the schema is Sales.

CREATE VIEW Sales.V_Monthly_Summary AS
(
	SELECT 
	DATETRUNC(month,OrderDate) AS OrderMonth,
	SUM(Sales) AS TotalSales,
	COUNT(OrderID) AS TotalOrders,
	SUM(Quantity) AS TotalQuantities
	FROM Sales.Orders 
	GROUP BY DATETRUNC(month, OrderDate)
)

After executing the above code, after refreshing the object explorer, in SalesDB in views the new view will be displayed.

To delete view, in new SQL: DROP VIEW V_Monthly_Summary.

For PostGress: to edit views
CREATE OR REPLACE VIEW Sales.V_Monthly_Summary AS
(
	SELECT 
	DATETRUNC(month,OrderDate) AS OrderMonth,
	SUM(Sales) AS TotalSales,
	COUNT(OrderID) AS TotalOrders,
	SUM(Quantity) AS TotalQuantities
	FROM Sales.Orders 
	GROUP BY DATETRUNC(month, OrderDate)
)

The above REPLACE is not available in SQL 
In views, once it is created and columns are decided, editing the view gives an error. For that we need to drop and create
the view again. However once the view is created and suppose it is named View1, and changes must be done, even after dropping
and editing, SQL will give the error as 'View1' exists. This is a limitation of SQL and for that we need T-SQL.Tansact SQl
is an extension of SQL that adds programming features.

IF OBJECT_ID ('Sales.V_Monthly_Summary','V') IS NOT NULL DROP VIEW Sales.V_Monthly_Summary;
GO

CREATE VIEW Sales.V_Monthly_Summary AS
(
	SELECT 
	DATETRUNC(month,OrderDate) AS OrderMonth,
	SUM(Sales) AS TotalSales,
	COUNT(OrderID) AS TotalOrders,
	SUM(Quantity) AS TotalQuantities
	FROM Sales.Orders 
	GROUP BY DATETRUNC(month, OrderDate)
)

Output: Commands completed successfully.

Completion time: 2026-06-25T09:57:54.2207712+05:30 

Views Use Case 2: Views can be used to hide the complexity of database tables and offers users more friendly and easy
to consume objects.

Task: Provide a view that combines details from orders,products,employees and customers 
SELECT 
o.OrderID,
o.OrderDate,
p.Product,
p.Category,
COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') AS CustomerName,
c.Country AS CustomerCountry,
COALESCE(e.FirstName,'') + ' ' + COALESCE(e.LastName,'') AS SalesName,
e.Department,
o.Sales,
o.Quantity
FROM Sales.Orders AS o
LEFT JOIN Sales.Products AS p
ON p.ProductID = o.ProductID
LEFT JOIN Sales.Customers AS c
ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.Employees AS e
ON e.EmployeeID = o.CustomerID 

Use Case 3: Use views to enforce security and protect sensitive data by hiding columns and/or rows from tables.
TasK: Provide a view for the EU Sales Team that combines details from all tables and excludes data related to the USA.
SELECT 
o.OrderID,
o.OrderDate,
p.Product,
p.Category,
COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') AS CustomerName,
c.Country AS CustomerCountry,
COALESCE(e.FirstName,'') + ' ' + COALESCE(e.LastName,'') AS SalesName,
e.Department,
o.Sales,
o.Quantity
FROM Sales.Orders AS o
LEFT JOIN Sales.Products AS p
ON p.ProductID = o.ProductID
LEFT JOIN Sales.Customers AS c
ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.Employees AS e
ON e.EmployeeID = o.CustomerID 
WHERE c.Country != 'USA' -- Row level security


Use Case 4: Flexibility and Dynamic */
