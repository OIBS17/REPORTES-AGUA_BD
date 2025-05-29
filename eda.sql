-- Número total de reportes
SELECT COUNT(*) FROM reportes_agua;

-- Reportes por alcaldía
SELECT alcaldia_catalogo, COUNT(*) AS total
FROM reportes_agua
GROUP BY alcaldia_catalogo
ORDER BY total DESC;

-- Reportes por colonia
SELECT colonia_catalogo, COUNT(*) AS total
FROM reportes_agua
GROUP BY colonia_catalogo
ORDER BY total DESC;

-- Clasificación más común
SELECT clasificacion, COUNT(*) AS total
FROM reportes_agua
GROUP BY clasificacion
ORDER BY total DESC;

--Clasificación más común por alcaldía
SELECT *
FROM (
    SELECT
        alcaldia_catalogo,
        clasificacion,
        COUNT(*) AS total,
        RANK() OVER (PARTITION BY alcaldia_catalogo ORDER BY COUNT(*) DESC) AS rnk
    FROM reportes_agua
    GROUP BY alcaldia_catalogo, clasificacion
) sub
WHERE rnk = 1;

--Subclasificación más común
SELECT reporte, COUNT(*) AS total 
FROM reportes_agua
GROUP BY reporte
ORDER BY total DESC;

--Clasificación más común por alcaldía
SELECT *
FROM (
    SELECT
        alcaldia_catalogo,
        reporte,
        COUNT(*) AS total,
        RANK() OVER (PARTITION BY alcaldia_catalogo ORDER BY COUNT(*) DESC) AS rnk
    FROM reportes_agua
    GROUP BY alcaldia_catalogo, reporte
) sub
WHERE rnk = 1;

SELECT colonia_catalogo, COUNT(*) AS total
FROM reportes_agua
WHERE clasificacion ILIKE '%agua potable%'
GROUP BY colonia_catalogo
ORDER BY total DESC
LIMIT 5;


-- Reportes por hora
SELECT DATE_PART('hour', hora_reporte) AS hora_del_dia, COUNT(*) AS total
FROM reportes_agua
GROUP BY hora_del_dia
ORDER BY hora_del_dia DESC;

--Medio más común
SELECT medio_recepcion, COUNT(*) AS total 
FROM reportes_agua
GROUP BY medio_recepcion
ORDER BY total DESC;

--Año con más reportes
SELECT EXTRACT(YEAR FROM fecha_reporte) AS anio, COUNT(*) AS total
FROM reportes_agua
GROUP BY anio
ORDER BY anio DESC;

--Meses y reportes
SELECT TO_CHAR(fecha_reporte, 'YYYY-MM') AS mes, COUNT(*) AS total
FROM reportes_agua
GROUP BY mes
ORDER BY total DESC;

--Fechas límite
SELECT
    MIN(fecha_reporte) AS fecha_minima,
    MAX(fecha_reporte) AS fecha_maxima,
    MIN(fecha_registro_incidente) AS fecha_registro_minima,
    MAX(fecha_registro_incidente) AS fecha_registro_maxima
FROM reportes_agua;

--Anomalías de fecha
SELECT *
FROM reportes_agua
WHERE fecha_reporte > fecha_registro_incidente;


SELECT id_reporte, COUNT(*) AS repeticiones
FROM reportes_agua
GROUP BY id_reporte
HAVING COUNT(*) > 1
ORDER BY repeticiones DESC;

SELECT folio_incidente, COUNT(*) AS repeticiones
FROM reportes_agua
GROUP BY folio_incidente
HAVING COUNT(*) > 1
ORDER BY repeticiones DESC;

SELECT COUNT(*) AS total_id_reporte_unicos
FROM (
    SELECT id_reporte
    FROM reportes_agua_l
    GROUP BY id_reporte
    HAVING COUNT(*) = 1
) AS sub;