select
    numero_aih,
    ano_competencia,
    mes_competencia,
    to_date(dt_inter, 'YYYYMMDD') as data_internacao,
    to_date(dt_saida, 'YYYYMMDD') as data_saida,
    dias_perm as dias_permanencia,
    val_tot as valor_total,
    diag_princ as cid_principal,
    diag_secun as cid_secundario,
    cgc_hosp as cnpj_hospital,
    munic_res as municipio_residencia
from {{ ref('stg_aih') }}
