with base as (
    select distinct
        cid_principal,
        cid_secundario
    from {{ ref('stg_aih') }}
),

cid_principal as (
    select distinct cid_principal as cid, 'Principal' as tipo from base where cid_principal is not null
),

cid_secundario as (
    select distinct cid_secundario as cid, 'Secundário' as tipo from base where cid_secundario is not null
),

cid_union as (
    select * from cid_principal
    union
    select * from cid_secundario
)

select
    {{ dbt_utils.generate_surrogate_key(['cid', 'tipo']) }} as id_doenca,
    cid,
    tipo
from cid_union