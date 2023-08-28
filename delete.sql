--Simple delete of duplicate rows
-- In this case it only deletes the most recents inserted, keeps the first register.
-- To delete the oldest, change the WHERE clause in the line 14


DELETE FROM CUSTOMER -- Insert your table here
WHERE ROWID IN (
    SELECT ROWID
    FROM (
        SELECT ROWID,
               ROW_NUMBER() OVER (PARTITION BY NAME ORDER BY ROWID) AS rn
        FROM CUSTOMER
    )
    WHERE rn > 1 -- where clause to change
) AND NAME = 'ETA_281'; -- Insert column and PK value

--Check before deleting the record.
SELECT NAME, ROWID, -- Insert the column name (pk)
       ROW_NUMBER() OVER (PARTITION BY NAME ORDER BY ROWID) AS RN
FROM CUSTOMER --Change table
WHERE NAME = 'ETA_281'; --Change column and value
