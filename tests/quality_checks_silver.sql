/*
======================================================================================
QUALITY CHECKS
======================================================================================
Script Purpose:
	This script performs various quality checks for data consistency, accuracy, and
	standardization across the 'silver' schemas. It includes checks for: 
	- Null or duplicate primary keys
	- Unwanted spaces in string fields
	- Data standardization and consistency
	- Invalid date ranges and orders
	- Data consistency between related fields

Usage Notes:
	- Run these checks after data loading Silver Layer
	- Investigate and resolve any discrepancies found during the checks
========================================================================================
*/

-- ======================================================================================
               -- silver.crm_cust_info
-- =====================================================================================

--Exploring data in the table bronze.crm_cust_info by selecting first 1000
SELECT TOP 1000 * 
FROM bronze.crm_cust_info;


-- Check for NULLS or duplicates in data using Primary Key
--Expectation: No result

SELECT 
cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 or cst_id IS NULL; -- cst_id IS NULL will include ids with single null as well 

-- Check for unwanted spaces in string values
--Expectation: No results
SELECT 
cst_key,
cst_firstname,
cst_lastname
FROM bronze.crm_cust_info
WHERE cst_key != TRIM(cst_key) OR cst_firstname != TRIM(cst_firstname) OR cst_lastname != TRIM(cst_lastname);

--Data Standardization & Consistency check
SELECT DISTINCT
cst_gndr,
cst_marital_status
FROM bronze.crm_cust_info;

-- ============================================================================================
                   -- silver.crm_prd_info
-- ============================================================================================

SELECT 
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 or prd_id IS NULL; -- cst_id IS NULL will include ids with single null as well

--Check for unwamted spaces
--Expectation: No results
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--Check for NULLS or Negative numbers
-- Expectation: No results
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

--Data Standardization & Consistency check
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;

-- Date quality check
SELECT
prd_id,
prd_key,
prd_nm,
prd_start_dt,
prd_end_dt,
LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1 AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509');


-- ====================================================================================
                -- silver.crm_sales_details
-- ===================================================================================

SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
--WHERE sls_ord_num != TRIM(sls_ord_num)  --checking for duplicates in primary key
--WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info) -- checking the integrity of product key (FK)
--WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info) -- checking the integrity of customer ID (FK)

-- Checking data integrity of sls_order_dt
SELECT
NULLIF(sls_order_dt, 0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101;

-- Checking data integrity of sls_ship_dt
SELECT
NULLIF(sls_ship_dt, 0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0
OR LEN(sls_ship_dt) != 8
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101;

-- Checking data integrity of sls_due_dt
SELECT
NULLIF(sls_ship_dt, 0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0
OR LEN(sls_ship_dt) != 8
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101;

-- checking for invalid date orders
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt; 

-- check data consistency: between sales, quantity, and price
-- >> sales = price * quantity
-- >> values must not be NULL, zero, or negative

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_price * sls_quantity
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0;

-- ================================================================================
                      -- silver.erp_cust
-- =================================================================================

-- Identify out-of-range dates
SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Check data standardization & consistency
SELECT DISTINCT gen
FROM bronze.erp_cust_az12

-- =================================================================================
                   -- silver.erp_cat
-- =================================================================================

--checking for unwanted spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

--checking for data standardization & consistency
SELECT DISTINCT cat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT subcat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2;


-- ====================================================================================
                  -- silver.erp_loc
-- ====================================================================================

--checking unmatching data with customer key in customer info table
SELECT
cid,
cntry
FROM bronze.erp_loc_a101
WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info)

-- checking for data standardization & consistency
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101 



