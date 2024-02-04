-- Question 4

USE AdventureWorks2019;

--Select:

--ForeignKeyName
--SchemaName
--TableName
--ColumnName
--ReferencedSchema
--ReferencedTable
--Referenced Column

--for every foreign key in the DB

SELECT
	o.name AS fk_name,
	s1.name AS schema_name,
	t1.name AS table_name,
	c1.name AS column_name,
	s2.name AS referenced_schema_name,
	t2.name AS referenced_table_name,
	c2.name AS referenced_column_name
FROM sys.foreign_key_columns FKC
    INNER JOIN sys.objects O ON O.object_id = FKC.constraint_object_id
    INNER JOIN sys.tables T1 ON T1.object_id = FKC.parent_object_id
    INNER JOIN sys.tables T2 ON T2.object_id = FKC.referenced_object_id
    INNER JOIN sys.columns C1 ON C1.column_id = parent_column_id 
				AND C1.object_id = T1.object_id
    INNER JOIN sys.columns C2 ON C2.column_id = referenced_column_id 
				AND C2.object_id = T2.object_id
    INNER JOIN sys.schemas S1 ON T1.schema_id = S1.schema_id
    INNER JOIN sys.schemas S2 ON T2.schema_id = S2.schema_id;