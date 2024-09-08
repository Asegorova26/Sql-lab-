-------------------------------------------------------------------------
-- Лабораторная 13  -- Егорова А.С. -- БИВТ-20-7 ------------------------
-------------------------------------------------------------------------
SELECT *
FROM SalesLT.Product P
WHERE (ListPrice > (SELECT 20 * MIN(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID = p.ProductCategoryID))

IF (@@ROWCOUNT > 0)
    PRINT 'Правило 20-кратной разницы в цене нарушено у ' + @@ROWCOUNT + 'товаров'
ELSE
    PRINT 'Правило 20-кратной разницы в цене соблюдено'
-------------------------------------------------------------------------
CREATE OR ALTER TRIGGER SalesLT.TriggerProductListPriceRules
    ON SalesLt.Product
    AFTER INSERT , UPDATE
    AS
BEGIN
    IF EXISTS(SELECT *
              FROM inserted INS
              WHERE (ListPrice >
                     (SELECT 20 * MIN(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID = INS.ProductCategoryID)))
        BEGIN
            ROLLBACK TRANSACTION;
            THROW 50001, 'Вносимые изменения нарушают правило 20-кратной разницы в цене товаров из одной рубрики', 1;
        END
END
GO
------------------------------------------------------------------------
------------------------------------------------------------------------
CREATE OR ALTER trigger TriggerProduct
    ON SalesLt.Product
    AFTER INSERT, UPDATE
    AS
BEGIN
    IF (SELECT ProductCategoryID FROM inserted)
        NOT IN (SELECT ProductCategoryID FROM SalesLT.ProductCategory)
        BEGIN
            ROLLBACK;
            THROW 50002,
                'Ошибка: попытка нарушения ссылочной целостности между таблицами Product и ProductCategory, транзакция отменена',0;
        END;
END
GO
CREATE OR ALTER TRIGGER TriggerProductCategory
    ON SalesLT.ProductCategory
    AFTER INSERT, UPDATE
    AS
BEGIN
    IF (SELECT ProductCategoryID FROM inserted)
        NOT IN (SELECT ProductCategoryID FROM SalesLT.Product)
        BEGIN
            ROLLBACK;
            THROW 50002,
                'Ошибка: попытка нарушения ссылочной целостности между таблицами Product и ProductCategory, транзакция отменена',
                1;
        END;
END
------------------------------------------------------------------------
    ALTER TABLE SalesLT.Product
        NOCHECK CONSTRAINT FK_Product_ProductCategory_ProductCategoryID;
    UPDATE SalesLT.Product
    SET ProductCategoryID = -1
    WHERE ProductID = 680
    BEGIN TRANSACTION
    DELETE
    FROM SalesLT.ProductCategory
    WHERE ProductCategoryID = 5
    ROLLBACK
    ALTER TABLE SalesLT.Product
        CHECK CONSTRAINT FK_Product_ProductCategory_ProductCategoryID;
    DISABLE TRIGGER SalesLT.TriggerProduct ON SalesLT.Product;
    DISABLE TRIGGER SalesLT.TriggerProductCategory ON SalesLT.ProductCategory;
