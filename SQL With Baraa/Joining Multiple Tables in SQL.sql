/* Using SalesDB, retrieve a list of all orders along with the related customer, product and employee details
For each order display:OrderID (Orders: Order_ID), Customer's Name(Customers: CustomerID), Product Name (Products:Product), Sale's Amount, Product Price(Products: Price), Salesperson's name(Employees: FirstName/LastName) */

SELECT *
FROM Sales.Customers 

SELECT *
FROM Sales.Employees

SELECT *
FROM Sales.Orders 

SELECT *
FROM Sales.OrdersArchive 

SELECT *
FROM Sales.Products

SELECT 
	o.OrderID,
	o.Sales,
	c.FirstName AS CustomerFirstName,
	c.LastName AS CustomerLastName,
	p.Product AS ProductName,
	p.Price,
	e.FirstName AS EmployeeFirstName,
	e.LastName AS EmployeeLastName
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
ON p.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID