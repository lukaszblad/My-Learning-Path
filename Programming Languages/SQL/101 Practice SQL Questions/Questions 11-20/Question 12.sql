--Question 12

USE AdventureWorks2019;

--a. What is the name of the CEO? Concatenate first and last name.

SELECT
    CONCAT(FirstName, ' ', LastName) AS CEO_Name
FROM HumanResources.Employee e
JOIN Person.Person p
    ON e.BusinessEntityID = p.BusinessEntityID
WHERE JobTitle = 'Chief Executive Officer'

--b. When did this person start working for AdventureWorks

SELECT
    CONCAT(FirstName, ' ', LastName) AS CEO_Name,
    HireDate
FROM HumanResources.Employee e
JOIN Person.Person p
    ON e.BusinessEntityID = p.BusinessEntityID
WHERE JobTitle = 'Chief Executive Officer'

--c. Who reports to the CEO? Includes their names and title

SELECT
    CONCAT(FirstName, ' ', LastName) AS board_members,
    JobTitle
FROM HumanResources.Employee e
JOIN Person.Person p
    ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.OrganizationLevel = 1