--Question 25

USE AdventureWorks2019;


--Which product has the best margins
SELECT
    p.Name,
    FORMAT((p.ListPrice - p.StandardCost), 'C0') AS Margin
FROM Production.Product p
ORDER BY (p.ListPrice - p.StandardCost) DESC;