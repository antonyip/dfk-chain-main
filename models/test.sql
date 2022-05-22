{{
    config(
        materialized='table',
        unique_key='day_date',
        tags=['core'],
        cluster_by=['block_timestamp']
    )
}}

select * from logs
where topic0 = '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
and address = lower('0xCCb93dABD71c8Dad03Fc4CE5559dC3D89F67a260')
