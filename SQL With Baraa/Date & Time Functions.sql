-- Date and Time Functions
-- Year-Quarter-Month-Week-Day-Hour-Minute-Second 
-- 1) Date column from a table
SELECT OrderID, CreationTime
FROM Sales.Orders

-- 2) Hardcoded Constant String value: This date is not present in the database. We define it
SELECT OrderID, CreationTime,'1998-03-28' AS HardCoded
FROM Sales.Orders

-- 3) GETDATE(): Returns the current date and time the moment an query gets executed. 
SELECT OrderID, CreationTime,'1998-03-28' AS HardCoded, GETDATE() TODAY
FROM Sales.Orders

-- Date and Time Functions Overview
-- Part Extraction
-- DAY(): Returns the day from the date. SYNTAX: DAY(date)
SELECT OrderID, CreationTime, DAY(CreationTime) AS Currentday
FROM Sales.Orders

-- MONTH(): Returns the month from the date. MONTH(date)
SELECT OrderID, CreationTime, MONTH(CreationTime) AS Currentmonth
FROM Sales.Orders

-- YEAR(): Returns the year from the date. YEAR(date)
SELECT OrderID, CreationTime, YEAR(CreationTime) AS Currentyear
FROM Sales.Orders

--Consolidated Query
SELECT OrderID, CreationTime, 
DAY(CreationTime) AS Currentday,
MONTH(CreationTime) AS Currentmonth, 
YEAR(CreationTime) AS Currentyear
FROM Sales.Orders

/* 2) DATEPART():extracts a specific component (like year, month, day, hour, or minute) from a date or 
time expression and returns it as an integer value */
-- SYNTAX: DATEPART(part, date)
-- Examples: DATEPART(month, OrderDate) or DATEPART(mm, '1998-03-28')
-- DATEPART for day
SELECT OrderID, CreationTime,DATEPART(DAY,CreationTime) AS partday
FROM Sales.Orders 

-- DATEPART for month
SELECT OrderID, CreationTime,DATEPART(MONTH,CreationTime) AS partmonth
FROM Sales.Orders 

-- DATEPART for Year
SELECT OrderID, CreationTime,DATEPART(YEAR,CreationTime) AS partyear
FROM Sales.Orders 

-- Consolidated Query for day, month, year, hour, minute, second, quarter, week
/* Quarter Definition: In SQL, a quarter represents a three-month period of the calendar year, 
returning an integer value from 1 to 4.The breakdown of standard calendar quarters is as follows:
Quarter 1 (Q1): January 1 – March 31Quarter 2 (Q2): April 1 – June 30Quarter 3 (Q3): July 1 – September 30
Quarter 4 (Q4): October 1 – December 31 */

SELECT OrderID, CreationTime,
DATEPART(DAY,CreationTime) AS partday,
DATEPART(MONTH,CreationTime) AS partmonth,
DATEPART(YEAR,CreationTime) AS partyear,
DATEPART(HOUR,CreationTime) AS parthour, 
DATEPART(MINUTE,CreationTime) AS partmin,
DATEPART(SECOND,CreationTime) AS partsecond,
DATEPART(QUARTER,CreationTime) AS partquarter,
DATEPART(WEEK,CreationTime) AS partweek
FROM Sales.Orders

--DATENAME(): Returns the name of the part mentioned. EG: In DATENAME(month,date),if month is 3, it'll return March.
--SYNTAX: DATENAME(part,date)
SELECT OrderID, CreationTime,
DATENAME(DAY,CreationTime) AS partday,
DATENAME(MONTH,CreationTime) AS partmonth,
DATENAME(YEAR,CreationTime) AS partyear,
DATENAME(HOUR,CreationTime) AS parthour, 
DATENAME(MINUTE,CreationTime) AS partmin,
DATENAME(SECOND,CreationTime) AS partsecond,
DATENAME(QUARTER,CreationTime) AS partquarter,
DATENAME(WEEK,CreationTime) AS partweek
FROM Sales.Orders

/* DATETRUNC(): Truncates the date to a specific part. If the full date is [Year,Month,Day],[Hours,Mins,Seconds] 
and we only want [Year,Month,Day],[Hours,Mins], seconds get reset to zero. Like this we can truncate any sub part.
Datepart resets to 01 and timepart resets to 00. */

-- The seconds are already zero hence the below query won't make any change
SELECT OrderID, CreationTime,
--DATENAME(DAY,CreationTime) AS partday,
--DATENAME(MONTH,CreationTime) AS partmonth,
--DATENAME(YEAR,CreationTime) AS partyear,
--DATENAME(HOUR,CreationTime) AS parthour, 
--DATENAME(MINUTE,CreationTime) AS partmin,
DATETRUNC(SECOND,CreationTime) AS partsecond
FROM Sales.Orders

-- mins are truncated
SELECT OrderID, CreationTime,
--DATETRUNC(DAY,CreationTime) AS partday,
--DATETRUNC(MONTH,CreationTime) AS partmonth,
--DATETRUNC(YEAR,CreationTime) AS partyear,
--DATETRUNC(HOUR,CreationTime) AS parthour, 
DATETRUNC(MINUTE,CreationTime) AS partmin,
DATETRUNC(SECOND,CreationTime) AS partsecond
FROM Sales.Orders

-- Hours are truncated
SELECT OrderID, CreationTime,
--DATETRUNC(DAY,CreationTime) AS partday,
--DATETRUNC(MONTH,CreationTime) AS partmonth,
--DATETRUNC(YEAR,CreationTime) AS partyear,
DATETRUNC(HOUR,CreationTime) AS parthour, 
DATETRUNC(MINUTE,CreationTime) AS partmin,
DATETRUNC(SECOND,CreationTime) AS partsecond
FROM Sales.Orders

-- Years are truncated. Set to 01.
SELECT OrderID, CreationTime,
--DATETRUNC(DAY,CreationTime) AS partday,
--DATETRUNC(MONTH,CreationTime) AS partmonth,
DATETRUNC(YEAR,CreationTime) AS partyear,
DATETRUNC(HOUR,CreationTime) AS parthour, 
DATETRUNC(MINUTE,CreationTime) AS partmin,
DATETRUNC(SECOND,CreationTime) AS partsecond
FROM Sales.Orders

-- Months are truncated. Set to 01.
SELECT OrderID, CreationTime,
DATETRUNC(DAY,CreationTime) AS partday,
DATETRUNC(MONTH,CreationTime) AS partmonth,
DATETRUNC(YEAR,CreationTime) AS partyear,
DATETRUNC(HOUR,CreationTime) AS parthour, 
DATETRUNC(MINUTE,CreationTime) AS partmin,
DATETRUNC(SECOND,CreationTime) AS partsecond
FROM Sales.Orders

-- DATETRUNC for data analysis
SELECT DATETRUNC(year,CreationTime) AS Creation,Count(*)
FROM Sales.Orders
GROUP BY DATETRUNC(year,CreationTime)

SELECT DATETRUNC(month,CreationTime) AS Creation,Count(*)
FROM Sales.Orders
GROUP BY DATETRUNC(month,CreationTime)

/* EOMONTH(): Changes the day of the date to its last day. Eg: 3rd March, 2025 gets changed to 31st March 2025.
If the day of the month is the last day, applying this function won't change the value. Hence 30th June, 2025 will remain same.
SYNTAX: EOMONTH(date) */

SELECT OrderID, CreationTime,
EOMONTH(CreationTime) AS monthend
FROM Sales.Orders 

-- Method to get first day of the month: There is no direct method. We have to use DATETRUNC since it sets the month to 1.
SELECT OrderID, CreationTime, EOMONTH(CreationTime) AS monthend,DATETRUNC(month,CreationTime) AS startofmonth
FROM Sales.Orders 

-- Part Extraction Use Case: 
-- Data Aggregations: Used in report analysis for answering the questions like, how many products were shipped in a year, month, etc
-- Task: How many orders were placed in a year.
SELECT YEAR(OrderDate) AS yearinfo ,Count(*) AS nooforders
FROM Sales.Orders
GROUP BY YEAR(OrderDate)

-- Task: How many orders were placed in a month.
SELECT DATENAME(month,OrderDate) AS monthinfo, COUNT(*) AS nooforders
FROM Sales.Orders 
GROUP BY DATENAME(month,OrderDate)

-- Data Filtering
-- Task: Show all the orders that were placed in February
SELECT DATENAME(month,OrderDate) AS monthinfo, COUNT(*) AS nooforders
FROM Sales.Orders 
WHERE DATENAME(month,OrderDate) = 'February'
GROUP BY DATENAME(month,OrderDate)

--Best Practice: avoid using DATENAME for data filtering, use DATEPART instead since numbers are faster to filter.
SELECT *
FROM Sales.Orders 
WHERE MONTH(OrderDate) = 2

/* Orders
| order_id | order_date |
| -------- | ---------- |
| 1        | 2023-01-15 |
| 2        | 2023-02-10 |
| 3        | 2023-02-25 |
| 4        | 2023-06-12 |
| 5        | 2024-01-05 |
| 6        | 2024-03-20 |
| 7        | 2024-03-25 |
| 8        | 2024-12-31 |

Question 1) Return: order_id, year using YEAR().
SELECT order_id, YEAR(order_date) AS onlyyear
FROM orders

Question 2) Return: order_id, month number using MONTH().
SELECT order_id, MONTH(order_date) AS onlymonth
FROM orders

Question 3) Return: order_id, month name using DATENAME().
SELECT order_id, DATENAME(month,order_date)
FROM orders

Question 4) Count orders by year.
SELECT DATEPART(year,order_date) AS onlyyear, COUNT(*) AS no_of_orders
FROM orders
GROUP BY DATEPART(year,order_date)

Question 5) Count orders by month.
SELECT DATEPART(month, order_date) AS onlymonth, COUNT(*) AS no_of_orders
FROM orders
GROUP BY DATEPART(month, order_date)

Question 6) Show only orders placed in March.
SELECT DATENAME(month,order_date) AS onlymonth, COUNT(*) AS nooforders
FROM orders
WHERE DATENAME(month,order_date) = 'March'
GROUP BY DATENAME(month,order_date)

Alternate: 
SELECT *
FROM orders
WHERE MONTH(order_date) = 3

Question 7) Show only orders placed in 2024.
SELECT DATENAME(year,order_date) AS onlyyear, COUNT(*) AS nooforders
FROM orders
WHERE DATENAME(year,order_date) = 2024
GROUP BY DATENAME(year,order_date)

Alternate: 
SELECT *
FROM orders
WHERE YEAR(order_date) = 2024

Question 8) Display: order_date, month_end using EOMONTH().
SELECT order_id, order_date,EOMONTH(order_date) AS endofmonth
FROM orders

Question 9) Display: order_date, month_start using DATETRUNC().
SELECT order_date, DATETRUNC(month,order_date) AS startofmonth
FROM orders

Question 10) How many orders were placed in Q1?
SELECT COUNT(*) AS no_of_orders
FROM orders
WHERE DATEPART(quarter,order_date) = 1 */

----------------------------------------------------------------------------------------------------------------
-- DATE FORMAT
-- Dates and time are case sensitive when it comes to months and minutes. MM means month and mm means minutes.
-- FORMAT(): Formats date and time value. 
-- SYNTAX: FORMAT(value, format [,culture]). Culture enables us to view the result in a particular region. It is optional.
-- Eg: FORMAT(OrderDate,'dd/MM/yyyy') (MM is used for month and culture is not specified)
-- Eg 2: FORMAT(OrderDate,'dd/MM/yyyy', 'ja-JP') (Japan region is mentioned in culture)
-- Eg 3: FORMAT(1234.56,'D','fr-FR') (Format is D)
-- Since culture is optional and not much used, by default 'en-US' is used.

SELECT OrderID, CreationTime,
FORMAT(CreationTime,'MM-dd-yyyy') AS USA_Format,-- USA Format
FORMAT(CreationTime,'dd-MM-yyyy') AS Europe_Format, -- Europe Format
FORMAT(CreationTime,'dd') AS dd, -- Formats the day and give the number of day in two digits like 01,20, etc
FORMAT(CreationTime,'ddd') AS ddd, -- Formats the day and gives the abbreviated name of the day like Mon,Fri,Sat
FORMAT(CreationTime,'dddd') AS dddd, -- Formats the day and gives the full name of the day like Monday, Sunday, etc
FORMAT(CreationTime,'MM') AS MM, -- Formats the month and gives the number of the month in two digits
FORMAT(CreationTime,'MMM') AS MMM,-- Formats the month and gives the abbreviated name of the month like Jan, Feb
FORMAT(CreationTime,'MMMM') AS MMMM -- Formats the month and gives the full name of the year like January, March, etc
FROM Sales.Orders

--Task: Show creation time using the following format: Day Wed Jan Q1 2025 12:34:56 PM
SELECT OrderID, CreationTime,
'Day' + ' ' +FORMAT(CreationTime,'ddd MMM') + DATENAME(quarter,CreationTime) + ' ' + FORMAT(CreationTime,'yyyy hh:ss:tt') AS CutomFormat
FROM Sales.Orders

-- Formatting Use Cases
-- Date Aggregations
SELECT FORMAT(OrderDate,'MM yy') AS OrderDate, COUNT(*)
FROM Sales.Orders 
GROUP BY FORMAT(OrderDate,'MM yy')

-- Date and Time Format specifiers (Refer to PPT)

-- Convert(): Converts a date or time value to a different data type and formats the value
-- Syntax: CONVERT(datatype, value [,style]) [style] is optional
-- Eg: CONVERT(INT,'124'), CONVERT(VARCHAR,OrderDate,'34') If style is not mentioned then default value of style is 0.
SELECT CONVERT(INT,'123') AS [String to INT Convert], --using square brackets gives the liberty to write any column name
CONVERT(DATE,'1998-03-27') AS [String to Date Convert],
CreationTime,
CONVERT(DATE,CreationTime) AS [Datetime to Date Convert]
FROM Sales.Orders 

SELECT CreationTime,
CONVERT(DATE,CreationTime) AS [Datetime To Date Convert],
CONVERT(VARCHAR,CreationTime,32) AS [USA Std. Style 32],
CONVERT(VARCHAR,CreationTime,34) AS [Europe Std. Style 34]
FROM Sales.Orders

-- CAST(): Converts a value to a specific datatype
-- Syntax:CAST(value AS data_type) 
-- Eg: CAST('123' AS INT), CAST('1998-03-27 AS DATE)
SELECT CAST('123' AS INT) AS [String to INT],
CAST(123 AS VARCHAR) AS [INT TO VARCHAR],
CAST('1998-03-27' AS DATE) AS [String to Date],
CAST('1998-03-27' AS DATETIME) AS [String to Datetime],
CreationTime,
CAST(CreationTime AS DATE) AS [CreationTime to Date]
FROM Sales.Orders 

/* Dataset. Table name: events
| event_id | event_time          |
| -------- | ------------------- |
| 1        | 2024-01-15 08:30:45 |
| 2        | 2024-03-20 14:15:10 |
| 3        | 2024-07-04 19:45:00 |
| 4        | 2024-12-31 23:59:59 |

Questions
1) Display event_time in dd-MM-yyyy format.
SELECT FORMAT(event_time,'dd-MM-yyyy') AS newdate
FROM events

2) Display event_time in MM/dd/yyyy format.
SELECT FORMAT(event_time,'MM/dd/yyyy') AS newdate
FROM events

3) Display only the abbreviated month name.
SELECT FORMAT(event_time,'MMM') AS abmonthname
FROM events

4) Display only the full month name.
SELECT FORMAT(event_time,'MMMM') AS fullmonthname
FROM events

5) Display only the abbreviated day name.
SELECT FORMAT(event_time,'ddd') AS abdayname
FROM events

6) Display only the full day name.
SELECT FORMAT(event_time,'dddd') AS fulldayname
FROM events

7) Convert event_time into a DATE datatype.
SELECT CONVERT(DATE,event_time) AS [Time to Date Conversion]
FROM events

8) Convert the string '2025-08-17' into DATE.
SELECT CONVERT(DATE,'025-08-17') AS [String to Date Conversion]

9) Convert the string '456' into INT.
SELECT CONVERT(INT,'456') AS [String to INT Conversion]

10) Convert the integer 789 into VARCHAR.
SELECT CONVERT(VARHCAR,789) AS [Integer to VARCHAR Conversion]

11) Display event_time as:Jan 2024,Mar 2024,Jul 2024,Dec 2024
SELECT 'Jan'+' '+'2024'+'Mar'+' '+'2024'+'Jul'+' '+'2024'+'Dec'+' '+2024
I mean ik I am wrong, just attempted it.

12) Count events by:Month-Year
SELECT FORMAT(event_time,'MM-yyyy') AS monthyearevents, COUNT(*) AS noofevents
FROM events
GROUP BY FORMAT(event_time,'MM-yyyy')

13) Display: Monday January 2024
SELECT 'Monday'+' '+'January'+' '+'2024'
how do I style it? I have to use convert() whoch kinda seems unnecesary.

14) Show event times formatted in: yyyy-MM-dd
SELECT event_id,FORMAT(event_times,'yyyy-MM-dd') AS yearfirst
FROM events

15) Return both: Original event_time and Converted DATE
SELECT FORMAT(event_time,'yyyy hh:ss:tt') AS CutomFormat, CONVERT(DATE,event_time) AS [Time to Date Conversion]
FROM events */

----------------------------------------------------------------------------------------------------------------------
--Date Calculations
--DATEADD(): Adds respective days, months, years to the original date.

/* SYNTAX: DATEADD(part,interval,date). Part means which part on the date the addition must take place(day,month or year)
interval means how much addition/changes must be made (eg:+2,+4,etc), date means on which date the operation is to be done.
eg: DATEADD(year,2,OrderDate) and DATEADD(year,-4,OrderDate) */

SELECT OrderID,OrderDate,
DATEADD(year,2,OrderDate) AS TwoYearsLater,
DATEADD(month,3,OrderDate) AS TwoMonthsLater,
DATEADD(day,-10,OrderDate) AS TenDaysPrior
FROM Sales.Orders 

--DATEDIFF(): Finds the difference between two dates
/* Syntax: DATEDIFF(part,start_date,end_date) where Part means which part on the date the addition must take 
place(day,month or year),start_date means orderdate and end_date is shipping date (like 2025-2026) 

EG: DATEDIFF(year, OrderDate,ShippedDate) OR DATEDIFF(day, OrderDate,ShippedDate)    */

--Task: Calculate the age of employees 
SELECT EmployeeID,FirstName,LastName,Department,BirthDate,Gender,Salary,
DATEDIFF(year,BirthDate,GETDATE()) AS Age
FROM Sales.Employees

--Task: Find the Average shipping duration in days for each month
SELECT MONTH(OrderDate),AVG(DATEDIFF(day,OrderDate,ShipDate)) AS ShippingDuration
FROM Sales.Orders
--WHERE OrderStatus = 'Shipped'
GROUP BY MONTH(OrderDate)

-- Time Gap Analysis
--Task: Find the number of days between each order and previous order
SELECT OrderID,
OrderDate AS CurrentOrderDate,
LAG(OrderDate) OVER (ORDER BY OrderDate) PreviousOrderDate,
DATEDIFF(day,LAG(OrderDate) OVER (ORDER BY OrderDate),OrderDate) AS noofdays
FROM Sales.Orders 

-- ISDATE(): Check if a value is a date. This returns 1 if the string value is a valid date.
-- Syntax: ISDATE(value). Eg: ISDATE('1998-03-27') OR ISDATE(2025)
SELECT ISDATE('123')
SELECT ISDATE(2025)
SELECT ISDATE('1998-03-27')
SELECT ISDATE('27-03-1998') AS DateCheck -- Returns 0 even if it is date because this time is not in standard time as per SQL.
SELECT ISDATE('2025')
SELECT ISDATE('08') -- We think we gave month, but SQL does not accept this.

-- TASK 18: Validate OrderDate using ISDATE and convert valid dates.

SELECT
    OrderDate,
    ISDATE(OrderDate) AS IsValidDate,
    CASE 
        WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
        ELSE '9999-01-01'
    END AS NewOrderDate
FROM (
    SELECT '2025-08-20' AS OrderDate UNION
    SELECT '2025-08-21' UNION
    SELECT '2025-08-23' UNION
    SELECT '2025-08'
) AS t
-- WHERE ISDATE(OrderDate) = 0

/* Dataset: Employees
| emp_id | hire_date  |
| ------ | ---------- |
| 1      | 2020-01-15 |
| 2      | 2021-06-10 |
| 3      | 2022-03-25 |
| 4      | 2023-11-01 |

Questions
1) Add 30 days to every hire date.
SELECT emp_id,hire_date,DATEADD(day,30,hire_date) AS newdate
FROM Employees

2) Add 2 years to every hire date.
SELECT emp_id,hire_date,DATEADD(year,2,hire_date) AS newdate
FROM Employees

3) Add 6 months to every hire date.
SELECT emp_id,hire_date,DATEADD(month,6,hire_date) AS newdate
FROM Employees

4) Find the number of days between:2024-01-01 and 2024-01-31
SELECT emp_id,hire_date,DATEDIFF(day,2024-01-01,2024-01-31) AS newdate
FROM Employees
Umm idk if those dates must be in '' cause then that would be string. idk

5) Find the number of months between:2023-01-01 and 2024-01-01
SELECT emp_id,hire_date,DATEDIFF(month,2023-01-01,2024-01-01) AS newdate
FROM Employees

6) Find the number of years between:2015-05-10 and 2025-05-10
SELECT emp_id,hire_date,DATEDIFF(year,2015-05-10,2025-05-10) AS newdate
FROM Employees

7) For each employee, calculate the number of years between hire_date and today.
SELECT emp_id,hire_date,DATEDIFF(year,hire_date,GETDATE()) AS newdate
FROM Employees

8) For each employee, calculate the number of months between hire_date and today.
SELECT emp_id,hire_date,DATEDIFF(month,hire_date,GETDATE()) AS newdate
FROM Employees

9) Check whether: '2025-08-17' is a valid date.
SELECT ISDATE('2025-08-17')
Will return 1 since it is a date and the format is accepted by SQL

10) Check whether: '2025-13-17' is a valid date.
SELECT ISDATE('2025-13-17')
Will return 0 since it is not a valid date

11) Check whether: 'abc' is a valid date.
SELECT ISDATE('abc')
Will return 0 since it is not a valid date

12) Display: hire_date,hire_date + 100 days for every employee.
SELECT hire_date,DATEADD(day,100,hire_date) AS newdate
FROM Employees

13) Display: hire_date, hire_date + 1 year, hire_date + 1 month for every employee.
SELECT hire_date,
DATEADD(year,1,hire_date) AS newhireyear,
DATEADD(month,1,hire_date) AS newhiremonth,
FROM Employees

14) Which employees were hired more than 3 years ago?
SELECT hire_date, DATEDIFF(year,hire_date,GETDATE()) AS hiredifference
FROM Employees
WHERE DATEDIFF(year,hire_date,GETTODAY()) > 3

15) For each employee display: hire_date,days employed using today's date.
SELECT hire_date,DATEDIFF(day,hire_date,GETDATE()) AS days_employed
FROM Employees */