
  create view "olist"."staging"."stg_order_payments__dbt_tmp"
    
    
  as (
    select
    order_id,
    payment_sequential::int             as payment_sequential,
    payment_type,
    payment_installments::int           as payment_installments,
    payment_value::numeric(10, 2)       as payment_value
from "olist"."raw"."order_payments"
  );