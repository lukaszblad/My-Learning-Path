--Question 19

USE AdventureWorks2019;

--Find the first and last order date in SalesOrderHeader Table and format as a date.

SELECT
    CAST(MIN(OrderDate) AS DATE) AS FirstOrderDate,
    CAST(MAX(OrderDate) AS DATE) AS LastOrderDate
FROM Sales.SalesOrderHeader;