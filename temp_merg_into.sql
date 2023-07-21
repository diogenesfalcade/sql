--Clears #temp_table from context
CREATE TABLE #temp_table ( 
      sample_id VARCHAR(50), 
      assay VARCHAR(50), 
      request VARCHAR(50), 
      quality VARCHAR(50)
      ); 

--Copy values from ##MISC_XNI_REQUESTS but replaces sFirstTextId for sTextId 
-- THE APPLICATION WHERE THIS IS USED IS INSIDE A FOR LOOP
--FOR
MERGE INTO #temp_table AS t 
USING ( 
		SELECT sample_id, assay, request, quality 
		FROM ##MISC_XNI_REQUESTS 
			WHERE sample_id = '{sFirstTextId}' 
	  ) AS s 
ON t.sample_id = '{sTextId}' and t.assay = s.assay 
WHEN MATCHED THEN 
		UPDATE SET t.request = s.request, t.quality = s.quality 
WHEN NOT MATCHED THEN 
		INSERT (sample_id, assay, request, quality) 
VALUES ('{sTextId}', s.assay, s.request, s.quality); 

--Builds a list of sTextId inside the application
--NEXT

--Clear all values from these sTextId
DELETE FROM ##MISC_XNI_REQUESTS 
WHERE SAMPLE_ID IN ({sListOfIds}) 

--Records all values from #temp_table
--#temp_table is created and droped each time the function is called
MERGE INTO ##MISC_XNI_REQUESTS AS target 
USING #temp_table AS source 
ON (target.sample_id = source.sample_id) 
			AND (target.assay = source.assay) 
WHEN MATCHED THEN 
	UPDATE SET target.assay = source.assay, target.request = source.request, target.quality = source.quality 
WHEN NOT MATCHED THEN 
	INSERT (sample_id, assay, request, quality) 
	VALUES (source.sample_id, source.assay, source.request, source.quality); 

DROP TABLE #temp_table; 
