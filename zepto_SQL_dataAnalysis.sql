-- GOOD PRACTICE
drop table if exists zepto;

-- CREATING TABLE
create table zepto(
sku_id serial primary key,
category varchar(120),
name varchar(150) not null,
mrp	numeric(8,2),
discountPercent numeric(5,2),
availableQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms integer,
outOfStock boolean,
quantity integer
);

-- EXPLORING DATA
-- COUNT OF ROWS
select count(*) from zepto;
-- SAMPLE DATA
select * from zepto limit 5;
-- Checking Null Values
select * from zepto where name is null
OR
category is null
OR
mrp is null
OR
discountpercent is null
OR
availablequantity is null 
OR
weightingms is null
OR
outofstock is null
OR
quantity is null;
-- DIIFRENT CATEGORIES
select distinct category from zepto order by category;
-- PRODUCTS IN STOCK & OUT OF STOCK
select outofstock,count(sku_id)
from zepto
group by outofstock;
-- product name present multiple time
select name,count(sku_id)
from zepto
group by name 
having count(sku_id)>1
order by count(sku_id) desc;

-- DATA CLEANING
-- PRODUCTS WITH PRICE = 0
select * from zepto where mrp =0;
-- THIS IS NOT POSSIBLE SO DELETE THS ROW
delete from zepto where mrp=0;
-- CONVERTIG PAISE TO RUPEES
update zepto
set mrp=mrp/100,
discountedsellingprice=discountedsellingprice/100;
-- CHECK THE UPDATED ONE 
select mrp,discountedsellingprice from zepto;

-- BUSINESS ANALYSIS
--Q1.Find the top 10 best-value products based on the discount percentage
select name,mrp,discountpercent 
from zepto
order by discountpercent desc
limit 10;
--Q2.What are the Products with High MRP but Out of Stock 
select distinct name,mrp,outofstock
from zepto
where outofstock=true and mrp>300
order by mrp desc;
--Q3.Calculate Estimated Revenue for each category
select category,sum(discountedsellingprice*availablequantity) as total_revenue
from zepto
group by category
order by total_revenue;
--Q4.Find all products where MRP is greater than ₹500 and discount is less than 10%.
select distinct name,mrp,discountpercent
from zepto
where mrp>500 and discountpercent<10
order by mrp desc,discountpercent desc;
--Q5.Identify the top 5 categories offering the highest average discount percentage. 
select category,ROUND(avg(discountpercent),2) as avg_discout
from zepto
group by category
order by avg_discout desc
limit 5;
--Q6.Find the price per gram for products above 100g and sort by best value.
select name,weightingms,discountedsellingprice,
ROUND(discountedsellingprice/weightingms,2) as price_per_grm
from zepto
where weightingms>=100
order by price_per_grm;
--Q7.Group the products into categories like Low, Medium, Bulk BASED ON The Weights In Gram
select name,weightingms,
CASE when weightingms<1000 then 'Low'
	when weightingms<5000 then'Medium'
	else 'Bulk'
	end as weight_category
from zepto;
-- Q8. What is The total Inventory Weight Per Category
select category,
sum(weightingms*availablequantity) as total_weight
from zepto
group by category
order by total_weight;