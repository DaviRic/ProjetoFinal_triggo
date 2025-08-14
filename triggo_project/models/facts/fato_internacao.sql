with stg_aih as (
    select * from {{ ref('stg_aih') }}
),

dim_doenca_base as (
    select * from {{ ref('dim_doenca') }}
),

dim_hospital_base as (
    select * from {{ ref('dim_hospital') }}
),

dim_localidade_base as (
    select * from {{ ref('dim_localidade') }}
),

dim_procedimento_base as (
    select * from {{ ref('dim_procedimento') }}
),

dim_tempo_base as (
    select * from {{ ref('dim_tempo') }}
)

select
    -- Métricas e fatos da internação
    stg.numero_aih,
    stg.ano_competencia,
    stg.mes_competencia,
    stg.dias_permanencia,
    stg.valor_total,
    stg.morte,

    -- Chaves Estrangeiras para as dimensões
    coalesce(dim_doenca_principal.id_doenca, '-1') as fk_doenca_principal,
    coalesce(dim_doenca_secundaria.id_doenca, '-1') as fk_doenca_secundaria,
    coalesce(dim_hospital.id_hospital, '-1') as fk_hospital,
    coalesce(dim_localidade_residencia.id_localidade, '-1') as fk_localidade_residencia,
    coalesce(dim_localidade_movimentacao.id_localidade, '-1') as fk_localidade_movimentacao,
    coalesce(dim_procedimento_solicitado.id_procedimento, '-1') as fk_procedimento_solicitado,
    coalesce(dim_procedimento_realizado.id_procedimento, '-1') as fk_procedimento_realizado,
    coalesce(dim_tempo.id_data, '19000101') as fk_tempo_internacao_data,
    coalesce(dim_tempo_saida.id_data, '19000101') as fk_tempo_saida_data

from stg_aih as stg
left join dim_doenca_base as dim_doenca_principal
    on stg.cid_principal = dim_doenca_principal.cid and dim_doenca_principal.tipo = 'Principal'
left join dim_doenca_base as dim_doenca_secundaria
    on stg.cid_secundario = dim_doenca_secundaria.cid and dim_doenca_secundaria.tipo = 'Secundário'
left join dim_hospital_base as dim_hospital
    on stg.cnes_id = dim_hospital.cnes_id
left join dim_localidade_base as dim_localidade_residencia
    on stg.municipio_residencia_id = dim_localidade_residencia.municipio_id
left join dim_localidade_base as dim_localidade_movimentacao
    on stg.municipio_movimentacao_id = dim_localidade_movimentacao.municipio_id
left join dim_procedimento_base as dim_procedimento_solicitado
    on stg.procedimento_solicitado = dim_procedimento_solicitado.procedimento_codigo and dim_procedimento_solicitado.tipo = 'Solicitado'
left join dim_procedimento_base as dim_procedimento_realizado
    on stg.procedimento_realizado = dim_procedimento_realizado.procedimento_codigo and dim_procedimento_realizado.tipo = 'Realizado'
left join dim_tempo_base as dim_tempo
    on stg.data_internacao = dim_tempo.data
left join dim_tempo_base as dim_tempo_saida
    on stg.data_saida = dim_tempo_saida.data