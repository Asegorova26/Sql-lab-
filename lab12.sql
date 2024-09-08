-------------------------------------------------------------------------
-- Лабораторная 12  -- Кузнецов Д.А -- БИВТ-20-7 ------------------------
-------------------------------------------------------------------------
DECLARE @Name   NVARCHAR(20) = 'Product'
DECLARE @Schema NVARCHAR(20) = 'SalesLT'

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE (DATA_TYPE IN ('nvarchar', 'char', 'nchar', 'varchar', 'nvarchar', 'text', 'ntext')
    AND TABLE_NAME = @Name
    AND TABLE_SCHEMA = @Schema)
GO
-------------------------------------------------------------------------
DECLARE @Name   NVARCHAR(20) = 'Product'
DECLARE @Schema NVARCHAR(20) = 'SalesLT'
DECLARE @Column NVARCHAR(2000)
DECLARE @Query  NVARCHAR(2000)
DECLARE @String NVARCHAR(2000) = 'Bike'

DECLARE cursor1 CURSOR LOCAL FAST_FORWARD
    FOR
    SELECT COLUMN_NAME
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE (DATA_TYPE IN ('nvarchar', 'char', 'nchar', 'varchar', 'nvarchar', 'text', 'ntext')
        AND TABLE_NAME = @Name
        AND TABLE_SCHEMA = @Schema)
OPEN cursor1
WHILE (1 = 1)
    BEGIN
        FETCH cursor1 INTO @Column
        IF @@FETCH_STATUS <> 0 BREAK
        SET @Query = 'SELECT [' + @Column + '] ' +
                     'FROM [' + @Schema + '].[' + @Name + '] ' +
                     'WHERE [' + @Column + '] LIKE ' +
                     '''%' + @String + '%'''
        EXEC (@Query)
    END
CLOSE cursor1
DEALLOCATE cursor1
GO
-------------------------------------------------------------------------
-------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE SalesLT.uspLookForString @Schema SYSNAME, @Table SYSNAME, @String NVARCHAR(2000)
AS
DECLARE @Count INT = 0
DECLARE @Column NVARCHAR(2000)
DECLARE @Query NVARCHAR(2000)

DECLARE
    cursor1 CURSOR LOCAL FAST_FORWARD
        FOR
        SELECT COLUMN_NAME
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE (DATA_TYPE IN ('nvarchar', 'char', 'nchar', 'varchar', 'nvarchar', 'text', 'ntext')
            AND TABLE_NAME = @Table
            AND TABLE_SCHEMA = @Schema)
    OPEN cursor1
    WHILE (1 = 1)
        BEGIN
            FETCH cursor1 INTO @Column
            IF @@FETCH_STATUS <> 0 BREAK
            SET @Query = 'SELECT [' + @Column + '] FROM [' + @Schema + '].[' + @table + '] WHERE [' + @column +
                         '] LIKE ' + '''%' + @String + '%'''
            EXEC (@Query)
            SET @Count = @Count + @@ROWCOUNT
        END
    CLOSE cursor1
    DEALLOCATE cursor1
    RETURN @Count
GO

DECLARE @out INT
EXEC @out = SalesLT.uspLookForString 'SalesLT', 'Product', 'Bike'
PRINT @out
-------------------------------------------------------------------
SET NOCOUNT ON

DECLARE @Schema NVARCHAR(2000)
DECLARE @Table  NVARCHAR(2000)
DECLARE @String NVARCHAR(2000) = 'Bike'
DECLARE @Count  INT

DECLARE cursor1 CURSOR LOCAL FAST_FORWARD
    FOR
    SELECT DISTINCT TABLE_SCHEMA, TABLE_NAME
    FROM INFORMATION_SCHEMA.COLUMNS

OPEN cursor1
WHILE (1 = 1)
    BEGIN
        FETCH cursor1 INTO @Schema, @Table
        IF @@FETCH_STATUS <> 0 BREAK

        BEGIN TRY

            EXEC @Count = SalesLT.uspLookForString @Schema, @Table, @String

        END TRY
        BEGIN CATCH

            Print 'Ошибка доступа';
            PRINT ERROR_MESSAGE();

        END CATCH;

        IF @Count <> 0
            PRINT 'В таблице ' + @Schema + '.' + @Table + ' найдено строк: ' + CAST(@Count AS NVARCHAR(2000))
        IF @Count = 0
            PRINT 'В таблице ' + @Schema + '.' + @Table + ' не найдено строк совпадений'
    END

CLOSE cursor1
DEALLOCATE cursor1
