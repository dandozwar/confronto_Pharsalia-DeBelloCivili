-------------------------------------------------------------------------------
------------------------ORIZZONTE COGNITIVO------------------------------------
-------------------------------------------------------------------------------
-- PESO
-- peso = occorrenze / sommatoria(occorrenze)
SELECT luogo.id, COUNT(*) / (
	SELECT COUNT(*) FROM corrispondenza WHERE opera = 1 
) AS peso
FROM corrispondenza, luogo
WHERE luogo.id = corrispondenza.luogo AND opera = 1
GROUP BY luogo.id
ORDER BY luogo.id;

-- X
-- X = sommatoria(peso * cos (latitudine) * cos (longitudine))
CREATE TEMPORARY TABLE singole_x (luogo SMALLINT PRIMARY KEY, x DECIMAL(20, 19));

INSERT INTO singole_x (x, luogo)
	SELECT ((COUNT(*) / (
		SELECT COUNT(*) FROM corrispondenza WHERE opera = 1
	)) * COS(RADIANS(latitudine)) * COS(RADIANS(longitudine))), luogo.id
	FROM corrispondenza, luogo
	WHERE luogo.id = corrispondenza.luogo AND opera = 1
	GROUP BY luogo.id
	ORDER BY luogo.id;
    
INSERT INTO variabile (id, valore) VALUES ('x_PH', (SELECT SUM(x) FROM singole_x));

-- Y
-- Y = sommatoria(peso * cos (latitudine) * sin (longitudine))
CREATE TEMPORARY TABLE singole_y (y DECIMAL(20, 19));

INSERT INTO singole_y (y)
	SELECT ((COUNT(*) / (
		SELECT COUNT(*) FROM corrispondenza WHERE opera = 1
	)) * COS(RADIANS(latitudine)) * SIN(RADIANS(longitudine)))
	FROM corrispondenza, luogo
	WHERE luogo.id = corrispondenza.luogo AND opera = 1
	GROUP BY luogo.id
	ORDER BY luogo.id;
    
INSERT INTO variabile (id, valore) VALUES ('y_PH', (SELECT SUM(y) FROM singole_y));

-- Z
-- Z = sommatoria(peso * sin (latitudine))
CREATE TEMPORARY TABLE singole_z (z DECIMAL(20, 19));

INSERT INTO singole_z (z)
	SELECT ((COUNT(*) / (
		SELECT COUNT(*) FROM corrispondenza WHERE opera = 1
	)) * SIN(RADIANS(latitudine)))
	FROM corrispondenza, luogo
	WHERE luogo.id = corrispondenza.luogo AND opera = 1
	GROUP BY luogo.id
	ORDER BY luogo.id;
    
INSERT INTO variabile (id, valore) VALUES ('z_PH', (SELECT SUM(z) FROM singole_z));

-- LATITUDINE CENTRO
-- latitudineC = arctan (Z/r(X^2 + Y^2))
SET @x_PH = (SELECT valore FROM variabile WHERE id = 'x_PH'); 
SET @y_PH = (SELECT valore FROM variabile WHERE id = 'y_PH'); 
SET @z_PH = (SELECT valore FROM variabile WHERE id = 'z_PH');

INSERT INTO variabile (id, valore) VALUES ('latiC_PH', DEGREES(ATAN(@z_PH / (SQRT(POW(@x_PH, 2) + POW(@y_PH,2))))));

-- LONGITUDINE CENTRO
-- longitudineC = arctan (Y/X)
SET @x_PH = (SELECT valore FROM variabile WHERE id = 'x_PH'); 
SET @y_PH = (SELECT valore FROM variabile WHERE id = 'y_PH');

INSERT INTO variabile (id, valore) VALUES ('longC_PH', DEGREES(ATAN(@y_PH / @x_PH)));

-- DISTANZA DAL CENTRO DI UN PUNTO
-- distanza = raggioT * arccos(cos(latitudine) * cos (latitudineC) * cos(longitudine - longitudineC) + sin(latitudine) * sin(latitudineC))
SET @latiC_PH = (SELECT valore FROM variabile WHERE id = 'latiC_PH'); 
SET @longC_PH = (SELECT valore FROM variabile WHERE id = 'longC_PH');

SELECT luogo.id, luogo.nome, (
	6378.4 * ACOS(COS(RADIANS(latitudine)) * COS(RADIANS(@latiC_PH)) * COS(RADIANS(longitudine - @longC_PH)) + (SIN(RADIANS(latitudine)) * SIN(RADIANS(@latiC_PH))))
) AS distanza
FROM luogo, corrispondenza
WHERE luogo.id = corrispondenza.luogo AND opera = 1
GROUP BY luogo.id
ORDER BY luogo.id;

-- RAGGIO DI PERCEZIONE
-- raggioP = sommatoria(peso * distanza)
SET @latiC_PH = (SELECT valore FROM variabile WHERE id = 'latiC_PH'); 
SET @longC_PH = (SELECT valore FROM variabile WHERE id = 'longC_PH');

CREATE TEMPORARY TABLE distanze_pesate (distanza_pesata DECIMAL(20, 15));

INSERT INTO distanze_pesate (distanza_pesata)
	SELECT 	6378.4 * ACOS(COS(RADIANS(latitudine)) * COS(RADIANS(@latiC_PH)) * COS(RADIANS(longitudine - @longC_PH)) + (SIN(RADIANS(latitudine)) * SIN(RADIANS(@latiC_PH)))) * (COUNT(luogo.id) / (
		SELECT COUNT(*) FROM corrispondenza WHERE opera = 1 
	))
	FROM luogo, corrispondenza
	WHERE luogo.id = corrispondenza.luogo AND opera = 1
	GROUP BY luogo.id
	ORDER BY luogo.id;
	
INSERT INTO variabile (id, valore) VALUES ('raggio_PH', (SELECT SUM(distanza_pesata) FROM distanze_pesate));


-- questione della Gaussiana??

-- NUOVO SET DI COORDINATE
-- latitudine' = distanza / raggioT
-- longitudine' = arctan((cos(latitudine) * sin(longitudine - longitudineC)) / ((cos(latitudine) * sin(latitudineC) * cos(longitudine - longitudineC)) - (sin(latitudine) * cos(latitudineC))))
SET @latiC_PH = (SELECT valore FROM variabile WHERE id = 'latiC_PH'); 
SET @longC_PH = (SELECT valore FROM variabile WHERE id = 'longC_PH');

CREATE TEMPORARY TABLE nuovi_punti (id SMALLINT PRIMARY KEY, latitudine DECIMAL(15,12), longitudine DECIMAL(15,12), peso DECIMAL(11, 10), distanza DECIMAL(20, 5));

INSERT INTO nuovi_punti (id, latitudine, longitudine, peso, distanza)
	SELECT luogo.id, (
		DEGREES(ACOS(COS(RADIANS(latitudine)) * COS(RADIANS(@latiC_PH)) * COS(RADIANS(longitudine - @longC_PH)) + (SIN(RADIANS(latitudine)) * SIN(RADIANS(@latiC_PH)))))
	), (
		DEGREES(ATAN((COS(RADIANS(latitudine)) * SIN(RADIANS(longitudine - @longC_PH))) / ((COS(RADIANS(latitudine)) * SIN(RADIANS(@latiC_PH)) * COS(RADIANS(longitudine - @longC_PH))) - (SIN(RADIANS(latitudine)) * COS(RADIANS(@latiC_PH))))))
	), COUNT(*) / (
		SELECT COUNT(*) FROM corrispondenza WHERE opera = 1 
	), 6378.4 * ACOS(COS(RADIANS(latitudine)) * COS(RADIANS(@latiC_PH)) * COS(RADIANS(longitudine - @longC_PH)) + (SIN(RADIANS(latitudine)) * SIN(RADIANS(@latiC_PH))))
	FROM corrispondenza, luogo
	WHERE luogo.id = corrispondenza.luogo AND opera = 1
	GROUP BY luogo.id
	ORDER BY luogo.id;

SELECT * FROM nuovi_punti;

-- I+
-- I+ = sommatoria(peso * distanza^2) / 2
-- usa nuovi_punti
INSERT INTO variabile (id, valore) VALUES ('Ip_PH', 
	(SELECT SUM(peso * POW(distanza, 2)) / 2 FROM nuovi_punti)
);

-- I-
-- I- = sommatoria(peso * distanza^2 * cos(2 * longitudine')) / 2
-- usa nuovi_punti
INSERT INTO variabile (id, valore) VALUES ('Im_PH', 
	(SELECT SUM(peso * POW(distanza, 2) * COS(RADIANS(2 * longitudine))) / 2 FROM nuovi_punti)
);

-- I12
-- I12 = sommatoria(peso * distanza^2 * sin(2 * longitudine')) / 2
-- usa nuovi_punti
INSERT INTO variabile (id, valore) VALUES ('I12_PH', 
	(SELECT SUM(peso * POW(distanza, 2) * SIN(RADIANS(2 * longitudine))) / 2 FROM nuovi_punti)
);

-- ANGOLO ASSI
-- angolo = arctan(I12 / I-) / 2
SET @Im_PH = (SELECT valore FROM variabile WHERE id = 'Im_PH'); 
SET @I12_PH = (SELECT valore FROM variabile WHERE id = 'I12_PH');

INSERT INTO variabile (id, valore) VALUES ('ang_assi_PH', DEGREES(ATAN(@I12_PH / @Im_PH) / 2));

-- SEMIASSE ORIZZONTALE
-- a = r(I+ + r((I-)^2 + (I12)^2))
SET @Ip_PH = (SELECT valore FROM variabile WHERE id = 'Ip_PH'); 
SET @Im_PH = (SELECT valore FROM variabile WHERE id = 'Im_PH'); 
SET @I12_PH = (SELECT valore FROM variabile WHERE id = 'I12_PH');

INSERT INTO variabile (id, valore) VALUES ('sem_a_PH', SQRT(@Ip_PH + SQRT(POW(@Im_PH, 2) + POW(@I12_PH, 2))));

-- SEMIASSE VERTICALE
-- b = r(I+ - r((I-)^2 + (I12)^2))
SET @Ip_PH = (SELECT valore FROM variabile WHERE id = 'Ip_PH'); 
SET @Im_PH = (SELECT valore FROM variabile WHERE id = 'Im_PH'); 
SET @I12_PH = (SELECT valore FROM variabile WHERE id = 'I12_PH');

INSERT INTO variabile (id, valore) VALUES ('sem_b_PH', SQRT(@Ip_PH - SQRT(POW(@Im_PH, 2) + POW(@I12_PH, 2))));

-------------------------------------------------------------------------------
------------------------CORRELAZIONE TESTUALE----------------------------------
-------------------------------------------------------------------------------

-- CORRELAZIONE
-- correlazione = (sommatoria(occorrenzePH * occorrenzeBC)) / (r(sommatoria(occorrenzePH)^2) * r(sommatoria(occorrenzeBC)^2))
CREATE TEMPORARY TABLE occorrenze_luogo (id SMALLINT PRIMARY KEY, opera_1 SMALLINT DEFAULT 0 NOT NULL, opera_2 SMALLINT DEFAULT 0 NOT NULL);

INSERT INTO occorrenze_luogo (id, opera_1, opera_2)
	SELECT luogo.id AS posto, (
		SELECT COUNT(*)
		FROM corrispondenza, luogo
		WHERE luogo.id = posto AND luogo.id = corrispondenza.luogo AND opera = 1
		GROUP BY luogo.id 
	), (
		SELECT COUNT(*)
		FROM corrispondenza, luogo
		WHERE luogo.id = posto AND luogo.id = corrispondenza.luogo AND opera = 2
		GROUP BY luogo.id
	)
	FROM corrispondenza, luogo 
	WHERE luogo.id = corrispondenza.luogo
	GROUP BY luogo.id;

INSERT INTO variabile (id, valore) VALUES ('corr_PH-BC', (
	SELECT SUM(opera_1 * opera_2)/(SQRT(SUM(POW(opera_1, 2))) * SQRT(SUM(POW(opera_2, 2))))
	FROM occorrenze_luogo
));