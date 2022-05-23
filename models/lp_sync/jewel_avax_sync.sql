{{
    config(
        materialized='incremental',
        unique_key='day_date',
        tags=['core', 'sync', 'daily'],
        cluster_by=['day_date']
    )
}}

with raws as (
    select 
        date_trunc('day', block_timestamp) as day_date,
        block_timestamp,
        data
    from logs
    where {{ incremental_last_x_days('block_timestamp', 2) }}
        and address = lower('0xF3EabeD6Bd905e0FcD68FC3dBCd6e3A4aEE55E98') -- jewel - avax
        and topic0 = '0x1c411e9a96e071241c2f21f7726b17ae89e3cab4c78be50e062b03a9fffbbad1' -- sync
        
),
counter as (
    select 
        day_date,
        data,
        row_number() over (partition by day_date order by block_timestamp desc) as rnk
    from raws
),
clean_sync as (
    select
        *
    from counter
    where rnk = 1
), 
final as (
    select 
        day_date,
        hex_to_decimal(
            trim(
                LEADING 
                '0'
                from substr(data,3, 64)
            )
        )::numeric / power(10,18) as token0,
        hex_to_decimal(
            trim(
                LEADING 
                '0'
                from substr(data,3+64, 64)
            )
        )::numeric / power(10,18) as token1
    from clean_sync
)

select * from final
