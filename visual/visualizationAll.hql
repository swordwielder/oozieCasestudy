USE cdw_sapp;

select sum(c.transaction_value) as val, b.branch_zip from CREDIT_PARTITION c
join BRANCH_PARTITION b on (c.branch_code = b.branch_code)
group by b.branch_zip
order by val desc
limit 20;

select sum(TRANSACTION_VALUE) AS VALUE, transaction_type, quarter from CREDIT_PARTITION
join TIME_PARTITION on CREDIT_PARTITION.transaction_id = TIME_PARTITION.transactionid
group by quarter, transaction_type;
