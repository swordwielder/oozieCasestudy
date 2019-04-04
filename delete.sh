oozie jobs -oozie http://localhost:11000/oozie -kill -filter user=root -jobtype bundle & oozie jobs -oozie http://localhost:11000/oozie -kill -filter user=root -jobtype coordinator & oozie jobs -oozie http://localhost:11000/oozie -kill -filter user=root

sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --delete cdw_branch_import
sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --delete cdw_credit_import
sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --delete cdw_customer_import
sqoop job --meta-connect jdbc:hsqldb:hsql://localhost:16000/sqoop --delete cdw_time_import
