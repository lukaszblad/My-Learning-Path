--Question 8

USE AdventureWorks2019;

-- a. count each data type in descending order.
SELECT 
    DATA_TYPE,
    COUNT(*) AS count
FROM information_schema.columns
GROUP BY DATA_TYPE
ORDER BY count DESC;

-- b. Using a case statement create a data type grouping that summarizes each data type as one of the following Groups: Character, Numeric, Date, Null
SELECT 
	CASE
		WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN 'Character'
		WHEN NUMERIC_PRECISION IS NOT NULL THEN 'Numeric'
		WHEN DATETIME_PRECISION IS NOT NULL THEN 'Date'
		ELSE 'NULL'
	END AS data_group,
	COUNT(*) AS total
FROM information_schema.columns
GROUP BY 
	CASE
		WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN 'Character'
		WHEN NUMERIC_PRECISION IS NOT NULL THEN 'Numeric'
		WHEN DATETIME_PRECISION IS NOT NULL THEN 'Date'
		ELSE 'NULL'
	END
ORDER BY total DESC;

--c. What data types are in the "Null" group
SELECT
	DATA_TYPE
FROM information_schema.columns
WHERE CHARACTER_MAXIMUM_LENGTH IS NULL AND NUMERIC_PRECISION IS NULL AND DATETIME_PRECISION IS NULL
GROUP BY DATA_TYPE;