with fato_internacao as (
    select * from {{ ref('fato_internacao') }}
),

dim_tempo as (
    select * from {{ ref('dim_tempo') }}
),

dim_doenca as (
    select * from {{ ref('dim_doenca') }}
),

dim_localidade as (
    select * from {{ ref('dim_localidade') }}
),

internacoes_agg as (
    select
        dim_tempo.ano,
        dim_tempo.mes_num,
        dim_tempo.mes_nome,
        dim_localidade.uf_sigla as estado,
        dim_doenca.cid as cid_principal,
        count(fato_internacao.numero_aih) as numero_internacoes,
        sum(fato_internacao.dias_permanencia) as total_dias_permanencia,
        sum(fato_internacao.valor_total) as valor_total_internacoes,
        sum(case when fato_internacao.morte = 1 then 1 else 0 end) as numero_obitos
    from fato_internacao
    left join dim_tempo on fato_internacao.fk_tempo_internacao_data = dim_tempo.id_data
    left join dim_doenca on fato_internacao.fk_doenca_principal = dim_doenca.id_doenca
    left join dim_localidade on fato_internacao.fk_localidade_residencia = dim_localidade.id_localidade
    group by 1, 2, 3, 4, 5
)

select * from internacoes_agg
order by ano, mes_num, estado, cid_principal
