{{
    config(
        materialized='table',
        unique_key='day_date',
        tags=['core', 'price', 'daily'],
        cluster_by=['day_date']
    )
}}

with c_price as (
    select 
        day_date,
        price
    from {{ ref('crystal_price') }}
)

-- token0 is crystal
-- token1 is avax
select 
    j.day_date,
    j.token0 / j.token1 * c.price as price
from {{ ref('crystal_avax_sync') }} as j
left join c_price c on c.day_date = j.day_date
