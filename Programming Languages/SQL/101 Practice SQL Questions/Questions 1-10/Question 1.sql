--Question 1

USE AdventureWorks2019;

--Write a SQL Statement that will give you a count of each object type in the AdventureWorks database. Order by count descending.

SELECT 
    type_desc,
    COUNT(*) AS total
FROM sys.objects
GROUP BY type_desc
ORDER BY total DESC;