-- 8. Inserta un cliente, dos productos y una factura con ambos productos para el cliente.

INSERT INTO cliente (cliente_id, nombre, direccion, email)
VALUES (3, 'Carolina Ruescas', 'Avenida Las Naciones', 'ruescas17@gmail.com');

INSERT INTO producto (producto_id, nombre)
VALUES (253, 'Ordenadores');

INSERT INTO producto (producto_id, nombre)
VALUES (230, 'Escritorio');

INSERT INTO factura (factura_id, cliente_id, fecha, descuento)
VALUEs (101, 3, '25-02-2025', 20), (102, 3, '28-02-2025', 15);


-- 9. Para cada producto, muestra la media de días de todos los transportes y la cantidad de clientes que tiene.
SELECT p.producto_id, p.nombre, AVG(fecha_recogida, fecha_entrega) dias_transporte, COUNT(DISTINCT c.cliente_id) clientes
FROM transporte t
   JOIN producto p USING(producto_id)
   JOIN item_venta USING(producto_id)
   JOIN factura f USING(factura_id)
   JOIN cliente c USING(cliente_id)
GROUP BY p.producto_id, p.nombre;


-- 10. Para cada productor y para cada medio de transporte que sume más de 500 kilómetros, obtén: 
-- - el total de unidades transportadas
-- - la cantidad de clientes con correo acabado en @email.com que han comprado sus productos
-- Puedes asumir que el productor siempre es centro de origen.

SELECT p.productor_id, t.transporte, SUM(t.unidades) unidades_transportadas, COUNT(DISTINCT c.cliente_id) cliente
FROM productor p
   JOIN centro_logistico cl USING(centro_id)
   JOIN comercio co USING(centro_id)
   JOIN item_venta iv USING(comercio_id)
   JOIN factura f USING(factura_id)
   JOIN cliente c USING(cliente_id)
WHERE t.length > 500 AND c.email LIKE '%@email.com'
GROUP BY p.productor_id, t.transporte;


-- 11. Numero de facuras cuya ganancia total es superior a la media.
-- La ganancia total se calcula como la suma de (precio_unidad * unidades) para todas los items
-- menos el descuento, que se resta a dicha suma. 
SELECT COUNT(f.factura_id)
FROM factura f
   JOIN





-- 12. Obtén la facturación total de cada comercio teniendo en cuenta el descuento. 
SELECT c.comercio_id, SUM(iv.unidades * iv.precio_unidad) - SUM(f.descuento) ventas
FROM comercio c
   JOIN item_venta iv USING(comercio_id)
   JOIN factura f USING(factura_id)
GROUP BY c.comercio_id;