--Question 9

USE AdventureWorks2019;

--Write a script that will show you each view name and the number of tables used to create the view.

SELECT
    VIEW_NAME,
    COUNT(DISTINCT TABLE_NAME) AS table_count
FROM information_schema.view_column_usage
GROUP BY VIEW_NAME
ORDER BY table_count DESC;