with base as (
    select distinct
        diag_princ as cid10_codigo,
        diag_secun as cid10_secundario
    from {{ ref('stg_aih')}}
    where diag_princ is not null
)

select
    row_number() over (order by cid10_codigo) as id_doenca,
    cid10_codigo,
    cid10_secundario
from base
