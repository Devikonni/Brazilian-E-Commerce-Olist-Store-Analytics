use e_commerce;
SELECT * FROM order_payments;

SELECT * FROM order_items;

SELECT * FROM customers;

SELECT * FROM orders;

-- 1st kpi 
CREATE VIEW week_type AS
    SELECT 
        DAYNAME(order_purchase_timestamp) AS day_name,
        DAYOFWEEK(order_purchase_timestamp) AS day_week,
        order_id
    FROM
        orders;
        
SELECT * FROM week_type;

CREATE VIEW weekdaytype AS
    SELECT 
        CASE
            WHEN day_week = 1 THEN 'weekend'
            WHEN day_week = 7 THEN 'weekend'
            ELSE 'weekday'
        END AS Weekday_type,
        day_week,
        order_id
    FROM
        week_type;

select * from weekdaytype;

SELECT 
    round(sum(order_payments.payment_value)) AS total_payment,
    weekdaytype.weekday_type AS day_type
FROM
    order_payments
        INNER JOIN
    weekdaytype ON order_payments.order_id = weekdaytype.order_id
GROUP BY day_type;

-- 2nd kpi
select payment_type,review_score,count(distinct order_id) order_id from review_score
 where payment_type = 'credit_card' and review_score = 5;

-- 3rd kpi
SELECT product_category_name
FROM products
WHERE product_category_name LIKE '%pet_shop%';
SELECT * FROM order_items;

-- Creating View for shippingdays

CREATE VIEW Shippigdays AS
    SELECT 
        order_id,
        TIMESTAMPDIFF(DAY,
            order_purchase_timestamp,order_delivered_customer_date) AS shipping_days
    FROM
        orders;

SELECT 
    products.product_category_name,
   ROUND(AVG(Shippigdays.shipping_days)) AS Avg_Shipping_days
FROM
    products
        left JOIN
    order_items ON products.product_id = order_items.product_id
        left JOIN
    Shippigdays ON order_items.order_id = Shippigdays.order_id
WHERE
    product_category_name like'%pet_shop%'
GROUP BY product_category_name;


-- 4th kpi

SELECT 
   customers.customer_city,
    round(AVG(order_items.price)) AS avg_Price,
    round(AVG(order_payments.payment_value)) AS Avg_paymentvalue
FROM
    customers
        left JOIN
    orders ON customers.customer_id = orders.customer_id
        left JOIN
    order_items ON orders.order_id = order_items.order_id
        left JOIN
    order_payments ON order_items.order_id = order_payments.order_id
WHERE
    customer_city LIKE 'sao paulo'
GROUP BY customer_city;

SELECT * FROM orders;
desc orders;
alter table orders modify column order_purchase_timestamp date;
UPDATE orders
SET order_delivered_customer_date = NULL
WHERE order_delivered_customer_date = '';
alter table orders modify column order_delivered_customer_date date;

set sql_safe_updates = 0;
DELETE FROM olist_orders_dataset 
WHERE
    order_delivered_customer_date = '';
 -- 5th Kpi

SELECT * FROM shipping_days;

select review_score,round(avg(Ship_days)) Avg_Shipdays from shipping_days 
group by 1 order by 1 desc;



SELECT 
    customers.customer_city,
    AVG(Shippigdays.shipping_days) AS average_days
FROM
    customers
        INNER JOIN
    orders ON customers.customer_id = orders.customer_id
        INNER JOIN
    Shippigdays ON orders.order_id = Shippigdays.order_id
WHERE
    customer_city LIKE 'sao paulo'
GROUP BY customer_city order by average_days;






