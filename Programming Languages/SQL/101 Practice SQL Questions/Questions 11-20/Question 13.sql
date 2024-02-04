--Question 13

USE AdventureWorks2019;

--a. What is the job title for John Evans

SELECT
    p.FirstName,
    p.LastName,
    e.JobTitle
FROM Person.Person p
JOIN HumanResources.Employee e
    ON p.BusinessEntityID = e.BusinessEntityID
WHERE p.FirstName = 'John' AND p.LastName = 'Evans';

--b. What department does John Evans work in?

SELECT
    p.FirstName,
    p.LastName,
    e.JobTitle,
    d.Name AS DeptName
FROM Person.Person p
JOIN HumanResources.Employee e
    ON p.BusinessEntityID = e.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory ed
    ON e.BusinessEntityID = ed.BusinessEntityID
JOIN HumanResources.Department d
    ON ed.DepartmentID = d.DepartmentID
WHERE p.FirstName = 'John' AND p.LastName = 'Evans';