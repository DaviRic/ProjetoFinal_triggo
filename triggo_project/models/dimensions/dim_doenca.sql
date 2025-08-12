with base as (
    select distinct
        diag_princ as cid_principal,
        diag_secun as cid_secundario
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
    cid,
    tipo
from cid_union
