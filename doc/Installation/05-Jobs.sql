


-----------------------------------------
-- create job
--
declare
	vJobNumber binary_integer;
begin
	dbms_job.submit(
		job => vJobNumber,
		next_date => to_date('20110114 07:00', 'YYYYMMDD HH24:MI'),
		interval => 'SYSDATE + 1',
		what => 'begin STAT_TRANSHIST; end;'
	);
	dbms_output.put_line('Job number assigned: ' || to_char(vJobNumber));
end;
/
-----------------------------------------
-- delete job
--
declare
  vJobNumber binary_integer := 122;
begin
  dbms_job.remove(vJobNumber);
end;
/