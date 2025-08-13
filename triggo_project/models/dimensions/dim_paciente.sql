with stg_aih as (
    select distinct
        municipio_residencia_id,
        data_nascimento,
        sexo,
        idade,
        raca_cor
    from {{ ref('stg_aih') }}
    where municipio_residencia_id is not null
    and sexo is not null
    and idade is not null
    and raca_cor is not null
),

final as (
    select
        municipio_residencia_id,
        data_nascimento,
        sexo,
        idade,
        raca_cor,
        case
            when idade < 1 then '0-1 ano'
            when idade between 1 and 4 then '1-4 anos'
            when idade between 5 and 14 then '5-14 anos'
            when idade between 15 and 49 then '15-49 anos'
            when idade between 50 and 64 then '50-64 anos'
            when idade >= 65 then '65+ anos'
            else 'Nao Informado'
        end as faixa_etaria
    from stg_aih
)

select
    {{ dbt_utils.generate_surrogate_key([
        'municipio_residencia_id', 
        'data_nascimento', 
        'sexo', 
        'idade', 
        'raca_cor'
    ]) }} as id_paciente,
    municipio_residencia_id,
    data_nascimento,
    sexo,
    idade,
    raca_cor,
    faixa_etaria
from final
