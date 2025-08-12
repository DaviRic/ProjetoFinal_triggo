select distinct
  case
    when idade between 0 and 10 then '0-10'
    when idade between 11 and 20 then '11-20'
    when idade between 21 and 30 then '21-30'
    when idade between 31 and 40 then '31-40'
    when idade between 41 and 50 then '41-50'
    when idade between 51 and 60 then '51-60'
    else 'Mais de 60'
  end as faixa_etaria,
  sexo
from {{ ref('stg_aih') }}
where idade is not null and sexo is not null