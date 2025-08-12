with base as (
    select distinct
        munic_res as municipio_id,
        municipio_residencia as municipio_nome,
        uf_zi as estado_sigla
    from {{ ref('stg_aih') }}
)

select
    municipio_id,
    municipio_nome,
    estado_sigla
from base
