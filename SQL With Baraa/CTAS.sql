-- CTAS (Create Table As SELECT) | Create SQL Tables From a Query
IF OBJECT_ID('Sales.MonthlyOrders','U') IS NOT NULL DROP TABLE Sales.MonthlyOrders
SELECT 
	DATENAME(month, OrderDate) OrderMonth,
	COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month,OrderDate)

SELECT * FROM Sales.MonthlyOrders
DROP TABLE Sales.MonthlyOrders