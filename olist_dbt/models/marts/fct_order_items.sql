-- Grain: one row per item within an order.
select
    oi.order_id || '-' || oi.order_item_id::text    as order_item_key,
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    o.customer_id,
    to_char(o.ordered_at, 'YYYYMMDD')::int          as order_date_key,
    o.order_status,
    oi.shipping_limit_at,
    oi.price,
    oi.freight_value,
    oi.price + oi.freight_value                     as total_item_value
from {{ ref('stg_order_items') }} oi
join {{ ref('stg_orders') }} o
    on oi.order_id = o.order_id