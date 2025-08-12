with base as (
    select distinct
        municipio_residencia as municipio_id,
        uf as uf_zi
    from {{ ref('stg_aih') }}
)

select
    municipio_id,
    uf_zi
from base
