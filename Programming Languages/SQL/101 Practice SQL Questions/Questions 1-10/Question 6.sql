--Question 6

USE AdventureWorks2019;

--In Question 1 we learned that the AdventureWorks Database has 152 Default Constraints. What tables and columns are these constraints on? And what are the default values?

    -- o.name AS df_name,
    -- o.type_desc AS df_type,
    -- t.name AS table_name

SELECT
    dc.name AS dc_name,
    dc.definition AS dc_definition,
    t.name AS table_name,
    c.name AS column_name
FROM sys.default_constraints dc
JOIN sys.tables t
    ON dc.parent_object_id = t.object_id
JOIN sys.columns c
    ON dc.parent_column_id = c.column_id
    AND c.object_id = t.object_id;