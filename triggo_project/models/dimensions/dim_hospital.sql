with base as (
    select
        distinct cnpj_hospital,
        uf,
        cnes
    from {{ ref('stg_aih') }}
)

select
    cnpj_hospital,
    uf,
    cnes
from base
