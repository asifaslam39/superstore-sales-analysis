use sales_store
select * from superstore
select count(*) from superstore
---Q.1 write the total order 
select count(distinct(order_id)) from superstore
--Q.2 calculates the total order for each segment 
select segment,count(distinct order_id) ordr from superstore group by segment
---Q.3 calculate the total sales and profit for each segment
select segment,round(sum(sales),2) sale,round(sum(profit),2) profit from superstore
group by segment order by sale desc
--Q.4 calcuclate the cumulative sum of sale 
select round(sum(sales),2) from superstore

--Q.5 calculate the total profit
select round(sum(profit),2) profit from superstore
---Q.6 Calculate the cumulative avg of profit
select avg(profit) avrg from superstore
--Q.7 calculate the total sale by region
select region,round(sum(sales),2) sale from superstore group by region
--Q.8 calculate the total profit by region
select region,round(sum(profit),2)profit from superstore group by region
--Q.9 calculate the cumulative sum of sales over each year

select year(order_date) years ,round(sum(sales),2) sale from superstore
group by  year(order_date) order by  year(order_date) asc
--- Q.10 calculate the cumulative sum of profit over each year
select year(order_date) years ,round(sum(profit),2) profit from superstore
group by  year(order_date) order by  year(order_date) asc

---Q. 11 Calculate the Monthly sales trends.
select datename(MM,order_date) months ,round(count(sales),2) sale from superstore group by datename(mm,order_date)
order by sale desc
---Q.12 calculate the daily trend by order
select DATENAME(dw,order_date),count(order_id) total_order from superstore group by DATENAME(dw,order_date)
order by DATENAME(dw,order_date)
-- Q .13 Which state  has the highest number of orders
select statee,count(distinct(order_id)) cnt from superstore group by statee order by cnt desc
--Q..14 which state has the highest sale and where we earn profit 
select statee,sale,profit, case when profit <0 then 'loss' else 'profit' end as profit_loss from
(
select statee,sum(sales) sale,sum(profit)profit from superstore group by statee) a
order by sale desc,profit desc

---Q.. 15 Calculate total sale and profit by category 
select category,round(sum(sales),2) sale,sum(profit) profit from superstore group by category
--Q.16 calculate total profit by category 
select category,round(sum(profit),2) profit from superstore group by category 
--Q.17 Top 10 best selling products 
select top 10 product_name,total_sale,total_profit from
(select product_name,sum(sales) total_sale,sum(profit)total_profit from superstore group by product_name)b
order by total_sale,total_profit desc

--Q.18 Calculate the  loss & profit by sub-category
select sub_category,sale,profit_loss,case when profit_loss< 0 then 'loss' else 'profit' end as PL_status from (

select sub_category,sum(sales) sale ,round(sum(profit),2) profit_loss from superstore group by sub_category)b
order by sale desc
---Q.19  Find the customer with the highest order.
select top 1 customer_name,total_order from
(SELECT customer_name, count(distinct(order_id)) AS total_order
FROM superstore
GROUP BY customer_name)b
ORDER BY total_order DESC
--Q.20 Calculate growth in sales compared to the previous period.
with yearly as(
select year(order_date) years,round(sum(sales),2) sale from superstore group by year(order_date))
select years,sale,previous_year_diff,case when previous_year_diff< 0 then 'Loss' when
previous_year_diff is null then 'null' else 'growth' end as growth_status from (
select *,sale-lag(sale) over(order by years) previous_year_diff from yearly)b ;

--Q.21 find the state which represents the product with the highest sales in that state.

with productsale as(
select product_name,statee,rank() over(partition by statee order by sum(sales) desc)
sales from superstore
group by product_name,statee)
select product_name,statee from productsale where sales=1
-- Q.22 top 5 city of california has more sale AND thier profit
select top 5 city,sale,profit from
(select city,sum(sales) sale,sum(profit)profit from superstore where statee='california' group by city)b
order by sale desc ,profit

--Q 23 find  orders with the Longest Shipping Time:
SELECT order_id,product_name, DATEDIFF(day, order_date, ship_date) AS shipping_duration
FROM superstore
ORDER BY shipping_duration DESC





