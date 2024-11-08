-- create a list from static data to reference the list multiple times
-- POSTGRESQL
WITH EXISTING_NAMES as (
	SELECT 
	unnest(Array['NAME_1', 'NAME_2', 'NAME_3', 'NAME_4',
                'NAME_5', 'Names go on.....']
		  ) as name
)
select 
  C.NAME, 
  C.DESCRIPTION, 
  C.CHANGED_ON, 
  C.CHANGED_BY, 
  C.REMOVED, 
  C.EXT_LINK, 
  C.GROUP_NAME
from 
  COMMON_NAME C
where C.NAME NOT IN(select name from EXISTING_NAMES)
