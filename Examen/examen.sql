 -- 1. Cantidad de alquileres realizados por el customer_id = 3 de cada categoría.

SELECT r.customer_id,fc.category_id, COUNT(r.rental_id)
FROM rental r
   JOIN inventory i USING(inventory_id)
   JOIN film f USING(film_id)
   JOIN film_category fc USING(film_id)
   WHERE r.customer_id = 3
   GROUP BY fc.category_id;

-- 2. Cantidad acumulada de ventas (payment.amount) para cada categoría que tenga más de 20 películas.


SELECT fc.category_id, SUM(p.amount)
FROM payment p 
   JOIN rental r USING(rental_id)
   JOIN inventory i USING(inventory_id)
   JOIN film f USING(film_id)
   JOIN film_category fc USING(film_id)
GROUP BY fc.category_id
HAVING fc.category_id > (
   SELECT COUNT(fc.film_id) film_customer
   FROM film_category fc
   GROUP BY fc.category_id
   HAVING COUNT(fc.film_id) > 20
);
   

-- 3. Títulos de peliculas en las que participe algún actor que haya actuado en más de 15 categorías distintas de peliculas.

SELECT DISTINCT f.title
FROM film f   
   JOIN film_actor fa USING(film_id)
   JOIN(
     SELECT fa.actor_id, COUNT(fc.category_id) categ
        FROM film_actor fa
        JOIN film f USING(film_id)
        JOIN film_category fc USING(film_id)
     GROUP BY fa.actor_id
     HAVING categ > 15
) actors USING(actor_id);



-- 4. Para cada categoría que comience por la letra 'a', contar el numero de actores cuyo nombre contiene la letra 'b'.

SELECT c.name, COUNT(a.actor_id)
FROM category c
   JOIN film_category fc USING(category_id)
   JOIN film f USING(film_id)
   JOIN film_category fa USING(film_id)
   JOIN actor a USING(actor_id)
WHERE c.name LIKE `a%` AND a.first_name LIKE `b%`
GROUP BY c.name, a.first_name;

-- 5. Listado de peliculas que tienen una duracion superior a la duracion media de de las pelis de todas las categorías y que tienen más numero de actores que la media global de actores por pelicula.


SELECT AVG(length) longitud
FROM film f
    JOIN film_category fc USING(film_id)
    JOIN category c USING(category_id)
GROUP BY c.name;


-- 6. Nombre y apellido de los actores, junto al texto "polifacético" si ha trabajado en mayor numero de categorias que la media. -- En caso de no superar la media, debe aparecer el numero de categorías que le faltan para llegar a esa media.

-- 7. Nombre y apellidos del cliente que más ha pagado (payment.amount).


