--Question 22

USE AdventureWorks2019;

--a. How many individual (retail) customers exist in the person table?

SELECT
    COUNT(DISTINCT p.BusinessEntityID) AS CustomerCount
FROM Person.Person p
WHERE PersonType = 'IN';

--b. Show this breakdown by country

SELECT
    cr.Name,
    COUNT(DISTINCT p.BusinessEntityID) AS CustomerCount
FROM Person.Person p
JOIN Person.BusinessEntityAddress bea
    ON p.BusinessEntityID = bea.BusinessEntityID
JOIN Person.Address a
    ON bea.AddressID = a.AddressID
JOIN Person.StateProvince sp
    ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr
    ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE p.PersonType = 'IN'
GROUP BY cr.Name
ORDER BY CustomerCount DESC;

--c. c. What percent of total customers reside in each country. For Example,  if there are 1000 total customers and 200 live in the United States then 20% of the customers live in the United States. 

SELECT 
    cr.Name AS Country,
    FORMAT(
            CAST(COUNT(DISTINCT p.BusinessEntityID) AS FLOAT) / CAST(
                (
                    SELECT COUNT(DISTINCT BusinessEntityID)
    FROM Person.Person
    WHERE PersonType = 'IN'
                ) AS FLOAT
            ),
            'P'
        ) AS CustomerPercentage
FROM Person.Person p
    JOIN Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID
    JOIN Person.Address a ON bea.AddressID = a.AddressID
    JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
    JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE p.PersonType = 'IN'
GROUP BY cr.Name
ORDER BY CustomerPercentage DESC;