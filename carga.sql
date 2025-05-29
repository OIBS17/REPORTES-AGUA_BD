DROP TABLE IF EXISTS reportes_agua;
CREATE TABLE reportes_agua (
    folio_incidente VARCHAR(20),
    fecha_registro_incidente DATE NOT NULL,
    id_reporte VARCHAR(20),
    fecha_reporte DATE,
    hora_reporte TIME,
    clasificacion VARCHAR(20),
    reporte VARCHAR(20),
    medio_recepcion VARCHAR(50),
    alcaldia_catalogo VARCHAR(50),
    colonia_catalogo VARCHAR(50),
    longitud DOUBLE PRECISION,
    latitud DOUBLE PRECISION
);