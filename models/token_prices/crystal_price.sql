{{
    config(
        materialized='table',
        unique_key='day_date',
        tags=['core', 'price', 'daily'],
        cluster_by=['day_date']
    )
}}

-- token0 is crystal
-- token1 is usdc
select 
    day_date,
    token1 / token0 as price
from {{ ref('crystal_usdc_sync') }}