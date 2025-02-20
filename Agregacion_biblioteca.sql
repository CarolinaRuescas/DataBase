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
SELECT year(fallecimiento) - YEAR(nacimiento) FROM autor;
SELECT avg(year(fallecimiento) - YEAR (nacimiento)) FROM autor;

SELECT l.categoria_id, avg(year(fallecimiento) - YEAR (nacimiento)) MediaAnyos
    FROM autor a 
        JOIN libro l ON a.id = l.autor_id
    GROUP BY l.categoria_id;

SELECT c.nombre, avg(year(fallecimiento) - YEAR (nacimiento)) MediaAnyos  -- al meter ese segundo JOIN lo que hace es que no aparezcan los NULL
    FROM autor a 
        JOIN libro l ON a.id = l.autor_id
        JOIN categoria c ON c.id = l.categoria_id
    GROUP BY l.categoria_id;

SELECT c.nombre, avg(year(fallecimiento) - YEAR (nacimiento)) MediaAnyos  -- Para que aparezcan también los NULL
    FROM autor a 
        JOIN libro l ON a.id = l.autor_id
        LEFT JOIN categoria c ON c.id = l.categoria_id
    GROUP BY l.categoria_id;


-- EJERCICIO 8. Número de autores diferentes de libros prestados a cada usuario, sólo si están en la categoría Novela.

SELECT p.usuario_id, COUNT(DISTINCT l.autor_id)
    FROM prestamo p
        JOIN libro l ON p.libro_id = l.id
        JOIN categoria c ON c.id = l.categoria_id
    WHERE c.nombre = "Novela"
    GROUP BY p.usuario_id;

-- EJERCICIO 9. Total de ejemplares de libros de cada autor
SELECT autor_id, SUM(ejemplares) FROM libro GROUP BY autor_id;

-- EJERCICIO 10. Total de ejemplares de libros de cada autor publicados depsués de 1970.

SELECT autor_id, SUM(ejemplares) FROM libro WHERE YEAR(fecha_publicacion) > 1970 GROUP BY autor_id;

-- Martes_18_Febrero

-- We can use conditional statements in mysql as the following example
--                 condition        true      false
SELECT titulo, IF(ejemplares > 10, 'Muchos', 'Pocos') AS Cantidad FROM libro;

-- EX 1: number of examples in every category
SELECT count(*) FROM libro GROUP BY categoria_id;

-- Its posible to convine aggregation functions with if statements
--                  NULL rows wont be counted
SELECT categoria_id, COUNT(IF(ejemplares > 10, 1, NULL)) FROM libro GROUP BY categoria_id;

-- This consult wont work because, even thought a 0 means nothing, COUNT function will count it as a row
SELECT categoria_id, COUNT(IF(ejemplares > 10, 1, 0)) FROM libro GROUP BY categoria_id;

-- USE sakila;

-- EX 2: averange rental days for every store and customer
SELECT AVG(DATEDIFF(r.return_date, r.rental_date)) AS AdverangeRentingDays, r.customer_id, s.store_id
    FROM rental r JOIN staff s USING(staff_id)
    GROUP BY s.store_id, r.customer_id;

-- EX 3: adverange rental days for those rents made between january and may
SELECT s.store_id, r.customer_id, AVG(IF(MONTH(rental_date) < 6, DATEDIFF(r.return_date, r.rental_date), null)) AS averangeRental
    FROM rental r JOIN staff s USING(staff_id)
    GROUP BY s.store_id, r.customer_id
    HAVING averangeRental IS NOT NULL;