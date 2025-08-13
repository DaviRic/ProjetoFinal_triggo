with base as (
    select distinct
        procedimento_solicitado,
        procedimento_realizado
    from {{ ref('stg_aih') }}
),

proc_solicitado as (
    select distinct
        procedimento_solicitado as procedimento_codigo,
        'Solicitado' as tipo
    from base
    where procedimento_solicitado is not null
),

proc_realizado as (
    select distinct
        procedimento_realizado as procedimento_codigo,
        'Realizado' as tipo
    from base
    where procedimento_realizado is not null
),

proc_union as (
    select * from proc_solicitado
    union
    select * from proc_realizado
)

select
    {{ dbt_utils.generate_surrogate_key(['procedimento_codigo', 'tipo']) }} as id_procedimento,
    procedimento_codigo,
    tipo
from proc_union