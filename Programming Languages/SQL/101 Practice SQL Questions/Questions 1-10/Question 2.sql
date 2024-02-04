--Question 2

USE AdventureWorks2019;

--a. Write a SQL Statement that will show a count of schemas, tables, and columns (do not include views) in the AdventureWorks database.

SELECT 
	COUNT(DISTINCT s.name) AS schema_name,
	COUNT(DISTINCT t.name) AS table_name,
	COUNT(c.name) AS column_name
FROM sys.tables t
	JOIN sys.columns c ON t.object_id = c.object_id
	JOIN sys.schemas s ON t.schema_id = s.schema_id;

--or

SELECT 
	COUNT(DISTINCT table_schema) AS schema_name,
	COUNT(DISTINCT table_name) AS table_name,
	COUNT(column_name) AS column_name
FROM information_schema.columns
WHERE table_name NOT IN (SELECT table_name FROM information_schema.views);

--b. Write a similar statement as part a but list each schema, table, and column (do not include views). This table can be used later in the course.

SELECT 
	s.name AS schema_name,
	t.name AS table_name,
	c.name AS column_name
FROM sys.tables t
	JOIN sys.columns c ON t.object_id = c.object_id
	JOIN sys.schemas s ON t.schema_id = s.schema_id;

--or

SELECT 
	table_schema AS schema_name,
	table_name AS table_name,
	column_name AS column_name
FROM information_schema.columns
WHERE table_name NOT IN (SELECT table_name FROM information_schema.views);