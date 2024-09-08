-------------------------------------------------------------------------
-- Лабораторная 14  -- Кузнецов Д.А -- БИВТ-20-7 ------------------------
-------------------------------------------------------------------------
USE [AdventureWorksLT2014]
GO

CREATE OR ALTER FUNCTION [dbo].[fn_GetOrders_totalDueForCustomer](@CustomerID INT)
    RETURNS FLOAT
AS
BEGIN
    RETURN (
        SELECT SUM(SOD.LineTotal)
        FROM SalesLT.Customer C
                 LEFT JOIN SalesLT.SalesOrderHeader SOH ON SOH.CustomerID = C.CustomerID
                 LEFT JOIN SalesLT.SalesOrderDetail SOD ON SOD.SalesOrderID = SOH.SalesOrderID
        WHERE C.CustomerID = @CustomerID);
END

CREATE VIEW [dbo].[vAllAddresses]
AS
(
SELECT C.CustomerID,
       CA.AddressType,
       CA.AddressID,
       A.AddressLine1,
       A.AddressLine2,
       A.City,
       A.StateProvince,
       A.CountryRegion,
       A.PostalCode
FROM SalesLT.Customer C
         INNER JOIN SalesLT.CustomerAddress CA ON CA.CustomerID = C.CustomerID
         INNER JOIN SalesLT.Address A on A.AddressID = CA.AddressID)

CREATE OR ALTER FUNCTION [dbo].[fn_GetAddressesForCustomer](@CustomerID INT)
    RETURNS TABLE
        AS
        RETURN
            (
                SELECT *
                FROM dbo.vAllAddresses V
                WHERE V.CustomerID = @CustomerID
            )

CREATE OR ALTER FUNCTION [dbo].[fn_GetMinMaxOrderPricesForProduct](@ProductID INT)
    RETURNS @ProductResult TABLE
                           (
                               [MinUnitPrice] FLOAT,
                               [MaxUnitPrice] FLOAT
                           )
AS
BEGIN
    INSERT INTO @ProductResult (MinUnitPrice, MaxUnitPrice)
        (SELECT MIN(SOD.UnitPrice), MAX(SOD.UnitPrice)
         FROM SalesLT.Product P
                  INNER JOIN SalesLT.SalesOrderDetail SOD ON SOD.ProductID = P.ProductID
         WHERE P.ProductID = @ProductID)
    RETURN;
END

CREATE OR ALTER FUNCTION [dbo].[fn_GetAllDescriptionsForProduct](@ProductID INT)
    RETURNS @ResultTable TABLE
                         (
                             [ProductID]    INT,
                             [Name]         NVARCHAR(50),
                             [MinUnitPrice] FLOAT,
                             [MaxUnitPrice] FLOAT,
                             [ListPrice]    FLOAT,
                             [ProductModel] NVARCHAR(50),
                             [Culture]      NVARCHAR(50),
                             [Description]  NVARCHAR(50)
                         )
AS
BEGIN
    INSERT INTO @ResultTable (ProductID,MaxUnitPrice, MinUnitPrice)
    SELECT @ProductID ,MaxUnitPrice, MinUnitPrice FROM dbo.fn_GetMinMaxOrderPricesForProduct(@ProductID)
    UPDATE @ResultTable
    SET ProductID = K.ProductID ,
        Name = K.Name,
        ListPrice = K.ListPrice,
        ProductModel = K.ProductModel,
        Culture = K.Culture,
        Description = K.Description
    FROM
    (SELECT P.ProductID, P.Name, P.ListPrice, PAD.ProductModel, PAD.Culture, PAD.Description
    FROM SalesLT.Product P
    INNER JOIN SalesLT.vProductAndDescription PAD ON PAD.ProductID = P.ProductID
    WHERE P.ProductID = @ProductID) K
    RETURN;
END
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
SELECT * FROM dbo.vAllAddresses

CREATE OR ALTER VIEW [SalesLT].[vAllAddresses]
    WITH SCHEMABINDING
AS
(SELECT C.CustomerID, CA.AddressType, CA.AddressID, A.AddressLine1, A.AddressLine2, A.City, A.StateProvince, A.CountryRegion, A.PostalCode FROM SalesLT.Customer C
INNER JOIN SalesLT.CustomerAddress CA ON CA.CustomerID = C.CustomerID
INNER JOIN SalesLT.Address A on A.AddressID = CA.AddressID)
go

SELECT objectproperty(
    object_id('SalesLT.vProductAndDescription'), 'IsIndexable'
);

GO
SELECT * FROM SalesLT.vAllAddresses
GO
CREATE UNIQUE CLUSTERED INDEX UIX_vAllAddresses ON SalesLT.vAllAddresses
(
	CustomerID ASC,
	AddressType ASC,
	AddressID ASC,
	AddressLine1 ASC,
	AddressLine2 ASC,
	City ASC,
	StateProvince ASC,
	CountryRegion ASC,
	PostalCode ASC
)

DROP INDEX UIX_vAllAddresses ON SalesLT.vAllAddresses
GO
SELECT * FROM SalesLT.vAllAddresses WITH (NOEXPAND)





