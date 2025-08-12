with base as (
    select distinct
        proc_solic as procedimento_solicitado,
        proc_rea as procedimento_realizado
    from {{ ref('stg_aih')}}
    where proc_solic is not null
)

select
    row_number() over (order by procedimento_solicitado) as id_procedimento,
    procedimento_solicitado
    procedimento_realizado,
from base