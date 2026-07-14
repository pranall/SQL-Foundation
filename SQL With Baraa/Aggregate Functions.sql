/* Aggregate Functions
Suppose this is the data: Sales|35,15,20,10
1) COUNT: Counts the number of rows. 
Syntax: COUNT(..). In this case Count(*) = 4 since there are 4 rows

2) SUM: Adds all the values in the coulumn
Syntax: SUM(). in this case SUM(Sales) calculates 35+15+20+10= 80

3) AVG: Calculates the average of all the rows
Syntax: AVG(). In this case, AVG(Sales) calculates 35+15+20+10/4 =20

4) MIN: Returns the smallest value from the rows
Syntax: MIN(). In this case, MIN() returns 10

5) MAX: Returns the largest value from the rows
Syntax: MAX(). In this case, MAX() returns 35 */

--Task: 
SELECT COUNT(*) AS Total_Orders, 
SUM(sales) AS total_sales,
AVG(sales) AS avg_sales,
MAX(sales) AS highest_sales,
MIN(sales) AS lowest_sales
FROM orders 

--Using GROUP BY: 
SELECT customer_id,
COUNT(*) AS Total_Orders, 
SUM(sales) AS total_sales,
AVG(sales) AS avg_sales,
MAX(sales) AS highest_sales,
MIN(sales) AS lowest_sales
FROM orders 
GROUP BY customer_id

--Task: Analyze the scores in the customers table
SELECT id,
COUNT(*) AS Total_Score, 
SUM(score) AS total_score,
AVG(score) AS avg_score,
MAX(score) AS highest_score,
MIN(score) AS lowest_score
FROM customers 
GROUP BY id