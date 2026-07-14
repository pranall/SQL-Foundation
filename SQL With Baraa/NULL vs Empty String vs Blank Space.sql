-- NULL vs Empty String vs Blank Space
/* NULL: Means nothing, unknown
Empty String: String value which has zero characters 
Blank Space: String value has one or more space characters. In SQL, space is considered data as well */

WITH Orders AS (
SELECT 1 Id,'A' Category UNION
SELECT 2, NULL UNION 
SELECT 3, '' UNION 
SELECT 4, '  '
)
SELECT *, DATALENGTH(Category) AS CategoryLen
FROM Orders

/*

| Attribute      | NULL                    | Empty String        | Blank Space                                |
| -------------- | ----------------------- | ------------------- | ------------------------------------------ |
| Representation | `NULL`                  | `''`                | `' '`                                      |
| Meaning        | Unknown / Missing Value | Known Empty Value   | Known Space Value                          |
| Data Type      | Special Marker          | String (Length = 0) | String (Length = 1 or more)                |
| Storage        | Very Minimal            | Occupies Memory     | Occupies Memory (for each space character) |
| Performance    | Best                    | Fast                | Slowest                                    |
| Comparison     | `IS NULL`               | `= ''`              | `= ' '`                                    | 

Mental Model

| Value  | Interpretation                                    |
| ------ | ------------------------------------------------- |
| `NULL` | "I don't know the value."                         |
| `''`   | "I know the value. It is empty."                  |
| `' '`  | "I know the value. It contains space characters." | 

Data Policies in order to eliminate bad quality data cause it affects decisions
1) Only use NULLs and empty strings but avoid blank spaces.
TRIM() is extremely useful to eliminate blank spaces */

;WITH Orders AS (
SELECT 1 Id,'A' Category UNION
SELECT 2, NULL UNION 
SELECT 3, '' UNION 
SELECT 4, '  '
)
SELECT *, 
DATALENGTH(Category) AS CategoryLen,
DATALENGTH(TRIM(Category)) AS Policy1 -- to confirm that blank spaces are actually trimmed
FROM Orders

--Data Policy 2: Only use NULLs and avoid using blank spaces and empty strings
;WITH Orders AS (
SELECT 1 Id,'A' Category UNION
SELECT 2, NULL UNION 
SELECT 3, '' UNION 
SELECT 4, '  '
)
SELECT *, 
TRIM(Category) AS Policy1,
NULLIF(TRIM(Category),'') AS Policy2 --Converting all the blank and empty spaces into NULL
FROM Orders

--Data Policy: Use default value 'Unknown' and avoid using NULLs, blank spaces and e,pty strings
;WITH Orders AS (
SELECT 1 Id,'A' Category UNION
SELECT 2, NULL UNION 
SELECT 3, '' UNION 
SELECT 4, '  '
)
SELECT *, 
TRIM(Category) AS Policy1,
NULLIF(TRIM(Category),'') AS Policy2, --Converting all the blank and empty spaces into NULL
COALESCE(Category ,'unknown') AS Policy3 --Converts only the NULLs which are in the table by default, not the converted ones
FROM Orders

--merge them
;WITH Orders AS (
SELECT 1 Id,'A' Category UNION
SELECT 2, NULL UNION 
SELECT 3, '' UNION 
SELECT 4, '  '
)
SELECT *, 
TRIM(Category) AS Policy1,
NULLIF(TRIM(Category),'') AS Policy2, --Converting all the blank and empty spaces into NULL
COALESCE(NULLIF(TRIM(Category),''),'unknown') AS Policy3 --Converts only the NULLs which are in the table by default, not the converted ones
FROM Orders

/* Policy 1 is the worst policy because human eye cannot determine whether the data is really a blank space or empty string. 
Policy 2: Replacing empty strings and blanks with NULL during data preparation before inserting into a database to optimize storage
and performance.
Policy 3: Replacing empty strings,blanks,NULLs with default value 'unknown' during data preparation before using it in reporting to
improve readability and reduce confusion. */