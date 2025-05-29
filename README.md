# REPORTES-AGUA_BD
Este proyecto busca analizar la base de datos que recoge infromación sobre reportes de agua en la Ciudad de México, con el objetivo de buscar patrones espaciales y/o temporales así como evaluar los tipos de problemas más comúnes para así poder buscar factores problemáticos y poder mejorar el sistema de agua en la Ciudad de México en el cual se estima que cerca del **40%** del agua limpia se pierde en fugas.
Los datos están en el **[Portal de Datos Abiertos de la CDMX](https://datos.cdmx.gob.mx/dataset/reportes-de-agua)** y son recopilados por el Sistema de Aguas de la Ciudad de México (**SACMEX**). Parece se que es actualizada periódicamente siendo la última actualización del 1 de abril de 2025. Sin embargo, el análisis siguiente se hizo de los años 2022 y 2023 debido a que solo hay datos del mes de enero de 2024.
La base de datos cuenta con **12 atributos** y **313,756 registros** 
-**folio_incidente** (_texto_)         -> identificador único del incidente 
-**fecha_registro_incidente** (_temporal_) -> fecha en que se hizo el reporte
-**id_reporte** (_texto_)               -> identificador único del reporte
-**fecha_reporte** (_temporal_)         -> día, mes y año en el que sucedió el reporte
-**hora_reporte** (_temporal_)           -> hora en la que sucedió el reporte
-**clasificación** (_categórico_)       -> Clasificación del Reporte: Agua Potable / Agua Tratada / Drenaje
-**reporte** (_categórico_)           -> Subclasificación del Reporte: **Fugas /Falta de agua /Drenaje obstruido** / Mala calidad /Mal uso / Encharcamientos / entre otros...
-**medio_recepción** (_categórico_)   -> Medio por el cual se hizo el reporte: **Ciudadano (Call Center) / Alcaldía / Redes Sociales** /entre otros...
-**alcaldía_catálogo** (_categórico_)   -> Alcaldía en la que sucedió el reporte
-**colonia_catálogo** (_categórico_)   -> Colonia en la que sucedió el reporte
-**longitud** (_numérico_)             -> Longitud
-**latitud** (_numérico_)               -> Latitud

### Carga inicial [carga.sql]()
#Crear la base de datos
  ```
  CREATE DATABASE reportes_agua;
  ```
#Cronectarse a la base de datos
  ```
  \c reportes_agua
  ```
#Crear la tabla
  ```
  CREATE TABLE reportes_agua(
    folio_incidente TEXT,
    fecha_registro_incidente DATE,
    id_reporte TEXT,
    fecha_reporte DATE,
    hora_reporte TIME,
    clasificacion TEXT,
    reporte TEXT,
    medio_recepcion TEXT,
    alcaldia_catalogo TEXT,
    colonia_catalogo TEXT,
    longitud DOUBLE PRECISION,
    latitud DOUBLE PRECISION
  );
  ```
#Cargar los datos (asegurate de tener el formato compatible)
  ```
  \copy reportes_agua FROM '/ruta/al/archivo/reportes_agua.csv' WITH (FORMAT csv, HEADER true);
  ```
### Análisis exploratorio [eda.sql]()
A partir de este análisis exploratorio se encontraron varios descubrimientos interesantes:
-La alcaldía con más reportes es **Gustavo A. Madero con 54,431**.
-La colonia con más reportes es la **Agrícola Oriental en 2022 con 8,003 reportes** (Alcaldía Iztacalco)
-Hay 956 reportes sin alcaldía y 4,775 reportes sin colonia.
-La clasificación con muchos más reportes **Agua Potable con 283,550** comparado con Drenaje con 29,775 y Agua Tratada con solo 431. Además, Agua Potable es la clasificación más común de todas las alcaldías.
-El tipo de reporte más común es **Falta de Agua con 173,404 reportes**.
-El medio más común de reportes es a través de **Call Center con 246,292 reportes**.
-La hora con más reportes son las **11:00 am con 30,463 reportes**.
-En 2022 hubo **165,018 reportes** y en 2023 **130,878**, se decidió descartar 2024 para el análisis pues solo hay información de los primeros meses solo habiendo 17,860 reportes.
-Podemos ver que puede haber un error pues en 2022 el mes con más reportes fue **abril con 24,305** reportes mientras que en abril de 2023 solo hay 250 registrados.
-Vemos que folio no son únicos sino que se repiten, mientras que id_reporte si es único.
-La única inconsistencia que se encontró fue que existen registros con registro del incidente menor a la fecha en la que sucedió el reporte.

Las subclasificaciones más comúnes por alcaldía:
Álvaro Obregón	|Fuga |	13,354	
Azcapotzalco	|Falta de agua	| 9,201	
Benito Juárez	|Falta de agua	| 14,298	
Coyoacán	|Falta de agua	| 15,140	
Cuajimalpa de Morelos	|Falta de agua	| 3,467	
Cuauhtémoc	|Falta de agua	| 13,441	
Gustavo A. Madero	|Falta de agua	| 33,059	
Iztacalco	|Falta de agua	| 16,281	
Iztapalapa	|Falta de agua	| 13,222	
La Magdalena Contreras	|Fuga	| 4,455	
Miguel Hidalgo	|Fuga	| 5,654	
Milpa Alta	|Falta de agua	| 1,231	
Tláhuac	|Falta de agua	| 5,826	
Tlalpan	|Falta de agua |	18,196	
Venustiano Carranza	|Falta de agua	| 7,526	
Xochimilco	|Falta de agua	| 5,033	

### Limpieza [limpieza.sql]()
Para limpiar los datos primero quitamos acentos y pusimos mayúsuclas a las alcaldías y colonias, esto además nos ayudará a hacer compatible nuestra base de datos con futuras conexiones que busquemos.
Se eliminaron registros en los que las coordenadas eran nula.
Se eliminaron los registros con anomalías de fecha.
Se eliminaron registros con coordenadas que no estuvieran en la CDMX.
Además se eliminaron registros repetidos.
Se eliminaron 12,713 filas repetidas.

### Normalización [normalizacion.sql]()

La base de datos está en Primera, Segunda y Tercera Forma Normal (3FN) porque:

Cada tabla tiene clave primaria única.

No hay dependencias parciales, los atributos dependen totalmente de la clave

No hay dependencias transitivas.

Está en **Cuarta Forma Normal (4FN)** porque no existen dependencias multivaluadas en ninguna tabla. No hay atributos que representen múltiples valores independientes para una misma clave primaria en la tabla reporte ni en ninguna otra tabla.


### Consultas [consultas.sql]()

