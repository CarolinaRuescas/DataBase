-- EJERCICIO 1.
-- Sacar la lista de customer_id de los clientes que se han gastado más de 100$ (payment.amount)

SELECT p.customer_id 
FROM payment p 
   GROUP BY p.customer_id 
   HAVING SUM(p.amount) > 100;

-- usamos el operador IN para que salga una lista y no pordemos limitar si usamon IN/ANY...
SELECT customer_id
FROM customer 
WHERE customer_id IN(
   SELECT p.customer_id 
   FROM payment p 
   GROUP BY p.customer_id 
   HAVING SUM(p.amount) > 100
   );
-- pero si queremos limitar el resultado a 1 es necerio cambiar IN por =
SELECT customer_id
FROM customer 
WHERE customer_id =(
   SELECT p.customer_id 
   FROM payment p 
   GROUP BY p.customer_id 
   HAVING SUM(p.amount) > 100
   LIMIT 1
   );

-- EJERCICIO 2. 
-- Como solucionar limitar a 5 pero usando el operador IN (para eso hacemos JOIN)
SELECT c.customer_id
FROM customer c
JOIN (
   SELECT p.customer_id 
   FROM payment p 
   GROUP BY p.customer_id 
   HAVING SUM(p.amount) > 100
   ORDER BY SUM(p.amount)
   LIMIT 5
   ) top ON c.customer_id = top.customer_id;

-- se puede simplificar un poco esta consulta
SELECT c.customer_id
FROM customer c
JOIN (
   SELECT p.customer_id 
   FROM payment p 
   GROUP BY p.customer_id 
   HAVING SUM(p.amount) > 100
   ORDER BY SUM(p.amount)
   LIMIT 5
   ) top USING(customer_id);

-- EJERCICIO 3. 
-- Lista de nombres de categorias de peliculas alquiladas por los 5 clientes que más se han gastado. 
SELECT c.name
FROM rental r
   JOIN inventory i USING (inventory_id)
   JOIN film f USING (film_id)
   JOIN film_category fc USING (film_id)
   JOIN category c USING (category_id)
   JOIN (
    SELECT p.customer_id
    FROM payment p
    GROUP BY p.customer_id
    ORDER BY SUM(p.amount)
    LIMIT 5
   ) top USING(customer_id); -- el top es el nombre corto que le doy a la tabla de la subquery

-- OPERADORES EXISTS | ALL | ANY/SOME
--  · Exist devuelve true o false dependiendo de si la subconsulta tiene resultado o no

-- EJERCICIO 4. 
-- Partiendo de la subquery de numero de actores que aparecen en cada pelicula
SELECT film_id, COUNT(actor_id)
FROM film_actor
GROUP by film_id;

-- En base a lo anterior sacar la lista de clientes que se han gastado más de 100$ y que 
-- comprado/alquilado alguna pelicula en la que apararecen más de 10 actores. (DOS FORMAS DE HACERLO)
SELECT DISTINCT clist.customer_id
FROM (
   SELECT DISTINCT p.customer_id
      FROM payment p
      GROUP BY p.customer_id
      HAVING SUM(amount) > 100
) clist
   JOIN rental r USING (customer_id)
   JOIN inventory i USING(inventory_id)
   JOIN(
      SELECT film_id
      FROM film_actor
      GROUP by film_id
      HAVING COUNT(actor_id) > 10
   ) flist USING (film_id);

-- consulta hecho por Santi
SELECT DISTINCT p.customer_id
FROM payment p
GROUP BY p.customer_id
HAVING SUM(p.amount) > 100
   AND EXISTS(  -- es un booleano verdadero(si devuelve algo) y falso(si no lo hace)
    SELECT *
    FROM rental r
      JOIN inventory i USING (inventory_id)
    WHERE p.customer_id = r.customer_id
       AND i.film_id IN (
         SELECT film_id
         FROM film_actor
         GROUP BY film_id
         HAVING COUNT(actor_id) > 10
       )
   );

-- ANY/SOME
SELECT * 
FROM film f
WHERE f.length > ALL 
(
   SELECT AVG(f.length)
   FROM film_actor fa 
      JOIN film f USING(film_id)
   GROUP BY actor_id
);



