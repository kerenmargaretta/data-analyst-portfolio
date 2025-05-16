-- make sales_data file--
CREATE TABLE sales_analysis As(
SELECT
area,
month_year,
product_group_code,
product_code.product_name,
si_qty,
si_value_before_tax,
so_qty,
so_value,
real_marketing_cost,
target_sales,
total_budget_marketing,
estimated_cash_in,
CASE
    WHEN SUM(real_marketing_cost) OVER (PARTITION BY area, month_year) > 0
    THEN SUM(so_value) OVER(PARTITION BY area, month_year) / SUM(real_marketing_cost) OVER(PARTITION BY area, month_year)
    ELSE 0
    END AS ROI
FROM sales_analysis
LEFT JOIN product_code ON sales_analysis.product_group_code = product_code.product_code_group
)


COPY (
  SELECT * 
  FROM sales_analysis
  ) TO 'D:\Data Analyst\1. Data Inafood\#Data_Used\csv\sales_analysis.csv' DELIMITER ',' CSV HEADER;


--- Make customer_data---
CREATE TABLE cust_aov AS(
  SELECT
    area,
    purchase_month,
	  product_group_code,
    COUNT(DISTINCT cleaned_invoice_number) AS total_invoice,
    (SUM(value_netto) / COUNT(DISTINCT cleaned_invoice_number)) AS AOV
  FROM cust_23_24
  WHERE value_netto IS NOT NULL
  GROUP BY area, purchase_month, product_group_code
  ORDER BY purchase_month
);


COPY (
  SELECT * 
  FROM cust_aov
  ) TO 'D:\Data Analyst\1. Data Inafood\#Data_Used\csv\customers_data.csv' DELIMITER ',' CSV HEADER;
