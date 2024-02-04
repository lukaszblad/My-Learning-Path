--Question 20

USE AdventureWorks2019;

--Find the First and Last order date in all the tables possible

--Purchasing
SELECT
    Status,
    CAST(MIN(OrderDate) AS DATE) AS FirstOrderDate,
    CAST(MAX(OrderDate) AS DATE) AS LastOrderDate
FROM Purchasing.PurchaseOrderHeader
GROUP BY Status
ORDER BY Status;

--Production
SELECT
    CAST(MIN(StartDate) AS DATE) AS FirstOrderDate,
    CAST(MAX(StartDate) AS DATE) AS LastOrderDate
FROM Production.WorkOrder;