-- String Functions are of three types: manipulation, calculation, string extraction.
-- Manipulation String Functions:
-- 1) Concat: Combines multiple strings into one. 
--Task: Show a list of customer's first names together with their country in one column
SELECT first_name,country, CONCAT(first_name,country) AS nameandcountry
FROM customers 

--NOTE: in the above code the results look merged hence aesthetically, the below code is better
SELECT first_name,country, CONCAT(first_name,' ',country) AS nameandcountry
FROM customers 

-- UPPER function: Converts all the characters to UPPER CASE
-- LOWER function: Converts all the characters to LOWEE CASE
-- Task: Convert the first name to LOWER CASE
SELECT id,LOWER(first_name) AS lowerfirstname, country, score
FROM customers 
-- Task: Convert the first name to UPPER CASE
SELECT id,UPPER(first_name) AS lowerfirstname, country, score
FROM customers 

-- TRIM function: Removes leading and trailing spaces.
-- Task: Find customers whose first name contains leading and trailing spaces
-- Long Method: This is to determine whether or not the strings contains any leading or trailing spaces. 
SELECT first_name, LEN(first_name) AS namelength, LEN(TRIM(first_name)) AS trimmedlength,
LEN(first_name) - LEN(TRIM(first_name)) AS new
FROM customers 
WHERE LEN(first_name) != LEN(TRIM(first_name))

-- Short Method
SELECT id,TRIM(first_name),country, score 
FROM customers 
WHERE first_name != TRIM(first_name)

-- REPLACE Function: Replaces specific character with a new character
-- Task: Remove dashes (-) from the contact numbers 
SELECT '123-456-789' AS phone, REPLACE('123-456-789','-','') AS newphone
-- Task: Replace dashes (-) to (/) from the contact numbers 
SELECT '123-456-789' AS phone, REPLACE('123-456-789','-','/') AS newphone

-- Replace file extension from txt to csv
SELECT 'file1.txt' AS originalfile, REPLACE('file1.txt','.txt','.csv') AS newfile

-- Sting Function (Calculation)
-- LEN Function: Calculates the length of the string. Counts how many characters in a string.
/* Theory: LEN(Maria) returns 5, LEN(350) returns 3, LEN(2026-01-01) returns 10. LEN() counts the underscores and dashes as 
separate numbers */
/* Task: Calculate the length of each customer's first name. TRIM is used because John is 4 letter name and gave 5 after LEN
due to a trailing space */
SELECT id, first_name,LEN(TRIM(first_name)) AS firstnamelength, country, score 
FROM customers 

-- Type 3: String Extraction 
-- LEFT Function: Extracts specific number of characters from the 'start' of the string. SYNTAX: LEFT(Value,no.of characters)
-- RIGHT Function: Extracts specific number of characters from the 'end' of the string. SYNTAX: RIGHT(Value,no.of characters)
-- Task: Retrieve the first two characters of the first name.
SELECT id, first_name, LEFT(first_name, 2) AS leftname, country,score 
FROM customers 
-- Retrieve the first two characters of the first name after trimming the leading space from John
SELECT id, first_name, LEFT(TRIM(first_name),2) AS leftname, country,score 
FROM customers 

-- Task: Retrieve the last two characters of the first name.
SELECT id, first_name, RIGHT(first_name,2) AS rightname, country,score 
FROM customers 

--SUBSTRING Function: Extracts a part of the string at the specified position. SYNTAX: SUBSTRING(Value, Start, Length)
--Task: Retrieve the customer's first names after removing the first character.
SELECT id, first_name, SUBSTRING(TRIM(first_name),2,LEN(first_name)) AS subname, country, score
FROM customers 

/* Employees
| emp_id | full_name         | email                                                         | phone        | department   |
| ------ | ----------------- | ------------------------------------------------------------- | ------------ | ------------ |
| 1      | " Alice Smith "   | [alice.smith@company.com](mailto:alice.smith@company.com)     | 123-456-7890 | Data Science |
| 2      | "Bob Johnson"     | [bob.johnson@company.com](mailto:bob.johnson@company.com)     | 234-567-8901 | Engineering  |
| 3      | " Charlie Brown " | [charlie.brown@company.com](mailto:charlie.brown@company.com) | 345-678-9012 | HR           |
| 4      | "David Lee"       | [david.lee@company.com](mailto:david.lee@company.com)         | 456-789-0123 | Finance      |
| 5      | "Eva Wilson"      | [eva.wilson@company.com](mailto:eva.wilson@company.com)       | 567-890-1234 | Marketing    |

CONCAT
1) Create a column: Alice Smith - Data Science using full_name and department.
SELECT emp_id, full_name, email,phone, department, CONCAT(TRIM(full_name),' - ',department) AS concatenatedcolumn
FROM employees

NOTE: if only Alice Smith - Data Science is expected then static values can be used
SELECT CONCAT(TRIM(" Alice Smith "),' - ', 'Data Science') AS concatenatedcolumn

2) Create a column: Alice Smith (alice.smith@company.com)
SELECT emp_id, full_name, email,phone, department, CONCAT(TRIM(full_name),' ','(',email,')') AS newcolumn
FROM employees

NOTE: if only Alice Smith - Data Science is expected then static values can be used
SELECT emp_id, full_name, email,phone, department, CONCAT(TRIM(" Alice Smith "),' ','(',alice.smith@company.com,')') AS newcolumn
FROM employees

3) Create a username format:AliceSmith_DS using full_name and department.
SELECT emp_id, full_name, email,phone, department,CONCAT(TRIM(" Alice Smith "),'_','DS')

UPPER / LOWER
4) Convert all employee emails to uppercase.
SELECT emp_id, full_name, email,phone, department,UPPER(email) AS upperemail
FROM employees

5) Convert all department names to lowercase.
SELECT emp_id, full_name, email,phone, department,LOWER(department) AS lowerdepartment
FROM employees

6) Display: ALICE SMITH, BOB JOHNSON ...
SELECT emp_id, full_name, email,phone, department,UPPER(TRIM(full_name)) AS uppername
FROM employees

TRIM
7) Find employees whose names contain leading/trailing spaces.
SELECT emp_id, full_name, email,phone, department,TRIM(full_name) AS uppername
FROM employees
WHERE LEN(TRIM(full_name)) != LEN(full_name)

8) Display original name and cleaned name.
SELECT full_name,TRIM(full_name) AS uppername
FROM employees

9) Calculate how many spaces were removed from each name.
SELECT first_name, LEN(first_name) AS namelength, LEN(TRIM(first_name)) AS trimmedlength,
LEN(first_name) - LEN(TRIM(first_name)) AS new
FROM employees
WHERE LEN(first_name) != LEN(TRIM(first_name))

REPLACE
10) Remove dashes from phone numbers. Expected: 1234567890
SELECT emp_id, full_name, email,phone, department, REPLACE(phone,'-','')
FROM employees

11) Replace: @company.com with @gmail.com
SELECT emp_id, full_name, email,phone, department, REPLACE(email,'@company.com','@gmail.com')
FROM employees 

12) Replace spaces in names with underscores. Expected: Alice_Smith
SELECT emp_id, full_name, email,phone, department, REPLACE(full_name,' ','_')
FROM employees 

LEN
13) Find the length of each employee's name after trimming.
SELECT emp_id, full_name, email,phone, department, LEN(full_name) AS fullnamelength, LEN(TRIM(full_name)) AS trimmednamelength
FROM employees 

14) Find employees whose name length exceeds 10 characters.
SELECT emp_id, full_name, email,phone, department, LEN(full_name) AS fullnamelength, LEN(TRIM(full_name)) AS trimmednamelength
FROM employees
WHERE LEN(TRIM(full_name)) > 10

15 Display: name, length, department
SELECT full_name, department, LEN(full_name) AS fullnamelength, LEN(TRIM(full_name)) AS trimmednamelength
FROM employees

LEFT
16) Extract the first 3 characters of each employee name.
SELECT emp_id, full_name, email, phone, department, LEFT(full_name,3) AS leftname
FROM employees

17) Extract the first letter of each department. Expected:D,E,H,F,
SELECT emp_id, full_name, email, phone, department, LEFT(department,1) AS leftname
FROM employees

18) Create employee initials using LEFT. Example: A,B,C
SELECT emp_id, full_name, email, phone, department, LEFT(full_name,1) AS leftname
FROM employees

RIGHT
19) Extract the last 4 digits of phone numbers. Expected: 7890, 8901, 9012...
SELECT emp_id, full_name, email, phone, department, RIGHT(phone,4) AS phonenumber
FROM employees

20) Extract the last 3 characters of each department.
SELECT emp_id, full_name, email, phone, department, RIGHT(department,3) AS dept
FROM employees

21) Extract the last letter of each employee name.
SELECT emp_id, full_name, email, phone, department, RIGHT(TRIM(full_name),1) AS empname
FROM employees

SUBSTRING
22) Remove the first character from every employee name.
SELECT emp_id, full_name, email, phone, department, SUBSTRING(TRIM(full_name),1,LEN(full_name) AS empname
FROM employees

23) Extract: smith, johnson, brown from emails. Hint: alice.smith@company.com
did reserach and it is not possible to extract it only using substring. CHARINDEX is required as well and I have no clue about that

24) Extract the first name from full_name using SUBSTRING. Expected: Alice, Bob, Charlie...
I think this might need CHARINDEX as well

Mixed Questions (Most Useful)
25) Create employee initials: AS, BJ, CB, DL, EW

26) Convert: Alice Smith into: alice_smith
SELECT emp_id, full_name, email, phone, department, LOWER(TRIM(REPLACE(full_name),' ','-')
FROM employees

27) Convert: alice.smith@company.com into: ALICE.SMITH (no domain).
SELECT emp_id, full_name, email, phone, department, UPPER(TRIM(REPLACE(email),'@company.com','')
FROM employees

28) Create: EMP-001, EMP-002, EMP-003 from emp_id.
SELECT emp_id, full_name, email, phone, department, UPPER(REPLACE(emp_id),emp_id,'EMP-000+1')
FROM employees
I tried duh...

29) Find employees whose cleaned names start with 'A'.
SELECT emp_id, full_name, email, phone, department,TRIM(full_name) AS trimmedname
FROM employees
WHERE LEFT(TRIM(full_name),1) = 'A'

30) Find employees whose email username contains more than 10 characters.
SELECT emp_id, full_name, email, phone, department,LEN(REPLACE(email),'@company.com','') AS newemail
FROM employees
WHERE LEN(REPLACE(email),'@company.com','') >10 */

