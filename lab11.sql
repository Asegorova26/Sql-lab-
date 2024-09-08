-------------------------------------------------------------------------
-- Лабораторная 11  -- Егорова А.С. -- БИВТ-20-7 ------------------------
-------------------------------------------------------------------------
EXEC sys.sp_addmessage
     @msgnum = 60000
    , @severity = 16
    , @msgtext = N'Order # (%d) does not exist'
    , @lang = 'us_english';
GO
BEGIN
    DECLARE @SalesOrderID int = 0
    IF NOT EXISTS(SELECT 1 FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
        BEGIN
            DECLARE @Error VARCHAR(100) = FORMATMESSAGE(60000, @SalesOrderID);
            THROW 60000, @Error, 1
        END;
    DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
    DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
END;
-----------------------------------------------------------------------------
BEGIN
    BEGIN TRY
        DECLARE @SalesOrderID int = 0
        IF NOT EXISTS(SELECT 1 FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
            BEGIN
                DECLARE @Error VARCHAR(100) = FORMATMESSAGE(60000, @SalesOrderID);
                THROW 60000, @Error, 1
            END;
        DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
        DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE()
    END CATCH
END;
----------------------------------------------------------------------------
----------------------------------------------------------------------------
BEGIN
    DECLARE @SalesOrderID int = 71780
    BEGIN TRY
        IF NOT EXISTS(SELECT 1 FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
            BEGIN
                DECLARE @Error VARCHAR(100) = FORMATMESSAGE(60000, @SalesOrderID);
                THROW 60000, @Error, 1
            END;
        BEGIN TRANSACTION
            DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
            THROW 60000, @Error, 1;
            DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF XACT_STATE() != 0
            BEGIN
                ROLLBACK TRANSACTION;
                THROW 60000, 'Aborted transaction', 1;
            END;
        ELSE
            PRINT ERROR_MESSAGE()
    END CATCH
END;
