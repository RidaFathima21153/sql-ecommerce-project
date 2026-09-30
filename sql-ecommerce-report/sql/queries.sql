USE ecommerce_report;

-- ============================================================
-- SQL E-COMMERCE REPORT: 40+ INTERVIEW/PORTFOLIO QUERIES
-- ============================================================

-- 01. List all active products.
SELECT * FROM products WHERE is_active = TRUE;

-- 02. Show products priced above the average product price.
SELECT product_id, product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- 03. Top 5 most expensive products.
SELECT product_name, price
FROM products
ORDER BY price DESC
LIMIT 5;

-- 04. Products with no rating (NULL handling).
SELECT product_name, COALESCE(rating, 0) AS rating_or_zero
FROM products
WHERE rating IS NULL;

-- 05. Replace NULL ratings with a readable label.
SELECT product_name,
       COALESCE(CAST(rating AS CHAR), 'Not rated') AS rating_status
FROM products;

-- 06. Products with stock below 20.
SELECT product_name, stock_qty
FROM products
WHERE stock_qty < 20
ORDER BY stock_qty;

-- 07. Count products in each category.
SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM categories c
LEFT JOIN products p ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY product_count DESC;

-- 08. Average product price by category.
SELECT c.category_name, ROUND(AVG(p.price), 2) AS avg_price
FROM categories c
JOIN products p ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY avg_price DESC;

-- 09. Top 5 products by units sold, excluding cancelled orders.
SELECT p.product_name, SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.status <> 'CANCELLED'
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC
LIMIT 5;

-- 10. Top 5 products by revenue, excluding cancelled orders.
SELECT p.product_name,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.status <> 'CANCELLED'
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 5;

-- 11. Customer spend based on paid orders.
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       ROUND(SUM(oi.quantity * oi.unit_price) - SUM(o.discount_amount), 2) AS total_spend
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN payments pay ON pay.order_id = o.order_id
WHERE pay.payment_status = 'PAID'
GROUP BY c.customer_id, customer_name
ORDER BY total_spend DESC;

-- 12. Customers who have never placed an order (LEFT JOIN).
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- 13. Number of orders per customer, including customers with zero orders.
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY order_count DESC;

-- 14. Average order value for delivered orders.
SELECT ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT o.order_id, SUM(oi.quantity * oi.unit_price) - o.discount_amount AS order_total
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.status = 'DELIVERED'
    GROUP BY o.order_id, o.discount_amount
) x;

-- 15. Orders whose gross value is above 10,000.
SELECT o.order_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS gross_value
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, customer_name
HAVING gross_value > 10000
ORDER BY gross_value DESC;

-- 16. Monthly sales revenue for paid orders.
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
       ROUND(SUM(pay.amount), 2) AS revenue
FROM orders o
JOIN payments pay ON pay.order_id = o.order_id
WHERE pay.payment_status = 'PAID'
GROUP BY sales_month
ORDER BY sales_month;

-- 17. Sales by city.
SELECT c.city, ROUND(SUM(pay.amount), 2) AS revenue
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN payments pay ON pay.order_id = o.order_id
WHERE pay.payment_status = 'PAID'
GROUP BY c.city
ORDER BY revenue DESC;

-- 18. Payment method usage.
SELECT payment_method, COUNT(*) AS payment_count, ROUND(SUM(amount), 2) AS amount
FROM payments
WHERE payment_status = 'PAID'
GROUP BY payment_method
ORDER BY amount DESC;

-- 19. Orders with pending payments.
SELECT o.order_id, o.order_date, pay.payment_method, pay.payment_status
FROM orders o
JOIN payments pay ON pay.order_id = o.order_id
WHERE pay.payment_status = 'PENDING';

-- 20. Customers with more than one order.
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       COUNT(o.order_id) AS orders_placed
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, customer_name
HAVING COUNT(o.order_id) > 1
ORDER BY orders_placed DESC;

-- 21. Best-selling category by units.
SELECT c.category_name, SUM(oi.quantity) AS units_sold
FROM categories c
JOIN products p ON p.category_id = c.category_id
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status <> 'CANCELLED'
GROUP BY c.category_id, c.category_name
ORDER BY units_sold DESC
LIMIT 1;

-- 22. Revenue by category.
SELECT c.category_name,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM categories c
JOIN products p ON p.category_id = c.category_id
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status <> 'CANCELLED'
GROUP BY c.category_id, c.category_name
ORDER BY revenue DESC;

-- 23. Customers whose spend is above average customer spend (CTE).
WITH customer_spend AS (
    SELECT c.customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           SUM(pay.amount) AS spend
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    JOIN payments pay ON pay.order_id = o.order_id
    WHERE pay.payment_status = 'PAID'
    GROUP BY c.customer_id, customer_name
)
SELECT customer_name, ROUND(spend, 2) AS spend
FROM customer_spend
WHERE spend > (SELECT AVG(spend) FROM customer_spend)
ORDER BY spend DESC;

-- 24. Rank customers by total spend (window function).
WITH customer_spend AS (
    SELECT c.customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           COALESCE(SUM(pay.amount), 0) AS spend
    FROM customers c
    LEFT JOIN orders o ON o.customer_id = c.customer_id
    LEFT JOIN payments pay ON pay.order_id = o.order_id AND pay.payment_status = 'PAID'
    GROUP BY c.customer_id, customer_name
)
SELECT customer_name,
       ROUND(spend, 2) AS spend,
       DENSE_RANK() OVER (ORDER BY spend DESC) AS spend_rank
FROM customer_spend
ORDER BY spend_rank, customer_name;

-- 25. Rank products by revenue within each category.
WITH product_revenue AS (
    SELECT c.category_name,
           p.product_name,
           SUM(oi.quantity * oi.unit_price) AS revenue
    FROM categories c
    JOIN products p ON p.category_id = c.category_id
    JOIN order_items oi ON oi.product_id = p.product_id
    JOIN orders o ON o.order_id = oi.order_id
    WHERE o.status <> 'CANCELLED'
    GROUP BY c.category_id, c.category_name, p.product_id, p.product_name
)
SELECT category_name, product_name, ROUND(revenue, 2) AS revenue,
       RANK() OVER (PARTITION BY category_name ORDER BY revenue DESC) AS category_rank
FROM product_revenue
ORDER BY category_name, category_rank;

-- 26. Latest order for every customer using ROW_NUMBER.
WITH ranked_orders AS (
    SELECT c.customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           o.order_id,
           o.order_date,
           ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.order_date DESC) AS rn
    FROM customers c
    LEFT JOIN orders o ON o.customer_id = c.customer_id
)
SELECT customer_id, customer_name, order_id, order_date
FROM ranked_orders
WHERE rn = 1 OR order_id IS NULL
ORDER BY customer_id;

-- 27. Customer segmentation using CASE.
WITH spend AS (
    SELECT c.customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           COALESCE(SUM(pay.amount), 0) AS total_spend
    FROM customers c
    LEFT JOIN orders o ON o.customer_id = c.customer_id
    LEFT JOIN payments pay ON pay.order_id = o.order_id AND pay.payment_status = 'PAID'
    GROUP BY c.customer_id, customer_name
)
SELECT customer_name, ROUND(total_spend, 2) AS total_spend,
       CASE
           WHEN total_spend >= 20000 THEN 'VIP'
           WHEN total_spend >= 10000 THEN 'Premium'
           WHEN total_spend > 0 THEN 'Regular'
           ELSE 'No Purchase'
       END AS customer_segment
FROM spend
ORDER BY total_spend DESC;

-- 28. Products with NULL ratings and their categories.
SELECT p.product_name, c.category_name, p.rating
FROM products p
JOIN categories c ON c.category_id = p.category_id
WHERE p.rating IS NULL;

-- 29. Customers with NULL phone numbers.
SELECT customer_id, CONCAT(first_name, ' ', last_name) AS customer_name
FROM customers
WHERE phone IS NULL;

-- 30. Self join: show customers and the person who referred them.
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       CONCAT(r.first_name, ' ', r.last_name) AS referred_by
FROM customers c
LEFT JOIN customers r ON r.customer_id = c.referred_by
ORDER BY c.customer_id;

-- 31. Products never ordered.
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE oi.product_id IS NULL;

-- 32. Customers who bought from Electronics.
SELECT DISTINCT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN categories cat ON cat.category_id = p.category_id
WHERE cat.category_name = 'Electronics';

-- 33. Orders containing more than one distinct product.
SELECT order_id, COUNT(DISTINCT product_id) AS distinct_products
FROM order_items
GROUP BY order_id
HAVING COUNT(DISTINCT product_id) > 1
ORDER BY distinct_products DESC;

-- 34. Highest-value order per customer.
WITH order_values AS (
    SELECT o.order_id, o.customer_id,
           SUM(oi.quantity * oi.unit_price) - o.discount_amount AS order_value
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY o.order_id, o.customer_id, o.discount_amount
), ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_value DESC) AS rn
    FROM order_values
)
SELECT r.order_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       ROUND(r.order_value, 2) AS order_value
FROM ranked r
JOIN customers c ON c.customer_id = r.customer_id
WHERE r.rn = 1;

-- 35. Orders placed in September 2024.
SELECT order_id, customer_id, order_date, status
FROM orders
WHERE order_date >= '2024-09-01'
  AND order_date < '2024-10-01'
ORDER BY order_date;

-- 36. Products priced between 1,000 and 5,000.
SELECT product_name, price
FROM products
WHERE price BETWEEN 1000 AND 5000
ORDER BY price;

-- 37. Orders with a coupon applied.
SELECT order_id, coupon_code, discount_amount
FROM orders
WHERE coupon_code IS NOT NULL
ORDER BY discount_amount DESC;

-- 38. Delivered orders with payment amount and customer name.
SELECT o.order_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       pay.amount AS paid_amount,
       pay.payment_method
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN payments pay ON pay.order_id = o.order_id
WHERE o.status = 'DELIVERED' AND pay.payment_status = 'PAID';

-- 39. Customers who purchased a product priced above 10,000.
SELECT DISTINCT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE p.price > 10000;

-- 40. Revenue contribution percentage by category.
WITH category_revenue AS (
    SELECT c.category_name,
           SUM(oi.quantity * oi.unit_price) AS revenue
    FROM categories c
    JOIN products p ON p.category_id = c.category_id
    JOIN order_items oi ON oi.product_id = p.product_id
    JOIN orders o ON o.order_id = oi.order_id
    WHERE o.status <> 'CANCELLED'
    GROUP BY c.category_id, c.category_name
)
SELECT category_name,
       ROUND(revenue, 2) AS revenue,
       ROUND(100 * revenue / SUM(revenue) OVER (), 2) AS revenue_percentage
FROM category_revenue
ORDER BY revenue DESC;

-- 41. Customers with loyalty points above the average.
SELECT customer_id,
       CONCAT(first_name, ' ', last_name) AS customer_name,
       loyalty_points
FROM customers
WHERE loyalty_points > (SELECT AVG(loyalty_points) FROM customers)
ORDER BY loyalty_points DESC;

-- 42. DDL metadata: list all tables in the project database.
SELECT table_name
FROM information_schema.tables
WHERE table_schema = DATABASE()
ORDER BY table_name;

-- 43. DDL metadata: list foreign-key constraints.
SELECT table_name, constraint_name, column_name, referenced_table_name, referenced_column_name
FROM information_schema.key_column_usage
WHERE table_schema = DATABASE()
  AND referenced_table_name IS NOT NULL
ORDER BY table_name, constraint_name;

-- 44. Order status summary.
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;

-- 45. Customers with at least one delivered order and total delivered spend.
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       COUNT(DISTINCT o.order_id) AS delivered_orders,
       ROUND(SUM(oi.quantity * oi.unit_price) - SUM(o.discount_amount), 2) AS delivered_spend
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id AND o.status = 'DELIVERED'
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, customer_name
HAVING delivered_orders >= 1
ORDER BY delivered_spend DESC;
