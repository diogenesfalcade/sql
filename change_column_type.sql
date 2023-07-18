--Mudar o tipo da coluna em todas as tabelas que ela existir
--Banco de dados em SQL Server (ODBC Driver 17 for SQL Server)

DECLARE @ColumnName NVARCHAR(128) = 'CHANGED_ON'
DECLARE @CurrentDataType NVARCHAR(128) = 'datetime2'
DECLARE @DesiredDataType NVARCHAR(128) = 'datetime'

DECLARE @TableName NVARCHAR(128)

DECLARE tableCursor CURSOR FOR
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE' -- Somente tabelas
    AND TABLE_SCHEMA = 'dbo' -- Esquema padrão, ajuste conforme necessário

OPEN tableCursor
FETCH NEXT FROM tableCursor INTO @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName
            AND COLUMN_NAME = @ColumnName
            AND DATA_TYPE = @CurrentDataType
    )
    BEGIN
        EXEC('
            ALTER TABLE ' + @TableName + '
            ALTER COLUMN ' + @ColumnName + ' ' + @DesiredDataType + '
        ')

        PRINT 'Alterações realizadas na coluna ' + @ColumnName + ' da tabela ' + @TableName + '.'
    END
    ELSE
    BEGIN
        PRINT 'A coluna ' + @ColumnName + ' não existe ou já está no tipo ' + @DesiredDataType + ' na tabela ' + @TableName + '.'
    END

    FETCH NEXT FROM tableCursor INTO @TableName
END

CLOSE tableCursor
DEALLOCATE tableCursor
