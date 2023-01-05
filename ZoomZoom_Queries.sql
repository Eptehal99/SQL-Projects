-- Examining the Data
select * 
from dealerships
where state = 'CA'
;

--Hard coded list of salespeople --> potential for inefficienies 
select * 
from salespeople
where dealership_id in (2,5)
order by 1
;
--least/greatest condition
select product_id, model, year, product_type,
least(600.00, base_msrp) as base_msrp,
production_start_date,
production_end_date
from products
where product_type='scooter'
order by 1;

--alternatviely use case-when-else method, you can use UNION too
select product_id, model, year, product_type,
case when base_msrp>600 then 600.00
else base_msrp end as base_msrp,
production_start_date,
production_end_date
from products
where product_type='scooter'
order by 1;

--casting column::datatype
select product_id, model, year::text, base_msrp,production_start_date, production_end_date
from products;

--distinct and distinct on
--for unique values
select distinct year
from products
order by 1
;

--Final Excercise
--Defining Fxns in SQL Lecture --
create function fixed_val() returns integer as 
$$ 
begin 
return 1;
end; 
$$
language plpgsql;

select * from fixed_val();

--investigating how to use fxn with query table
select first_name, fixed_val()
from customers;

-- creating fxn without arguments
create function num_samples() returns 
integer as  $total$
declare total integer; --declaring/creating a variable to store the integer
begin --going into what the function will actually do check yt or textbook
select count(*) into total from
sales; --from table sales
return total;
end; $total$
language PLPGSQL;

select num_samples();

--Excercise, defining a maximum sale function
drop function max_sale() --deleting the function to create the new correct one.
create or replace function max_sale() returns 
double precision as  
$big_sale$ --profs format
declare big_sale double precision; 
begin 
select max(sales_amount) into big_sale from sales; --from table sales
return big_sale;
end; 
$big_sale$ --profs format
language PLPGSQL;

select max_sale();
--create or replace function use this when you are not sure if the function already exists. 

-- creating functions with arguments
create function avg_sales(channel_type text) returns double precision as $channel_avg$
declare channel_avg double precision; --why didn't we use decimal instead of double precision, --doule precioicon because we don't know the nature of the data and decimal we had to assign dp
begin 
select avg(sales_amount) into
channel_avg from sales where 
channel=channel_type;
return channel_avg;
end;
$channel_avg$
language plpgsql
--testing our fxn
select avg_sales('internet')
select avg_sales('dealership')

select avg(sales_amount), channel from sales group by channel;
select * from sales; -- the function is not a column, so you won't find it in the table 

-- creating a function over a time window here we have more than 1 argument specifically here we use 2 arguments
create function avg_sales_window(from_date date, to_date date) returns double precision as 
$$
declare sales_avg double precision; 
begin 
select avg(sales_amount) into sales_avg from sales
where sales_transaction_date >= from_date and 
sales_transaction_date <= to_date;
return sales_avg;
end;
$$ -- why no label?
language plpgsql
--he posted the soltion to class exercises above.
--testing our fxn
select avg_sales_window('2013-04-12', '2014-04-12')

--Procedures in SQL
--What are procedures in sql?
--how do you update the table everytime we add a new record? using trigger or procedures?
create procedure some_procedure_name
(procedure_arguments)
as $proc_label$
declare <some variables>;
begin 
<procedure statements>;
end; $proc_label$
language PLPGSQL;
call some_procedure_name(); 
--a final type of question, trick was to use the width/where?
create table dl_products as select * from products;
alter table dl_products and cat test;
select * from dl_products;

create as 
create procedure adding_products
(arguments) as 
$$
declare pricecategory varbinary;
begin

end;
$$
language plpgsql
call adding_products();
$$


--nov 21 class 

--slide 5
SELECT 
latitude,
longitude
FROM customers;

--install and re-install in each database you use
CREATE EXTENSION cube;
CREATE EXTENSION earthdistance;

SELECT point(longitude, latitude)
FROM customers;

SELECT 
point(-90, 38) <@> point(-91, 37) 
AS distance_in_miles;

SELECT 
(point(-90, 38) <@> point(-91,  --<@> distance b/w left and right points
37)) * 1.609344 AS distance_in_kms;

--slide 9 Example: Closest Dealership | identify the closest dealership to each customer
CREATE TEMP TABLE customer_points AS(
SELECT
customer_id,
point(longitude, latitude) AS 
lng_lat_point
FROM customers
WHERE longitude IS NOT NULL AND latitude IS NOT NULL
);

--looking at the temp table
select * from customer_points;

--(slide 11) do same thing for dealerships
CREATE TEMP TABLE dealership_points
AS (
SELECT
dealership_id,
point(longitude, latitude) AS 
lng_lat_point
FROM dealerships
);

select * from dealership_points;

--slide 12
CREATE TEMP TABLE 
customer_dealership_distance AS ( 
SELECT customer_id, dealership_id,
c.lng_lat_point <@> d.lng_lat_point AS distance 
FROM customer_points c 
CROSS JOIN dealership_points d
);

select * from customer_dealership_distance;

CREATE TEMP TABLE closest_dealerships
AS (
SELECT DISTINCT ON (customer_id) --distinct on will select the distinct one row of customer for each search distinct on you can specify which col we want to be distinct
customer_id, dealership_id, distance 
FROM customer_dealership_distance
ORDER BY customer_id, distance -- since we're ordering it in ascending order: smallest to largest, by customer distance
); -- or you can group by and use min aggerate function

select * from closest_dealerships;

--Calculate the average distance from each customer to their closest dealership
SELECT 
AVG(distance) AS avg_dist,
PERCENTILE_CONT(0.5) WITHIN GROUP --percentile cont for continuous function, within group an alternative to group by used alone
(ORDER BY distance) AS median_dist
FROM closest_dealerships
group by dealership_id order by avg_dist;
-- 

-- window frame example 2
--look at sales in this 30 day window.
