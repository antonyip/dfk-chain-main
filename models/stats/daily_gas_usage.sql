{{
    config(
        materialized='incremental',
        unique_key='day_date',
        tags=['core', 'daily', 'stats'],
        cluster_by=['day_date']
    )
}}

with

daily_fees as (
    select 
        date_trunc('day', timestamp) as day_date,
        sum(gas_used)/1000000000 as tx_fees
    from blocks
    where {{ incremental_last_x_days('timestamp', 2) }}
        and number > 0
    group by 1
    order by 1
)

select 
    day_date,
    tx_fees,
    sum(tx_fees) over (order by day_date) as sum_fees
from daily_fees
order by 1