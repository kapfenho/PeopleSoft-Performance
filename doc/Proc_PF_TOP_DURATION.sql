CREATE OR REPLACE PROCEDURE PSFT.PF_TOP_DURATION
AS
BEGIN
   INSERT INTO aa_top_duration
      (SELECT   /*+ FIRST_ROWS */
                TRUNC (SYSDATE) AS transdate,
                AVG (pm_trans_duration) AS average,
                SUM (pm_trans_duration * pm_trans_duration) AS weighted,
                COUNT (*) AS counter, pm_context_value1, pm_context_value2,
                pm_context_value3
           FROM pspmtrans11_vw
          WHERE pm_mon_strt_dttm >= TRUNC (SYSDATE)
            AND pm_mon_strt_dttm <= (TRUNC (SYSDATE) + (23 / 24))
            AND pm_agentid IN
                   (7,
                    8,
                    45,
                    14,
                    18,
                    22,
                    9,
                    12,
                    13,
                    15,
                    16,
                    21,
                    23,
                    24,
                    28,
                    29,
                    65,
                    10,
                    11,
                    17,
                    19,
                    20,
                    25,
                    26,
                    27,
                    30,
                    33,
                    32,
                    34,
                    37,
                    35,
                    36,
                    39,
                    40,
                    41,
                    42,
                    43,
                    38,
                    44,
                    47,
                    49,
                    51,
                    46,
                    53,
                    50,
                    52,
                    55,
                    56,
                    54,
                    57,
                    60,
                    61,
                    63,
                    66,
                    69,
                    75,
                    84,
                    62,
                    67,
                    68,
                    71,
                    74,
                    77,
                    80,
                    81,
                    82,
                    58,
                    59,
                    64,
                    70,
                    72
                   )
       GROUP BY pm_context_value1, pm_context_value2, pm_context_value3
         HAVING COUNT (*) > 9);

   COMMIT;
END;
/
