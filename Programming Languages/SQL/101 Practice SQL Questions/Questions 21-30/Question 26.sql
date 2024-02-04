--Question 26

USE AdventureWorks2019;

--a. find model indetifier
SELECT
    Name,
    ProductModelID
FROM Production.Product
WHERE ProductModelID = 19;

--b. special offers on these bikes
SELECT 
	so.StartDate,
	so.EndDate,
	so.Type,
	so.Category,
	so.Description,
	so.DiscountPct,
	Count(DISTINCT p.name) AS CNT
FROM Production.Product p
	JOIN Sales.SpecialOfferProduct sop ON sop.ProductID = p.ProductID
	JOIN Sales.SpecialOffer so ON so.SpecialOfferID = sop.SpecialOfferID
WHERE ProductModelID = 19
GROUP BY
	so.StartDate,
	so.EndDate,
	so.Type,
	so.Category,
	so.Description,
	so.DiscountPct;


--c. most recent special offer
SELECT
    SellStartDate,
    SellEndDate,
    DiscontinuedDate
FROM Production.Product
WHERE ProductModelID  = 19;

