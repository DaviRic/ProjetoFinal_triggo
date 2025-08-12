with date_range as (
    select
        dateadd(day, seq4(), '2024-01-01') as data
    from table(generator(rowcount => 366)) 
),
dim_tempo as (
    select
        data,
        extract(year from data) as ano,
        extract(month from data) as mes,
        extract(day from data) as dia,
        extract(quarter from data) as trimestre,
        to_char(data, 'YYYY-MM-DD') as data_formatada,
        dayofweek(data) as dia_da_semana,
        case
            when dayofweek(data) in (1,7) then 'Fim de Semana'
            else 'Dia Útil'
        end as tipo_dia
    from date_range
)

select * from dim_tempo
order by data;
