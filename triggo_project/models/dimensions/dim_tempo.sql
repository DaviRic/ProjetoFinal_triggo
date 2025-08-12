with date_range as (
    select
        dateadd(day, seq4(), '2024-01-01') as data
    from table(generator(rowcount => 366)) -- 366 para cobrir o caso de ano bissexto
),
dim_tempo as (
    select
        data,
        extract(year from data) as ano,
        extract(month from data) as mes,
        extract(day from data) as dia,
        

)