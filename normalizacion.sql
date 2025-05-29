DROP TABLE IF EXISTS alcaldia;
CREATE TABLE alcaldia (
	id SERIAL PRIMARY KEY,
	nombre_alcaldia VARCHAR(50)
);

DROP TABLE IF EXISTS colonia;
CREATE TABLE colonia (
	id SERIAL PRIMARY KEY,
	nombre_colonia VARCHAR(100)
);

DROP TABLE IF EXISTS categoria;
CREATE TABLE categoria (
	id SERIAL PRIMARY KEY,
	categoria VARCHAR(20)
);

DROP TABLE IF EXISTS subcategoria;
CREATE TABLE subcategoria (
	id SERIAL PRIMARY KEY,
	subcategoria VARCHAR(50)
);

DROP TABLE IF EXISTS reporte;
CREATE TABLE reporte (
    id_reporte VARCHAR(20) PRIMARY KEY,
    fecha_reporte DATE,
    hora_reporte TIME,
    categoria_id INTEGER,
    FOREIGN KEY (categoria_id) REFERENCES categoria(id),
    subcategoria_id INTEGER,
    FOREIGN KEY (subcategoria_id) REFERENCES subcategoria(id),
    medio_recepcion VARCHAR(50),
    alcaldia_id INTEGER,
    FOREIGN KEY (alcaldia_id) REFERENCES alcaldia(id),
    colonia_id INTEGER,
    FOREIGN KEY (colonia_id) REFERENCES colonia(id),
    longitud DOUBLE PRECISION,
    latitud DOUBLE PRECISION
);

INSERT INTO alcaldia (nombre_alcaldia)
SELECT DISTINCT TRIM(alcaldia_catalogo)
FROM reportes_agua_l;

INSERT INTO colonia(nombre_colonia)
SELECT DISTINCT TRIM(colonia_catalogo)
FROM reportes_agua_l;

INSERT INTO categoria (categoria)
SELECT DISTINCT clasificacion
FROM reportes_agua_l;

INSERT INTO subcategoria (subcategoria)
SELECT DISTINCT reporte
FROM reportes_agua_l;

INSERT INTO reporte (
    id_reporte,
    fecha_reporte,
    hora_reporte,
    categoria_id,
    subcategoria_id,
    medio_recepcion,
    alcaldia_id,
    colonia_id,
    longitud,
    latitud
)
SELECT
    r.id_reporte,
    r.fecha_reporte,
    r.hora_reporte,
    c.id AS categoria_id,
    s.id AS subcategoria_id,
    r.medio_recepcion,
    a.id AS alcaldia_id,
    co.id AS colonia_id,
    r.longitud,
    r.latitud
FROM reportes_agua_l r
LEFT JOIN categoria c ON r.clasificacion = c.categoria
LEFT JOIN subcategoria s ON r.reporte = s.subcategoria
LEFT JOIN alcaldia a ON r.alcaldia_catalogo = a.nombre_alcaldia
LEFT JOIN colonia co ON r.colonia_catalogo = co.nombre_colonia
WHERE r.id_reporte IS NOT NULL;
