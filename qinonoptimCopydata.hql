use cdw_sapp;
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;

insert OVERWRITE TABLE BRANCH_PARTITION partition(branch_state) select
		branch_code, branch_name, branch_street, branch_city,
			 branch_zip, branch_phone, last_updated, branch_state
FROM CDW_Sapp_Branch;

INSERT OVERWRITE TABLE CREDIT_PARTITION partition(transaction_type) SELECT
								transaction_Id, timeid,
										credit, ssn, branch_code, transaction_value,
											last_updated,
									transaction_type
FROM CDW_Sapp_Credit;

INSERT OVERWRITE TABLE CUSTOMER_PARTITION partition(cu_state) SELECT
								fname, mname, lname,
									ssn, credit, address,
									cu_city, cu_country,
									cu_zip, cust_phone, cust_email,
												last_updated, cu_state
FROM CDW_Sapp_Customer;

INSERT OVERWRITE TABLE TIME_PARTITION partition(quarter) SELECT
								timeid, day, month, year,
								transactionid, last_updated, quarter
FROM CDW_Sapp_Time;
