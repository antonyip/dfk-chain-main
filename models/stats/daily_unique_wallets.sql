{{
    config(
        materialized='incremental',
        unique_key='day_date',
        tags=['core', 'daily', 'stats'],
        cluster_by=['day_date']
    )
}}

with

min_address as (
    select
        from_address,
        min(block_number) as min_block
    from transactions
    group by 1
),
daily_unique as (
    select 
        date_trunc('day', b.timestamp) as day_date,
        count(1) as number_of_new_users
    from min_address t
    join blocks b on b.number = t.min_block
    where b.number > 0
    group by 1
    order by 1
)

select 
    *,
    sum(number_of_new_users) over (order by day_date) as total_users
from daily_unique
order by 1