-- FUNCION AVG (el numero de salidas debe coincidir)
-- calcula el precio medio de todos los productos de la columna buyPrice

select avg(buyPrice) from products;

-- si queremos hacer el promedio de precio pero de solo los cinco primeros productos 
-- no podemos usar LIMIT porque ese sirve para una vez ejecutado todo que coja solo 
-- los ultimos productos, pero no te hace la media desde el principio. 

-- Media de los productos que cuestan mas de 60 (euros o la moneda que sea)
select avg(buyPrice) from products WHERE buyPrice > 60;

-- Para coger la lineas de productos y que todas aquellas que sean iguales se agreguen,
-- es decir, que lo agrupe.
select productLine, avg(buyPrice) from products group by productLine;

-- Para que cuente todos los productos que hay en total( cuenta todo el numero de filas)
select count(*) from products;

-- Cuenta cuantos productLine hay (usamos el distinct dentro del parentesis para que los englobe)
select count(distinct productLine) from products;

--  Si quiero que agrupe los productos que hay dentro de cada categoria
select productLine, count(*) from products group by productLine;

-- Si queremos combinar y que aparezca el precio medio de cada categoria de producto, y que
-- además tambien agrupe la cantidad de productos que hay de esa categoria
select productLine, avg(buyPrice), count(*) from products group by productLine;

-- Dar un nombre alternativo a una columna, en este caos a la de count y a la de buyPrice
select productLine, avg(buyPrice) AS precio_medio, count(*) AS numero from products group by productLine order by numero;

-- Coger la tabla de los orderditails y agrupar por productCode, por lo que 
-- por cada uno de esos productos habra varias ordenes, pues puede ser comprado una o varias veces,
-- por lo que si nunca ha sido comprado no deberia aparecer dicho producto.

select productCode, SUM(priceEach * quantityOrdered) AS total FROM orderdetails GROUP BY productCode;

-- Mostrar todos los productos que se han vendido con ese codigo en la coluna de orderdetails
select * FROM orderdetails WHERE productCode = 'S10_1678';

-- Para calcular lo que se ha pagado en cada venta de ese mismo producto
select productCode, priceEach * quantityOrdered from orderdetails where productCode = 'S10_1678';

-- Para calcular la suma total de lo que se ha ganado con todas esas ventas ( el SELECT anterior)
select SUM(priceEach * quantityOrdered) from orderdetails where productCode = 'S10_1678';

-- Pongamos que se quiere hacer la misma suma anterior, peor que tambien aparezca el codigo del producto
select productCode, SUM(priceEach * quantityOrdered) from orderdetails where productCode = 'S10_1678';

-- Si queremos que calcule el total de ganancias pero todos los productos
select productCode, SUM(priceEach * quantityOrdered) from orderdetails group by productCode;

-- EJERCICIOS
-- Ejercicio 1 -- En la tabla empleados: calcular la longitud media de los nombres de todos los empleados (el nº de caracteres)

SELECT firstName from employees; -- esto e spara saber el numero de empleados
SELECT firstName, length(firstName) from employees; -- para saber el numero de letras que tiene cada nombre del empleado

SELECT avg(length(firstName)) from employees; -- Esta seria la media

-- Ejercicio 2 - como se llama el empleado con el nombre mas largo
SELECT firstName from employees; -- Primero para mostrar el primer nombre de todos los empleados
SELECT max(length(firstName)) from employees; -- Despues vemos ual es la longitud maxima del nombre de los empleados

SELECT firstName, length(firstName) from employees order by length(firstName) DESC LIMIT 1 ;
SELECT firstName from employees order by length(firstName) DESC LIMIT 1;

-- Ejercici3 -- Longitud media del nombre para cada una de las oficionas
SELECT avg(length(firstName)) media from employees; -- con esto calculamos la media global del nombre de todas las oficinas

SELECT avg(length(firstName)) media from employees GROUP BY officeCode; -- la media de cada una de las oficinas
SELECT officeCode, avg(length(firstName)) media from employees GROUP BY officeCode; -- igual que el anterior pero también aparece agrupado por codigo de oficina

-- Para que aparezca también el número
SELECT officeCode, o.phone, avg(length(firstName)) media from employees GROUP BY officeCode; 








