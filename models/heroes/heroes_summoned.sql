{{
    config(
        materialized='incremental',
        unique_key='u_key',
        tags=['game', 'daily', 'heroes'],
        cluster_by=['block_timestamp']
    )
}}

select
    concat_ws('-', log_index, transaction_hash)as u_key,
    *
from logs
where {{ incremental_last_x_days('block_timestamp', 2) }}
    and topic0 = '0xef277373d709abc6be9d4926ac62b54991f4de2b6f8718079ae3d735ded22340' -- hero summoned