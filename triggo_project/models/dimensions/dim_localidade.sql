with base as (
    select distinct
        minucipio_residencia as municipio,
        uf as estado
    from {{ ref('stg_aih')}}
    where municipio_residencia is not null
)
select