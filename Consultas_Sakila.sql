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
				 
-- Otra formad ehacer más corta con USING (la misma consulta anterior)
SELECT DISTINCT a.first_name, a.last_name 
	FROM actor a JOIN film_actor fa USING (actor_id) 
				 JOIN film f USING (film_id)
		 	     JOIN inventory i USING (film_id)
				 JOIN film_text ft USING (film_id)
	WHERE ft.description LIKE '%epic%' LIMIT 5;