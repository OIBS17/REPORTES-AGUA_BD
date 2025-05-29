--Eliminamos repetidos
WITH cte AS (
    SELECT
        ctid,
        ROW_NUMBER() OVER (
            PARTITION BY 
                folio_incidente,
                fecha_registro_incidente,
                id_reporte,
                fecha_reporte,
                hora_reporte,
                clasificacion,
                reporte,
                medio_recepcion,
                alcaldia_catalogo,
                colonia_catalogo,
                longitud,
                latitud
            ORDER BY ctid
        ) AS rn
    FROM reportes_agua
)
DELETE FROM reportes_agua
WHERE ctid IN (
    SELECT ctid FROM cte WHERE rn > 1
);

DROP TABLE IF EXISTS reportes_agua_l;

CREATE TABLE reportes_agua_l AS
SELECT
    folio_incidente,
    fecha_registro_incidente,
    id_reporte,
    fecha_reporte,
    hora_reporte,
    INITCAP(clasificacion) AS clasificacion,
    INITCAP(reporte) AS reporte,
    INITCAP(medio_recepcion) AS medio_recepcion,
    -- Ponemos en mayúsculas y sin acentos
    UPPER(TRANSLATE(alcaldia_catalogo, 'áéíóúÁÉÍÓÚñÑ', 'aeiouAEIOUnN')) AS alcaldia_catalogo,
    UPPER(TRANSLATE(colonia_catalogo, 'áéíóúÁÉÍÓÚñÑ', 'aeiouAEIOUnN')) AS colonia_catalogo,
    longitud,
    latitud
FROM reportes_agua
WHERE
    longitud IS NOT NULL --Eliminamos registros con coordenadas nulas
    AND latitud IS NOT NULL
    AND (
        folio_incidente IS NOT NULL AND folio_incidente NOT ILIKE 'NA'
    )
    AND (
        id_reporte IS NOT NULL AND id_reporte NOT ILIKE 'NA'
    )
    AND (
        clasificacion IS NOT NULL AND clasificacion NOT ILIKE 'NA'
    )
    AND (
        reporte IS NOT NULL AND reporte NOT ILIKE 'NA'
    )
    AND (
        medio_recepcion IS NOT NULL AND medio_recepcion NOT ILIKE 'NA'
    )
    AND (
        alcaldia_catalogo IS NOT NULL AND alcaldia_catalogo NOT ILIKE 'NA'
    )
    AND (
        colonia_catalogo IS NOT NULL AND colonia_catalogo NOT ILIKE 'NA'
    )
    AND fecha_reporte >= fecha_registro_incidente --Corregimos anomalísa de fechas
    AND longitud BETWEEN -100 AND -98     -- Coordenadas en la CDMX
    AND latitud BETWEEN 18 AND 20;
    