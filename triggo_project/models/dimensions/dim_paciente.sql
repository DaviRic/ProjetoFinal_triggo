with base as (
    select
        distinct
        municipio_residencia,
        data_nascimento,
        sexo,
        idade,
        raca_cor
    from {{ ref('stg_aih') }}
)

select
    municipio_residencia,
    data_nascimento,
    sexo,
    idade,
    raca_cor
from base
