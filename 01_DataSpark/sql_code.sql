USE customer_sale_data;

-- Display all tables
SELECT * FROM customer_details;
SELECT * FROM exchange_details;
SELECT * FROM product_details;
SELECT * FROM sales_details;
SELECT * FROM store_details;

-- Describe tables
DESCRIBE sales_details;
DESCRIBE customer_details;
DESCRIBE store_details;

-- Convert data types to DATE
-- Customer Table
UPDATE customer_details SET birthday = STR_TO_DATE(birthday, "%Y/%m/%d") WHERE birthday REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$';
ALTER TABLE customer_details MODIFY COLUMN birthday DATE;

-- Sales Table
UPDATE sales_details SET order_date = STR_TO_DATE(order_date, "%Y/%m/%d") WHERE order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$';
ALTER TABLE sales_details MODIFY COLUMN order_date DATE;

-- Store Table
UPDATE store_details SET open_date = STR_TO_DATE(open_date, "%Y/%m/%d") WHERE open_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$';
ALTER TABLE store_details MODIFY COLUMN open_date DATE;

-- Exchange Table
UPDATE exchange_details SET date = STR_TO_DATE(date, "%Y-%m-%d") WHERE date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';
ALTER TABLE exchange_details MODIFY COLUMN date DATE;

-- Insights Queries
-- 1. Female count
SELECT COUNT(gender) AS female_count FROM customer_details WHERE gender = "Female";

-- 2. Male count
SELECT COUNT(gender) AS male_count FROM customer_details WHERE gender = "Male";

-- 3. Customer count by country
SELECT sd.country, COUNT(DISTINCT c.customerkey) AS customer_count 
FROM sales_details c 
JOIN store_details sd ON c.storekey = sd.storekey
GROUP BY sd.country 
ORDER BY customer_count DESC;

-- 4. Total customer count
SELECT COUNT(DISTINCT customerkey) AS customer_count FROM sales_details;

-- 5. Store count by country
SELECT country, COUNT(storekey) AS store_count FROM store_details 
GROUP BY country 
ORDER BY store_count DESC;

-- 6. Store-wise sales
SELECT s.storekey, sd.country, SUM(pd.unit_price_USD * s.quantity) AS total_sales_amount 
FROM product_details pd
JOIN sales_details s ON pd.productkey = s.productkey 
JOIN store_details sd ON s.storekey = sd.storekey 
GROUP BY s.storekey, sd.country;

-- 7. Total sales amount
SELECT SUM(pd.unit_price_USD * sd.quantity) AS total_sales_amount 
FROM product_details pd
JOIN sales_details sd ON pd.productkey = sd.productkey;

-- 8. Brand count
SELECT brand, COUNT(brand) AS brand_count FROM product_details GROUP BY brand;

-- 9. Profit and cost-price difference
SELECT unit_price_USD, unit_cost_USD, ROUND((unit_price_USD - unit_cost_USD), 2) AS price_diff,
ROUND(((unit_price_USD - unit_cost_USD) / unit_cost_USD) * 100, 2) AS profit_percent
FROM product_details;

-- 10. Brand-wise sales amount
SELECT brand, ROUND(SUM(unit_price_USD * sd.quantity), 2) AS sales_amount 
FROM product_details pd 
JOIN sales_details sd ON pd.productkey = sd.productkey 
GROUP BY brand;

-- 11. Subcategory-wise sales amount
SELECT subcategory, ROUND(SUM(unit_price_USD * sd.quantity), 2) AS total_sales_amount
FROM product_details pd 
JOIN sales_details sd ON pd.productkey = sd.productkey 
GROUP BY subcategory 
ORDER BY total_sales_amount DESC;

-- 12. Country-wise overall sales
SELECT s.country, SUM(pd.unit_price_USD * sd.quantity) AS total_sales 
FROM product_details pd 
JOIN sales_details sd ON pd.productkey = sd.productkey 
JOIN store_details s ON sd.storekey = s.storekey 
GROUP BY s.country;

-- 13. Yearly brand sales
SELECT YEAR(order_date) AS year, pd.brand, ROUND(SUM(unit_price_USD * sd.quantity), 2) AS year_sales 
FROM sales_details sd 
JOIN product_details pd ON sd.productkey = pd.productkey 
GROUP BY YEAR(order_date), pd.brand;

-- 14. Overall sales with quantities and profit by brand
SELECT brand, SUM(unit_price_USD * sd.quantity) AS sp, SUM(unit_cost_USD * sd.quantity) AS cp,
(SUM(unit_price_USD * sd.quantity) - SUM(unit_cost_USD * sd.quantity)) / SUM(unit_cost_USD * sd.quantity) * 100 AS profit 
FROM product_details pd 
JOIN sales_details sd ON pd.productkey = sd.productkey 
GROUP BY brand;

-- 15. Monthly sales
SELECT MONTH(order_date) AS month, SUM(unit_price_USD * sd.quantity) AS sp_month 
FROM sales_details sd 
JOIN product_details pd ON sd.productkey = pd.productkey 
GROUP BY MONTH(order_date);

-- 16. Monthly and yearly sales by brand
SELECT MONTH(order_date) AS month, YEAR(order_date) AS year, brand, SUM(unit_price_USD * sd.quantity) AS sp_month 
FROM sales_details sd 
JOIN product_details pd ON sd.productkey = pd.productkey 
GROUP BY MONTH(order_date), YEAR(order_date), brand;

-- 17. Yearly sales
SELECT YEAR(order_date) AS year, SUM(unit_price_USD * sd.quantity) AS sp_year 
FROM sales_details sd 
JOIN product_details pd ON sd.productkey = pd.productkey 
GROUP BY YEAR(order_date);

-- 18. Current vs previous month sales comparison
SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, ROUND(SUM(unit_price_USD * sd.quantity), 2) AS sales, 
LAG(SUM(unit_price_USD * sd.quantity)) OVER (ORDER BY YEAR(order_date), MONTH(order_date)) AS previous_month_sales 
FROM sales_details sd 
JOIN product_details pd ON sd.productkey = pd.productkey 
GROUP BY YEAR(order_date), MONTH(order_date);

-- 19. Current vs previous year sales comparison
SELECT YEAR(order_date) AS year, ROUND(SUM(unit_price_USD * sd.quantity), 2) AS sales, 
LAG(SUM(unit_price_USD * sd.quantity)) OVER (ORDER BY YEAR(order_date)) AS previous_year_sales 
FROM sales_details sd 
JOIN product_details pd ON sd.productkey = pd.productkey 
GROUP BY YEAR(order_date);

-- 20. Monthly profit
SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, 
(SUM(unit_price_USD * sd.quantity) - SUM(unit_cost_USD * sd.quantity)) AS sales,
LAG(SUM(unit_price_USD * sd.quantity) - SUM(unit_cost_USD * sd.quantity)) OVER (ORDER BY YEAR(order_date), MONTH(order_date)) AS previous_month_sales,
ROUND(((SUM(unit_price_USD * sd.quantity) - SUM(unit_cost_USD * sd.quantity)) - 
LAG(SUM(unit_price_USD * sd.quantity) - SUM(unit_cost_USD * sd.quantity)) OVER (ORDER BY YEAR(order_date), MONTH(order_date))) /
LAG(SUM(unit_price_USD * sd.quantity) - SUM(unit_cost_USD * sd.quantity)) OVER (ORDER BY YEAR(order_date), MONTH(order_date)) * 100, 2) AS profit_percent
FROM sales_details sd 
JOIN product_details pd ON sd.productkey = pd.productkey 
GROUP BY YEAR(order_date), MONTH(order_date);

-- 21. Yearly profit
SELECT YEAR(order_date) AS year, (SUM(unit_price_USD * sd.quantity) - SUM(unit_cost_USD * sd.quantity)) AS sales, 
LAG(SUM(unit_price_USD * sd.quantity) - SUM(unit_cost_USD * sd.quantity)) OVER (ORDER BY YEAR(order_date)) AS previous_year_sales,
ROUND(((SUM(unit_price_USD * sd.quantity) - SUM(unit_cost_USD * sd.quantity)) - 
LAG(SUM(unit_price_USD * sd.quantity) - SUM(unit_cost_USD * sd.quantity)) OVER (ORDER BY YEAR(order_date))) /
LAG(SUM(unit_price_USD * sd.quantity) - SUM(unit_cost_USD * sd.quantity)) OVER (ORDER BY YEAR(order_date)) * 100, 2) AS profit_percent
FROM sales_details sd 
JOIN product_details pd ON sd.productkey = pd.productkey 
GROUP BY YEAR(order_date);
