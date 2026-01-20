--for the 2nd table 
SELECT 
    prd_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info

--check for null values
SELECT 
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- no nulls detected in id
--move to next column - prd_key
--we decide to do prd_key make into 2 columns. since lots of info

SELECT 
    prd_id,
    prd_key,
    SUBSTRING(prd_key, 1,5) AS cat_id,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info

SELECT distinct id from bronze.erp_px_cat_g1v2

