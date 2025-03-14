-- EJERCICIO 1
-- Sacar la longitud media de todas las peliculas que hay en cada categoria
SELECT fc.category_id, AVG(f.length) AS Longitud
FROM film f 
   JOIN film_category fc USING(film_id)
GROUP BY fc.category_id;

-- Lista de peliculas de mayor longitud que la media de alguna categoria.
-- Hacer con operadores ANY/ALL/SOME/EXISTS
SELECT film_id
FROM film 
WHERE length > ANY(
   SELECT AVG(f.length) AS Longitud
   FROM film f 
      JOIN film_category fc USING(film_id)
   GROUP BY fc.category_id
);

-- Partiendo de la consulta anterior, sacar la lista de clientes que han 
-- alquilado alguna pelicula cuya longitud sea superior a la media de alguna categoria. 
SELECT DISTINCT r.customer_id
FROM rental r
   JOIN inventory i USING(inventory_id)
WHERE i.film_id  = ANY (
    SELECT film_id
    FROM film
    WHERE length > ANY(
        SELECT AVG(f.length)
        FROM film f
           JOIN film_category fc USING(film_id)
        GROUP BY fc.category_id
    )
);

-- Misma consulta anterior pero con otra sintaxis
WITH lista_pelis AS(
    SELECT film_id
    FROM film
    WHERE length > ANY(
        SELECT AVG(f.length)
        FROM film f
           JOIN film_category fc USING(film_id)
        GROUP BY fc.category_id
    )
)
SELECT DISTINCT r.customer_id
FROM rental r
   JOIN inventory i USING(inventory_id)
WHERE i.film_id = ANY(SELECT film_id FROM lista_pelis);

-- Otra forma diferente sin utilizar ANY

SELECT DISTINCT r.customer_id
FROM rental r
   JOIN inventory i USING(inventory_id)
   JOIN film f USING(film_id)
WHERE f.length > ANY(
    SELECT AVG(f.length)
        FROM film f
           JOIN film_category fc USING(film_id)
        GROUP BY fc.category_id
);



-- EJERCICIO 2
-- tabla temporal 1: lista de peliculas film_id con nº de actores (tabla temporal = WITH)
WITH numero_actores AS(
    SELECT film_id, COUNT(actor_id)
    FROM film_actor fa
    GROUP BY film_id
);


-- tabla temporal 2: lisa de los 5 clientes con más alquileres
WITH lista_clientes AS(
    SELECT customer_id
    FROM rental
    GROUP BY customer_id
    ORDER BY COUNT(rental_id) DESC
    LIMIT 5
);

-- Consulta general: número medio de actores(que han actuado) por pelicula de las alquiladas por 
-- los clientes de temp2.
WITH numero_actores AS(
    SELECT film_id, COUNT(actor_id) actores_x_film
    FROM film_actor 
    GROUP BY film_id
), lista_clientes AS(
    SELECT customer_id
    FROM rental
    GROUP BY customer_id
    ORDER BY COUNT(rental_id) DESC
    LIMIT 5
)
SELECT AVG(na.actores_x_film)
FROM lista_clientes
   JOIN rental USING (cusotmer_id)
   JOIN inventory USING (inventory_id)
   JOIN num_actores na USING (film_id);


-- RELACIONAR QUERY EXTERNA CON SUBQUERY (CORRELACIONADAS)
-- EJERCICIO 3
-- obtener la lista de clientes que se llaman igual que algun otro cliente pero sin ser el mismo
SELECT c.customer_id
FROM customer c
WHERE c. customer_id IN (
    SELECT c2.customer_id 
    FROM customer c2
    WHERE c.first_name = c2.first_name
       AND c.customer_id <> c2.customer_id
);

SELECT c.customer_id
FROM customer c JOIN customer c2   
   ON c.first_name = c2.first_name
      AND c.customer_id <> c2.customer_id
   ;



-- una consulta que el first name de todos los clientes excepto el cliente que estoy recorriendo en la primera query
SELECT c.customer_id
FROM customer c
WHERE c. first_name IN (
    SELECT c2.first_name 
    FROM customer c2
    WHERE c.customer_id <> c2.customer_id
);

-- hacer la misma consulta y en lugar de usar IN emplear EXISTS
SELECT c.customer_id
FROM customer c
WHERE EXISTS (
    SELECT 1 
    FROM customer c2
    WHERE c.first_name = c2.first_name
       AND c.customer_id <> c2.customer_id
);

-- EJERCICIO 4
-- Obtener el número medio de actores en las películas de las 3 categorías
-- que suman más duración en sus películas solo para las categorías alquiladas por
-- los 5 clientes que más dinero se han gastado. 

-- 1º scacamos los 5 clientes que mas dinero se han gastado
SELECT p.customer_id
FROM payment p 
GROUP BY p.customer_id
ORDER BY SUM(p.amount) DESC
LIMIT 5;

-- 2º sacar la lista de categorias alquiladas por los clientes anteriores
WITH top5_clientes AS (
   SELECT p.customer_id
   FROM payment p 
   GROUP BY p.customer_id
   ORDER BY SUM(p.amount) DESC
   LIMIT 5
), top5_cli_cat AS(
   SELECT DISTINCT fc.category_id
   FROM top5_clientes t5
      JOIN rental USING(customer_id)
      JOIN inventory USING(inventory_id)
      JOIN film_category fc USING(film_id)
)
SELECT category_id
FROM top5_cli_cat;


-- 3º sacar las 3 categorias de más duración pero de la lista de categorias anterior

WITH top5_clientes AS (
   SELECT p.customer_id
   FROM payment p 
   GROUP BY p.customer_id
   ORDER BY SUM(p.amount) DESC
   LIMIT 5
), top5_cli_cat AS(
   SELECT DISTINCT fc.category_id
   FROM top5_clientes t5
      JOIN rental USING(customer_id)
      JOIN inventory USING(inventory_id)
      JOIN film_category fc USING(film_id)
), top3_category AS(
SELECT category_id 
FROM top5_cli_cat
   JOIN film_category USING(category_id)
   JOIN film f USING(film_id)
GROUP BY category_id
ORDER BY SUM(f.length) DESC
LIMIT 3
)
SELECT *
FROM top3_category;

-- 4º sacar para cada categoria el numero medio de actores











-- VISTAS

CREATE VIEW top5_clientes AS
SELECT customer_id
FROM rental
GROUP BY customer_id
ORDER BY COUNT(rental_id) DESC
LIMIT 5
;

show tables;
show create table top5_clientes;
show full tables where table_type='VIEW';
SELECT * from top5_clientes;

-- OPTIMIZACIÓN
EXPLAIN ANALYZE 
SELECT customer_id
FROM rental
GROUP BY customer_id
ORDER BY COUNT(rental_id) DESC
LIMIT 5
;
