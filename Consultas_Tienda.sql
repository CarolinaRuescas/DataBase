-- Filtramos con WHERE
SELECT * FROM producto;
SELECT * FROM producto WHERE precio > 300;
SELECT nombre FROM producto WHERE precio > 300;
SELECT * FROM producto WHERE precio BETWEEN 100 AND 200;

-- Expresión regular que en este caso muestra lo que empieza por 'monitor'
SELECT nombre FROM producto WHERE nombre LIKE 'Monitor%';
-- para que apàrezca lo que tiene a la izquiereda y a la decrecha '%palabra%'
SELECT nombre FROM producto WHERE nombre LIKE '%LED%';
-- al poner LOWER lo que se hace es que la busqueda coja tanto las palabra que estan en mayuscula o
-- tneiendo que poner tambien la palabra que va entre %...% en minuscula
SELECT nombre FROM producto WHERE LOWER(nombre) LIKE '%LED%';

-- Búsqueda con COLLATE (cotejamiento)
-- collate: ai (accent sensitive), ai (accent insensitive)
--          cs (case sensitive), ci (case insensitive)
SELECT nombre FROM producto WHERE LOWER(nombre) COLLATE utf8mb4_0900_as_cs LIKE '%LED%';
SHOW COLLATION LIKE 'utf8mb4%';
-- Lo que aparece con @ permite hacer ocnsultas que son variables en la base de datos
SELECT @@character_set_database, @@collation_database; 
SELECT nombre FROM producto WHERE (nombre) COLLATE utf8mb4_0900_as_cs LIKE '%monitor%';
SELECT nombre FROM producto WHERE nombre LIKE 'monitor%';
SHOW COLLATION LIKE 'utf8mb4%cs';

SELECT nombre FROM producto WHERE nombre LIKE 'Disco SSD _ TB';
-- si tubiera información de disco de...TB y ... de memoria, si ponemos % combina
-- ejemplo: 
--        Memoria 5 TB
--        Disco Duro 1 TB
--        Disco SSD 8 TB
--     No haría match en: "Dico duro 10 TB", ya que '_' indica que solo es un caracter, y 10 son dos.
SELECT nombre FROM producto WHERE nombre LIKE '% _ TB';
-- Si quisiera que mostrase tanto los de un caracter '_' como con dos '__' habría que ponerlo así:
SELECT nombre FROM producto WHERE nombre LIKE '% _ TB' OR nombre LIKE '% __ TB';


-- ORDENAR RESULTADOS
SELECT * FROM producto;
SELECT * FROM producto ORDER BY precio;

-- Para hacer la busqueda ascendente (que es la busqueda por defecto)
SELECT * FROM producto ORDER BY precio ASC;

-- Para hacer la busqueda descendente.
SELECT * FROM producto ORDER BY precio DESC;

-- los productos de cada uno de los fabricantes aparezcan a su vez ordenador por precio
SELECT * FROM producto ORDER BY id_fabricante;
SELECT * FROM producto ORDER BY id_fabricante, precio;

-- para que aparezca que los id d elos fabricantes aparezcan de forma descendente y precio ascendente seria 
-- (en precio no hace falta poner ASC porque por defecto lo pone ascendente):
SELECT * FROM producto ORDER BY id_fabricante DESC,precio;
-- para que aparezca que los id d elos fabricantes aparezcan de forma descendente y precio descendiente seria:
SELECT * FROM producto ORDER BY id_fabricante DESC, precio DESC;

-- despues de ordenarlo si queremos que solo se vea una columna con el resultado seria:
SELECT nombre FROM producto ORDER BY id_fabricante DESC, precio DESC;

-- PODEMOS COMBINAR TODO LO VISTO
SELECT nombre FROM producto WHERE precio > 100
   AND nombre LIKE 'Disco%'
   ORDER BY id_fabricante DESC, precio DESC;

-- LIMIT
SELECT * FROM fabricante;
-- al poner limit 4 la consulta se limit a abuscar en las 4 primeras
SELECT * FROM fabricante LIMIT 4;

-- si añadimos OFFSET lo que sucede es que nos limita la busqueda a las 4 siguientes desde que indicamos el OFFSET
SELECT * FROM fabricante LIMIT 4 OFFSET 1;

-- aunque solo sale un dato al poner de OFFSET 8 no pasa nada porque poongamos de limit 4
SELECT * FROM fabricante LIMIT 4 OFFSET 8;


-- DISTINCT
SELECT * FROM producto;

-- imprimir solo el id de los fabricantes que hay, aunque podemos observar que aparecen 11 cuando en realidad son 7, porque están duplicados 
SELECT id_fabricante FROM producto;

-- para que aparezcan los distintos fabricantes usamos DISTINCT, es decir, quita los duplicados de la columna seleccionada
SELECT DISTINCT id_fabricante FROM producto;

--  nos muestra los id d elos fabricantes que sean diferentes cuyo precio es este caso superen los 200
SELECT id_fabricante FROM producto WHERE precio > 200;

-- nos muestra los id d elos fabricantes que sean diferentes cuyo precio es este caso superen los 200 y sin que se repitan los fabricantes
SELECT DISTINCT id_fabricante FROM producto WHERE precio > 200;

-- muestra lo mismo que anteriormente, con la difernecia que ordena los fabricantes
SELECT DISTINCT id_fabricante FROM producto WHERE precio > 200 ORDER BY id_fabricante;

-- ¿que pasa si combinamos esto último con la columna nombre? Da ERROR porque no aparece el id_fabricante
--  y pide ordenarlo por el, por lo que solo tiene sentido ordenar por aquellas columnas que se van a mostrar
SELECT DISTINCT nombre FROM producto WHERE precio > 200 ORDER BY id_fabricante;

--  es no da ERROR porque esta ordenando una columna que si que aparece
SELECT DISTINCT nombre FROM producto WHERE precio > 200 ORDER BY nombre; 

-- se muestran todas las columnas que su precio es mayor que 200, ordenando solo la columna de nombre
SELECT * FROM producto WHERE precio > 200 ORDER BY nombre; 