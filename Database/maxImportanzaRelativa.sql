-- LOCALITA' ORDINATE PER MASSIMA IMPORTANZA RELATIVA
SELECT luogo.id AS identificativo, luogo.nome AS localita, (
	SELECT COUNT(*) / (
		SELECT COUNT(*) FROM corrispondenza WHERE opera = 1 
	)
	FROM corrispondenza, luogo
	WHERE luogo.id = corrispondenza.luogo AND opera = 1 AND luogo.id = identificativo
	GROUP BY luogo.id
	ORDER BY luogo.id
) AS pesoPH, (
	SELECT COUNT(*) / (
		SELECT COUNT(*) FROM corrispondenza WHERE opera = 2 
	) AS peso
	FROM corrispondenza, luogo
	WHERE luogo.id = corrispondenza.luogo AND opera = 2  AND luogo.id = identificativo
	GROUP BY luogo.id
	ORDER BY luogo.id
) AS pesoBC
FROM luogo
ORDER BY GREATEST(pesoPH, pesoBC) DESC;