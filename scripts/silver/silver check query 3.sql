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
    REPLACE(SUBSTRING(prd_key, 1,5),'-','_') AS cat_id,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info

SELECT distinct id from bronze.erp_px_cat_g1v2

SELECT 
    prd_id,
    prd_key,
    REPLACE(SUBSTRING(prd_key, 1,5),'-','_') AS cat_id,
    SUBSTRING(prd_key, 7,LEN(prd_key)) AS prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info
WHERE SUBSTRING(prd_key, 7,LEN(prd_key)) IN (
SELECT sls_prd_key from bronze.crm_sales_details)

SELECT sls_prd_key from bronze.crm_sales_details WHERE sls_prd_key LIKE 'FK'

SELECT distinct sls_prd_key from bronze.crm_sales_details

SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL


SELECT 
    prd_id,
    prd_key,
    REPLACE(SUBSTRING(prd_key, 1,5),'-','_') AS cat_id,
    SUBSTRING(prd_key, 7,LEN(prd_key)) AS prd_key,
    prd_nm,
    ISNULL(prd_cost, 0) AS prd_cost,
    CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info

SELECT distinct prd_line
FROM bronze.crm_prd_info

SELECT * FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt


--start date end date confusion fixing
SELECT 
    prd_id,
    prd_key,
    prd_nm,
    prd_start_dt,
    prd_end_dt,
    LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509')



SELECT 
    prd_id,
    prd_key,
    REPLACE(SUBSTRING(prd_key, 1,5),'-','_') AS cat_id,
    SUBSTRING(prd_key, 7,LEN(prd_key)) AS prd_key,
    prd_nm,
    ISNULL(prd_cost, 0) AS prd_cost,
    CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,
    CAST(prd_start_dt AS DATE) AS prd_start_dt,
    CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt_test
FROM bronze.crm_prd_info

--change the metadata according to new coloumns and executed the table 
--insearting processed data to the table

INSERT silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT 
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1,5),'-','_') AS cat_id,
    SUBSTRING(prd_key, 7,LEN(prd_key)) AS prd_key,
    prd_nm,
    ISNULL(prd_cost, 0) AS prd_cost,
    CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,
    CAST(prd_start_dt AS DATE) AS prd_start_dt,
    CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt_test
FROM bronze.crm_prd_info

--for the 3rd table 
SELECT *
FROM silver.crm_prd_info

SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL