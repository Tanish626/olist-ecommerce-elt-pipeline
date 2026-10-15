-- Grain: one row per customer_id.
-- In Olist, customer_id is generated per order; customer_unique_id identifies the real person.
select
    customer_id,
    customer_unique_id,
    city,
    state,
    zip_code_prefix
from {{ ref('stg_customers') }}