select distinct
    cod_idade as codigo_idade,
    idade,
    sexo
from {{ ref('stg_aih') }}
where cod_idade is not null and idade is not null and sexo is not null
