/* Ranking Window Functions | ROW_NUMBER, RANK, DENSE_RANK, NTILE
These functions assign a rank (number) to each row.
| Month | Sales | Rank |
|-------|-------|------|
| Jun   | 70    | 1    |
| Jul   | 40    | 2    |
| Mar   | 30    | 3    |
| Jan   | 20    | 4    |
| Feb   | 10    | 5    |
| Apr   | 5     | 6    |

+---------+-------+
| Product | Sales |
+---------+-------+
| E       | 70    |
| B       | 30    |
| A       | 20    |
| C       | 10    |
| D       | 5     |
+---------+-------+

Integer-Based Ranking
+---------+-------+------+
| Product | Sales | Rank |
+---------+-------+------+
| E       | 70    | 1    |
| B       | 30    | 2    |
| A       | 20    | 3    |
| C       | 10    | 4    |
| D       | 5     | 5    |
+---------+-------+------+

Percentage-Based Ranking
+---------+-------+--------------+
| Product | Sales | PercentRank  |
+---------+-------+--------------+
| E       | 70    | 0.00         |
| B       | 30    | 0.25         |
| A       | 20    | 0.50         |
| C       | 10    | 0.75         |
| D       | 5     | 1.00         |
+---------+-------+--------------+

Summary
+----------------------+--------------------------------------+
| Analysis Type        | Functions                            |
+----------------------+--------------------------------------+
| Top/Bottom N         | ROW_NUMBER()                         |
|                      | RANK()                               |
|                      | DENSE_RANK()                         |
|                      | NTILE()                              |
+----------------------+--------------------------------------+
| Top X Percent        | CUME_DIST()                          |
|                      | PERCENT_RANK()                       |
+----------------------+--------------------------------------+
| Ranking Type         | Output Values                        |
+----------------------+--------------------------------------+
| Integer Ranking      | 1, 2, 3, 4, 5                        |
| Percentage Ranking   | 0, 0.25, 0.50, 0.75, 1.00           |
+----------------------+--------------------------------------+

Ranking Function Syntax: RANK() OVER(PARTITION BY ProductID ORDER BY Sales)
In this: RANK() expression must be empty. ORDER BY is mandatory.

+-------------------+------------+-------------+--------------+----------------+
| Function          | Expression | PARTITION   | ORDER BY     | FRAME          |
+-------------------+------------+-------------+--------------+----------------+
| ROW_NUMBER()      | Empty      | Optional    | Required     | Not Allowed    |
| RANK()            | Empty      | Optional    | Required     | Not Allowed    |
| DENSE_RANK()      | Empty      | Optional    | Required     | Not Allowed    |
| CUME_DIST()       | Empty      | Optional    | Required     | Not Allowed    |
| PERCENT_RANK()    | Empty      | Optional    | Required     | Not Allowed    |
| NTILE(n)          | Number     | Optional    | Required     | Not Allowed    |
+-------------------+------------+-------------+--------------+----------------+

Ranking Functions Summary
+-------------------+--------------------------------------------+
| Function          | Purpose                                    |
+-------------------+--------------------------------------------+
| ROW_NUMBER()      | Unique sequential number per row           |
| RANK()            | Ranking with gaps after ties               |
| DENSE_RANK()      | Ranking without gaps after ties            |
| NTILE(n)          | Divide rows into n buckets/groups          |
| CUME_DIST()       | Cumulative distribution (0 to 1)           |
| PERCENT_RANK()    | Relative rank percentage (0 to 1)          |
+-------------------+--------------------------------------------+

Syntax Pattern
ROW_NUMBER()   OVER(PARTITION BY column ORDER BY column)

RANK()         OVER(PARTITION BY column ORDER BY column)

DENSE_RANK()   OVER(PARTITION BY column ORDER BY column)

CUME_DIST()    OVER(PARTITION BY column ORDER BY column)

PERCENT_RANK() OVER(PARTITION BY column ORDER BY column)

NTILE(n)       OVER(PARTITION BY column ORDER BY column)

-------------------------------------------------------------------------------
ROWNUMBER(): Assigns a unique sequential integer to each row with in a window
Input Data

+-------+
| Sales |
+-------+
| 100   |
| 80    |
| 80    |
| 50    |
| 20    |
+-------+

ROW_NUMBER() Output
+-------+------------+
| Sales | RowNumber  |
+-------+------------+
| 100   | 1          |
| 80    | 2          |
| 80    | 3          |
| 50    | 4          |
| 20    | 5          |
+-------+------------+

Key Observation
+----------------------+-------------------------------------------+
| Property             | ROW_NUMBER()                              |
+----------------------+-------------------------------------------+
| Duplicate Values     | Allowed                                   |
| Tie Handling         | No Special Handling                       |
| Rank Assignment      | Unique Rank For Every Row                 |
| Rank Repetition      | Never                                     |
| Rank Gaps            | Not Applicable                            |
+----------------------+-------------------------------------------+
Tie Example
Sales = 80
Sales = 80

Even though the values are tied:

+-------+------------+
| Sales | RowNumber  |
+-------+------------+
| 80    | 2          |
| 80    | 3          |
+-------+------------+
ROW_NUMBER() always assigns a unique sequential number to every row. */

--Task: Rank the orders based on their sales from higest to the lowest.
SELECT OrderID,OrderDate,ProductID,Sales,
ROW_NUMBER() OVER(ORDER BY Sales DESC) AS SalesRanking
FROM Sales.Orders

--Use Case 1: Top N-analysis: Analysis the top performers to do targetted marketing.
-- Task: Find the top highest sales for each product.
SELECT *
FROM (
	SELECT 
		OrderID, 
		ProductID,
		Sales,
		ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS RankByProduct
	FROM Sales.Orders
)t WHERE RankByProduct = 1

--Use Case 2: Bottom N-analysis.
--Task: Find the lowest two customers based on their total sales.
SELECT *
FROM (
	SELECT 
		CustomerID,
		SUM(Sales) TotalSales,
		ROW_NUMBER() OVER(ORDER BY SUM(Sales)) RankCustomers
	FROM Sales.Orders
	GROUP BY CustomerID
)t WHERE RankCustomers <=2

/* Use Case 3: Generate Unique IDs: ROW_NUMBER() assigns unique ranks to the rows despite the row position. This also helps
in paginating 
Task: Assign Unique IDs to the rows of 'OrdersArchive' Table */
SELECT *,
ROW_NUMBER() OVER(ORDER BY OrderID) AS UniqueKey
FROM Sales.OrdersArchive

--Use Case 4: Identify Duplicates
--Task: Identity duplicate rows in the OrdersArchive table and return a clean result without duplicates.
-- My solution
SELECT *
FROM (
	SELECT *,
	ROW_NUMBER() OVER(ORDER BY OrderID) AS UniqueKey
	FROM Sales.OrdersArchive
)t WHERE UniqueKey != OrderID

--Professor's Solution
SELECT *,ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) AS rn
FROM Sales.OrdersArchive

SELECT *
FROM (
	SELECT ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) AS rn,
	*
	FROM Sales.OrdersArchive
)t WHERE rn = 1

--To get duplicates and bad quality data
SELECT *
FROM (
	SELECT ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) AS rn,
	*
	FROM Sales.OrdersArchive
)t WHERE rn > 1

--RANK(): It assigns a rank to each row and it can handle ties. It leaves gaps in ranking.
-- Task: Rank the orders based on their sales from highest to lowest.
SELECT OrderID,OrderDate,ProductID,Sales,
ROW_NUMBER() OVER(ORDER BY Sales DESC) AS SalesRowNumber,
RANK() OVER(ORDER BY Sales DESC) AS SalesRanking
FROM Sales.Orders

--DENSE_RANK():it assignes a rank to each row, it can handle ties and it does not leave gaps in ranking.
-- Task: Rank the orders based on their sales from highest to lowest.
SELECT OrderID,OrderDate,ProductID,Sales,
ROW_NUMBER() OVER(ORDER BY Sales DESC) AS SalesRowNumber,
RANK() OVER(ORDER BY Sales DESC) AS SalesRanking,
DENSE_RANK() OVER(ORDER BY Sales DESC) AS SalesDenseRank
FROM Sales.Orders

/* NTILE(): NTILE() divides rows into a specified number of approximately equal groups called buckets.
The purpose of NTILE() is not ranking. The purpose is distribution.
It answers questions such as:
- Which rows belong to the top half?
- Which rows belong to the bottom half?
- Which rows belong to the top 25%?
- Which rows belong to Bucket 1, Bucket 2, Bucket 3, etc.?
NTILE() therefore performs segmentation of data.

Buckets: A bucket is simply a group of rows.
When NTILE(n) is used:
- n = number of buckets
- SQL distributes rows into those buckets
- Each row receives a bucket number
- Bucket numbering starts from 1

Example: Bucket 1, Bucket 2, Bucket 3...Bucket n

Equal Distribution: NTILE() attempts to distribute rows as evenly as possible.

Goal:All buckets should contain approximately the same number of rows.

The distribution is based on:Number of Rows/Number of buckets

When Rows Cannot Be Divided Equally: Perfect distribution is not always possible.

Example: 5 rows,2 buckets. Each bucket cannot contain exactly 2.5 rows.Therefore SQL distributes the extra rows to 
earlier buckets.

Rule: Larger buckets come first. Smaller buckets come later.

Distribution Logic: If there are leftover rows after division:
1. Earlier buckets receive the extra rows.
2. Later buckets receive fewer rows.
3. Difference between bucket sizes is never more than 1 row.

Examples: 5 Rows, 2 Buckets
Bucket 1 = 3 rows
Bucket 2 = 2 rows

5 Rows, 3 Buckets

Bucket 1 = 2 rows
Bucket 2 = 2 rows
Bucket 3 = 1 row

5 Rows, 4 Buckets

Bucket 1 = 2 rows
Bucket 2 = 1 row
Bucket 3 = 1 row
Bucket 4 = 1 row

Ordering Determines Distribution: Before rows are distributed into buckets, SQL first sorts the rows.
After sorting:
- Highest values may appear in Bucket 1
- Lowest values may appear in the last bucket
Therefore bucket assignment depends entirely on the ordering sequence.

Top and Bottom Analysis: NTILE() is commonly used when data needs to be divided into segments.
Examples:
- Top 50% vs Bottom 50%
- Top 25% vs Remaining 75%
- Top Quartile
- Bottom Quartile
- Customer Segmentation
- Product Segmentation
- Performance Bands
The goal is not to identify exact ranks. The goal is to identify groups.

Approximate Equality: NTILE() guarantees:
Every row belongs to a bucket
Bucket numbers start at 1
Rows are distributed as evenly as possible
Larger buckets appear before smaller buckets
Difference between bucket sizes is at most one row
Buckets represent groups rather than exact rankings

Imagine sorting all rows from best to worst.Then cut the sorted rows into approximately equal-sized pieces.Each piece 
becomes a bucket.
NTILE() simply labels those pieces:Bucket 1,Bucket 2,Bucket 3...Bucket n */

SELECT OrderID,Sales,
NTILE(1) OVER(ORDER BY Sales DESC) AS OneBucket,
NTILE(2) OVER(ORDER BY Sales DESC) AS TwoBuckets,
NTILE(3) OVER(ORDER BY Sales DESC) AS ThreeBuckets,
NTILE(4) OVER(ORDER BY Sales DESC) AS FourBuckets,
NTILE(5) OVER(ORDER BY Sales DESC) AS FiveBuckets
FROM Sales.Orders

/* Use Case1: Data Segmentation: Divides the dataset into distinct subsets based on a certain criteria.
Data analyst uses NTILE for Data Segmentation. */
--Task: Segment all orders into 3 categories: High, Medium and Low sales
SELECT *,
CASE WHEN Buckets = 1 THEN 'High'
	 WHEN Buckets = 2 THEN 'Medium'
     WHEN Buckets = 3 THEN 'Low'
END AS Categorizing 
FROM (
	SELECT OrderID, Sales,
	NTILE(3) OVER(ORDER BY Sales DESC) AS Buckets
	FROM Sales.Orders
)t 

/* Use Case 2: Equalizing load: Transfering the entiresdata from one database to another database is a long, tedious process
and puts a strain on the networks as well. In this case, NTILE() is used in order to split the data into chunks and then
tranfer it to another database. Data engineer uses it for equalizing load processing. The number of buckets depends on the
size of the data as well.*/
--Task: In order to export the data divide the divide orders into 2 groups
SELECT *,NTILE(2) OVER(ORDER BY OrderID) AS TwoGroups
FROM Sales.Orders

-- Percentage based ranking: Consists of CUME_DIST() and PERCENT_RANK()
/* CUME_DIST():Cumulative distribution calculates the distribution of data points within a window. if there is a tie,
CUME_DIST() assumes the last same value's position number and calculates the CUME_DIST(). Hence for same values, 
the percent is same as well. In CUME_DIST() the current row is included.
CUME_DIST() = Position number/number of rows*/

/* PERCENT_RANK(): Calculates the relative position of each row. 
PERCENT_RANK() = Position number - 1/number of rows - 1. Tie Rule: Opposite of CUME_DIST(). it takes the position number
of the first same value. Like CUME_DIST(),PERCENT_RANK() shares the same percent number. Based on the formula,
PERCENT_RANK() does not include the current row. */

--Task: Find the products that fall within the highest 40% of prices.
SELECT *,
CONCAT(Dist_rank * 100,'%') AS DistRankPercentage
FROM (
	SELECT *, CUME_DIST() OVER (ORDER BY Price DESC) AS Dist_rank
	FROM Sales.Products
)t WHERE Dist_rank <= 0.4

--With PERCENT_RANK()
SELECT *,
CONCAT(Percent_Rank * 100,'%') AS DistRankPercentage
FROM (
	SELECT *, PERCENT_RANK() OVER (ORDER BY Price DESC) AS Percent_Rank
	FROM Sales.Products
)t WHERE Percent_Rank <= 0.4

/* Dataset: Orders
+----------+------------+--------+
| OrderID  | CustomerID | Sales  |
+----------+------------+--------+
| 1        | A          | 100    |
| 2        | A          | 80     |
| 3        | A          | 80     |
| 4        | B          | 60     |
| 5        | B          | 40     |
| 6        | C          | 20     |
+----------+------------+--------+

Conceptual Questions.Q1) Which function would you use? Give every row a unique rank even when Sales are tied.
Answer: ROW_NUMBER()

Q2) Which function would you use? If two rows have Sales = 80, both should get Rank 2 and the next rank should be 4.
Answer: RANK()

Q3) Which function would you use? If two rows have Sales = 80, both should get Rank 2 and the next rank should be 3.
Answer: DENSE_RANK()

Q4) Which function would you use? Divide all orders into 4 approximately equal groups.
ANSWER: NTILE()

Q5) Which function would you use? Find the top 20% products.
Answer: CUME_DIST()

Q6) True or False? SUM(Sales) OVER() returns one row.
ANSWER: Since OVER() indicates that window functions are used, SUM(Sales) will return all the rows the dataset has. If the
dataset has only one row, then it will return one row.

Q7) True or False? COUNT(*) OVER() preserves row granularity.
Answer: True.

Q8) What happens when PARTITION BY is removed? AVG(Sales) OVER()
Answer: Then the aggregation will be performed on the entire dataset and there will be no windows, and no subset of data
on which the aggregation will be performed.

Q9) What happens when ORDER BY is removed from RANK()?
Answer: As a mandatory element in the syntax of RANK(), removal of ORDER BY will result in an error.

Q10) Can NTILE(4) produce buckets with different row counts? Why?
Answer: If the number of rows of the dataset are divisible by 4 then it won't produce buckets with different row counts.

Output Prediction. Q11) Predict:Sales: 100,80,80,40
ROW_NUMBER() OVER(ORDER BY Sales DESC)
Answer: 
Sales | SalesRowNumber
100	  |		1
80	  |		2
80    |		3
40    |		4

Q12) Predict: RANK() OVER(ORDER BY Sales DESC)
Answer: 
Sales | SalesRankNumber
100	  |		1
80	  |		2
80    |		2
40    |		4

Q13) Predict: DENSE_RANK() OVER(ORDER BY Sales DESC)
Answer: 
Sales | SalesDenseRankNumber
100	  |		1
80	  |		2
80    |		2
40    |		3

Q14) Predict: NTILE(2) OVER(ORDER BY Sales DESC)
Answer: 
Sales | SalesNTILE
100	  |		1
80	  |		1
80    |		2
40    |		2

Q15) Predict:COUNT(*) OVER() for the 6-row dataset.
Answer: Returns all 6 rows even if NULLs are included.

Tiny Coding Questions. Q16) Show every order together with: Total Orders In Table
Answer: 
SELECT OrderID,Sum(OrderID) OVER() AS TotalOrders
FROM Orders

Q17) Show every order together with: Total Sales In Table
Answer: 
SELECT OrderID, Sales, SUM(Sales) OVER() AS TotalSales 
FROM Orders

Q18) Show every order together with: Average Sales In Table
SELECT OrderID, Sales, AVG(Sales) OVER() AS AverageSales 
FROM Orders

Q19) Show every order together with: Highest Sales In Table
SELECT OrderID, Sales, MAX(Sales) OVER() AS HighestSales 
FROM Orders

Q20) Show every order together with: Lowest Sales In Table
SELECT OrderID, Sales, MIN(Sales) OVER() AS LowestSales 
FROM Orders

Business Thinking
Q21) You need: CustomerID, Sales, Customer Total Sales GROUP BY or WINDOW FUNCTION? Why?
Answer: As additional details are required, WINDOW FUNCTIONS will be used.

Q22)You need: Only Customer Total Sales GROUP BY or WINDOW FUNCTION? Why?
Answer: GROUP BY(CustomerID) would be enough along with SUM(Sales)

Q23) You need: Top sale within each customer. Which ranking function?
Answer: ROW_NUMBER()

Q24) You need: Top 25% customers. Which function is most natural?
ANSWER: Both PERCENT_DIST()

Q25)You need: Gold,Silver,Bronze customer segments. Which function is most natural?
Answer: NTILE()

Hard Conceptual Questions. Q26) Why does this work?
SELECT
    OrderID,
    Sales,
    SUM(Sales) OVER()
FROM Orders

but this does not?

SELECT
    OrderID,
    Sales,
    SUM(Sales)
FROM Orders

ANSWER: In the first code, OVER() is mentioned which means windows functions are used. aggregations can be used with window
functions and it also allows additional details as well. In the second code, windows functions are not used since OVER() is
absent. Also aggregate functions are used with GROUP BY. WeLL I think both code may work. Umm, the second one may work as well
it's just that the entire database will be considered.

Q27) What business problem does NTILE solve that RANK does not?
Answer: Since huge datasets are used in businesses, NTILE() divides the huge dataset into buckets which can be used for
tranferring from one database into other without starining the networks.

Q28) Why is ROW_NUMBER commonly used for duplicate removal?
Answer: ROW_NUMBER() ranks the dataset rows as 1,2,3 .... without gaps and without considering the position of the row which
helps the developer understand whether duplicates and bad quality data exists. 

Q29) What is the difference between: Top 3 Customers and Top 30% Customers in terms of window functions?
Answer: Top 3 customers indicate only 3 customers as 3 is an integer. top 30 percent customers may have many customers.

Q30) Complete:

ROW_NUMBER() is for ranking the data without caring about the positions and gaps. 1,2,3,4...etc

RANK() is for ranking, but tied values get the same rank and next value gets the row position number

DENSE_RANK() is for ranking tied values get the same rank and the next value gets the next number from the previous rank

NTILE() is for dividing the large dataset into chunks/buckets

CUME_DIST() is for calculating the top/bottom data in percentages.

PERCENT_RANK() is for calculating the top/bottom data in percentages. */