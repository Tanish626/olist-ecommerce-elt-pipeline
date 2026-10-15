-- Grain: one row per calendar day, spanning the first order to the last estimated delivery.
with bounds as (
    select
        min(ordered_at)::date           as start_date,
        max(estimated_delivery_at)::date as end_date
    from "olist"."staging"."stg_orders"
),

days as (
    select generate_series(start_date, end_date, interval '1 day')::date as date_day
    from bounds
)

select
    to_char(date_day, 'YYYYMMDD')::int          as date_key,
    date_day,
    extract(year from date_day)::int            as year,
    extract(quarter from date_day)::int         as quarter,
    extract(month from date_day)::int           as month,
    trim(to_char(date_day, 'Month'))            as month_name,
    extract(day from date_day)::int             as day_of_month,
    extract(isodow from date_day)::int          as day_of_week,
    trim(to_char(date_day, 'Day'))              as day_name,
    extract(isodow from date_day) in (6, 7)     as is_weekend
from days