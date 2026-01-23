CREATE VIEW gold.dim_products AS
SELECT 
       ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key
      ,[prd_id] AS product_id
      ,[prd_key] AS product_number
      ,[prd_nm] AS product_name
      ,[cat_id] AS category_id
      ,pc.cat AS category
      ,pc.subcat AS subcategory
      ,pc.maintenance
      ,[prd_cost] AS cost 
      ,[prd_line] AS product_line
      ,[prd_start_dt] AS start_date
  FROM [DataWarehouse].[silver].[crm_prd_info] pn
   LEFT JOIN silver.erp_px_cat_g1v2 pc 
  ON pn.cat_id = pc.id 
  WHERE prd_end_dt IS NULL -- filter out all historical data

