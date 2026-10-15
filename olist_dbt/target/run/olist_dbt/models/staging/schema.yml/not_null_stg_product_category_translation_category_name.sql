
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select category_name
from "olist"."staging"."stg_product_category_translation"
where category_name is null



  
  
      
    ) dbt_internal_test