create table CustPeriodService (
customerID char(6),
periodID char(3),
serviceID char(6),
serviceType char(1)
);

create table customer(customerID char(6));
create table period (periodID char(3));

create table cstr_prd_bb as 
select p.periodID, c.customerID
from period as p
cross join 
customer as c
order by customerID, periodID;

select *
from cstr_prd_bb;

select serviceID, count(*) as cnt
from custperiodservice
group by serviceID
order by cnt DESC;


create temporary table t1 as 
select *,
case when serviceID = 'INT' then 1 else 0 end as srv_INT_fl,
case when serviceID = 'Phone' then 1 else 0 end as srv_Phone_fl,
case when serviceID = 'TV' then 1 else 0 end as srv_TV_fl,
case when serviceID = 'Mobile' then 1 else 0 end as srv_Mobile_fl
from custperiodservice;

select *
from t1;

CREATE TEMPORARY TABLE t2 AS
SELECT customerID, periodID,
SUM(srv_INT_fl) AS srv_INT_n,
SUM(srv_Phone_fl) AS srv_Phone_n,
SUM(srv_TV_fl) AS srv_TV_n,
SUM(srv_Mobile_fl) AS srv_Mobile_n
FROM t1
GROUP BY customerID, periodID;

SELECT * FROM t2;

create temporary table t3 as select * from t2;
--DROP TABLE t1;

--Adding Period-Level service Activity Flags
CREATE TEMPORARY TABLE t4 AS
SELECT *,
CASE WHEN srv_INT_n>=1 THEN 1 ELSE 0 END AS 
srv_INT_fl,
CASE WHEN srv_Phone_n>=1 THEN 1 ELSE 0 END AS 
srv_Phone_fl,
CASE WHEN srv_TV_n>=1 THEN 1 ELSE 0 END AS srv_TV_fl,
CASE WHEN srv_Mobile_n>=1 THEN 1 ELSE 0 end as 
srv_Mobile_fl
FROM t3;

SELECT * FROM t4;

--Determine Period-Level Service Activity Flags (Short Version):
CREATE TEMPORARY TABLE t5 AS
SELECT customerID, periodID,
MAX(srv_INT_fl) AS srv_INT_fl,
MAX(srv_Phone_fl) AS srv_Phone_fl,
MAX(srv_TV_fl) AS srv_TV_fl,
MAX(srv_Mobile_fl) AS srv_Mobile_fl
FROM t1
GROUP BY customerID, periodID;

SELECT * FROM t5;

-- Left Join
CREATE TABLE cstr_prd_bb_srv AS
SELECT cpbb.*, 
t4.srv_INT_fl, t4.srv_Phone_fl, 
t4.srv_TV_fl, t4.srv_Mobile_fl 
FROM cstr_prd_bb cpbb LEFT JOIN t4
ON cpbb.customerID=t4.customerID AND 
cpbb.periodID=t4.periodID;
SELECT * FROM cstr_prd_bb_srv;

--Replacing NULLs with Zeros Using Coalesce
UPDATE cstr_prd_bb_srv SET
srv_INT_fl=COALESCE(srv_INT_fl,0), 
srv_TV_fl=COALESCE(srv_TV_fl,0),
srv_Phone_fl=COALESCE(srv_Phone_fl,0), 
srv_Mobile_fl=COALESCE(srv_Mobile_fl,0);

SELECT * FROM cstr_prd_bb_srv;

-- Creating New Categorical Variable 'Product'
--Use CASE...WHEN sql statement to create Product variable
CREATE TABLE cstr_prd_bb_srv_prod AS 
SELECT *, CASE
WHEN srv_INT_fl+srv_TV_fl+srv_Phone_fl+srv_Mobile_fl=4 THEN 
'4srvBNDL'
WHEN srv_INT_fl+srv_TV_fl+srv_Phone_fl+srv_Mobile_fl=3 THEN 
'3srvBNDL'
WHEN srv_INT_fl+srv_TV_fl+srv_Phone_fl+srv_Mobile_fl=2 THEN 
'2srvBNDL'
WHEN srv_INT_fl+srv_TV_fl+srv_Phone_fl+srv_Mobile_fl=1 THEN 
'1srvOnly'
ELSE 'Inactive' END AS product --new column name
FROM cstr_prd_bb_srv;

SELECT * FROM cstr_prd_bb_srv_prod;

--[CLASS]report on the number of customers by period by product
create table product_report as 
select periodID, product, count(*) as n_customers
from cstr_prd_bb_srv_prod
group by periodID, product
order by periodID, product
;

select * 
from product_report;