SELECT * FROM INFORMATION_SCHEMA.TABLES

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'

SELECT DISTINCT country FROM gold.dim_customers

SELECT DISTINCT category, subcategory,product_name FROM gold.dim_products
ORDER BY 1,2,3
