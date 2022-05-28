{{
    config(
        materialized='incremental',
        unique_key='day_date',
        tags=['core', 'daily', 'stats'],
        cluster_by=['day_date']
    )
}}

select 
    date_trunc('day', block_timestamp) as day_date,
    count(1) as number_of_transactions
from transactions t
where {{ incremental_last_x_days('block_timestamp', 2) }}
group by 1
order by 1