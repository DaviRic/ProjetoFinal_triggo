with base as (
    select distinct
        proc_solic as procedimento_solicitado,
        proc_rea as procedimento_realizado
    from {{ ref('stg_aih') }}
),

PROC_SOLIC as (
    select distinct procedimento_solicitado as procedimento, 'Solicitado' as tipo from base where procedimento_solicitado is not null
),

PROC_REA as (
    select distinct procedimento_realizado as procedimento, 'Realizado' as tipo from base where procedimento_realizado is not null
),

proc_union as (
    select * from proc_solic
    union
    select * from PROC_REA
)

select
    procedimento,
    tipo
from proc_union
