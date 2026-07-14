/* Value Window Functions | LEAD, LAG, FIRST_VALUE, LAST_VALUE
Value functions let us access the values from other row. Consider the dataset:
Month | Sales
Jan	  |	20
Feb   |	10
Mar   |	30
Apr   |	5
Jun   |	70
Jul   |	40
If current row is on March, then LEAD() gives us the value of Apr|5, LAG() gives us Feb|10,FIRST_VALUE() gives JAN|20
and last value gives Jul|40. ORDER BY is mandatory for Value functions and Frame is mandatory only for LAST_VALUE()
Input Data

+-------+-------+
| Month | Sales |
+-------+-------+
| Jan   | 20    |
| Feb   | 10    |
| Mar   | 30    |
| Apr   | 5     |
+-------+-------+
LEAD(Sales) OVER(ORDER BY Month)
+-------+-------+------+
| Month | Sales | LEAD |
+-------+-------+------+
| Jan   | 20    | 10   |
| Feb   | 10    | 30   |
| Mar   | 30    | 5    |
| Apr   | 5     | NULL |
+-------+-------+------+
LAG(Sales) OVER(ORDER BY Month)
+-------+-------+------+
| Month | Sales | LAG  |
+-------+-------+------+
| Jan   | 20    | NULL |
| Feb   | 10    | 20   |
| Mar   | 30    | 10   |
| Apr   | 5     | 30   |
+-------+-------+------+

LEAD() and LAG() Syntax:
LEAD(Sales, 2, 10) OVER(PARTITION BY ProductID ORDER BY OrderDate)
+----------------+--------------------------------------------------+
| Component      | Details                                          |
+----------------+--------------------------------------------------+
| Expression     | Required                                         |
|                | Any Data Type                                    |
+----------------+--------------------------------------------------+
| Offset         | Optional                                         |
|                | Number of rows forward or backward               |
|                | from current row                                 |
|                | Default = 1                                      |
+----------------+--------------------------------------------------+
| Default Value  | Optional                                         |
|                | Returns default value if                         |
|                | next/previous row is not available               |
|                | Default = NULL                                   |
+----------------+--------------------------------------------------+
| PARTITION BY   | Optional                                         |
+----------------+--------------------------------------------------+
| ORDER BY       | Required                                         |
+----------------+--------------------------------------------------+ 

Time Series Analysis:
1) Year-Over-Year(YoY): Analyze the overall growth or decline of the business's performance over the period of time.
2) Month-Over-Month(MoM): Analyze the short term trends and discover patterns in seasonality.

Task: Analyze the month over month(MoM) performance by finding the percentage change in sales between the current and 
previous month */
SELECT *,
CurrentMonthSales - PreviousMonthSales AS MoMChange,
ROUND(CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT)/PreviousMonthSales * 100,1) AS MoMPercent
FROM (
	SELECT 
	DATENAME(month,OrderDate) AS OrderMonth,
	SUM(Sales) CurrentMonthSales,
	LAG(SUM(Sales)) OVER(ORDER BY DATENAME(month,OrderDate)) PreviousMonthSales
FROM Sales.Orders 
GROUP BY DATENAME(month,OrderDate)
)t

/* Customer Retention Analysis: Measure customer's behavior and loyalty to help businessess build strong relationships 
with customers 
Task: Analyze the customer loyalty by ranking customers based on the average number of days between orders */
SELECT
    CustomerID,
    AVG(DaysUntilNextOrder) AS AvgDays,
    RANK() OVER (ORDER BY COALESCE(AVG(DaysUntilNextOrder), 999999)) AS RankAvg
FROM (
    SELECT
        OrderID,
        CustomerID,
        OrderDate AS CurrentOrder,
        LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS NextOrder,
        DATEDIFF(
            day,
            OrderDate,
            LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)
        ) AS DaysUntilNextOrder
    FROM Sales.Orders
) AS CustomerOrdersWithNext
GROUP BY CustomerID

/* FIRST_VALUE(): Access a value from the first row within the window. default frame can be used for this function
LAST_VALUE(): Access a value from the last row within the window. Frame 'ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING'
must be used to get the last value 

Task: Find the lowest and highest sales for each product.Find the difference between current and lowest sales */
SELECT
    OrderID,
    ProductID,
    Sales,
    FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) AS LowestSales,
    LAST_VALUE(Sales) OVER (
        PARTITION BY ProductID 
        ORDER BY Sales 
        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    ) AS HighestSales,
    Sales - FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) AS SalesDifference
FROM Sales.Orders

/* Dataset: Sales
+-------+-------+
| Month | Sales |
+-------+-------+
| Jan   | 20    |
| Feb   | 10    |
| Mar   | 30    |
| Apr   | 5     |
| May   | 70    |
| Jun   | 40    |
+-------+-------+

Conceptual Questions. Q1) If the current row is: Mar | 30. What does: LAG(Sales) return?
Answer: Feb | 10

Q2) If the current row is: Mar | 30 What does: LEAD(Sales) return?
Answer: Apr | 5

Q3) True or False? LAG() looks at future rows.
Answer: False. LAG() looks at previous rows.

Q4) True or False? LEAD() looks at previous rows.
Answer: false. LEAD() looks are following rows

Q5) What does Offset mean? LAG(Sales,2)
Answer: Offset means how many rows to consider. in this case LAG(Sales,2) means,'consider the value excluding the current 
row's and previous 1 row's in the sales column'

Q6) What does this return for March? LAG(Sales,2)
Answer: Jan | 20

Q7) What does this return for March? LEAD(Sales,2)
Answer: May | 70

Q8) What happens when there is no previous row for LAG()?
Answer: SQL shows NULL.

Q9) What happens when there is no next row for LEAD()?
Answer: SQL shows NULL.

Q10) Why does LEAD/LAG require ORDER BY?
Answer: Since the values for LEAD/LAG depends on the following and previous rows, ordering as per column name 
is important for LEAD/LAG before implementing the function.

Output Prediction. Q11) Predict: LAG(Sales) OVER(ORDER BY Month)
Answer: 
 Month  | Sales |  LAG(Sales)
+-------+-------+-------------
| Jan   | 20    |NULL
| Feb   | 10    |20
| Mar   | 30    |10
| Apr   | 5     |30
| May   | 70    |5
| Jun   | 40    |70

Q12) Predict: LEAD(Sales) OVER(ORDER BY Month)
 Month  | Sales |  LEAD(Sales)
+-------+-------+-------------
| Jan   | 20    |10
| Feb   | 10    |30
| Mar   | 30    |5
| Apr   | 5     |70
| May   | 70    |40
| Jun   | 40    |NULL

Q13) Predict: LAG(Sales,2) OVER(ORDER BY Month)
 Month  | Sales |  LAG(Sales,2)
+-------+-------+-------------
| Jan   | 20    |NULL
| Feb   | 10    |NULL
| Mar   | 30    |20
| Apr   | 5     |10
| May   | 70    |30
| Jun   | 40    |5

Q14) Predict: LEAD(Sales,2) OVER(ORDER BY Month)
 Month  | Sales |  LEAD(Sales,2)
+-------+-------+-------------
| Jan   | 20    |30
| Feb   | 10    |5
| Mar   | 30    |70
| Apr   | 5     |40
| May   | 70    |NULL
| Jun   | 40    |NULL

Q15) Predict: LAG(Sales,1,0) OVER(ORDER BY Month) Notice the default value.
Answer: 
 Month  | Sales |  LAG(Sales)
+-------+-------+-------------
| Jan   | 20    |0
| Feb   | 10    |20
| Mar   | 30    |10
| Apr   | 5     |30
| May   | 70    |5
| Jun   | 40    |70

FIRST_VALUE / LAST_VALUE

Dataset
+---------+-------+
| Product | Sales |
+---------+-------+
| A       | 10    |
| A       | 20    |
| A       | 50    |
| A       | 80    |
+---------+-------+
Q16) What does: FIRST_VALUE(Sales) return on every row?
Answer: 10

Q17) What does: LAST_VALUE(Sales) return on every row when using: ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
Answer: 80

Q18) What business question is solved by: FIRST_VALUE() Give one example.
Answer: Depends on how FIRST_VALUE() is sorted. if sorted ASC, the lowest value will be displayed. if sorted DESC,the highest
value will be displayed. Number of business questions like, loyal customers, best/worst selling products can be answered.

Q19) What business question is solved by: LAST_VALUE() Give one example.
Answer: Depends on how FIRST_VALUE() is sorted. if sorted ASC, the lowest value will be displayed. if sorted DESC,the highest
value will be displayed. Number of business questions like, loyal customers, best/worst selling products can be answered.

Q20) Complete:
LAG()         → looks at previous rows 
LEAD()        → looks at following rows
FIRST_VALUE() → looks at the first value within a certain window
LAST_VALUE()  → looks at the last value within a certain window

Tiny Coding Questions.Q21) Show every month together with previous month's sales.
SELECT Sales,Month, LAG(Month) OVER(ORDER BY Month) AS PreviousMonthSales
FROM Sales

Q22) Show every month together with next month's sales.
SELECT Sales,Month, LEAD(Month) OVER(ORDER BY Month) AS NextMonthSales
FROM Sales

Q23) Show every month together with: CurrentSales - PreviousSales
SELECT *,
CurrentSales - PreviousSales AS PreviousSalesCalculation
FROM (
    SELECT Sales,Month,LAG(Month) OVER(ORDER BY Month) AS PreviousSales, SUM(Sales) AS CurrentSales
    FROM Sales
)t

Q24) Show every month together with:NextSales - CurrentSales
SELECT *,
NextSales - CurrentSales AS FollowingSalesCalculation
FROM (
    SELECT Sales,Month,LEAD(Month) OVER(ORDER BY Month) AS NextSales, SUM(Sales) AS CurrentSales
    FROM Sales
)t

Q25) Show every order together with the lowest sales of its product.
Answer:
SELECT Sales,FIRST_VALUE(Sales) OVER(ORDER BY Month ASC) AS LowestSales
FROM Sales

Q26) Show every order together with the highest sales of its product.
Answer:
SELECT Sales,FIRST_VALUE(Sales) OVER(ORDER BY Month DESC) AS HighestSales
FROM Sales

Business Thinking.Q27) Which function would you use? Month-over-Month Growth
Answer: LAG()

Q28) Which function would you use? Days until customer's next order
Answer: LEAD()

Q29) Which function would you use? Days since customer's previous order
Answer: LAG()

Q30) You need: Current Price,Previous Price,Price Difference. Which value function is most natural?
Answer: LAG() cause previous price is mentioned.

Hard Conceptual Questions. Q31) Why is LAST_VALUE usually more confusing than FIRST_VALUE?
Answer: FIRST_VALUE() and LAST_VALUE() are always dependent on the current row and the Frame defined. There is no issue with
FIRST_VALUE() since by default SQL considers the first row no matter what hence we get the FIRST_VALUE() correct.
Since frames and windows shifts, the last value within the window also changes. Hence in LAST_VALUE() the frame: ROWS BETWEEN
CURRENT ROW AND UNBOUNDED FOLLOWING is mandatory as current row's value does not matter, but since UNBOUNDED FOLLOWING is
mentioned, the last limit will always be pointing to the last row which gives us the correct last value.

Q32) Why is:LAST_VALUE() often paired with:ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
Answer: Refer 31st's question's answer

Q33) What is the difference between: LAG(Sales) and FIRST_VALUE(Sales)
Answer:LAG(Sales) considers previous rows from the current row. FIRST_VALUE(Sales) considers the value of the first row
no matter what even if the frame is not defined.

Q34) What is the difference between: LEAD(Sales) and LAST_VALUE(Sales)
Answer: LEAD(Sales) considers the following rows from the current row. LAST_VALUE(Sales) considers the values of the last row
within the defined window and if the frame conditon: ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING is mentioned, then
only the value of the last row of the sales's column will be considered.

Q35) Complete:
Ranking Functions answer: ROW_NUMBER(),RANK(),DENSE_RANK()
"Which position am I?"

Value Functions answer:LEAD(),LAG()
"Which value exists on another row?" */