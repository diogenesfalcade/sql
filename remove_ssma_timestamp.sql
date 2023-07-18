DECLARE @TableName NVARCHAR(128)

DECLARE tableCursor CURSOR FOR
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'SSMA_TIMESTAMP'

OPEN tableCursor
FETCH NEXT FROM tableCursor INTO @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC('
        ALTER TABLE ' + @TableName + '
        DROP COLUMN SSMA_TIMESTAMP
    ')

    PRINT 'Campo SSMA_TIMESTAMP removido da tabela ' + @TableName + '.'

    FETCH NEXT FROM tableCursor INTO @TableName
END

CLOSE tableCursor
DEALLOCATE tableCursor
