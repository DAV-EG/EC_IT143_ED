
/*****************************************************************************************************************
NAME:    Question and Answer for 8 AdventureWorks Business Questions
PURPOSE: To answer eight business and metadata questions using the AdventureWorks database.

MODIFICATION LOG:
Ver      Date        Author             Description
-----   ----------   ----------------   -------------------------------------------------------------------------------
1.0     11/23/2026   EguaborDavid       Built this script for EC IT143 W3.4.

RUNTIME:
1h 40m

NOTES:
This script answers eight questions using SQL queries in the AdventureWorks database.
The questions were selected from classmates' discussion posts.

******************************************************************************************************************/

USE AdventureWorks2022;
GO

-- Q1: Which ten products have the highest list prices?
-- Original Author: Eguabor David
-- A1: This query displays the ten products with the highest list prices.

SELECT TOP 10
    ProductID,
    Name,
    ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;


-- Q2: Which products are available in red?
-- Original Author: Eguabor David
-- A2: This query identifies products whose color is recorded as Red.

SELECT
    ProductID,
    Name,
    Color
FROM Production.Product
WHERE Color = 'Red'
ORDER BY Name;


-- Q3: Which employees belong to each department?
-- Can I see their names together with their department names and current assignment information?
-- Original Author: Favourite 
-- A3: This query joins employee, person, department history, and department tables.

SELECT
    P.FirstName,
    P.LastName,
    D.Name AS DepartmentName,
    EDH.StartDate,
    EDH.EndDate
FROM HumanResources.Employee AS E
INNER JOIN Person.Person AS P
    ON E.BusinessEntityID = P.BusinessEntityID
INNER JOIN HumanResources.EmployeeDepartmentHistory AS EDH
    ON E.BusinessEntityID = EDH.BusinessEntityID
INNER JOIN HumanResources.Department AS D
    ON EDH.DepartmentID = D.DepartmentID
WHERE EDH.EndDate IS NULL
ORDER BY D.Name, P.LastName;


-- Q4: Which sales territories generated the highest sales totals in 2013?
-- Can we compare the order amounts with the names of the territories?
-- Original Author: Azeez 
-- A4: This query calculates total sales for each territory during 2013.

SELECT
    ST.Name AS TerritoryName,
    SUM(SOH.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesTerritory AS ST
    ON SOH.TerritoryID = ST.TerritoryID
WHERE SOH.OrderDate >= '20130101'
  AND SOH.OrderDate < '20140101'
GROUP BY ST.Name
ORDER BY TotalSales DESC;


-- Q5: The purchasing department wants to review its spending during 2013.
-- Show the vendors, number of products ordered, and total amount spent with each vendor.
-- Original Author: Favourite 
-- A5: This query summarizes vendor spending and quantities purchased during 2013.

WITH VendorSpending AS
(
    SELECT
        VendorID,
        SUM(TotalDue) AS TotalAmountSpent
    FROM Purchasing.PurchaseOrderHeader
    WHERE OrderDate >= '20130101'
      AND OrderDate < '20140101'
    GROUP BY VendorID
),
VendorProducts AS
(
    SELECT
        POH.VendorID,
        SUM(POD.OrderQty) AS TotalProductsOrdered
    FROM Purchasing.PurchaseOrderHeader AS POH
    INNER JOIN Purchasing.PurchaseOrderDetail AS POD
        ON POH.PurchaseOrderID = POD.PurchaseOrderID
    WHERE POH.OrderDate >= '20130101'
      AND POH.OrderDate < '20140101'
    GROUP BY POH.VendorID
)
SELECT
    V.Name AS VendorName,
    VP.TotalProductsOrdered,
    VS.TotalAmountSpent
FROM Purchasing.Vendor AS V
INNER JOIN VendorSpending AS VS
    ON V.BusinessEntityID = VS.VendorID
INNER JOIN VendorProducts AS VP
    ON V.BusinessEntityID = VP.VendorID
ORDER BY VS.TotalAmountSpent DESC;


-- Q6: Which product categories performed best during the first half of 2013?
-- Show monthly quantities sold and total sales amount for each category.
-- Original Author: Azeez 
-- A6: This query summarizes monthly sales quantities and revenue by product category.

SELECT
    PC.Name AS CategoryName,
    YEAR(SOH.OrderDate) AS SalesYear,
    MONTH(SOH.OrderDate) AS SalesMonth,
    SUM(SOD.OrderQty) AS TotalQuantitySold,
    SUM(SOD.LineTotal) AS TotalSalesAmount
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
    ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product AS P
    ON SOD.ProductID = P.ProductID
INNER JOIN Production.ProductSubcategory AS PSC
    ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS PC
    ON PSC.ProductCategoryID = PC.ProductCategoryID
WHERE SOH.OrderDate >= '20130101'
  AND SOH.OrderDate < '20130701'
GROUP BY
    PC.Name,
    YEAR(SOH.OrderDate),
    MONTH(SOH.OrderDate)
ORDER BY
    PC.Name,
    SalesMonth;


-- Q7: Can INFORMATION_SCHEMA.TABLES show all base tables
-- available in the HumanResources schema?
-- Original Author: Favourite
-- A7: This query lists all base tables in the HumanResources schema.

SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'HumanResources'
  AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;


-- Q8: Can INFORMATION_SCHEMA.COLUMNS list the column names and data types
-- available in the Sales.SalesOrderHeader table?
-- Original Author: Azeez 
-- A8: This query displays column names and data types for SalesOrderHeader.

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Sales'
  AND TABLE_NAME = 'SalesOrderHeader'
ORDER BY ORDINAL_POSITION;


/*****************************************************************************************************************
END OF SCRIPT
******************************************************************************************************************/
