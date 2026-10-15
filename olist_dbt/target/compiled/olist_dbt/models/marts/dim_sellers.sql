-- Grain: one row per seller.
select
    seller_id,
    city,
    state,
    zip_code_prefix
from "olist"."staging"."stg_sellers"