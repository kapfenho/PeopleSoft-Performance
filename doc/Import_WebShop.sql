---------------------------------------
-- create the import statements

select 'INSERT INTO STAT_TRANSHIST_AVG values (to_date(''' || 
		to_char(COLLECT_DATE, 'YYYYMMDD') || ''',''YYYYMMDD''), ''WSHOP'', ''' || 
		PM_CONTEXT_VALUE1 || ''',' || AVERAGE || ',' || STD_DEV || ',' ||
		decode (median, NULL, 'NULL', median ) || ',NULL,NULL,NULL,' || COUNTER || ',to_date(''' || 
		to_char(SYNCDTTM, 'YYYYMMDD') || ''',''YYYYMMDD''),' || MIN || ',' || MAX || ')'
from stat_transhist_avg
-- where median is not null
/
---------------------------------------
-- create new entries
begin
for i in -16..-1 loop
  STAT_TRANSHIST(sysdate+i);
  DBMS_OUTPUT.PUT_LINE (sysdate+i);
end loop;
end;
/