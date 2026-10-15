
  create view "olist"."staging"."stg_product_category_translation__dbt_tmp"
    
    
  as (
    select
    product_category_name           as category_name,
    product_category_name_english   as category_name_english
from "olist"."raw"."product_category_name_translation"
  );