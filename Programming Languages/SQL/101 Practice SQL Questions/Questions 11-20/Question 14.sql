--Question 14

USE AdventureWorks2019;

--a. Which Purchasing vendors have the highest credit rating?

SELECT
    Name AS VendorName,
    CreditRating
FROM Purchasing.Vendor v
WHERE CreditRating = (SELECT MIN(CreditRating) FROM Purchasing.Vendor);

--b. Using a case statement replace the 1 and 0 in Vendor.PreferredVendorStatus to "Preferred" vs "Not Preferred."   How many vendors are considered Preferred?

SELECT
    Name AS VendorName,
    CASE
        WHEN PreferredVendorStatus = 1 THEN 'Preferred'
        ELSE 'Not Preferred'
    END AS PreferredStatus
FROM Purchasing.Vendor;

SELECT
    COUNT(*) AS PreferredVendorCount
FROM Purchasing.Vendor
GROUP BY PreferredVendorStatus
HAVING PreferredVendorStatus = 1;

--c. For Active Vendors only, do Preferred vendors have a High or lower average credit rating?

SELECT
    CASE
        WHEN PreferredVendorStatus = 1 THEN 'Preferred'
        ELSE 'Not Preferred'
    END AS PreferredStatus,
    AVG(CAST(CreditRating as DECIMAL)) AS AverageRating
FROM Purchasing.Vendor
WHERE ActiveFlag = 1
GROUP BY
    CASE
        WHEN PreferredVendorStatus = 1 THEN 'Preferred'
        ELSE 'Not Preferred'
        END;

--d. How many vendors are active and Not Preferred?

SELECT
    COUNT(*) AS ActiveNotPreferred
FROM Purchasing.Vendor
WHERE ActiveFlag = 1 AND PreferredVendorStatus = 0;