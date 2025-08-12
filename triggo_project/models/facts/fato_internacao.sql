select
    numero_aih,
    ano_competencia,
    mes_competencia,
    data_internacao,
    data_saida,
    dias_permanencia,
    valor_total,
    cid_principal,
    cid_secundario,
    cnpj_hospital,
    municipio_residencia
from {{ ref('stg_aih') }}
