CREATE TABLE students (
	student_id INT PRIMARY KEY NOT NULL,
	student_name VARCHAR (50) NOT NULL,
	country VARCHAR (50) NOT NULL,
	age INT,
	GPA DECIMAL (3,2)
)

CREATE TABLE courses (
	course_id INT PRIMARY KEY NOT NULL,
	course_name VARCHAR (50),
	credits INT
)

CREATE TABLE enrollments (
	enroll_id INT PRIMARY KEY NOT NULL,
	student_id INT,
	course_id INT,
	score INT,
	enroll_date DATE
)

SELECT * 
FROM students 

SELECT * 
FROM courses 

SELECT *
FROM enrollments 

INSERT INTO students VALUES
(1, 'Aarav','India',21,8.5),
(2,'Liam','USA',22,7.2),
(3,'Noah','Canada',20,9.1),
(4,'Emma','UK',23,6.),
(5,'Olivia','India',21, NULL)

INSERT INTO courses VALUES
(101,'Math',4),
(102,'Physics',3),
(103,'CS',5)

INSERT INTO enrollments VALUES
(1,1,101,85,'2024-01-01'),
(2,2,102,70,'2024-02-01'),
(3,3,103,95,'2024-03-01'),
(4,1,103,88,'2024-02-15'),
(5,5,101,NULL,'2024-04-01');

SELECT * 
FROM students 

SELECT * 
FROM courses 

SELECT *
FROM enrollments 

-- Practice Questions
-- 1. Basic SELECT
-- Retrieve all columns from students.
SELECT *
FROM students 

-- Retrieve only name, country, and gpa.
SELECT student_name,country,GPA 
FROM students 

-- Retrieve students where gpa is NULL.
SELECT *
FROM students 
WHERE GPA IS NULL

-- Retrieve students from India with age > 20.
SELECT *
FROM students 
WHERE country = 'India' AND age > 20

---------------------------------------------------------------------

-- 2. WHERE + Conditions
-- Find students with GPA between 7 and 9.
SELECT *
FROM students 
WHERE GPA BETWEEN 7 AND 9

-- Retrieve students not from India.
SELECT *
FROM students 
WHERE country != 'India'

-- Get enrollments where score is not NULL.
SELECT *
FROM enrollments 
WHERE score IS NOT NULL

-- Find students whose name starts with 'A'.
SELECT *
FROM students 
WHERE student_name LIKE 'A%'