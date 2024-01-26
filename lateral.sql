--The majority of concepts used here are very simple, excpet the LATERAL UNNEST

--the field "assigned_to" can contain more than one USER_NAME separated by comma. Like (0001, 0006, 5024)
--LATERAL UNNEST is spliting the USER_NAMEs and then joining them on LIMS_USERS
--We are retrieving the FULL_NAME of all USER_NAMES contained in ASSIGNED_TO field throught the left join of splited USER_NAMES
--Also, the STRING_AGG is concatenating the FULL_NAMES to be shown like the USER_NAMES

select distinct t.PLAN_NUMBER, 
to_char(t.CREATED_ON, 'YYYY/Mon/DD') as CREATED_ON, 
lu.FULL_NAME as CREATED_BY, 
to_char(t.DUE_DATE, 'YYYY/Mon/DD') as DUE_DATE,
  STRING_AGG(lu2.FULL_NAME, ', ' order by lu2.FULL_NAME asc) as assigned_to_names
from T_EM_PLAN t 
	inner join LIMS_USERS lu on t.CREATED_BY = lu.USER_NAME 
  left join 
 lateral unnest(string_to_array(t.ASSIGNED_TO, ', ')) as assigned_user_name on true 
 left join LIMS_USERS lu2 on assigned_user_name = lu2.USER_NAME 
where t.CREATED_ON is not null and t.REMOVED = 'F'
and (t.PLAN_NUMBER in 
  (
  select distinct s.T_EM_PLAN from SAMPLE s 
  where s.STATUS in ('U','I','P','C') 
  and s.T_EM_PLAN > 0 
  and s.FACILITY = 'USNC') or t.PLAN_NUMBER not in (select s.T_EM_PLAN from SAMPLE s where s.T_EM_PLAN = t.PLAN_NUMBER)
  ) 
group by 1, 3 --PLAN_NUMBER, CREATED_BY
order by 2 desc, 1 desc  --CREATED_ON, PLAN_NUMBER
