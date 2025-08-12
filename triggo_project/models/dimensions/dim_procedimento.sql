with base as (
    select distinct
        proc_solic as procedimento_solicitado,
        proc_rea as procedimento_realizado
    from {{ ref('stg_aih')}}
    where proc_solic is not null
)