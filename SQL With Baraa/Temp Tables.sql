--Temporary Tables

SELECT *
INTO #Orders
FROM Sales.Orders

--To select from temporary table
SELECT *
FROM #Orders

--Delete certain info from temporary tables
DELETE FROM #Orders
WHERE OrderStatus = 'Delivered'

SELECT *
FROM #Orders 

-- Adding the above code's result into the actual physical table
SELECT *
INTO Sales.OrdersTest
FROM #Orders

--Note: The temporary table will vanish after we exit SQLServer.