
    
    

select
    category_name as unique_field,
    count(*) as n_records

from "olist"."staging"."stg_product_category_translation"
where category_name is not null
group by category_name
having count(*) > 1


