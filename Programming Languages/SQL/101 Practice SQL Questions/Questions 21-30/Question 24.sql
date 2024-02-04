--Question 24

USE AdventureWorks2019;

--In this question use SalesOrderID '69411' to determine answer.
--a. In the SalesOrderHeader what is the difference between "SubTotal" and "TotalDue"

SELECT
    FORMAT(TotalDue, 'C') AS TotalDue,
    FORMAT(SubTotal, 'C') AS SubTotal,
    FORMAT(TotalDue - SubTotal, 'C') AS Difference
FROM Sales.SalesOrderHeader
WHERE SalesOrderID = '69411';

--b. Which one of these matches the "LineTotal" in the SalesOrderDetail?

SELECT
    CAST(SUM(LineTotal) AS MONEY) AS LineTotal
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = '69411';


--c. How is TotalDue calculated in SalesOrderHeader?

SELECT
    FORMAT(SubTotal + TaxAmt + Freight, 'C') AS Sum,
    FORMAT(TotalDue, 'C') AS TotalDue
FROM Sales.SalesOrderHeader
WHERE SalesOrderID = '69411';

--d. How is LineTotal calculated in SalesOrderDetail?
--Per product subtotal. Computed as UnitPrice * (1 - UnitPriceDiscount) * OrderQty.

SELECT
    FORMAT(SUM(UnitPrice * (1-UnitPriceDiscount) * OrderQty), 'C') AS Sum,
    FORMAT(SUM(LineTotal), 'C') AS LineTotal
FROM Sales.SalesOrderDetail od
WHERE SalesOrderID = '69411';