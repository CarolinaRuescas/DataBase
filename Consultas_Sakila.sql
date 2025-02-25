-- Para sacar la resta entre la fecha y el alquiler

SELECT rental_id, return_date, rental_date, DATEDIFF(return_date, rental_date) FROM rental limit 5;

-- Sacar el rental ID con el alquiler más largo (columna datediff)

SELECT rental_id, return_date, rental_date, DATEDIFF(return_date, rental_date) AS diferencia FROM rental ORDER BY diferencia DESC LIMIT 1;

-- Esta es otra forma de hacer la búsqueda anterior

SELECT rental_id FROM rental ORDER BY  DATEDIFF(return_date, rental_date) DESC LIMIT 1;

-- Peliculas que duren mas de 100 minutos ordenadas por mes de last_update y por el titulo (que solo salgan las 5 primeras)

SELECT title FROM film  WHERE  length > 100 ORDER BY MONTH(last_update), title LIMIT 5;

-- JOIN tabla customer y film. Hacer una ocnsulta que devuelva el nombre del cliente y el título 
-- de la pelicula para aquellos clientes y peliculas que tienen el mismo mes en la columna last_update

SELECT f.title, c.first_name, c.last_name FROM customer c, film f WHERE MONTH (c.last_update) = MONTH (f.last_update) LIMIT 10;

-- direccion _address_ (sin repetidos) de las tiendas _store_ en las que trabajan empeados que no tienen _picture_ 
SELECT a.address, s.first_name, s.last_name 
	FROM address a JOIN store st ON a.address_id  = st.address_id 
	JOIN staff s ON st.store_id = s.staff_id 
	WHERE s.picture IS NULL;

-- Si queremos simplicar la consulta anterior (esto solo se puede utilizar si el nombre es exactamente igual)
SELECT DISTINCT a.address
	FROM address a JOIN store st USING (address_id) 
				   JOIN staff s USING (store_id)
	WHERE s.picture IS NULL;

-- Nombre de los actores que han participado en alguna pelicula que tiene un texto con la descripción que 
-- incluya la palabra "epic"

SELECT DISTINCT a.first_name, a.last_name 
	FROM actor a JOIN film_actor fa ON a.actor_id = fa. actor_id 
				 JOIN film f ON fa.film_id = f.film_id 
				 JOIN inventory i ON f.film_id = i.film_id 
				 JOIN film_text ft ON i.film_id = ft.film_id 
	WHERE ft.description LIKE '%epic%' LIMIT 5;
				 
-- Otra forma de hacer más corta con USING (la misma consulta anterior)
SELECT DISTINCT a.first_name, a.last_name 
	FROM actor a JOIN film_actor fa USING (actor_id) 
				 JOIN film f USING (film_id)
		 	     JOIN inventory i USING (film_id)
				 JOIN film_text ft USING (film_id)
	WHERE ft.description LIKE '%epic%' LIMIT 5;

-- Numero de peliculas que hay en cada idioma
SELECT l.name, count(f.film_id) FROM language l JOIN film f USING(language_id) GROUP BY l.language_id;

-- Número de peliculas diferentes que hay en cada ciudad (tiene que aparecer el nombre de la ciudad y el numero de peliculas)
SELECT c.city, count(DISTINCT i.film_id) 
    FROM city c 
	    JOIN address a USING (city_id) 
        JOIN store s USING (address_id)
        JOIN inventory i USING (store_id)
    GROUP BY c.city_id;

-- Número de peliculas distintas que hay en cada país y ciudad
SELECT co.country, c.city, count(DISTINCT i.film_id)
    FROM country co
        JOIN city c USING(country_id)
		JOIN address a USING (city_id) 
        JOIN store s USING (address_id)
        JOIN inventory i USING (store_id)
    GROUP BY co.country_id, c.city_id;

-- Número de categorias distintas de peliculas alquiladas por cliente y staff.
SELECT r.customer_id, r.staff_id, count(DISTINCT fc.category_id)
    FROM rental r
	    JOIN inventory i USING (inventory_id)
		JOIN film f USING (film_id)
		JOIN film_category fc USING (film_id)
    GROUP BY r.customer_id, r.staff_id;

-- Longitud media de las películas que hay en cada tienda y de cada categoría.
SELECT s.store, ca.category_id, avg()


-- Ejercicio1. Número de actores en cada pelicula
SELECT COUNT(DISTINCT actor_id) as actors, film_id FROM film_actor GROUP BY film_id;

-- A subquery statement is made inside the from statement, and is used as a regular table
SELECT * FROM (
    SELECT COUNT(DISTINCT actor_id) as actors, film_id FROM film_actor GROUP BY film_id)
    WHERE actors > 10;

SELECT f.film_id, f.title, actorsCounter.actors
    FROM (
        SELECT film_id, COUNT(DISTINCT actor_id) actors
            FROM film_actor
            GROUP BY film_id
    ) AS actorsCounter JOIN film f USING(film_id)
    WHERE actors > 10;

-- EX 2: add a categories counter column next to actorsCounter 
SELECT f.film_id, f.title, actorsCounter.actors, countCat.categories
    FROM (
        SELECT film_id, COUNT(DISTINCT actor_id) actors
            FROM film_actor
            GROUP BY film_id
        ) AS actorsCounter 
        JOIN film f USING(film_id)
        JOIN (
            SELECT film_id, count(DISTINCT category_id) categories
            FROM film_category
            GROUP BY film_id
        ) AS countCat USING(film_id)
    WHERE actors > 10;

-- EX 3: number of films by each actor
SELECT actor_id, COUNT(DISTINCT film_id) FROM film_actor GROUP BY actor_id;

-- EX 4: actors who had participated on Drama films
SELECT actor_id 
    FROM film_actor fa JOIN film f USING(film_id)
                       JOIN film_category fc USING(film_id)
                       JOIN category c USING(category_id)
    WHERE c.name = 'Drama';

-- Also, subqueries can be made inside where conditions
SELECT actor_id, first_name, last_name
    FROM actor
    WHERE actor_id IN (
        SELECT actor_id 
            FROM film_actor fa JOIN film f USING(film_id)
                               JOIN film_category fc USING(film_id)
                               JOIN category c USING(category_id)
    WHERE c.name = 'Drama'
    );

-- 21 / 02 / 2025

-- NÚMERO DE ACTORES POR PELÍCULA
SELECT film_id, count(DISTINCT actor_id) 
   FROM film_actor 
   GROUP BY film_id;

-- 1º subconsulta hacer la media de la columna de actores que hay en todas 
-- las películas
SELECT AVG(media)
FROM(
   SELECT count(DISTINCT actor_id) media 
   FROM film_actor 
   GROUP BY film_id
   )tabla;

-- 2º lista de nombre de las pelciulas donde participan más actores 
-- que en la media (la media que acabamos de clacular) 

-- En esta subconsulta lo primero que hacemos es consultar en que peliculas
-- participan más de cinco actores.

SELECT f.title, COUNT(fa.actor_id) num_actores
   FROM film_actor fa JOIN film f USING (film_id)
   GROUP BY f.film_id
   HAVING num_actores > 5
   limit 10;

-- *Esta seria la solución de 2º (lista de nombre de las pelciulas donde participan más actores 
-- que en la media )
SELECT f.title, COUNT(fa.actor_id) num_actores
   FROM film_actor fa JOIN film f USING (film_id)
   GROUP BY f.film_id
   HAVING num_actores > (
    SELECT AVG(media)
    FROM(
       SELECT count(DISTINCT actor_id) media 
       FROM film_actor 
       GROUP BY film_id
       )tabla
   );

-- CLIENTES QUE HAN ALQUILADO MÁS PELICULAS QUE LA MEDIA
-- 1º Media de todos los clientes que han alquilado peliculas
SELECT AVG(media)
FROM(
   SELECT count( rental_id) media, customer_id
   FROM rental
   GROUP BY customer_id
   )tabla;

-- Número de peliculas que ha alquilado cada cliente
