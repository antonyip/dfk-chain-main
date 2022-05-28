{{
    config(
        materialized='incremental',
        unique_key='day_date',
        tags=['core', 'daily', 'stats'],
        cluster_by=['day_date']
    )
}}

with raws as (
    select
        date_trunc('day', block_timestamp) as day_date,
        from_address,
        count(from_address) as ccount
    from transactions
    where {{ incremental_last_x_days('block_timestamp', 2) }}
    group by 1,2
),
final as (
    select
        day_date,
        count(from_address) as daily_active_addresses
    from raws
    group by 1
)

select * from final
