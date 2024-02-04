--Question 17

USE AdventureWorks2019;

--a. Sum the LineTotal in SalesOrderDetail. Format as currency

SELECT
    FORMAT(SUM(LineTotal), 'c', 'en-US') AS Total
FROM Sales.SalesOrderDetail;

--b. Sum the LineTotal in SalesOrderDetail by the MakeFlag in the product table. Use a case statement to specify manufactured vs. purchased. Format as currency.

SELECT
    CASE
        WHEN MakeFlag = 0 THEN 'Purchased'
        ELSE 'Manufactured'
    END AS MakeFlag,
    FORMAT(SUM(LineTotal), 'c', 'en-US') AS Total
FROM Sales.SalesOrderDetail o
JOIN Production.Product p
    ON o.ProductID = p.ProductID
GROUP BY MakeFlag;

--c. Add a count of distinct SalesOrderIDs

SELECT
    CASE
        WHEN MakeFlag = 0 THEN 'Purchased'
        ELSE 'Manufactured'
    END AS MakeFlag,
    FORMAT(SUM(LineTotal), 'c', 'en-US') AS Total,
    FORMAT(COUNT(DISTINCT SalesOrderID), '#,#') AS CountDistinctOrders
FROM Sales.SalesOrderDetail o
JOIN Production.Product p
    ON o.ProductID = p.ProductID
GROUP BY MakeFlag;

--d. What is the average LineTotal per SalesOrderID?

SELECT
    CASE
        WHEN MakeFlag = 0 THEN 'Purchased'
        ELSE 'Manufactured'
    END AS MakeFlag,
    FORMAT(SUM(LineTotal), 'c', 'en-US') AS Total,
    FORMAT(COUNT(DISTINCT SalesOrderID), '#,#') AS CountDistinctOrders,
    FORMAT(SUM(LineTotal)/COUNT(DISTINCT o.SalesOrderID), 'c', 'en-US') AS AvgLineTotal
FROM Sales.SalesOrderDetail o
JOIN Production.Product p
    ON o.ProductID = p.ProductID
GROUP BY MakeFlag;