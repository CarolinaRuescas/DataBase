-- EJERCICIO 1. Numero de libros con más de 3 ejemplares de cada categoria.

SELECT categoria_id, ejemplares FROM libro LIMIT 10; -- Para ver todos los ejemplares que hay y de que categoria son
SELECT categoria_id, SUM(ejemplares) FROM libro GROUP BY categoria_id; -- Con esto agrupamos todos los libros por sus categorias contando los libros que tienen más o menos de 3 ejemplares

SELECT categoria_id, COUNT(*) FROM libro WHERE ejemplares >3 GROUP BY categoria_id; -- SOLUCIÓN -- Con esta consulta si que nos aparecen los libros que tienen más de 3 ejemplares
SELECT * FROM libro WHERE categoria_id = 4; -- Esto es por si queremos ver el titulo de los libros de esa categoria 



-- EJERCICIO 2. Número de libros diferentes prestados a cada usuario. 

SELECT * FROM prestamo LIMIT 10; -- imprimir los prestamos

SELECT usuario_id, COUNT(DISTINCT libro_id) FROM prestamo GROUP BY usuario_id; -- SOLUCIÓN

SELECT usuario_id, COUNT(libro_id) FROM prestamo GROUP BY usuario_id; -- si quiesieramos ver cuantos prestamos ha realizado cada usuario seria igual pero sin DISTINCT




-- EJERCICIO 2B. Número de libros diferentes prestados a cada usuario y que admeás aparezca el nombre y el apellido del usuario

SELECT u.nombre, u.apellido, COUNT(DISTINCT libro_id) FROM prestamo p JOIN usuario u ON p.usuario_id = u.id GROUP BY p.usuario_id;




-- EJERCICIO 3. Título del libro con menor fecha_prestamo de cada autor.
-- (Esto se debe hacer con subconsultas para sacar el título)




-- EJERCICIO 3B. Menor fecha_prestamo de los libros de cada autor

SELECT l.autor_id, MIN(p.fecha_prestamo) FROM libro l JOIN prestamo p ON p.libro_id = l.id GROUP BY l.autor_id;
 

-- EJERCICIO 4. Mayor tiempo de préstamo de entre los libros de cada categoría. (hemos puesto días prestamo para que quede más bonito)
SELECT l.categoria_id, MIN(p.fecha_devolucion - p.fecha_prestamo) DiasPrestamo FROM libro l JOIN prestamo p ON p.libro_id = l.id GROUP BY l.categoria_id;


-- EJERCICIO 5. Número de autores diferentes de cada categoría.

SELECT categoria_id, COUNT(DISTINCT autor_id) FROM libro GROUP BY categoria_id; --- SOLUCIÓN

SELECT categoria_id, COUNT(DISTINCT autor_id) FROM libro GROUP BY categoria_id HAVING categoria_id > 2; -- para que algunas agrupaciones aparezcan y otras no
SELECT categoria_id, COUNT(DISTINCT autor_id) FROM libro GROUP BY categoria_id HAVING categoria_id IS NOT NULL; -- para que aparezcan agrupaciones que no sean nulas 

-- EJERCICIO 6. Numero de libros de cada autor nacido después de 1920


-- EJERCICIO 7. Media de los años de vida de los autores de cada categoría.

SELECT categoria_id, avg(nacimiento - fallecimiento) FROM autor GROUP BY categoria_id;

-- EJERCICIO 8. Número de autores diferentes de libros prestados a cada usuario, sólo si están en la categoría Novela.
