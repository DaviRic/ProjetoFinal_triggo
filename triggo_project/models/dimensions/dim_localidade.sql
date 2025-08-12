with base as (
    select distinct
        municipio_residencia as municipio,
        uf as estado
    from {{ ref('stg_aih')}}
    where municipio_residencia is not null
)

select
    row_number() over (order by municipio, estado) as id_localidade,
    municipio,
    estado
from base
