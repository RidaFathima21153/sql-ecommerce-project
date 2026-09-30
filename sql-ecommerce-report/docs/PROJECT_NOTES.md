# Project Notes

## Interview talking points

### Problem
Build a relational e-commerce reporting database that can answer common business questions about customers, orders, products, categories, payments, revenue, and inventory.

### Design decisions
- Separate entities into normalized tables to reduce duplication.
- Use primary and foreign keys to maintain relationships.
- Use `CHECK`, `UNIQUE`, `NOT NULL`, and `DEFAULT` constraints for data quality.
- Use `LEFT JOIN` when the report must retain entities with no matching rows.
- Use `COALESCE` for NULL handling.
- Use CTEs and window functions for analytical reporting.

### Example relationship
One customer can place many orders. One order can contain many products through `order_items`. A product belongs to one category. Each order has one payment record in this sample model.

### Suggested interview questions
1. Why did you normalize the schema?
2. Why is `order_items` a separate table?
3. Difference between `INNER JOIN` and `LEFT JOIN`?
4. Why use `COALESCE`?
5. What is a primary key vs foreign key?
6. Why use indexes on `orders(customer_id, order_date)`?
7. What is a CTE?
8. What is a window function?
9. Difference between `WHERE` and `HAVING`?
10. How would you find the top 5 customers by spend?
