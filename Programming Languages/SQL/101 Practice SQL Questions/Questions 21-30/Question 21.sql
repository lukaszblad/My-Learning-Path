--Question 21

USE AdventureWorks2019;

--a. Pull a list of every country and state in the database.

SELECT
    cr.Name AS Country,
    sp.Name AS Province
FROM Person.StateProvince sp
JOIN Person.CountryRegion cr
    ON sp.CountryRegionCode = cr.CountryRegionCode;

--b. Includes tax rates.

SELECT
    cr.Name AS Country,
    sp.Name AS Province,
    tr.TaxRate AS TaxRate
FROM Person.StateProvince sp
JOIN Person.CountryRegion cr
    ON sp.CountryRegionCode = cr.CountryRegionCode
LEFT JOIN Sales.SalesTaxRate tr
    ON sp.StateProvinceID = tr.StateProvinceID;

--c. There are 181 rows when looking at countries and states, but once you add tax rates the number of rows increases to 184. Why is this?

SELECT
    *
FROM Sales.SalesTaxRate
WHERE StateProvinceID IN (
        SELECT
            sp.StateProvinceID
        FROM Person.StateProvince sp
        LEFT JOIN Sales.SalesTaxRate tr
            ON sp.StateProvinceID = tr.StateProvinceID
        GROUP BY sp.StateProvinceID
        HAVING COUNT(tr.TaxRate) > 1);

--d. Which location has the highest tax rate?

SELECT
    sp.Name,
    tr.TaxRate
FROM Person.StateProvince sp
LEFT JOIN Sales.SalesTaxRate tr
    ON sp.StateProvinceID = tr.StateProvinceID
ORDER BY tr.TaxRate DESC;