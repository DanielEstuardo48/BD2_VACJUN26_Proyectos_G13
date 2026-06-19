
// CARGA DE USUARIOS

LOAD CSV WITH HEADERS
FROM 'file:///usuarios.csv' AS row

MERGE (u:Usuario {id_usuario: toInteger(row.id_usuario)})
SET
    u.nombre = row.nombre,
    u.email = row.email,
    u.edad = toInteger(row.edad),
    u.pais = row.pais;


// CARGA DE RESTAURANTES

LOAD CSV WITH HEADERS
FROM 'file:///restaurantes.csv' AS row

MERGE (r:Restaurante {id_restaurante: toInteger(row.id_restaurante)})
SET
    r.nombre = row.nombre,
    r.anio_apertura = toInteger(row.anio_apertura),
    r.rango_precios = row.rango_precios,
    r.descripcion = row.descripcion;

// CARGA DE CHEFS

LOAD CSV WITH HEADERS
FROM 'file:///chefs.csv' AS row

MERGE (c:Chef {id_chef: toInteger(row.id_chef)})
SET
    c.nombre = row.nombre,
    c.fecha_nacimiento = date(row.fecha_nacimiento),
    c.nacionalidad = row.nacionalidad;

// CARGA DE PLATILLOS

LOAD CSV WITH HEADERS
FROM 'file:///platillos.csv' AS row

MERGE (p:Platillo {id_platillo: toInteger(row.id_platillo)})
SET
    p.nombre = row.nombre,
    p.precio = toFloat(row.precio),
    p.descripcion = row.descripcion;

//  Tipos de cocina

LOAD CSV WITH HEADERS
FROM 'file:///tipos_cocina.csv' AS row

MERGE (t:TipoCocina {id_tipo_cocina: toInteger(row.id_tipo_cocina)})
SET
    t.nombre = row.nombre,
    t.descripcion = row.descripcion;