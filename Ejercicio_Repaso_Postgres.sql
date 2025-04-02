-- 3. En Postgres/docker local:
-- Crea una base de datos y un nuevo usuario con los nombres que quieras.
-- Conectado desde ese usuario, en el esquema _public_ 
-- crea una base de datos con estas tablas relacionadas:
--   usuario(id, nombre)
--   producto(id, titulo, precio)
--   compra(id, fecha, id_usuario, id_producto)
-- Los id deben ser auto incrementales: id SERIAL PRIMARY KEY

DROP TABLE IF EXISTS compra;
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS usuario;

CREATE TABLE usuario (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(255)
);

CREATE TABLE producto (
  id SERIAL PRIMARY KEY,
  titulo VARCHAR(255),
  precio DOUBLE PRECISION
);

CREATE TABLE compra (
  id SERIAL PRIMARY KEY,
  fecha TIMESTAMP, -- Equivale a DATETIME en mysql
  id_usuario INT,
  id_producto INT,
  FOREIGN KEY (id_usuario) REFERENCES usuario(id),
  FOREIGN KEY (id_producto) REFERENCES producto(id)
);


-- 4. Crea un procedimiento que introduzca valores en las tres tablas:
-- nueva_compra(nombre_usuario, titulo_producto, precio)

CREATE OR REPLACE PROCEDURE nueva_compra(
  nombre_usuario VARCHAR, 
  titulo_producto VARCHAR, 
  p_precio DOUBLE PRECISION
) LANGUAGE plpgsql AS $$
DECLARE
  usua_id INT;
  prod_id INT;
BEGIN
  -- 1. Obtener el id del usuario para nombre_usuario
  --    Si no existe, crear el usuario
  SELECT id INTO usua_id FROM usuario WHERE nombre = nombre_usuario;
  IF NOT FOUND THEN
    INSERT INTO usuario(nombre) VALUES (nombre_usuario);
    SELECT id INTO usua_id FROM usuario WHERE nombre = nombre_usuario;
  END IF;

  -- 2. Obtener el id del producto para titulo_producto
  --    Si no existe, crear el producto
  SELECT id INTO prod_id FROM producto p 
    WHERE p.titulo = titulo_producto AND p.precio = p_precio;
  IF NOT FOUND THEN
    INSERT INTO producto(titulo, precio) 
    VALUES (titulo_producto, p_precio) RETURNING id INTO prod_id;
  END IF;

  -- 3. Insertar una nueva compra con CURRENT_DATE como fecha.
  INSERT INTO compra(fecha, id_usuario, id_producto) 
  VALUES (CURRENT_DATE, usua_id, prod_id);
END;
$$;
