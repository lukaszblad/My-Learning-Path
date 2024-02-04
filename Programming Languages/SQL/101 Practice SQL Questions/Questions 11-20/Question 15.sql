--Question 15

USE AdventureWorks2019;

--a. Calculate the age for every current employee. What is the age of the oldest employee?

SELECT
    CONCAT (p.FirstName, '', p.LastName) AS FullName,
    DATEDIFF(yy, e.BirthDate, '2014-08-15') AS Age
FROM Person.Person p
JOIN HumanResources.Employee e
    ON p.BusinessEntityID = e.BusinessEntityID
ORDER BY 2 DESC;

--b. What is the average age by Organization level? Show answer with a single decimal

SELECT
    FORMAT(AVG(CAST(DATEDIFF(yy, BirthDate, '2014-08-19') AS DECIMAL)), 'N1') AS AverageAge
FROM HumanResources.Employee
GROUP BY OrganizationLevel;

--c. Use the ceiling function to round up

SELECT
    CEILING(AVG(CAST(DATEDIFF(yy, BirthDate, '2014-08-19') AS DECIMAL))) AS AverageAge
FROM HumanResources.Employee
GROUP BY OrganizationLevel;

--d. Use the floor function to round down

SELECT
    FLOOR(AVG(CAST(DATEDIFF(yy, BirthDate, '2014-08-19') AS DECIMAL))) AS AverageAge
FROM HumanResources.Employee
GROUP BY OrganizationLevel;