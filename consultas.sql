-- Reportes mensuales por alcaldía
SELECT
    a.nombre_alcaldia,
    EXTRACT(YEAR FROM r.fecha_reporte) AS anio,
    EXTRACT(MONTH FROM r.fecha_reporte) AS mes,
    COUNT(*) AS total_reportes
FROM reporte r
JOIN alcaldia a ON r.alcaldia_id = a.id
GROUP BY a.nombre_alcaldia, anio, mes
ORDER BY a.nombre_alcaldia, anio, mes;

-- Reportes fuera de rango geográfico típico 
SELECT
    r.id_reporte,
    a.nombre_alcaldia,
    c.nombre_colonia,
    r.longitud,
    r.latitud
FROM reporte r
JOIN alcaldia a ON r.alcaldia_id = a.id
JOIN colonia c ON r.colonia_id = c.id
WHERE r.longitud NOT BETWEEN -99.4 AND -98.9
   OR r.latitud NOT BETWEEN 19.0 AND 19.6;
--No hay :)

--Evolución de reportes por categoría
SELECT
    TO_CHAR(r.fecha_reporte, 'YYYY-MM') AS mes,
    c.categoria,
    COUNT(*) AS total_reportes
FROM reporte r
JOIN categoria c ON r.categoria_id = c.id
GROUP BY mes, c.categoria
ORDER BY mes, c.categoria;

--Evolución por sucategoría
WITH top_subcategorias AS (
    SELECT s.id, s.subcategoria
    FROM reporte r
    JOIN subcategoria s ON r.subcategoria_id = s.id
    GROUP BY s.id, s.subcategoria
    ORDER BY COUNT(*) DESC
    LIMIT 3
)
SELECT
    TO_CHAR(r.fecha_reporte, 'YYYY-MM') AS mes,
    s.subcategoria,
    COUNT(*) AS total_reportes
FROM reporte r
JOIN subcategoria s ON r.subcategoria_id = s.id
WHERE s.id IN (SELECT id FROM top_subcategorias)
GROUP BY mes, s.subcategoria
ORDER BY mes, s.subcategoria;

--Alcaldías y número de reportes
-- Para 2022
SELECT a.nombre_alcaldia, COUNT(*) AS total_2022
FROM reporte r
JOIN alcaldia a ON r.alcaldia_id = a.id
WHERE EXTRACT(YEAR FROM r.fecha_reporte) = 2022
GROUP BY a.nombre_alcaldia
ORDER BY total_2022 DESC
LIMIT 1;

-- Para 2023
SELECT a.nombre_alcaldia, COUNT(*) AS total_2023
FROM reporte r
JOIN alcaldia a ON r.alcaldia_id = a.id
WHERE EXTRACT(YEAR FROM r.fecha_reporte) = 2023
GROUP BY a.nombre_alcaldia
ORDER BY total_2023 DESC
LIMIT 1;

-- Porcentaje de categoria  por alcaldía
WITH total_reportes_alcaldia AS (
    SELECT alcaldia_id, COUNT(*) AS total
    FROM reporte
    GROUP BY alcaldia_id
)
SELECT
    a.nombre_alcaldia,
    r.categoria_id,
    COUNT(*) AS cuenta,
    ROUND((COUNT(*)::decimal / tra.total) * 100, 2) AS porcentaje
FROM reporte r
JOIN alcaldia a ON r.alcaldia_id = a.id
JOIN total_reportes_alcaldia tra ON r.alcaldia_id = tra.alcaldia_id
GROUP BY a.nombre_alcaldia, r.categoria_id, tra.total
ORDER BY a.nombre_alcaldia, porcentaje DESC;

-- Porcentaje de subcategoria por alcaldía
WITH total_reportes_alcaldia AS (
    SELECT alcaldia_id, COUNT(*) AS total
    FROM reporte
    GROUP BY alcaldia_id
)
SELECT
    a.nombre_alcaldia,
    r.subcategoria_id,
    COUNT(*) AS cuenta,
    ROUND((COUNT(*)::decimal / tra.total) * 100, 2) AS porcentaje
FROM reporte r
JOIN alcaldia a ON r.alcaldia_id = a.id
JOIN total_reportes_alcaldia tra ON r.alcaldia_id = tra.alcaldia_id
GROUP BY a.nombre_alcaldia, r.subcategoria_id, tra.total
ORDER BY a.nombre_alcaldia, porcentaje DESC;

-- 2022
SELECT c.nombre_colonia, COUNT(*) AS total_2022
FROM reporte r
JOIN colonia c ON r.colonia_id = c.id
WHERE EXTRACT(YEAR FROM r.fecha_reporte) = 2022
GROUP BY c.nombre_colonia
ORDER BY total_2022 DESC
LIMIT 3;

-- 2023
SELECT c.nombre_colonia, COUNT(*) AS total_2023
FROM reporte r
JOIN colonia c ON r.colonia_id = c.id
WHERE EXTRACT(YEAR FROM r.fecha_reporte) = 2023
GROUP BY c.nombre_colonia
ORDER BY total_2023 DESC
LIMIT 3;

-- Evolución mensual de esas colonias
WITH top_colonias AS (
    SELECT c.id
    FROM reporte r
    JOIN colonia c ON r.colonia_id = c.id
    WHERE EXTRACT(YEAR FROM r.fecha_reporte) IN (2022, 2023)
    GROUP BY c.id
    ORDER BY COUNT(*) DESC
    LIMIT 3
)
SELECT
    TO_CHAR(r.fecha_reporte, 'YYYY-MM') AS mes,
    c.nombre_colonia,
    COUNT(*) AS total
FROM reporte r
JOIN colonia c ON r.colonia_id = c.id
WHERE c.id IN (SELECT id FROM top_colonias)
GROUP BY mes, c.nombre_colonia
ORDER BY mes, c.nombre_colonia;



-- Porcentaje de medios de recepción por alcaldía
WITH total_reportes_alcaldia AS (
    SELECT alcaldia_id, COUNT(*) AS total
    FROM reporte
    GROUP BY alcaldia_id
)
SELECT
    a.nombre_alcaldia,
    r.medio_recepcion,
    COUNT(*) AS cuenta,
    ROUND((COUNT(*)::decimal / tra.total) * 100, 2) AS porcentaje
FROM reporte r
JOIN alcaldia a ON r.alcaldia_id = a.id
JOIN total_reportes_alcaldia tra ON r.alcaldia_id = tra.alcaldia_id
GROUP BY a.nombre_alcaldia, r.medio_recepcion, tra.total
ORDER BY a.nombre_alcaldia, porcentaje DESC;

--Evolución de reportes por hora
SELECT
    EXTRACT(HOUR FROM hora_reporte) AS hora,
    COUNT(*) AS total_reportes
FROM reporte
GROUP BY hora
ORDER BY hora;




