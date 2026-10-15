-- Grain: one row per product. Adds English category names.
-- A few categories have no translation, so we fall back to the Portuguese name.
select
    p.product_id,
    p.category_name,
    coalesce(t.category_name_english, p.category_name, 'unknown') as category_name_english,
    p.name_length,
    p.description_length,
    p.photos_qty,
    p.weight_g,
    p.length_cm,
    p.height_cm,
    p.width_cm
from "olist"."staging"."stg_products" p
left join "olist"."staging"."stg_product_category_translation" t
    on p.category_name = t.category_name