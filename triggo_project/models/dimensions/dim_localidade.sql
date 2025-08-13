with stg_aih as (
    select distinct
        municipio_residencia_id,
        municipio_movimentacao_id,
        uf
    from {{ ref('stg_aih') }}
),

todas_localidades as (
    select
        municipio_residencia_id as municipio_id,
        uf
    from stg_aih
    where municipio_residencia_id is not null
    
    union
    
    select
        municipio_movimentacao_id as municipio_id,
        uf
    from stg_aih
    where municipio_movimentacao_id is not null
),

final as (
    select distinct
        municipio_id,
        uf as uf_sigla
    from todas_localidades
)

select
    {{ dbt_utils.generate_surrogate_key(['municipio_id']) }} as id_localidade,
    municipio_id,
    uf_sigla
from final