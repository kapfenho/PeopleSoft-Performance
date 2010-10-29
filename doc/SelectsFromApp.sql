-----------------------------------
-- STATS
SELECT "TRANSHIST_TOP_AVG".*  FROM "TRANSHIST_TOP_AVG" 
WHERE (rownum < 101)

-- STATS -> Graph
SELECT "STAT_TRANSHIST_AVG".* FROM "STAT_TRANSHIST_AVG" 
WHERE (pm_context_value1 = 'AT_CMP_LOGIST_SRCH.GBL' 
  AND pm_context_value2 = 'AT_PG_LOGISTICSDET' 
  AND pm_context_value3 = 'Click PeopleCode Command Button for Field AT_LOGISTIC_WRK.DETAIL_PB' 
  and counter > 1 
  and collect_date > sysdate - 40)
ORDER BY collect_date ASC

-----------------------------------
-- TRANS_GROUPS -> select one group
SELECT "TRANSGROUP_AVG".*     FROM "TRANSGROUP_AVG" 
WHERE (TRANSACTION_GROUP_ID = '10001') 
ORDER BY COLLECT_DATE ASC

-- TRANS_GROUPS -> select one group -> select one trans
SELECT "STAT_TRANSHIST_AVG".* FROM "STAT_TRANSHIST_AVG" 
WHERE (pm_context_value1 = 'AT_360_CMP.GBL' 
  AND pm_context_value2 = 'AT_360_PG' 
  AND pm_context_value3 = 'Launch Page/Search Page' 
  and counter > 1 
  and collect_date > sysdate - 40) 
ORDER BY collect_date ASC
