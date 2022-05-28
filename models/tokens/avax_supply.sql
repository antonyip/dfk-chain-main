{{
    config(
        materialized='incremental',
        unique_key='day_date',
        tags=['core','hour6','mints'],
        cluster_by=['block_timestamp']
    )
}}

with
raw_mints as (
    select
        date_trunc('day', block_timestamp) as day_date,
        hex_to_decimal(
            trim(
                LEADING '0'
                from
                substr(data,3)
            ))::numeric / pow(10,18) as valuee
    from logs
    where {{ incremental_last_x_days('day_date', 2) }}
        and topic0 = '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
        and address = lower('0xB57B60DeBDB0b8172bb6316a9164bd3C695F133a') -- avax
        and topic1 = '0x0000000000000000000000000000000000000000000000000000000000000000' -- mint
),
raw_burns as (
    select
        date_trunc('day', block_timestamp) as day_date,
        hex_to_decimal(
            trim(
                LEADING '0'
                from
                substr(data,3)
            ))::numeric / pow(10,18) as valuee
    from logs
    where {{ incremental_last_x_days('day_date', 2) }}
        and topic0 = '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
        and address = lower('0x04b9dA42306B023f3572e106B11D82aAd9D32EBb') -- crystal
        and topic2 = '0x0000000000000000000000000000000000000000000000000000000000000000' -- burn
),
mints as (
    select
        day_date,
        sum(valuee) as daily_mint
    from raw_mints
    group by 1
),
burns as (
    select
        day_date,
        sum(valuee) as daily_burn
    from raw_burns
    group by 1
),
combine as (
    select
        coalesce(m.day_date, b.day_date) as final_day_date,
        coalesce(daily_mint, 0) as final_mint,
        coalesce(daily_burn, 0) as final_burn
    from mints m
    full outer join burns b on m.day_date = b.day_date
),
final as (
    select
        final_day_date,
        final_mint,
        final_burn
    from combine
)

select * from final
