#########################################################
## Those are views used by the rails application 
## to represent the data - check in the rails soure code
##
## Create with user PPERF

CREATE OR REPLACE VIEW TRANSGROUP_AVG ( TRANSACTION_GROUP_ID, COLLECT_DATE, COUNTER, SUM_AVG, MIN_COUNTER, MAX_COUNTER )
AS
select	s.TRANSACTION_GROUP_id, top.collect_date , count(1), sum(top.average), min (top.counter), max(top.counter)
from	STAT_TRANSHIST_AVG top, 
		TRANSACTION_GROUP_ITEMS s
/* where	top.PM_CONTEXT_VALUE1 = s.PM_CONTEXT_VALUE1
and		top.PM_CONTEXT_VALUE2 = s.PM_CONTEXT_VALUE2
and		top.PM_CONTEXT_VALUE3 = s.PM_CONTEXT_VALUE3 */
where	top.SYSTEM_NAME = s.SYSTEM_NAME
and		top.PM_TRANSACTION = s.PM_TRANSACTION
and		top.counter > 3
--and		top.collect_date > sysdate - 90
group by s.TRANSACTION_GROUP_id, top.collect_date
;


CREATE OR REPLACE VIEW TRANSHIST_TOP_AVG ( SYSTEM_NAME, PM_TRANSACTION, SUM_AVG, STD_DEV, MEDIAN, MEDIAN1, MEDIAN2, MEDIAN3, COUNTER, MIN, MAX, DESCRIPTION )
AS
select	
			top.SYSTEM_NAME,
			top.PM_TRANSACTION,
			top.average as sum_avg,
			top.std_dev,
			top.median,
			top.median1,
			top.median2,
			top.median3,
			top.counter,
			top.min,
			top.max,
			(	select trans.description from transactions trans
				where top.SYSTEM_NAME = trans.SYSTEM_NAME
				and top.PM_TRANSACTION = trans.PM_TRANSACTION) as description
		from  STAT_TRANSHIST_AVG top
		where COLLECT_DATE = (select max(b.COLLECT_DATE) from STAT_TRANSHIST_AVG b where b.system_name = top.system_name)
	--  and   top.counter > 3
order by sum_avg desc
;
