with base as (
    select
        distinct cnes_id,
        cnpj_hospital,
        uf
    from {{ ref('stg_aih') }}
)
select
    cnes_id as id_hospital,
    cnes_id,
    cnpj_hospital,
    uf
from base