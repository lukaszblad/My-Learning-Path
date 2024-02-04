--Question 18

USE AdventureWorks2019;

--a. In the TransactionHistory and TransactionHistoryArchive tables a "W","S", and "P" are used as Transaction types.    What do these abbreviations mean?

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
AND t.name = 'TransactionHistoryArchive ';

--b. Union TransactionHistory and TransactionHistoryArchive

SELECT
    *
FROM Production.TransactionHistoryArchive
UNION
SELECT
    *
FROM Production.TransactionHistory;

--c. Find the First and Last TransactionDate in the TransactionHistory and TransactionHistoryArchive tables. Use the union written in part b. The current data type for TransactionDate is datetime. Convert or Cast the data type to date.

SELECT
    CAST(MIN(TransactionDate) AS DATE) AS FirstDate,
    CAST(MAX(TransactionDate) AS DATE) AS LastDate
FROM (SELECT
    *
FROM Production.TransactionHistoryArchive
UNION
SELECT
    *
FROM Production.TransactionHistory) a;

--d. Find the First and Last Date for each transaction type. Use a case statement to specify the transaction types.

SELECT
    CASE
        WHEN TransactionType = 'P' THEN 'Purchase Order'
        WHEN TransactionType = 'S' THEN 'Sales Order'
        WHEN TransactionType = 'W' THEN 'Work Order'
        ELSE NULL
    END AS TransactionType,
    CAST(MIN(TransactionDate) AS DATE) AS FirstDate,
    CAST(MAX(TransactionDate) AS DATE) AS LastDate
FROM (SELECT
    *
FROM Production.TransactionHistoryArchive
UNION
SELECT
    *
FROM Production.TransactionHistory) a
GROUP BY TransactionType;