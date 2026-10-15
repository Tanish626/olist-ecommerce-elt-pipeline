
  create view "olist"."staging"."stg_sellers__dbt_tmp"
    
    
  as (
    select
    seller_id,
    seller_zip_code_prefix      as zip_code_prefix,
    seller_city                 as city,
    seller_state                as state
from "olist"."raw"."sellers"
  );