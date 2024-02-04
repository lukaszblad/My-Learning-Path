--Question 23

USE AdventureWorks2019;

--Select the percentage of customers from each Country, using a variable

DECLARE @TotalRetailCustomers FLOAT = 
    (SELECT
        COUNT(DISTINCT p.BusinessEntityID) AS CustomerCount
    FROM Person.Person p
    WHERE PersonType = 'IN');

SELECT 
    cr.Name AS Country,
    FORMAT(
        CAST(COUNT(DISTINCT p.BusinessEntityID) AS FLOAT)
        /
        @TotalRetailCustomers,
        'P') AS '%ofTotal'
FROM Person.Person p
    JOIN Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID
    JOIN Person.Address a ON bea.AddressID = a.AddressID
    JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
    JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE p.PersonType = 'IN'
GROUP BY cr.Name
ORDER BY '%ofTotal' DESC;