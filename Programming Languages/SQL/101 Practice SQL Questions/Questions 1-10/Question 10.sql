--Question 10

USE AdventureWorks2019;

--a. Write a script that will give you the TableName, ColumnName and each value (definition) where class = 1

SELECT
    p.class AS class,
    t.name AS table_name,
    c.name AS column_name,
    p.value AS definition
FROM sys.extended_properties p
JOIN sys.tables t
    ON p.major_id = t.object_id
JOIN sys.columns c
    ON p.minor_id = c.column_id
    AND p.major_id = c.object_id
WHERE p.class = 1;

--b. What is the find the value (definition) for every Column in the Person table

SELECT
    p.class AS class,
    t.name AS table_name,
    c.name AS column_name,
    p.value AS definition
FROM sys.extended_properties p
JOIN sys.tables t
    ON p.major_id = t.object_id
JOIN sys.columns c
    ON p.minor_id = c.column_id
    AND p.major_id = c.object_id
WHERE p.class = 1
AND t.name = 'TransactionHistory';