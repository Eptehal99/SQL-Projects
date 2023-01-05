--SQL Functions and Triggers
create or replace function abc(channel_type TEXT)
return double PRECISION
as $channel_avg$ 

DECLARE channel_avg double precision;

begin 

select avg(sales_amount) into 
channel_avg from sales
where channel=channel_type;
return channel_avg;

end; $channel_avg$
language plpgsql;	

------	
create or replace function abc(--variable function takes in as input)
return double PRECISION
as
-- here you can declare any variables that you'll use b/w begin and end
begin 
-- write sql statements (select statements)/whatever you want to preform
end; --$variable function will return/you delcared$
	
-- slide 6 create a fxn called max_Sale that does not take any input, but returns double precision value called big_sale
create or replace function max_sale()
returns double precision  
AS $big_sale$ --Q U E S T I O N: what are these dollar signs doing?
	
declare big_sale double precision;
begin 
select max(sales_amount) INTO 
	big_sale from sales;
return big_sales;
end; $big_sale$
language plpgsql
	
--calling the function
select max_sale();
	
select max(sales_amount)
from sales;
ABORT
	
	
-- slide 9-10
create or replace function avg_sales(channel_type text)
returns double PRECISION
as $channel_avg$
declare channel_avg double precision;
begin 
select AVG(sales_amount) into channel_avg from sales
where channel = channel_type;
return channel_avg;
end; $channel_avg$
language plpgsql
--calling fxn
select avg_sales('dealership');

--slide 11 Q U E S T I O N: function not working
create or replace function avg_sales_window(date date)
returns double precision
as $channel_avg$
declare channel_avg double precision;
begin 
select avg(sales_amount) into channel_avg from sales
where date_added = '2013-04-12 00:00:00'
return channel_avg;
end $channel_avg$
language plpgsql

select date_added from customers;
	
CREATE PROCEDURE procedure_name(arguments)
AS $proc_label$
DECLARE <some variables>;
BEGIN
<procedure statements>;
END; $proc_label$
LANGUAGE PLPGSQL;

CALL procedure_name();
 
	
create or replace procedure product_cate(product_type text)
as $$
BEGIN
select avg(base_msrp) as avg_base_msrp, case
when base_msrp = 1.1*avg(base_msrp) then 'high'
when base_msrp < 0.9*avg(base_msrp) then 'low'
else 'average' end as pricecategory
from products; 
end; $$
language plpgsql;
	
call product_cate('scooter');

create table d_products as select * from products;
alter table d_products add cat text; --created an empty column
select * from d_products;


