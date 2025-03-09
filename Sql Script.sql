-- 1.customer behavioural analysis
-- KPI 1: Active Customers Count
select count(distinct customer_unique_id) as Active_Customers 
from customers;

-- KPI 2: City-Wise Customer Distribution
select customer_city ,count(*) as customer_count
from customers 
group by customer_city
order by customer_count desc
limit 10;

-- KPI 3: Weekday Vs Weekend Orders
select Weektype, count(*) as Total_Orders
from orders
group by weektype;

-- kpi 4 top 5 cities with highest orders
select customer_city ,count(o.order_id) as total_orders
from customers c join orders o on c.customer_id=o.customer_id
group by customer_city
order by total_orders desc
limit 5;

 

-- kpi 5
-- Average Order Value (AOV) per Customer
SELECT c.customer_city, ROUND(AVG(op.payment_value), 2) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_payments op ON o.order_id = op.order_id
GROUP BY c.customer_city
ORDER BY avg_order_value DESC;
-- kpi6
-- Most Popular Order Time
SELECT HOUR(order_purchase_timestamp) AS order_hour, COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY total_orders DESC;
-- kpi 7
-- . Average Order Processing Time by Customer State
SELECT c.customer_state, ROUND(AVG(o.processing_time_hours), 2) AS avg_processing_time
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY avg_processing_time DESC;


 -- Sales Performance
-- 1. Number of Orders with Review Score 5 & Payment Type as Credit Card
SELECT op.payment_type,rs.review_score ,COUNT( rs.order_id) AS total_orders
FROM review_score rs
JOIN order_payments op 
    ON rs.order_id COLLATE utf8mb4_unicode_ci = op.order_id COLLATE utf8mb4_unicode_ci
WHERE rs.review_score = 5 AND op.payment_type = 'credit_card';


-- 2. Total Revenue Generated
SELECT ROUND(SUM(payment_value), 2) AS total_revenue
FROM order_payments;
-- 3. Most Profitable Product Categories
SELECT p.product_category_name, ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;
-- 4. Top Payment Methods Used by Customers
select payment_type,count(order_id) as total_orders from order_payments
group by payment_type
order by total_orders desc;
--  5. Average Order Value (AOV)

SELECT ROUND(AVG(payment_value), 2) AS avg_order_value
FROM order_payments;


 -- Delivery Performance
-- 1. Average Number of Days Taken for Pet Shop Deliveries
SELECT p.product_category_name, round(AVG(o.Days)) AS avg_days
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.product_category_name LIKE '%pet_shop%'
GROUP BY p.product_category_name;

--  2. Relationship Between Shipping Days & Review Scores
select round(avg(o.days)) AS Avg_shipping_days ,r.review_score from orders o join review_score r
on o.order_id=r.order_id COLLATE utf8mb4_unicode_ci
group by review_score;

-- 3 Orders Delivered Late vs On Time
SELECT 
    CASE 
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY delivery_status;


-- 4. Fastest & Slowest Product Categories for Delivery
SELECT p.product_category_name, ROUND(AVG(o.days), 2) AS avg_days
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_days ASC
LIMIT 10;

--  5. Average Time Between Order Approval & Shipping
SELECT ROUND(AVG(TIMESTAMPDIFF(HOUR, order_approved_at, order_delivered_carrier_date)), 2) AS avg_shipping_delay
FROM orders;


-- 4️⃣ Product Performance

--  1. Average Price & Payment Values from São Paulo Customers
select c.customer_city,avg(oi.price) as avg_price,avg(op.payment_value) as avg_payment
from customers c join  orders o on c.customer_id=o.customer_id
join order_payments op on op.order_id=o.order_id
join order_items oi on oi.order_id= op.order_id
where c.customer_city="Sao paulo"
group by  c.customer_city;

--  2. Best-Selling Products by Quantity Sold
SELECT p.product_category_name, COUNT(oi.product_id) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_sold DESC
LIMIT 10;

--  3. Product Categories with Highest Returns (Based on Review Scores)

SELECT 
    p.product_category_name, 
    COUNT(rs.order_id) AS total_returns
FROM review_score rs
JOIN order_items oi 
  ON rs.order_id COLLATE utf8mb4_unicode_ci = oi.order_id COLLATE utf8mb4_unicode_ci
JOIN products p 
  ON oi.product_id COLLATE utf8mb4_unicode_ci = p.product_id COLLATE utf8mb4_unicode_ci
WHERE rs.review_score <= 2
GROUP BY p.product_category_name
ORDER BY total_returns DESC
LIMIT 10;


-- 4. Products with the Highest Revenue

SELECT p.product_category_name, ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;
-- 🔹 5. Average Product Price per Category
SELECT p.product_category_name, ROUND(AVG(oi.price), 2) AS avg_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_price DESC limit 10;