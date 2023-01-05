select * from products;
select * from order_info;
select * from customers;

-- inspecting functions 
--[go to functions, highlight the function of interest, right click and hit properties, then tab -> code]

--slide 24 example | trying out functions | creating triggers & updating fields
select insert_order(4,'MON636', 10)
select * from order_info;
-- Update (and review) the products table to account for the newly sold 10 Red 
--Herrings using the update_stock function:
select update_stock();
select * from products;

-- creating a trigger that will do the above automatically
-- first drop fxn we have to return a trigger, it can't be used for trigger since it is not a trigger fxn
--return it rather as a trigger fxn
drop function update_stock();

--creating a trigger function
create function update_stock() returns 
trigger as $stock_trigger$
declare
stock_qty integer; --stock_qty is the trigger fxn variable
begin
stock_qty := get_stock(new.product_code) - new.qty; --new info that triggers this fxn, whenever the trigger is fired the new is created.
--in order to refer to this new info, we use the new keyword, theres also an 'all' keyword
update products set stock=stock_qty
where product_code=new.product_code; --refering to the newly created order
return new;
end; $stock_trigger$
language PLPGSQL;

---- We want the trigger to occur AFTER an INSERT operation on the order_info table. For each row, we want to 
--execute the newly modified update_stock function to update the stock values in the product table:
--creating the trigger
create trigger update_trigger
after insert on order_info
for each row
execute procedure update_stock();

--testing the trigger:
select * from order_info;
select * from products;
select insert_order(4, 'MON123', 2); --using insert_order fxn
select * from order_info;
select * from products;

-- Exercise: slide 30-34 I need help with the previous and this excercise
--must redo it at least twice before hand. 
--Creating a Trigger to Track Average Purchases
-- Create a new table called avg_qty_log that is composed of an 
--order_id integer field and an avg_qty double precision field
create table dl.avg_qty_log select order_id, avg(qty)
create table dl.avg_qty_log select order_id avg(qty) from order_id;
where order_id = double precision  


