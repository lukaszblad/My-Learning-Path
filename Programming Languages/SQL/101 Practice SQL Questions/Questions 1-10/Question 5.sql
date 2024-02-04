--Question 5

USE AdventureWorks2019;

--a. Create a DB called Edited_AdventureWorks

CREATE DATABASE Edited_AdventureWorks;

--b. Create a table named Table_Relationships and insert the selection from question 4 into the table

CREATE TABLE Table_Relationship(
	fk_name VARCHAR(100),
	schema_name VARCHAR(100),
	table_name VARCHAR(100),
	column_name VARCHAR(100),
	referenced_schema_name VARCHAR(100),
	referenced_table_name VARCHAR(100),
	referenced_column_name VARCHAR(100)
);

INSERT INTO Edited_AdventureWorks.dbo.Table_Relationship(
	fk_name,
	schema_name,
	table_name,
	column_name,
	referenced_schema_name,
	referenced_table_name,
	referenced_column_name
)
SELECT
	o.name AS fk_name,
	s1.name AS schema_name,
	t1.name AS table_name,
	c1.name AS column_name,
	s2.name AS referenced_schema_name,
	t2.name AS referenced_table_name,
	c2.name AS referenced_column_name
FROM AdventureWorks2019.sys.foreign_key_columns FKC
    INNER JOIN AdventureWorks2019.sys.objects O ON O.object_id = FKC.constraint_object_id
    INNER JOIN AdventureWorks2019.sys.tables T1 ON T1.object_id = FKC.parent_object_id
    INNER JOIN AdventureWorks2019.sys.tables T2 ON T2.object_id = FKC.referenced_object_id
    INNER JOIN AdventureWorks2019.sys.columns C1 ON C1.column_id = parent_column_id 
				AND C1.object_id = T1.object_id
    INNER JOIN AdventureWorks2019.sys.columns C2 ON C2.column_id = referenced_column_id 
				AND C2.object_id = T2.object_id
    INNER JOIN AdventureWorks2019.sys.schemas S1 ON T1.schema_id = S1.schema_id
    INNER JOIN AdventureWorks2019.sys.schemas S2 ON T2.schema_id = S2.schema_id;

--c. Find the table in Object Explorer

--d. find the foreign key that has been used twice

SELECT TOP(1)
	fk_name,
	COUNT(*) AS count
FROM Edited_AdventureWorks.dbo.Table_Relationship
GROUP BY fk_name
ORDER BY count
DESC;

--FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID

--e. How many Distinct Foreign Keys include BusinessEntityID as a column or referenced column?

SELECT COUNT(*)
FROM Table_Relationship
WHERE column_name = 'BusinessEntityID' or referenced_column_name = 'BusinessEntityID';