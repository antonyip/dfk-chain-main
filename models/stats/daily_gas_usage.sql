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
        date_trunc('day', block_timestamp) as day_date,
        sum(receipt_gas_used / pow(10,18) * receipt_effective_gas_price ) as tx_fees
    from transactions
    where {{ incremental_last_x_days('block_timestamp', 2) }}
    group by 1
    order by 1
)

select 
    day_date,
    tx_fees,
    sum(tx_fees) over (order by day_date) as sum_fees
from daily_fees
order by 1