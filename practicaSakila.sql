-- 1. Nombre y apellido de los actores que actúan en más de una película
SELECT DISTINCT a.first_name, a.last_name, f.title
  FROM actor a 
    JOIN film_actor fa USING (actor_id)
    JOIN film f USING(film_id)
  WHERE f.film_id > 1
  GROUP BY a.actor_id, f.film_id;

-- 2. Número de películas distintas con rating oigual a G que hay en cada tienda.
SELECT s.store_id, count(DISTINCT f.film_id)
  FROM store s
    JOIN inventory i USING(store_id)
    JOIN film f USING(film_id)
    WHERE f.rating = "G"
GROUP BY s.store_id;

-- 3. Suma total de la longitud de las películas que ha vendido cada vendedor (staff)
SELECT SUM(f.`length`) Suma_TotalLongitud
FROM film f
   JOIN inventory i USING(film_id)
   JOIN rental r USING(inventory_id)
GROUP BY r.staff_id;

-- 4. Número de actores diferentes que aparecen en las películas de cada categoría.
SELECT fc.category_id, count(DISTINCT fa.actor_id) Numero_Actores
FROM film_actor fa
   JOIN film f USING(film_id)
   JOIN film_category fc USING(film_id)
GROUP BY fc.category_id;

-- 5. Longitud máxima de las películas en cada categoría cuyo nombre comienza por la letra A.
SELECT c.name, MAX(f.`length`) Longitud_Maxima
FROM film f
   JOIN film_category fc USING(film_id)
   JOIN category c USING(category_id)
WHERE c.name LIKE 'A%'
GROUP BY c.category_id;

-- 6. Título de las películas con más de 4 actores y que duren más de 100 minutos.
SELECT f.title, fa.actor_id, f.`length`
FROM film f
   JOIN film_actor fa USING(film_id)
WHERE fa.actor_id > 4 AND f.`length` > 100
GROUP BY f.title, fa.actor_id, f.`length`;

-- 7. Longitud máxima de las películas de cada cagtegoría y de cada actor.
SELECT ca.category_id, c.name_id, MAX(f.`length`) Longitud_Maxima
FROM film_actor fa
   JOIN film f USING(film_id)
   JOIN film_category fc USING(film_id)
   JOIN category ca USING(category_id)
GROUP BY ca.category_id, c.name_id;
