-- SQL Aggregate Window Functions
/* COUNT(): Returns the number of rows in a window
COUNT(*)/COUNT(1): Counts all the rows in the table regardless of whether any value is NULL
COUNT(Column Name): Counts The number of non-NULL values in the column.
COUNT counts the total number of rows including duplicates. It does not just count unique rows.
COUNT allows ANY datatype unlike other aggregate functions which require only numeric data type */

--Task: Find the total number of orders
SELECT COUNT(*) AS TotalOrders
FROM Sales.Orders 

--Task: Find the total number of orders additionally provide details such as order id and order date
SELECT OrderID,OrderDate, COUNT(1) OVER() AS TotalSales
FROM Sales.Orders

--Task: Find the total number of orders from each customers
SELECT OrderID,OrderDate, COUNT(1) OVER(PARTITION BY CustomerID) AS TotalSalesPerCustomer
FROM Sales.Orders

--Task: Find the total number of customers and all the customer details
SELECT * ,COUNT(*) OVER() AS TotalCustomers
FROM Sales.Customers

--Task: Find the total number of scores for the customers
SELECT *,
COUNT(Score) OVER() AS TotalScore,
COUNT(Country) OVER() AS TotalCountry
FROM Sales.Customers 

/* NOTE: COUNT(*),COUNT(1),COUNT(COLUMN) is used to test data quality especially for NULLs in case we want to double check even after 
cleaning the data and loading into database. The data quality of Score column is little bad as there are 5 customers and scores are 4 
meaning 1 is NULL and on the other hand the data quality of Country is good as there are 5 customers and 5 country entries and no NULL.

Data Quality Issue: Duplicates leads to inaccuracies in analysis. COUNT() can be used in order to identity duplicates.*/

--Task: Check whether the table 'Orders' has any duplicates
SELECT OrderID,COUNT(*) OVER(PARTITION BY OrderID) AS PrimaryKeyCheck
FROM Sales.Orders

--There are duplicate primary keys in OrdersArchive table
SELECT *
FROM (
SELECT OrderID,COUNT(*) OVER(PARTITION BY OrderID) AS PrimaryKeyCheck
FROM Sales.OrdersArchive
)t WHERE PrimaryKeyCheck > 1

/* Aggregate Window Function: SUM(): Returns the sum of values within each window. It only accepts numbers.
Also helps us understand group wise analysis and to understand patterns within different categories */

--Task: Find the total sales across all orders and total sales for each product along with order id,order date
SELECT OrderID, OrderDate, SUM(Sales) OVER() AS TotalSales,SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProduct
FROM Sales.Orders

-- Find the percentage contribution of each product's sales to the total sales. 
SELECT OrderID, OrderDate, SUM(Sales) OVER() AS TotalSales,SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProduct,
ROUND(CAST(Sales AS FLOAT) / SUM(Sales) OVER() * 100,2) AS PercentContribution
FROM Sales.Orders

--AVG(): Returns the average of values within a window.

-- Task: Find the average sales across all orders,average sales for all products aling with order id and order date
SELECT OrderID,OrderDate,Sales,ProductID,AVG(Sales) OVER () AS AverageSales,
AVG(Sales) OVER (PARTITION BY ProductID) AS AverageProductSales
FROM Sales.Orders

-- Task: Find the average scores of customers along with CustomerID and FirstName
SELECT CustomerID,FirstName,
COALESCE(Score,0) AS NewScore,
AVG(COALESCE(Score,0)) OVER() AS AverageScoreOfCustomer
FROM Sales.Customers

--Task: Find all orders where sales are higher than the average sales across all orders
SELECT *
FROM(
	SELECT 
		OrderID,
		OrderDate,
		Sales,
		AVG(Sales) OVER() AS AverageSales
	FROM Sales.Orders
)t WHERE Sales > AverageSales


/* MIN() and MAX(): Returns the minimum or maximum value of the table respectively. Handling NULLs is extremely important as the MIN()
value depends on the NULL. if NULLs are not replaced by 0 (in most cases,NULLs are replaced by 0s) then then the MIN() will pick up
a wrong minimum value. if NULLs are handled correctly, the MIN() will be 0.*/

--Task: Find the Highest and the lowest sales across all orders and across all the products
SELECT OrderID, OrderDate,ProductID,Sales,
MIN(Sales) OVER() AS LowestSales,
MAX(Sales) OVER() AS HighestSales,
MIN(Sales) OVER(PARTITION BY ProductID) AS LowestProductSales,
MAX(Sales) OVER(PARTITION BY ProductID) AS HighestProductSales
FROM Sales.Orders

-- Task: Show the employees which have the highest salaries
SELECT *
FROM
(
	SELECT 
		EmployeeID,
		FirstName,
		Salary,
		MAX(Salary) OVER() AS HighestSalary
	FROM Sales.Employees
)t WHERE Salary = HighestSalary

--Task: Calculate the deviation of each salary from both the minimum and maximum salary amounts
SELECT EmployeeID, FirstName, Salary,MAX(Salary) OVER() AS HighestSalary, MIN(Salary) OVER() AS LowestSalary,
Salary - MIN(Salary) OVER() AS DeviationFromMin,MAX(Salary) OVER() - Salary AS DeviationFromMax
FROM Sales.Employees

/* Running Total and Rolling Total: Used for tracking current sales with target sales and for trend analysis to provide insights into
historical patterns.They aggregate sequence of members and the aggregation is updated each time a new member is added/updated. It is 
also called as analysis over time.

RUNNING TOTAL: It aggregates all the values from the beginning up to the current point without dropping off the older data,
ROLLING TOTAL: It aggregates all the values within a fixed time window(eg.30 days). As new data is added, the oldest data point will
be dropped. 
This is also called as shifting window analysis. */

-- Moving Average: 

--Task: Calculate the moving average of sales for each product over time. Since 'over time' is used, the ordering of OrderDate is ASC
SELECT OrderID, OrderDate, ProductID, Sales,
AVG(Sales) OVER(PARTITION BY ProductID) AS AverageSalesbyProduct,
AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) AS AverageSalesOverTime
FROM Sales.Orders

--Task: Calculate the moving average of sales for each product over time including only the next order
SELECT OrderID, OrderDate, ProductID, Sales,
AVG(Sales) OVER(PARTITION BY ProductID) AS AverageSalesbyProduct,
AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) AS AverageSalesOverTime,
AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS AvgSalesOfNextOrder
FROM Sales.Orders

/* Dataset: Orders
+----------+------------+--------+------------+
| OrderID  | CustomerID | Sales  | OrderDate  |
+----------+------------+--------+------------+
| 1        | A          | 100    | 2024-01-01 |
| 2        | A          | 150    | 2024-01-02 |
| 3        | A          | 200    | 2024-01-03 |
| 4        | B          | 300    | 2024-01-01 |
| 5        | B          | 250    | 2024-01-02 |
| 6        | C          | 400    | 2024-01-01 |
+----------+------------+--------+------------+

Aggregate Window Functions. Q1) Show every order together with:TotalSalesAcrossAllOrders
SELECT OrderID, CustomerID, Sales, OrderDate, SUM(Sales) OVER () AS TotalSales
FROM Orders

Q2) Show every order together with: TotalSalesPerCustomer
SELECT OrderID, CustomerID, Sales, OrderDate, SUM(Sales) OVER (CustomerID) AS TotalSalesPerCustomer
FROM Orders

Q3) Show every order together with: AverageSalesAcrossAllOrders
SELECT OrderID, CustomerID, Sales, OrderDate, AVG(Sales) OVER () AS AverageSalesAcrossAllOrders
FROM Orders

Q4) Show every order together with: AverageSalesPerCustomer
SELECT OrderID, CustomerID, Sales, OrderDate, AVG(Sales) OVER (CustomerID) AS AverageSalesPerCustomer
FROM Orders

Q5) Show every order together with:MinimumSalesPerCustomer and MaximumSalesPerCustomer
SELECT OrderID, CustomerID, Sales, OrderDate, MIN(Sales) OVER (CustomerID) AS MinimumSalesPerCustomer,
MAX(Sales) OVER (CustomerID) AS MaximumSalesPerCustomer
FROM Orders

Q6) Show every order together with: NumberOfOrdersPerCustomer
SELECT OrderID, CustomerID, Sales, OrderDate, COUNT(OrderID) OVER(CustomerID) AS NumberOfOrdersPerCustomer
FROM Orders

Q7) Show every order together with: PercentageContributionToTotalSales
SELECT OrderID, CustomerID, Sales, OrderDate, SUM(Sales) OVER() AS TotalSales,
Sales/ SUM(Sales) OVER() * 100 AS PercentageContributionToTotalSales
FROM Orders

Running Totals. Q8) Show every order together with: RunningTotalSales ordered by: OrderDate
SELECT OrderID, CustomerID, Sales, OrderDate, 
SUM(Sales) OVER(ORDER BY OrderDate UNBOUNDED PRECEDING AND CURRENT ROW ) AS RunningTotalSales,
FROM Orders

Q9) Show every order together with: RunningTotalSalesPerCustomer
SELECT OrderID, CustomerID, Sales, OrderDate, 
SUM(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS RunningTotalSalesPerCustomer,
FROM Orders

Q10) Predict the output. Sales 100,150,200 Running Total?
Answer: 450. Running total calculates right from the beginning of the entry.

Frames. Q11) Predict the frame contents.Data:10,20,30,40,50. Frame:ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
For Row 4, which values participate?
ANSWER: if the current row arrow points at 10 which is the first row, then unbounded preceeding won't exist right?
UNBOUNDED means there is no limit and preceding means previous,prior,older. 

Q12) Predict the frame contents.ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING For Row 2, which values participate?
Answer: UNBOUNDED means there is no limit and FOLLOWING means the next value.
The answer would be
10 | 10
20 | 30
30 | 60
40 | 100
50 | 150
For row 2, the answer is self explanatory.

Q13) Predict the frame contents.ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING. For Row 3, which values participate?
Answer: The arrow starts from 10 which is the first row and then after calculating, it moves to second row. in that case
the FRAME condition is satified and this would be the result.
10 | 10
20 | 30
30 | 60
For row 3 if the arrow points to row 3,then the answer would be this
20 | 30
30 | 60
40 | 100

Q14) Predict the result. Data:10,20,30,40,50
Window:
SUM(Value)
OVER(
ORDER BY Value
ROWS BETWEEN 1 PRECEDING
AND 1 FOLLOWING
)
What result appears for Row 3?
ANSWER: Isn't this the same as 13th?

Conceptual Questions.Q15) True or False? PARTITION BY behaves similarly to GROUP BY.
Answer: Fasle. Partition creates parts and notifies the SQL on which part/window to perform the function on unlike GROUP BY
which is the drawback of GROUP BY overcomed with the help of Window function.

Q16) True or False? PARTITION BY reduces row count.
Answer: False. PARTITION preserves row count and row granularity.

Q17) True or False? SUM(Sales) OVER() returns exactly one row.
Answer: False. Partition returns all the rows and the number of rows returned is based on the data.

Q18) True or False? COUNT(*) OVER() can be used without PARTITION BY.
Answer: True. PARTITION is optional.

Q19) Why does this return the same number on every row? SUM(Sales) OVER()
Answer: PARTITION preserves row granularity and does not collapse rows hence the output is returned on every row

Q20_ Why is this useful? AVG(Salary) OVER(PARTITION BY Department)
ANSWER: Helps us perform the aggreation function AVERAGE of salary only on the column Department and not the entire table.

Q21) What is the difference? COUNT(*) vs COUNT(*) OVER()
ANSWER: COUNT(*) is used with GROUP BY. It counts all the rows including NULLs and returns the count number. 
COUNT(*) OVER() is used with WINDOW Functions. When OVER() is mentioned, windows functions come into picture where row
granularity is preserved. it also counts all the rows including NULLs and returns the count number

Q22) What is the difference?
SUM(Sales)
GROUP BY CustomerID
vs
SUM(Sales) OVER(PARTITION BY CustomerID)
Answer: The first code performs SUM() over the entire table and then collapses and returns 1 row cause grouping by is done 
on CustomerID. In the second code, SUM() is performed only on the CustomerID column and not the entire table and all the
rows are returned. There is no row collapsing and row granularity is preserved.

Q23) What happens when PARTITION BY is removed? AVG(Salary) OVER()
Answer: Then AVG(Salary) will be performed on the entire table, rows will be collapsed and only one row will be returned.

Q24) What is a window frame.Answer in one sentence.
Answer: Window Frame is a set of condition which forces the SQL to perform functions only on that set of data/condition
and is always used with ORDER BY.

Q25) Complete:
PARTITION BY determines on which column/columns the function must be performed on.
ORDER BY determines whether the data is sorted in ascending or descending order.
FRAME determines a set of condition which forces the SQL to perform functions only on that set of data/condition
and is always used with ORDER BY.

Business Thinking
Q26) You need:
Employee Name
Salary
Department Average Salary
Would you prefer: GROUP BY or WINDOW FUNCTION. Why?

Answer: Window function. Because I want to calculate only the department average and not the entire data average.
Also, GROUP BY needs the same number of columns in SELECT as in GROUP BY which destroys the grouping and gives incorrect 
results.

Q27) You need: Total sales per customer only No detail rows required.Would you prefer:GROUP BY or WINDOW FUNCTION. Why?
Answer: Window function. Because I want to calculate only the total sales per customer and not the entire data average.
Even if I do not want additional details, GROUP BY does not support only column wise aggregations.

Q28) You need: Order Details,Customer Total Sales Would you prefer: GROUP BY or WINDOW FUNCTION. Why?
Answer: WINDOW functions cause additional details are supported as well.

Q29) Give one example where GROUP BY is sufficient.
Answer: For small dataset where complex analysis are not present and row granularity does not matter.

Q30) Give one example where GROUP BY becomes awkward but a window function is natural.
Answer: in time series analysis.