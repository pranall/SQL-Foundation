/* Set 1 (Questions 1–25): Recognize One Pattern

Q1) Find all employees whose salary is greater than 80,000.
	1. What is the question asking? only the mplyess whose salary is above 80k
	2. What should the output look like? emp_name, salary
	3. Which SQL concepts are involved? comparison operator (greater than)
	4. Which concept is the primary one? comparison operator (greater than)

Q2) List customers ordered alphabetically by last name.
	1. What is the question asking? sorting the data alphabetically by last name
	2. What should the output look like? customer_last_name 
	3. Which SQL concepts are involved? ORDER BY ASC
	4. Which concept is the primary one? ORDER BY ASC

Q3) Show employees who do not have a department assigned.
	1. What is the question asking? employees with no department
	2. What should the output look like? emp_name,dept
	3. Which SQL concepts are involved? IS NULL
	4. Which concept is the primary one? IS NULL

Q4) Replace all NULL salaries with 0.
	1. What is the question asking? replacing NULL salaries with 0
	2. What should the output look like? salary (if NULL then replace it with 0)
	3. Which SQL concepts are involved? COALECSCE
	4. Which concept is the primary one? COALECSCE

Q5) Replace all blank department names with NULL.
	1. What is the question asking? replace blank, unknown department names with NULL
	2. What should the output look like? dept (if dept has no value then NULL)
	3. Which SQL concepts are involved? NULL
	4. Which concept is the primary one? NULL

Q6) Find the total number of employees.
	1. What is the question asking? total number of employees's count
	2. What should the output look like? emp_id (with count)
	3. Which SQL concepts are involved? COUNT()
	4. Which concept is the primary one? COUNT(column_name)

Q7) Find the average salary.
	1. What is the question asking? average salary
	2. What should the output look like? salary and average_salary
	3. Which SQL concepts are involved? Function AVG
	4. Which concept is the primary one? AVG()

Q8) Find the highest salary.
	1. What is the question asking? Highest Salary of the table
	2. What should the output look like? salary, highest_salary
	3. Which SQL concepts are involved? MAX()
	4. Which concept is the primary one? MAX()

Q9) Find the lowest salary.
	1. What is the question asking? lowest salary of the table
	2. What should the output look like? salary, lowest_salary
	3. Which SQL concepts are involved? MIN()
	4. Which concept is the primary one? MIN()

Q10) Count employees in each department.
	1. What is the question asking? number of employees in each department 
	2. What should the output look like? dept, emp_id, number_of_employees_per_department
	3. Which SQL concepts are involved? GROUP BY 
	4. Which concept is the primary one? GROUP BY

Q11) Find departments having more than 20 employees.
	1. What is the question asking? list of departments having 20 employees in each 
	2. What should the output look like? dept, dept with 20 employees
	3. Which SQL concepts are involved? GROUP BY, HAVING
	4. Which concept is the primary one? GROUP BY

Q12) Display FullName by combining FirstName and LastName.
	1. What is the question asking? combine First and Last name
	2. What should the output look like? FullName
	3. Which SQL concepts are involved? CONCAT
	4. Which concept is the primary one? CONCAT

Q13) Find employees hired after 2022.
	1. What is the question asking? employees hired after 2022
	2. What should the output look like? displaying employees after 2022
	3. Which SQL concepts are involved? WHERE 
	4. Which concept is the primary one? WHERE

Q14) Display employee names in uppercase.
	1. What is the question asking? convert the employee names to uppercase
	2. What should the output look like? Mike should be MIKE
	3. Which SQL concepts are involved? UPPER()
	4. Which concept is the primary one? UPPER()

Q15) Show distinct countries.
	1. What is the question asking? List of distinct countries
	2. What should the output look like? India may appear multiple times in a table. India must appear only once
	3. Which SQL concepts are involved? DISTINCT
	4. Which concept is the primary one? DISTINCT

Q16) Assign employees into High, Medium and Low salary categories.
	1. What is the question asking? classification of employees into salary categories
	2. What should the output look like? given a number, comparison must be done and classified the salary into high, medium and low.
	3. Which SQL concepts are involved? CASE, comparison operators
	4. Which concept is the primary one? CASE

Q17) Find duplicate email addresses.
	1. What is the question asking? Finding duplicate email addresses
	2. What should the output look like?
	3. Which SQL concepts are involved? ROW_NUMBER(), subquery
	4. Which concept is the primary one? ROW_NUMBER

Q18) Show every order together with total sales across the table.
	1. What is the question asking? display every order along with total sales of the orders across table
	2. What should the output look like? orders, SUM(orders)
	3. Which SQL concepts are involved? Window function, SUM(), PARTITION BY 
	4. Which concept is the primary one? Window function, PARTITION BY 

Q19) Show every order together with total sales of its customer. same as question 18th

Q20) Show every employee together with average department salary.
	1. What is the question asking? display every employee with the average salary of the dept salary
	2. What should the output look like? emp_salary, average_dept_salary
	3. Which SQL concepts are involved? Window function, AVG(), PARTITION BY 
	4. Which concept is the primary one? Window function, AVG(), PARTITION BY 

Q21) Rank employees by salary.
	1. What is the question asking? assign ranks to employees based on the salary
	2. What should the output look like? 
	3. Which SQL concepts are involved? DENSE_RANK() because it can handle ties(two employees may have same salary) and it does not leave gaps
	4. Which concept is the primary one? DENSE_RANK()

Q22) Give every employee a unique rank by salary.
	1. What is the question asking? assigning unique ranks based on salary
	2. What should the output look like?
	3. Which SQL concepts are involved? ROW_NUMBER()
	4. Which concept is the primary one? ROW_NUMBER()

Q23) Show previous month's sales beside current month's sales.
	1. What is the question asking? display previous month's sales beside current month's sales
	2. What should the output look like? prev_month_sales, current_month_sales
	3. Which SQL concepts are involved? LEAD(), LAG()
	4. Which concept is the primary one? LEAD(), LAG()

Q24) Show next order date for every customer.
	1. What is the question asking? next order date for every customer
	2. What should the output look like? order_date, next_order_date
	3. Which SQL concepts are involved? I am not quite sure but date function and window function needs to be used
	4. Which concept is the primary one? date function

Q25) Show highest salary within each department beside every employee.
	1. What is the question asking? highest salary within each dept of emp
	2. What should the output look like? emp_salary, highest_salary_per_dept
	3. Which SQL concepts are involved? MAX(), window function, PARTITION BY
	4. Which concept is the primary one? MAX(), window function, PARTITION BY