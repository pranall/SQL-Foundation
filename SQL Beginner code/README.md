# SQL-Foundation
This repository contains basic SQL queries practiced using MySQL on the `parks_and_recreation.employee_demographics` table.

# 2. SELECT and DISTINCT

## Covered Concepts
- Selecting all columns using `SELECT *`
- Selecting specific columns
- Performing arithmetic operations in queries
- Understanding order of execution (PEMDAS)
- Using `DISTINCT` to retrieve unique values
- Applying `DISTINCT` across single and multiple columns

## Database
- MySQL
- Schema: `parks_and_recreation`
- Table: `employee_demographics`

-------------------

# 3.WHERE Clause and Filtering

## Covered Concepts
- Filtering rows using the `WHERE` clause
- Comparison operators (`=`, `!=`, `>`, `<`, `>=`, `<=`)
- Filtering by numeric, string, and date values
- Logical operators (`AND`, `OR`, `NOT`)
- Combining conditions with parentheses
- Pattern matching using `LIKE`
- Wildcards (`%` and `_`) for partial string matching

## Database
- MySQL
- Schema: `parks_and_recreation`
- Tables:
  - `employee_salary`
  - `employee_demographics`
 
--------

# 4. GROUP BY and ORDER BY

## Covered Concepts
- Grouping rows using `GROUP BY`
- Aggregation functions (`AVG`, `MAX`, `MIN`, `COUNT`)
- Grouping by single and multiple columns
- Understanding valid and invalid `GROUP BY` usage
- Sorting results using `ORDER BY`
- Ascending and descending order (`ASC`, `DESC`)
- Sorting by multiple columns
- Ordering by column position (demonstration only, not best practice)

## Database
- MySQL
- Schema: `parks_and_recreation`
- Tables:
  - `employee_demographics`
  - `employee_salary`

----

# 5. WHERE vs HAVING

## Covered Concepts
- Using `WHERE` to filter rows before grouping
- Understanding why aggregate functions cannot be used in `WHERE`
- Grouping data with `GROUP BY`
- Using `HAVING` to filter results after aggregation
- Combining `WHERE`, `GROUP BY`, and `HAVING` in a single query
- Filtering grouped salary data using aggregate conditions

## Key Takeaway
- `WHERE` filters individual rows before grouping
- `HAVING` filters grouped results after aggregation

## Database
- MySQL
- Schema: `parks_and_recreation`
- Tables:
  - `employee_demographics`
  - `employee_salary`
```


