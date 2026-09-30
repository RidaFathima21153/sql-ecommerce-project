# SQL E-commerce Report

A portfolio SQL analytics project built around an e-commerce database. It demonstrates relational database design, DDL constraints, NULL handling, INNER/LEFT/SELF joins, aggregations, subqueries, CTEs, window functions, CASE expressions, date functions, and customer/product reporting.

## Stack
- MySQL 8.0+
- SQL

## Project scope
- Customer spend and order analysis
- Top-selling and top-revenue products
- Category performance
- Monthly sales reporting
- NULL handling with `COALESCE`
- INNER, LEFT, and SELF JOINs
- DDL constraints: PK, FK, UNIQUE, CHECK, DEFAULT
- Subqueries and CTEs
- Window functions such as `RANK`, `DENSE_RANK`, and `ROW_NUMBER`
- Customer segmentation with `CASE`

## Database schema

```text
customers ───< orders ───< order_items >─── products >─── categories
    │             │
    └──────────── addresses
                  │
                  └──── payments
```

## Run locally

### 1. Create the database and tables
```bash
mysql -u root -p < sql/schema.sql
```

### 2. Load sample data
```bash
mysql -u root -p < sql/seed.sql
```

### 3. Run the report queries
```bash
mysql -u root -p ecommerce_report < sql/queries.sql
```

Or open the files in MySQL Workbench and execute them section by section.

## Files
- `sql/schema.sql` — database and table definitions with constraints
- `sql/seed.sql` — realistic sample e-commerce data
- `sql/queries.sql` — 40+ reporting and SQL practice queries

## Highlights
The project intentionally includes examples of `JOIN`, `LEFT JOIN`, `GROUP BY`, `HAVING`, `CASE`, `COALESCE`, correlated subqueries, CTEs, and window functions so it can be used as both a portfolio project and SQL interview practice.
