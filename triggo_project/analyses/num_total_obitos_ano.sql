SELECT
    ano,
    estado,
    SUM(numero_obitos) AS total_obitos
FROM {{ ref('mrt_internacoes_mensal') }}
GROUP BY 1, 2
ORDER BY ano, estado;
