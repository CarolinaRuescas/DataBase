-- 1. Número medio de categorías diferentes en cada tienda.
SELECT AVG(media)
FROM(
    SELECT s.store_id, COUNT(DISTINCT fc.category_id) media
    FROM store s
    JOIN inventory i USING(store_id)
    JOIN film f USING(film_id)
    JOIN film_category fc USING (film_id)
    GROUP BY s.store_id
)tabla;


-- 2. Longitud máxima de las películas de cada categoría.
SELECT c.name, MAX(f.length) Longitud_Maxima
FROM film f 
   JOIN film_category fc USING(film_id)
   JOIN category c USING(category_id)
   GROUP BY c.name;


-- 3. Clientes que han alquilado películas en la tienda con más ganancias (payment.amount).
SELECT customer_id
FROM store s USING (store_id)
 JOIN store s USING (store_id)
WHERE s.store_id = (
   -- subquery devuelve el store_id de la tienda con mas ganancias
   SELECT i.store_id
   From payment pais_id   
      JOIN rental r USING (rental_id)
      JOIN inventory i USING (inventory_id)
   GROUP BY i.store_id
   -- ordena por ganancias y quedate con el primero
   ORDER BY SUM(p.amount) DESCLIMIT 1
);


-- Esto son las ganancias de cada tienda
SELECT s.store_id, sum(p.amount) 
FROM store s
   JOIN staff st USING (store_id)
   JOIN payment p USING(staff_id)
   GROUP by s.store_id;

-- 4. Clientes que han alquilado las 5 películas más alquiladas.

SELECT c.customer_id, r.rental_id
FROM customer c
   JOIN rental r USING(customer_id)
GROUP BY c.customer_id, r.rental_id
ORDER BY r.rental_id DESC LIMIT 5;


-- 5. Para cada río, mostrar su nombre, longitud total y número de países por los que pasa, ordenados por longitud.

SELECT r.nombre, rp.longitud_en_pais_km, COUNT(rp.pais_id)
FROM rios r
   JOIN rio_pasa_por_pais rp USING (id)
   GROUP BY r.nombre, r.longitud_en_pais_km
   ORDER BY rp.longitud_en_pais_km;

-- 6. Nombres de los 5 investigadores con más observaciones en el país por el que migran más animales


-- 7. Cantidad total de animales diferentes que hay en el mes de febrero en los países por los que pasa el río más largo.