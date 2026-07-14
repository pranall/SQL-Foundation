-- ROUND function: Rounds up the decimal numbers to the value mentioned. 
SELECT 3.516 AS number,
ROUND(3.516,2) AS roundedvalue2,
ROUND(3.516,1) AS roundedvalue1,
ROUND(3.516,0) AS roundedvalue0

-- ABS (absolute) Function: Converts negtive number to positive. If the number is already positive, the value remains the same
SELECT -10 AS number,
ABS(-10),
ABS(20)

SELECT ROUND(15.6789,2)

SELECT ABS(-15) + ROUND(3.456,1)