oozie jobs -oozie http://localhost:11000/oozie -kill -filter user=root -jobtype bundle & oozie jobs -oozie http://localhost:11000/oozie -kill -filter user=root -jobtype coordinator & oozie jobs -oozie http://localhost:11000/oozie -kill -filter user=root

sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --delete cdw_branch_import
sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --delete cdw_credit_import
sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --delete cdw_customer_import
sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --delete cdw_time_import

sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop  --create cdw_branch_import -- import -m1 --connect jdbc:mysql://localhost/CDW_SAPP --driver com.mysql.jdbc.Driver --query 'SELECT
 BRANCH_CODE, BRANCH_NAME, BRANCH_STREET,
 BRANCH_CITY, BRANCH_STATE, BRANCH_ZIP, CONCAT("(",SUBSTR(BRANCH_PHONE, 1, 3),")",SUBSTR(BRANCH_PHONE, 4, 3),"-",SUBSTR(BRANCH_PHONE, 7))
 as BRANCH_PHONE,
 LAST_UPDATED
 FROM
 CDW_SAPP_BRANCH WHERE $CONDITIONS' --append --incremental lastmodified --check-column LAST_UPDATED --last-value '0' --target-dir /user/maria_dev/cdw_sapp_branch --outdir java_files --fields-terminated-by '\t'



sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --create cdw_customer_import -- import -m1 --connect jdbc:mysql://localhost/CDW_SAPP --driver com.mysql.jdbc.Driver --query 'SELECT CONCAT(UCASE(MID(FIRST_NAME, 1, 1)),
 LCASE(MID(FIRST_NAME, 2))) AS FIRST_NAME,LCASE(MIDDLE_NAME),
 CONCAT(UCASE(MID(LAST_NAME, 1, 1)),
 LCASE(MID(LAST_NAME, 2))) AS LAST_NAME,
 SSN,
 CREDIT_CARD_NO,
 CONCAT(STREET_NAME, ", ", APT_NO) AS RESIDENCE,
 CUST_CITY,
 CUST_STATE,
 CUST_COUNTRY,
 CUST_ZIP,
 CONCAT("",SUBSTR(CUST_PHONE, 1, 3),"-",SUBSTR(CUST_PHONE, 4)) AS CUST_PHONE,
 CUST_EMAIL,
 LAST_UPDATED
 FROM CDW_SAPP_CUSTOMER WHERE
   $CONDITIONS' --append --incremental lastmodified  --check-column LAST_UPDATED --last-value '0' --target-dir /user/maria_dev/cdw_sapp_customer --outdir java_files --fields-terminated-by '\t'



sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --create cdw_credit_import -- import -m1 --connect jdbc:mysql://localhost/CDW_SAPP --driver com.mysql.jdbc.Driver --query 'SELECT
 TRANSACTION_ID,
 replace(str_to_date(concat(YEAR,"/",MONTH,"/",DAY), "%Y/%m/%d" ) , "-",""),
 CREDIT_CARD_NO,
 CUST_SSN,
 BRANCH_CODE,
 TRANSACTION_TYPE,
 TRANSACTION_VALUE, LAST_UPDATED
 FROM CDW_SAPP_CREDITCARD WHERE $CONDITIONS' --append --incremental lastmodified --check-column LAST_UPDATED --last-value '0' --target-dir /user/maria_dev/cdw_sapp_credit --outdir java_files --fields-terminated-by '\t'


sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --create cdw_time_import -- import -m1 --connect jdbc:mysql://localhost/CDW_SAPP --driver com.mysql.jdbc.Driver --query 'SELECT
 REPLACE(STR_TO_DATE(CONCAT(YEAR, "/", MONTH, "/", DAY), "%Y/%m/%d"),"-",""), DAY, MONTH, CASE WHEN month BETWEEN 1 AND 3 THEN "First" WHEN month BETWEEN 4 AND 6 THEN "Second" WHEN month BETWEEN 7 AND 9 THEN
 "Third" WHEN month BETWEEN 10 AND 12 THEN "Fourth" END, YEAR, Transaction_ID , LAST_UPDATED FROM CDW_SAPP_CREDITCARD WHERE $CONDITIONS' --append --incremental lastmodified --check-column LAST_UPDATED --last-value '0' --target-dir /user/maria_dev/cdw_sapp_time --outdir java_files --fields-terminated-by '\t'


oozie job -oozie http://localhost:11000/oozie -config ~/Documents/casestudy/job.properties -run
