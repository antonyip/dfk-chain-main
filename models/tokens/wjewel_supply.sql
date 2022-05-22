{{
    config(
        materialized='table',
        unique_key='day_date',
        tags=['core'],
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
            ))::float / pow(10,18) as valuee
    from logs
    where topic0 = '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
        and address = lower('0xCCb93dABD71c8Dad03Fc4CE5559dC3D89F67a260') -- wjewel
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
            ))::float / pow(10,18) as valuee
    from logs
    where topic0 = '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
        and address = lower('0xCCb93dABD71c8Dad03Fc4CE5559dC3D89F67a260') -- wjewel
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
        final_burn,
        sum(final_mint) over (order by final_day_date) as jewel_on_chain_minted,
        sum(final_burn) over (order by final_day_date) as jewel_on_chain_burnt,
        final_mint - final_burn as daily_jewel_supply,
        sum(final_mint - final_burn) over (order by final_day_date) as current_jewel_in_circulation
    from combine
)

select * from final
