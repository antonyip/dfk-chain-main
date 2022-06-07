{{
    config(
        materialized='incremental',
        unique_key='day_date',
        tags=['core', 'daily', 'stats'],
        cluster_by=['day_date']
    )
}}

select 
    date_trunc('day', timestamp) as day_date,
    count(1) as number_of_blocks
from blocks
where {{ incremental_last_x_days('timestamp', 2) }}
    and number > 0
group by 1
order by 1
