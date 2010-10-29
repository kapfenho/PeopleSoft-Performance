CREATE OR REPLACE PROCEDURE PSFT.STAT_TRANSHIST
AS
BEGIN
   INSERT INTO STAT_TRANSHIST_AVG
      (select  trunc(sysdate-1) as collect_date, 
				pm_context_value1, 
				pm_context_value2, 
				pm_context_value3 , 
				avg(pm_trans_duration) as average, 
				sum(pm_trans_duration * pm_trans_duration) as std_dev, 
				count(*) as counter, 
				sysdate as syncdttm
        from    pspmtrans11_vw -- pspmtranshist
        where   pm_mon_strt_dttm between trunc(sysdate-1) and trunc(sysdate) 
        and     pm_trans_duration < 1000000
        and     pm_agentid in (7,8,45,14,18,22,9,12,13,15,16,21,23,24,28,29,65,10,11,17,19,20,25,26,27,30,33,32,34,37,35,36,39,40,41,42,43,38,44,47,49,51,46,53,50,52,55,56,54,57,60,61,63,66,69,75,84,62,67,68,71,74,77,80,81,82,58,59,64,70,72)
        group by pm_context_value1, pm_context_value2, pm_context_value3);
   COMMIT;
END;
/
