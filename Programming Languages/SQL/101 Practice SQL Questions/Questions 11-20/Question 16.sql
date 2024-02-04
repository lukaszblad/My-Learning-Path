--Question 16

USE AdventureWorks2019;

--a. How many products are sold by AdventureWorks?

SELECT
    COUNT(ProductID) AS ProductsCount
FROM Production.Product
WHERE FinishedGoodsFlag = 1;

--b. How many of these products are actively being sold by AdventureWorks?

SELECT
    COUNT(*) AS ActiveProducts
FROM Production.Product
WHERE 
    SellEndDate IS NULL
    AND FinishedGoodsFlag = 1;

--c. How many of these active products are made in house vs. purchased?

SELECT
    CASE
        WHEN MakeFlag = 0 THEN 'Product is Purchased'
        ELSE 'Product is manufactured inhouse'
    END AS Make,
    COUNT(*) AS ProductsCount
FROM Production.Product
WHERE 
    SellEndDate IS NULL
    AND FinishedGoodsFlag = 1
GROUP BY 
    CASE
        WHEN MakeFlag = 0 THEN 'Product is Purchased'
        ELSE 'Product is manufactured inhouse'
    END;