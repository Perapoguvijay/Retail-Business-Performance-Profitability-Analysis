/*****************Retail Business performance and Profitability Analysis******************* ***/

--- use the database 
use elative;

--- select all data 
select * from retail;

--- check null values 
select * from retail where profit is null;
-- check null values of all columns 
select * from retail where Category is null;

--- How many null values in category columns 
select category,count(*) as counting from retail group by Category order by counting ;

--- replace with null values 
---- (Coalesce) function is replace the null values temporarly 
select Order_ID,Coalesce(Category,'Miscellaneous') as Category , Discount,profit from retail;

--- I just update the null value .

update retail
set Category ='Miscellaneous'
where Category is null;
--- 11 row updated 

--- Next see that column we have null values or not 
select category from retail where Category is null;
--- (we have no null values)

/**same all columns we updat null values **/
select Sub_Category,count(*) as counting  from retail group by Sub_Category ;

select category,coalesce(Sub_Category,'Unsubcategorized')  as Sub_Category from retail group by Sub_Category,Category

select * from retail;

--- update the column
update retail
set Sub_Category ='Unsubcategorized'
where Sub_Category is null;
----(- 5 rows affected or updated)

--- Next region column its is a categorical column 
select region,Sub_Category from retail where Region is null group by region,Sub_Category;
--- challange update the null values using sub_categories 
update retail
set region = 'South'
where region is null and Sub_Category ='Outdoor'

--- east
update retail
set region = 'East'
where region is null and Sub_Category ='Dairy'

update retail
set region = 'South'
where region is null and Sub_Category ='Tvs'


--- update west 
update retail
set region = 'West'
where region is null and Sub_Category ='Indoor'

-- update north 
update retail
set region = 'North'
where region is null and Sub_Category ='Kids'

---
update retail
set region = 'East'
where region is null and Sub_Category ='Men'

select region from retail where region is null;

select * from retail

--- Now we have null values in numerical columns .
--- we can impute the colums using mean and median values or just try individual values.
/**Show how many null values on the discount column **/
select Discount,count(*) as null_values from retail where Discount is null group by Discount;

update retail 
set Discount = '00:22:00.0000000'
where discount is null

--- The column in time data type . 

/**Now profit column**/
select profit ,count(*) as null_values from retail where Profit is null group by profit 
--- we have 11 null values 

select * from retail

update retail 
set profit = (select avg(profit) from retail)
where profit is null ;

--- 11 rows updated .
--- i just updated avg of value .
select * from retail where profit is null;

/** first step is completed . I fill null values with suitable values **/

/**calculate profit margins by category and sub category**/
select Category,
		Sub_Category,
		sum(Profit) as Total_profit ,
		sum(Revenue) as total_revenue,
		round(sum(profit)/sum(revenue)*100,2) as profit_margins
		from retail
	group by Category,Sub_Category

select * from retail;

/* total amount of all items */
select Category ,
		round(sum(quantity*Unit_Price),2) as total_amount
		from retail
		group by Category
/* profit amount between year first 6 months */

select Category from retail where Order_Date between '2024-01-01' and '2024-06-01' group by Category;


-- we have 220 rows in the table i want first 6 months orders 
--- check count rows 
select count(*) from retail

with cte as (
	select category,order_date, ROW_NUMBER() over( order by order_date ) as row_num from retail)
	select * from cte where Order_Date between '2024-01-01' and '2024-06-30' ;

select * from retail;

/** Region wise sum profit and avg profit */
select region,sum(profit) as total_profit,avg(profit) as avg_profit from retail group by region;

/**top-5 sub_categories using profit*/

select * from retail

select top 5 Sub_Category,
		sum(profit) as total_profit	
from retail 
		group by Sub_Category
		order by total_profit desc

--- region find  highest avg profit per order
select top 1 
	Region,
	round(avg(profit),2) as avg_profit
from retail
	where Region is not null
	group by Region
	order by avg_profit desc

--- extarct month total sales 
select month(order_date) as months,sum(quantity*unit_price) as total_sales from retail
group by MONTH(order_date) order by total_sales desc

--- here 10th month has highest sales.
select * from retail

--- average quantity sold per category and season.
select 
		Category ,Season,
		avg(quantity) as avg_sales 
		from retail 
		group by Category,Season 
		order by avg_sales desc
--- Identify which season gives the highest total profit
select season,
		sum(profit) as total_profit from retail
		where profit is not null
		group by Season
		order by total_profit

with cte as (
	select *, row_number() over (partition by season order by profit desc) as rnk from retail)
	select season,sum(profit) as total_profit from cte group by season

--- Show the top 3 most profitable products or sub-categories in each region
select top 3
		Sub_Category,
		Region,
		sum(profit) as total_profitables_prod 
from retail 
		where profit is not null 
		group by Sub_Category,Region
		order by total_profitables_prod desc 

/*Find the correlation-like relationship: 
does a higher discount lead to higher or lower profit? */
--- scenior based question 
select 
	case 
	when cast(discount as float) <0.1 then '0-10%'
	when cast(discount as float) <0.2 then '10% - 20%'
	when cast(discount as float) <0.3 then '20% - 30%'
	else '30% +'
	end as 'discount_range',
	round(avg(profit),2)
	from retail 
	where profit is not null and Discount is not null
	group by case 
	when cast(discount as float)<0.1 then '0-10%'
	when cast(discount as float)<0.2 then '10% - 20%'
	when cast(discount as float)<0.3 then '20% - 30%'
	else '30% +'end 
	order by discount_range

-- if we have a column discount in string type to convert float and then apply case statement .

/*********************************KPIs************************************/
select * from retail
select count(order_id) as total_sales from retail --- total sales
select sum(profit) as total_profit from retail    --- total profit 
 
select avg(profit) as avg_profit from retail      --- average profit 
select max(profit) as max_profit from retail   --- maximum prfofit
select min(profit) as min_profit from retail   --- minmum prfofit

--- Identify the slow-moving products (lowest revenue but highest inventory or quantity).


--- same as well as revenue 

/*couning how many unique values in a column*/
select distinct category from retail;

select 
		count(distinct category) as category_unique,
		count(distinct Sub_Category) as sub_category_unique
		from retail

/*Find the overall average profit and compare each category’s profit against it.*/
		--- 1.group by category. 
		--- 2.using comparision case statement .
select 
	category,
	avg(profit) as avg_profit
	from retail 
where profit is not null
group by Category



select * from retail;

select avg(profit) from retail

select 
	category,
	round(avg(profit),2) as avg_profit,
	case 
		when avg(profit) >(select avg(profit) from retail where profit is not null) then 'Above profit'
		when  avg(profit) <(select avg(profit) from retail where profit is not null) then 'Below profit'
		else 'Average'
		end as comparision 
from retail
		group by category 
		order by avg_profit

/*Show all records where profit is negative (loss)*/
select * from retail where profit <0;

/*Display the top 5 highest-revenue orders and their details.*/
select top 5 * from retail where revenue is not null order by Revenue desc;


select * from retail
/*quater comaprision */
select *,
	case
		when revenue >=15000 then 'Q1'
		when revenue >=10000 then 'Q2'
		when revenue >=5000 then  'Q3'
		else 'Q4'
		end as 'comparsion'
		from retail

/* find variance and standard dev*/


select 
	category,
	round(avg(profit),2) as avg_profit,
	round(VAR(profit),2) as variance ,
	round(STDEV(profit),2) as std_profit
from retail 
	group by Category
	order by variance desc









/** Key insights of the project */
--- 1.check null values and update null values using coalsece function or update comand 
--- 2.find the total profit and tota_revenue
--- 3.calculate the profit margin by category and sub category 
--- 4.calculate the total amount of all items by catergory 
--- 5.finding the top 5 sub categories by profit 
--- 6.highest top 1 region by average profit per order
--- 7.using common table expression for temperory table and find the row number highest one 
--- 8.separate month avg revenue  and also find the top 5 months 
--- 9.top 3 most profitable products or sub-categories in each region
--- 10.using case statement for discount ranges .
--- 11.KPIs (total orders,profit,avg discount,avg revenue,max profit ,min profit...etc)
--- 12.counting number of unique values in category and sub_category
--- 13.Find the overall average profit and compare each category’s profit against it.(using case statement)
--- 14. where profit is negative 
--- 15.comparsion and using case statement divide by revenue

