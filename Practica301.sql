-- 1. Crea una vista llamada top_actores que muestre nombre y apellidos de los actores 
--    que han participado en las 10 películas más taquilleras (payment.amount)
--    ordenador por el número de películas taquilleras en las que han participado.

CREATE VIEW top_actores AS 
SELECT a.first_name, a.last_name 
FROM actor a
   JOIN film_actor fa USING(actor_id)
   JOIN film f USING(film_id)
   JOIN inventory i USING(film_id)
   JOIN rental r USING(inventory_id)
   JOIN payment p USING(rental_id)
   GROUP BY a.actor_id
   HAVING f.film_id =(
      SELECT f.film_id
      FROM payment p
      JOIN film f USING(film_id)
      GROUP BY f.film_id
      ORDER BY SUM(p.amount) DESC
      LIMIT 10
   );



-- 2. Lista con la película con más alquileres de cada categoría.
--    Dos columnas: category_id, film_id

SELECT f.film_id
FROM film_category fc
   JOIN film f USING(film_id)
   JOIN inventory i USING(film_id)
   JOIN rental r USING(inventory_id)
GROUP BY fc.category_id, f.film_id
ORDER BY COUNT(r.rental_id);



SELECT c.category_id, f.film_id
FROM film_category fc
   JOIN film f USING(film_id)
   JOIN inventory i USING(film_id)
   JOIN rental r USING(inventory_id)
   GROUP BY f.category_id, f.film_id
   HAVING COUNT(r.rental_id) = (
    SELECT MAX(rentals_count)
    FROM(
        SELECT COUNT(r.rental_id) AS rentals_count
        FROM rental r
        



-- 3. a) trabajador (staff) con más alquileres.

SELECT r.staff_id AS trabajador_alquiler
FROM rental r
GROUP BY r.staff_id
ORDER BY COUNT(r.rental_id) DESC;

--    b) lista de las 10 películas de mayor longitud alquiladas por a)
SELECT f.film_id AS Mayor_duracion
FROM film f
GROUP BY f.film_id
ORDER BY SUM(f.length) DESC
LIMIT 10;


--    c) las 3 categorías con mayor media de actores por película.
SELECT c.category_id, AVG(actor_count) AS media_actores
FROM category c   
   JOIN film_category fc USING(category_id)
   JOIN (
    SELECT f.film_id, COUNT(DISTINCT fa.actor_id) AS actor_count
    FROM film f
       JOIN film_actor fa USING (film_id)
       GROUP BY f.film_id
   ) AS film_actors USING(film_id)
   GROUP BY c.category_id
   ORDER BY media_actores
   LIMIT 3;


--    CONSULTA GENERAL: lista de las películas que están en a) y tienen categoría c)


