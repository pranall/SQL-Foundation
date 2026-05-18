-- CREATE table
CREATE TABLE persons (
id INT NOT NULL,
person_name VARCHAR (50) NOT NULL,
birth_date DATE,
phone VARCHAR (15) NOT NULL,
CONSTRAINT pk_persons PRIMARY KEY (id)
)

SELECT * 
FROM persons

-- ALTER table
ALTER TABLE persons 
ADD email VARCHAR (50) NOT NULL

SELECT * 
FROM persons

-- Remove the column phone from the persons table
ALTER TABLE persons
DROP COLUMN phone 

SELECT *
FROM persons 

-- DROP 
-- Delete the table persons from the database
DROP TABLE persons 