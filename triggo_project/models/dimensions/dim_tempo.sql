with date_range as (
    select
        dateadd(day, seq4(), '2000-01-01') as data
    from table(generator(rowcount => 10958)) 
),
dim_tempo as (
    select
        to_char(data, 'YYYYMMDD') as id_data,
        data,
        extract(year from data) as ano,
        extract(month from data) as mes_num,
        monthname(data) as mes_nome,
        extract(day from data) as dia,
        dayname(data) as dia_da_semana,
        extract(quarter from data) as trimestre,
        case
            when dayofweek(data) in (1,7) then 'Fim de Semana'
            else 'Dia Útil'
        end as tipo_dia,
        case
            when data = current_date() then true
            else false
        end as e_dia_atual
    from date_range
)

select * from dim_tempo
order by data