SELECT '{sTextId}' AS sample_id, assay, request, quality
INTO #temp_intermediaria
FROM ##MISC_XNI_REQUESTS
WHERE sample_id = '{sFirstTextId}';

INSERT INTO ##MISC_XNI_REQUESTS (sample_id, assay, request, quality)
SELECT sample_id, assay, request, quality
FROM #temp_intermediaria;

DROP TABLE #temp_intermediaria;