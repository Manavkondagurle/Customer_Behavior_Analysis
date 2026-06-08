##compairing revenue on the basis of gender
 select gender, sum(purchase_amount) as revenue from customer_behavior.customer group by gender;

##customers used a discount but still spent more than the average purchase amount
select customer_id , purchase_amount from customer_behavior.customer 
where discount_applied = 'Yes' and purchase_amount >= (select avg(purchase_amount) from customer_behavior.customer);

##the top 5 products with the highest average review rating
select item_purchased , round(avg(review_rating) , 2) from customer_behavior.customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

##Compare the average Purchase Amounts between Standard and Express Shipping. 
select shipping_type, round(avg(purchase_amount), 2)
from customer_behavior.customer
where shipping_type in ('standard' , 'Express')
group by shipping_type;

##subscribed customers spend more? Compare average spend and total revenue --between subscribers and non-subscribers.
select subscription_status , count(customer_id) as total_customers, round(avg(purchase_amount) , 2) as avg_spend,
sum(purchase_amount) as total_revenue
from customer_behavior.customer
group by subscription_status
order by total_revenue , avg_spend desc;

## products have the highest percentage of purchases with discounts applied
select item_purchased , 
round(sum(case when discount_applied = 'Yes' then 1 else 0 end)/count(*) * 100 , 2) as discount_rate
from customer_behavior.customer
group by item_purchased
order by discount_rate desc
limit 5;

##the top 3 most purchased products within each category
WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customer_behavior.customer
    GROUP BY category, item_purchased
)
SELECT item_rank,category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <=3;

##the revenue contribution of each age group
SELECT age_group, SUM(purchase_amount) AS total_revenue
FROM customer_behavior.customer
GROUP BY age_group
ORDER BY total_revenue desc;