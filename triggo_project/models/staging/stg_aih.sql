with raw_data as (
    select * from {{ source('raw', 'raw_aih') }}
)

select
    -- Hospital
    uf_zi as uf,
    cgc_hosp as cnpj_hospital,
    cnes,

    -- Paciente
    munic_res as municipio_residencia,
    cast(nasc as date) as data_nascimento,
    sexo,
    idade,
    raca_cor,

    -- Fato internação
    cast(n_aih as string) as numero_aih,
    ano_cmpt as ano_competencia,
    mes_cmpt as mes_competencia,
    cast(dt_inter as date) as data_internacao,
    cast(dt_saida as date) as data_saida,
    dias_perm as dias_permanencia,
    cast(val_tot as numeric) as valor_total,

    -- Diagnósticos
    diag_princ as cid_principal,
    diag_secun as cid_secundario

from raw_data
