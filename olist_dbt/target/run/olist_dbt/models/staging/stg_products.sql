
  create view "olist"."staging"."stg_products__dbt_tmp"
    
    
  as (
    -- Note: the source columns really are spelled "lenght" in the Olist dataset.
select
    product_id,
    product_category_name                       as category_name,
    product_name_lenght::int                    as name_length,
    product_description_lenght::int             as description_length,
    product_photos_qty::int                     as photos_qty,
    product_weight_g::numeric                   as weight_g,
    product_length_cm::numeric                  as length_cm,
    product_height_cm::numeric                  as height_cm,
    product_width_cm::numeric                   as width_cm
from "olist"."raw"."products"
  );