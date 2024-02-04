--Question 3

USE AdventureWorks2019;

--a. Create a new database called "Edited_AdventureWorks" (we are creating another database so we don't   overwrite or change the AdventureWorks database). Then write a USE statement to connect to the new database.

CREATE DATABASE Edited_AdventureWorks;

USE Edited_AdventureWorks;

--b. Using the following tables - sys.check_constraints, sys.tables, and sys.columns to write a query that will give you TableName, ColumnName, CheckConstraintName, and CheckConstraintDefinition

SELECT DISTINCT
	tbl.name AS TableName,
	cmn.name AS ColumnName,
	chk.name AS CheckConstraint,
	chk.definition AS Definition
FROM AdventureWorks2019.sys.check_constraints chk
	JOIN AdventureWorks2019.sys.tables tbl
		ON chk.parent_object_id = tbl.object_id
	LEFT JOIN AdventureWorks2019.sys.columns cmn
		ON chk.parent_column_id = cmn.column_id
		AND chk.parent_object_id = cmn.object_id;

--c. Create a table named "tbl_CheckConstraint" in the "Edited_AdventureWorks" database with the following  columns and data types:

CREATE TABLE tbl_CheckConstraint (
	TableName VARCHAR(100),
	ColumnName VARCHAR(100),
	CheckConstraint VARCHAR(250),
	Definition VARCHAR(500),
	ConstraintLevel VARCHAR(100)
);

--d. Using the query in part b insert the data into "tbl_CheckConstraint"

INSERT INTO tbl_CheckConstraint
    (TableName,
	ColumnName,
	CheckConstraint,
	Definition)
SELECT DISTINCT
	tbl.name AS TableName,
	cmn.name AS ColumnName,
	chk.name AS CheckConstraint,
	chk.definition AS Definition
FROM AdventureWorks2019.sys.check_constraints chk
	JOIN AdventureWorks2019.sys.tables tbl
		ON chk.parent_object_id = tbl.object_id
	LEFT JOIN AdventureWorks2019.sys.columns cmn
		ON chk.parent_column_id = cmn.column_id
		AND chk.parent_object_id = cmn.object_id;

--e. Using a case statement write an update statement (update ConstraintLevel) that will specify whether the constraint is assigned to the column or the table.

UPDATE tbl_CheckConstraint
SET ConstraintLevel = 
	CASE
		WHEN ColumnName IS NULL THEN 'TableRelated'
		ELSE 'ColumnRelated'
	END
;

--f. What does this mean?
--When column name is empty, then the check constraint is related to the table

--g. Once you're done interpreting the results drop the tbl_CheckConstraint table

DROP TABLE tbl_CheckConstraint;