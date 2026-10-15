
  
    

  create  table "olist"."marts"."fct_orders__dbt_tmp"
  
  
    as
  
  (
    -- Grain: one row per order.
-- Items, payments and reviews are aggregated to order level BEFORE joining,
-- so the joins can't multiply rows (fan-out).
with items as (
    select
        order_id,
        count(*)            as items_count,
        sum(price)          as items_value,
        sum(freight_value)  as freight_value
    from "olist"."staging"."stg_order_items"
    group by order_id
),

payments as (
    select
        order_id,
        sum(payment_value)  as total_payment_value
    from "olist"."staging"."stg_order_payments"
    group by order_id
),

reviews as (
    select
        order_id,
        round(avg(review_score), 2) as review_score
    from "olist"."staging"."stg_order_reviews"
    group by order_id
)

select
    o.order_id,
    o.customer_id,
    to_char(o.ordered_at, 'YYYYMMDD')::int                      as order_date_key,
    o.order_status,
    o.ordered_at,
    o.approved_at,
    o.shipped_at,
    o.delivered_at,
    o.estimated_delivery_at,
    coalesce(i.items_count, 0)                                  as items_count,
    coalesce(i.items_value, 0)                                  as items_value,
    coalesce(i.freight_value, 0)                                as freight_value,
    coalesce(p.total_payment_value, 0)                          as total_payment_value,
    r.review_score,
    (o.delivered_at::date - o.ordered_at::date)                 as delivery_days,
    (o.delivered_at::date - o.estimated_delivery_at::date)      as delivery_delay_days,
    (o.delivered_at > o.estimated_delivery_at)                  as is_late
from "olist"."staging"."stg_orders" o
left join items i    on o.order_id = i.order_id
left join payments p on o.order_id = p.order_id
left join reviews r  on o.order_id = r.order_id
  );
  