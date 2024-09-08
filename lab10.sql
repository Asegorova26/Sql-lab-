-------------------------------------------------------------------------
-- Лабораторная 10  -- Кузнецов Д.А -- БИВТ-20-7 -------------------------
-------------------------------------------------------------------------
DECLARE @OrderDate DATE = GETDATE();
DECLARE @DueDate DATE = DATEADD(d, 7, GETDATE());
DECLARE @CustomerId INT = 1

BEGIN
    IF OBJECT_ID('SalesLT.SalesOrderNumber') IS NULL
        BEGIN
            CREATE SEQUENCE SalesLT.SalesOrderNumber AS INT
                START WITH 1 INCREMENT BY 1;
        END

    DECLARE @NextId INT = NEXT VALUE FOR SalesLT.SalesOrderNumber;

    INSERT INTO SalesLT.SalesOrderHeader (DueDate, OrderDate, CustomerID, ShipMethod)
    VALUES (@DueDate, @OrderDate, @CustomerId, 'CARGO TRANSPORT 5');

    PRINT (@NextId);
    PRINT (SCOPE_IDENTITY())
END
-------------------------------------------------------------------------------------
DECLARE @SalesOrderId INT = 71955;
DECLARE @ProductId INT = 760;
DECLARE @Quantity INT = 1;
DECLARE @UnitPrice DECIMAL = 782.99;

BEGIN
    IF NOT EXISTS(SELECT 1 FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderId)
        PRINT ('ЗАКАЗА НЕТ!') -- THROW 50505, 'СОВСЕМ НЕТ!', 10;
    ELSE
        BEGIN
            INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice)
            VALUES (@SalesOrderId, @Quantity, @ProductId, @UnitPrice);
        END;
END;
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
DECLARE @Categories TABLE
                    (
                        ProductCategoryID INT
                    )
DECLARE @a          DECIMAL
DECLARE @b          DECIMAL

BEGIN
    INSERT INTO @Categories (ProductCategoryID)
    SELECT ProductCategoryID
    FROM SalesLT.vGetAllCategories
    WHERE ParentProductCategoryName = 'Bikes';
    IF (6000 >
        (SELECT AVG(ListPrice)
         FROM SalesLT.Product
         WHERE Product.ProductCategoryID IN (SELECT * FROM @Categories))) -- Или можно в while условия прописать
        BEGIN
            WHILE 1 = 1
                BEGIN
                    UPDATE SalesLT.Product
                    SET ListPrice = ListPrice * 1.1
                    WHERE ProductCategoryID IN (SELECT * FROM @Categories)
                    IF ((SELECT MAX(ListPrice)
                         FROM SalesLT.Product
                         WHERE Product.ProductCategoryID IN (SELECT * FROM @Categories)) > 8000)
                        BREAK;
                END;
            SET @a = (SELECT AVG(ListPrice)
                      FROM SalesLT.Product
                      WHERE Product.ProductCategoryID IN (SELECT * FROM @Categories))
            PRINT ('NEW AVERAGE PRICE' + CAST(@a as VARCHAR));
            SET @b = (SELECT MAX(ListPrice)
                      FROM SalesLT.Product
                      WHERE Product.ProductCategoryID IN (SELECT * FROM @Categories))
            PRINT ('NEW MAX PRICE' + CAST(@b as VARCHAR));
        END;
END;