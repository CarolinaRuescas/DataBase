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
    SELECT film_id, COUNT(actor_id)
    FROM film_actor fa
    GROUP BY film_id
), lista_clientes AS(
    SELECT customer_id
    FROM rental
    GROUP BY customer_id
    ORDER BY COUNT(rental_id) DESC
    LIMIT 5
)
SELECT 

   
