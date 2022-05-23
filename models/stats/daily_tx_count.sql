{{
    config(
        materialized='incremental',
        unique_key='day_date',
        tags=['core', 'daily', 'stats'],
        cluster_by=['day_date']
    )
}}

select 
    date_trunc('day', b.timestamp) as day_date,
    count(1) as number_of_transactions
from transactions t
join blocks b on b.number = t.block_number
where b.number > 0
group by 1
order by 1