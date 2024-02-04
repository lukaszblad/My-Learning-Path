--Question 11

USE AdventureWorks2019;

--a. How many employees exist in the Database?

SELECT
    COUNT(*) AS emp_count,
    COUNT(DISTINCT BusinessEntityID) AS emp_count_check1,
    COUNT(DISTINCT NationalIDNumber) AS emp_count_check2
FROM HumanResources.Employee;

--b. How many of these employees are active employees?

SELECT
    COUNT(*) AS active_emp_count
FROM HumanResources.Employee
WHERE CurrentFlag = 1;

--c. How many Job Titles equal the 'SP' Person type?

SELECT
    COUNT(DISTINCT JobTitle)
FROM HumanResources.Employee e
JOIN Person.Person p
    ON e.BusinessEntityID = p.BusinessEntityID
WHERE PersonType = 'SP'

--d. How many of these employees are sales people?

SELECT COUNT(*) FROM HumanResources.Employee e
JOIN Sales.SalesPerson s
    ON e.BusinessEntityID = s.BusinessEntityID;