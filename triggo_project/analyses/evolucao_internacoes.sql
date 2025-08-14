SELECT
    ano,
    mes_nome,
    SUM(numero_internacoes) AS total_internacoes
FROM {{ ref('mrt_internacoes_mensal') }}
GROUP BY 1, 2
ORDER BY ano, mes_nome;
