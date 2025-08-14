SELECT
  cid_principal,
  SUM(numero_obitos) AS total_obitos
FROM triggo_db.raw.mrt_internacoes_mensal
WHERE
  estado = 'AM' AND ano = 2024
GROUP BY
  cid_principal
ORDER BY
  total_obitos DESC
LIMIT 5;