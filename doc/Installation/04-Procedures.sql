#########################################################
## All Oracle procedures for importing the data.
## The last procedure RUN_IMPORTS will be added as a
## DBA_JOB and will call the other ones.
##
## What jobs do we have here:
## STAT_TRANSHIST
##    read the PeopleSoft Performance Monitor data for 
##    online transactions performance
## GET_PSFT_BATCH
##    read the performance data of the batch jobs 
##    which is the process scheduler data
## GET_PSFT_EXTCALLS
##    reads the performance data of the external system
##    which is Integration Gateway Sync Calls
## GET_SELFCARE & GET_WEBSHOP
##    sample implementation, how to add other
##    applications to show their performance data

#########################################################
## The main PeopleSoft performance monitor data
## Here it is read from a different schema in the 
## same database. However you can use a database 
## link as well, reading from a different database.

CREATE PROCEDURE PPERF.STAT_TRANSHIST
AS
BEGIN
   INSERT INTO STAT_TRANSHIST_AVG
	-- (collect_date, system_name, pm_transaction, average, std_dev, median, median1, median2, median3, counter, syncdttm, min, max)
	-- values
    (select  trunc(sysdate-1) as collect_date,
				'PSFT-OL' as system_name,
				pm_context_value1 || '--' || 
				pm_context_value2 || '--' || 
				pm_context_value3 as pm_transaction, 
				avg(pm_trans_duration) as average, 
				sum(pm_trans_duration * pm_trans_duration) as std_dev, 
				PERCENTILE_CONT(0.5 ) WITHIN GROUP (ORDER BY pm_trans_duration DESC) as median, 
				NULL, 
				NULL, 
				NULL, -- 0 as median,
				count(*) as counter, 
				sysdate as syncdttm,
				min(pm_trans_duration) as min,
				max(pm_trans_duration) as max
        from    psft.pspmtrans11_vw -- pspmtranshist
        where   pm_mon_strt_dttm between trunc(sysdate-1) and trunc(sysdate) 
        and     pm_trans_duration < 1000000
        and     pm_agentid in (7,8,45,14,18,22,9,12,13,15,16,21,23,24,28,29,65,10,11,17,19,20,25,26,27,30,33,32,34,37,35,36,39,40,41,42,43,38,44,47,49,51,46,53,50,52,55,56,54,57,60,61,63,66,69,75,84,62,67,68,71,74,77,80,81,82,58,59,64,70,72)
        group by pm_context_value1, pm_context_value2, pm_context_value3);
   COMMIT;
EXCEPTION  -- exception handlers begin
	WHEN DUP_VAL_ON_INDEX THEN
		rollback;
		insert into stats_import_log (dttm, message, error) 
			values (sysdate, 'ERROR: Duplicate value on index', '1');
		commit;
	WHEN OTHERS THEN  -- handles all other errors
		rollback;
		insert into stats_import_log (dttm, message, error) 
			values (sysdate, 'ERROR: Unknown error', '2');
		commit;

END;
/

#########################################################


CREATE PROCEDURE PPERF.GET_PSFT_BATCH
AS
BEGIN
	insert into STAT_TRANSHIST_AVG  (
	select
		trunc(cast(BEGINDTTM as date)) as collect_date,
		'PSFT-BT' as system_name,
		PRCSNAME as PM_TRANSACTION,
		avg( (cast(ENDDTTM as date) - cast(BEGINDTTM as date ))	)*86400000 as AVERAGE, 
		sum( (cast(ENDDTTM as date) - cast(BEGINDTTM as date ))*86400000 *
		     (cast(ENDDTTM as date) - cast(BEGINDTTM as date ))*86400000	) as STD_DEV, 
		PERCENTILE_CONT(0.5 ) WITHIN GROUP (ORDER BY ((cast(ENDDTTM as date) - cast(BEGINDTTM as date ))*86400000) DESC) as MEDIAN,
		NULL as MEDIAN1,
		NULL as MEDIAN2,
		NULL as MEDIAN3,
		count(1) as counter,
		sysdate as syncdttm,
		min(cast(ENDDTTM as date) - cast(BEGINDTTM as date ))*86400000 as min,
		max(cast(ENDDTTM as date) - cast(BEGINDTTM as date ))*86400000 as max
	from	psprcsrqst@pscrp01
	where	BEGINDTTM between trunc(sysdate-1) and trunc(sysdate)
	and		runstatus = 9
	group by trunc(cast(BEGINDTTM as date)), PRCSNAME);
   COMMIT;
EXCEPTION  -- exception handlers begin
	WHEN DUP_VAL_ON_INDEX THEN
		rollback;
		insert into stats_import_log (dttm, message, error) 
			values (sysdate, 'ERROR: Duplicate value on index', '1');
		commit;
	WHEN OTHERS THEN  -- handles all other errors
		rollback;
		insert into stats_import_log (dttm, message, error) 
			values (sysdate, 'ERROR: Unknown error', '2');
		commit;

END;
/

#########################################################


CREATE PROCEDURE PPERF.GET_PSFT_EXTCALLS
AS
BEGIN
insert into STAT_TRANSHIST_AVG  (
select  trunc(cast(PUBLISHTIMESTAMP as date)) as collect_date,
		'PSFT-EX' as system_name,
		PUBNODE || '--' || IB_OPERATIONNAME as PM_TRANSACTION,
		avg( (cast(LASTUPDDTTM as date) - cast(PUBLISHTIMESTAMP as date ))	)*86400000 as AVERAGE, 
		sum( (cast(LASTUPDDTTM as date) - cast(PUBLISHTIMESTAMP as date ))*86400000 *
		     (cast(LASTUPDDTTM as date) - cast(PUBLISHTIMESTAMP as date ))*86400000	) as STD_DEV, 
		PERCENTILE_CONT(0.5 ) WITHIN GROUP (ORDER BY ((cast(LASTUPDDTTM as date) - cast(PUBLISHTIMESTAMP as date ))*86400000) DESC) as MEDIAN,
		NULL as MEDIAN1,
		NULL as MEDIAN2,
		NULL as MEDIAN3,
		count(1) as counter,
		sysdate as syncdttm,
		min(cast(LASTUPDDTTM as date) - cast(PUBLISHTIMESTAMP as date ))*86400000 as min,
		max(cast(LASTUPDDTTM as date) - cast(PUBLISHTIMESTAMP as date ))*86400000 as max
from	psibloghdr@pscrp01
where	PUBLISHTIMESTAMP between trunc(sysdate-1) and trunc(sysdate)
group by trunc(cast(PUBLISHTIMESTAMP as date)), PUBNODE || '--' || IB_OPERATIONNAME );
   COMMIT;
EXCEPTION  -- exception handlers begin
	WHEN DUP_VAL_ON_INDEX THEN
		rollback;
		insert into stats_import_log (dttm, message, error) 
			values (sysdate, 'ERROR: Duplicate value on index', '1');
		commit;
	WHEN OTHERS THEN  -- handles all other errors
		rollback;
		insert into stats_import_log (dttm, message, error) 
			values (sysdate, 'ERROR: Unknown error', '2');
		commit;
END;
/

#########################################################



CREATE PROCEDURE PPERF.GET_SELFCARE
AS
BEGIN
	insert into STAT_TRANSHIST_AVG 
	(collect_date, system_name, PM_TRANSACTION, AVERAGE, STD_DEV, MEDIAN, MEDIAN1, MEDIAN2, MEDIAN3, counter, syncdttm, min, max) 
 (
select
		collect_date as collect_date,
		'SCARE' as system_name,
		PM_CONTEXT_VALUE1 as PM_TRANSACTION,
		AVERAGE as AVERAGE, 
		STD_DEV as STD_DEV, 
		MEDIAN as MEDIAN,
		NULL as MEDIAN1,
		NULL as MEDIAN2,
		NULL as MEDIAN3,
		COUNTER as counter,
		sysdate as syncdttm,
		min as min,
		max as max
	from	stat_transhist_avg@WEBPTP02
	where	collect_date >= trunc(sysdate - 1)
	and		system = 'SELFCARE'
) ;
   COMMIT;
EXCEPTION  -- exception handlers begin
	WHEN DUP_VAL_ON_INDEX THEN
		rollback;
		insert into stats_import_log (dttm, message, error) 
			values (sysdate, 'ERROR: Duplicate value on index', '1');
		commit;
	WHEN OTHERS THEN  -- handles all other errors
		rollback;
		insert into stats_import_log (dttm, message, error) 
			values (sysdate, 'ERROR: Unknown error', '2');
		commit;
END;
/

#########################################################



CREATE PROCEDURE PPERF.GET_WEBSHOP
AS
BEGIN
	insert into STAT_TRANSHIST_AVG 
	(collect_date, system_name, PM_TRANSACTION, AVERAGE, STD_DEV, MEDIAN, MEDIAN1, MEDIAN2, MEDIAN3, counter, syncdttm, min, max) 
 (
select
		collect_date as collect_date,
		'WSHOP' as system_name,
		PM_CONTEXT_VALUE1 as PM_TRANSACTION,
		AVERAGE as AVERAGE, 
		STD_DEV as STD_DEV, 
		MEDIAN as MEDIAN,
		NULL as MEDIAN1,
		NULL as MEDIAN2,
		NULL as MEDIAN3,
		COUNTER as counter,
		sysdate as syncdttm,
		min as min,
		max as max
	from	stat_transhist_avg@WEBPTP02
	where	collect_date >= trunc(sysdate - 1)
	and		system = 'WEBSHOP'
) ;
   COMMIT;
EXCEPTION  -- exception handlers begin
	WHEN DUP_VAL_ON_INDEX THEN
		rollback;
		insert into stats_import_log (dttm, message, error) 
			values (sysdate, 'ERROR: Duplicate value on index', '1');
		commit;
	WHEN OTHERS THEN  -- handles all other errors
		rollback;
		insert into stats_import_log (dttm, message, error) 
			values (sysdate, 'ERROR: Unknown error', '2');
		commit;
END;
/

#########################################################



CREATE PROCEDURE PPERF.RUN_IMPORTS
AS
BEGIN
	insert into stats_import_log (dttm, message, error)
		values (sysdate, 'Begin import job', '0');
	commit;

	begin 
		insert into stats_import_log (dttm, message, error) 
			values (sysdate, 'Step 1 - import PSFT-OL start', '0');
		commit;
		STAT_TRANSHIST;
		insert into stats_import_log (dttm, message, error)
			values (sysdate, 'Step 1 - import PSFT-OL end', '0');
		commit;
	end;

	begin 
		insert into stats_import_log (dttm, message, error) 
			values (sysdate, 'Step 2 - import PSFT-BT start', '0');
		commit;
		GET_PSFT_BATCH;
		insert into stats_import_log (dttm, message, error)
			values (sysdate, 'Step 2 - import PSFT-BT end', '0');
		commit;
	end;

	begin 
		insert into stats_import_log (dttm, message, error) 
			values (sysdate, 'Step 3 - import PSFT-EX start', '0');
		commit;
		GET_PSFT_EXTCALLS;
		insert into stats_import_log (dttm, message, error)
			values (sysdate, 'Step 3 - import PSFT-EX end', '0');
		commit;
	end;

	begin 
		insert into stats_import_log (dttm, message, error) 
			values (sysdate, 'Step 4 - import SCARE start', '0');
		commit;
		GET_SELFCARE;
		insert into stats_import_log (dttm, message, error)
			values (sysdate, 'Step 4 - import SCARE end', '0');
		commit;
	end;

	begin 
		insert into stats_import_log (dttm, message, error) 
			values (sysdate, 'Step 5 - import WSHOP start', '0');
		commit;
		GET_WEBSHOP;
		insert into stats_import_log (dttm, message, error)
			values (sysdate, 'Step 5 - import WSHOP end', '0');
		commit;
	end;
	
	insert into stats_import_log (dttm, message, error)
		values (sysdate, 'End import job', '0');

   COMMIT;
END;
/
