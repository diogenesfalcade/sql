MERGE INTO ##MISC_XNI_REQUESTS AS target
USING (
    SELECT '{sFirstTextId}' AS sample_id, assay, request, quality
) AS source
ON (target.sample_id = source.sample_id)
WHEN MATCHED THEN
    UPDATE SET target.assay = source.assay, target.request = source.request, target.quality = source.quality
WHEN NOT MATCHED THEN
    INSERT (sample_id, assay, request, quality)
    VALUES (source.sample_id, source.assay, source.request, source.quality);
