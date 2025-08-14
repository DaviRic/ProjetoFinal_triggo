SELECT
    cid_principal,
    SUM(valor_total_internacoes) AS gasto_total
FROM {{ ref('mrt_internacoes_mensal') }}
WHERE estado = 'AM'
GROUP BY 1
ORDER BY gasto_total DESC
LIMIT 5;
