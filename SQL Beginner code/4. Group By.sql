-- GROUP BY

SELECT * 
FROM parks_and_recreation.employee_demographics;

SELECT gender
FROM parks_and_recreation.employee_demographics
GROUP BY gender
;

SELECT first_name
FROM parks_and_recreation.employee_demographics
GROUP BY gender
;

SELECT gender
FROM parks_and_recreation.employee_demographics
GROUP BY gender
;

SELECT gender, AVG(age)
FROM parks_and_recreation.employee_demographics
GROUP BY gender
;

SELECT occupation
FROM parks_and_recreation.employee_salary
GROUP BY occupation
;

SELECT occupation, salary
FROM parks_and_recreation.employee_salary
GROUP BY occupation, salary
;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM parks_and_recreation.employee_demographics
GROUP BY gender
;

-- ORDER BY

SELECT * 
FROM parks_and_recreation.employee_demographics
ORDER BY first_name ASC
;

SELECT * 
FROM parks_and_recreation.employee_demographics
ORDER BY first_name DESC
;

SELECT * 
FROM parks_and_recreation.employee_demographics
ORDER BY gender
;

SELECT * 
FROM parks_and_recreation.employee_demographics
ORDER BY gender, age
;

SELECT * 
FROM parks_and_recreation.employee_demographics
ORDER BY gender, age DESC
;

SELECT * 
FROM parks_and_recreation.employee_demographics
ORDER BY age, gender DESC
;

SELECT * 
FROM parks_and_recreation.employee_demographics
ORDER BY 4, 5 DESC -- not a best practice
;