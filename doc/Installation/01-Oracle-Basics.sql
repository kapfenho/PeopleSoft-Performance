#########################################################
## Create Oracle tablespace and user/schema for 
## this application.
## All app specific objects will reside in this schema
## This user needs the grants (stated below) to the 
## PeopleSoft Perforance Monitor tables to fetch the data

## The details given here shall be modified to fulfil
## specific requirements (passwords, tablespaces, etc.)
##


CREATE TABLESPACE PPERF
	LOGGING
	DATAFILE '/appl/PSPFP01/u01/PSPFP01_pperf01.dbf' 
	SIZE 262144K AUTOEXTEND ON NEXT 5120K MAXSIZE 33554416K
	EXTENT MANAGEMENT LOCAL
	ONLINE
	SEGMENT SPACE MANAGEMENT AUTO
	BLOCKSIZE 8K
;

CREATE USER PPERF IDENTIFIED BY PPERF
	DEFAULT TABLESPACE PPERF
	TEMPORARY TABLESPACE TEMP
	PROFILE DEFAULT
;
GRANT PSADMIN TO PPERF
;
ALTER USER PPERF 
	QUOTA UNLIMITED ON PPERF 
;

GRANT SELECT ON PSFT.PSPMTRANSHIST  TO PPERF;
GRANT SELECT ON PSFT.PSPMTRANS11_VW TO PPERF;
