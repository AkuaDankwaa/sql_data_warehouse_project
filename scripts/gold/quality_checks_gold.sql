/*
=========================================================================================
QUALITY CHECKS
==========================================================================================
Script Purpose:
	This script performs quality checks to validate the integrity,consistency, and accuracy
	of the Gold layer. These checks ensure: 
	- Uniqueness of surrogate keys in dimension tables
	- Refferential integrity between fact and dimension tables
	- Validation of relationships in the data model for analytical purposes.

Usage Notes:
	- Run these checks after data loading Gold Layer
	- Investigate and resolve any discrepancies found during the checks
========================================================================================
*/

-- ======================================================================================
               -- gold.dim_customers
-- =====================================================================================

--checking for duplicate after join

SELECT cst_id, COUNT(*) FROM
(SELECT
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ci.cst_marital_status,
	ci.cst_gndr,
	ci.cst_create_date,
	ca.bdate,
	ca.gen,
	la.cntry
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON		  ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON		  ci.cst_key = la.cid
)t GROUP BY cst_id
HAVING COUNT(*) >1;

-- integrating 2 gender columns into one
SELECT
	ci.cst_gndr,
	ca.gen,
CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master table for gender info
	 ELSE COALESCE(ca.gen, 'n/a')
END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON		  ci.cst_key = ca.cid;


-- ======================================================================================
               -- gold.dim_product
-- =====================================================================================

-- duplicate check on product key after join

SELECT prd_key, COUNT(*) FROM(
SELECT
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	cat,
	subcat,
	maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON	pn.cat_id =  pc.id 
WHERE pn.prd_end_dt IS NULL --Filter out all historical data
)t GROUP BY prd_key
HAVING COUNT(*) > 1;

-- ======================================================================================
               -- gold.fact_sales
-- =====================================================================================


-- Foreign key integrity(Dimensions)
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL

SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL;
