--Table with a colum in json
-- it is used to build a html table


select 
  top 250 SAMPLE_NUMBER, 
  SAMPLED_DATE, 
  TEXT_ID, 
  XNI_FEED_TYPE1, 
  XNI_FEED_TYPE2, 
  XNI_FEED_TYPE3, 
  (
    select 
      TEST.ANALYSIS AS 'test', 
      SAMPLE.XNI_FEED_TYPE1 AS 'type', 
      SAMPLE.XNI_FEED_TYPE2 AS 'source', 
      SAMPLE.XNI_FEED_TYPE3 AS 'target', 
      RESULT.NAME AS 'name', 
      RESULT.ENTRY AS 'entry', 
      CASE Result.RESULT_TYPE WHEN 'K' THEN 'calculated' ELSE NULL END AS 'type' 
    FROM 
      TEST test 
      JOIN RESULT result ON TEST.TEST_NUMBER = RESULT.TEST_NUMBER 
    WHERE 
      TEST.SAMPLE_NUMBER = SAMPLE.SAMPLE_NUMBER FOR JSON AUTO
  ) as JSON 
FROM 
  SAMPLE 
WHERE 
  CUSTOMER = 'SUD_SMELTER' 
  and TEMPLATE IN (
    'SUD_SM_XRF_PROD', 'SUD_SM_XRF_PROD2'
  ) 
  AND STATUS NOT IN ('X', 'R', 'A') 
ORDER BY 
  SAMPLE_NUMBER DESC
