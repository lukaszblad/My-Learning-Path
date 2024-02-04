--Question 7

USE AdventureWorks2019;

--a. Write a script that you can use to find every column in the database that includes "rate" in the column name.

SELECT * FROM sys.columns
WHERE name LIKE '%rate%';

--b. Write a script that you can use to find every table in the database that includes "History" in the table name.

SELECT * FROM sys.tables
WHERE name LIKE '%History%';