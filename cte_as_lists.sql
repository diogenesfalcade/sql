-- POSTGRESQL
-- Quick solution to deal with two different systems with each one its database
-- Get a list of values and write as a SQL list from DATABASE1
select '(' || string_agg(quote_literal(NAME), ', ') || ')'
from (
    select distinct NAME
    from COMMON_NAME where REMOVED = 'F'
	ORDER BY NAME asc
) as LIST

-- Copy the result from the query above and paste inside the brackets []
with EXISTING_NAMES as (
	select
	unnest(array['NAME_1', 'NAME_2', 'NAME_3', 'NAME_4',
                'NAME_5', 'Names go on.....']
		  ) as NAME
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
where C.NAME not in (select NAME from EXISTING_NAMES)
