select * from rsale limit 10;

SELECT COUNT(*) FROM rsale;

-- Data Cleaning
SELECT * FROM rsale WHERE transactions_id IS NULL;

SELECT * FROM rsale WHERE sale_date IS NULL;

SELECT * FROM rsale WHERE sale_time IS NULL;

ALTER TABLE rsale CHANGE quantiy quantity INT;

-- altering sale_date column to  date format
ALTER TABLE rsale ADD COLUMN temp_sale_date DATE;
UPDATE rsale SET temp_sale_date = STR_TO_DATE(sale_date, '%d-%m-%Y');
SELECT sale_date, temp_sale_date FROM rsale LIMIT 10;
ALTER TABLE rsale DROP COLUMN sale_date;
ALTER TABLE rsale RENAME COLUMN temp_sale_date TO sale_date;


SELECT * FROM rsale
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
    
    DELETE FROM rsale
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM rsale ;

-- How many uniuque customers we have ?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM rsale;

SELECT DISTINCT category FROM rsale ;

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

 -- Q.1 SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM rsale
WHERE sale_date = '2022-11-05';

-- Q.2 SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT  *
FROM rsale
WHERE 
    category = 'Clothing'
    AND 
    sale_date >= '2022-11-01' AND sale_date < '2022-12-01'
    AND
    quantity >= 4;
    
-- Q.3 SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category, 
    SUM(total_sale) as net_sale, 
    COUNT(*) as total_orders
FROM rsale
GROUP BY 1 ;

-- Q.4 SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT AVG(age) as avg_age
FROM rsale
WHERE category = 'Beauty';

-- Q.5 SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM rsale
WHERE total_sale > 1000;

-- Q.6 SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM rsale
GROUP BY category, gender
ORDER BY 1 ;

-- Q.7 SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year, month, avg_sale FROM 
(SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as Ranks
FROM rsale
GROUP BY 1, 2
) as t1
WHERE Ranks = 1 ;

-- Q.8 SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM rsale
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5 ;

-- Q.9 SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as Unique_customer
FROM rsale
GROUP BY category;

-- Q.10 SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale AS (
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM rsale
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

-- End of project
