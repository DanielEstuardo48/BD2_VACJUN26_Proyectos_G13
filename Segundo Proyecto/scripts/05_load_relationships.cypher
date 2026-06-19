
// RELACIÓN: CALIFICÓ
// Usuario -> Restaurante

LOAD CSV WITH HEADERS
FROM 'file:///califico.csv' AS row
MATCH (u:Usuario {id_usuario: toInteger(row.id_usuario)})
MATCH (r:Restaurante {id_restaurante: toInteger(row.id_restaurante)})
MERGE (u)-[c:CALIFICÓ]->(r)
SET
    c.puntuacion = toInteger(row.puntuacion),
    c.fecha = date(row.fecha),
    c.comentario = row.comentario;

// RELACIÓN: VISITÓ
// Usuario -> Restaurante

LOAD CSV WITH HEADERS
FROM 'file:///visito.csv' AS row
MATCH (u:Usuario {id_usuario: toInteger(row.id_usuario)})
MATCH (r:Restaurante {id_restaurante: toInteger(row.id_restaurante)})
CREATE (u)-[v:VISITÓ]->(r)
SET
    v.fecha_visita = date(row.fecha_visita),
    v.consumo = toFloat(row.consumo),
    v.con_reserva = toBoolean(row.con_reserva);

// RELACIÓN: ES_AMIGO_DE
// Usuario -> Usuario

LOAD CSV WITH HEADERS
FROM 'file:///amistades.csv' AS row
MATCH (u1:Usuario {id_usuario: toInteger(row.id_usuario_1)})
MATCH (u2:Usuario {id_usuario: toInteger(row.id_usuario_2)})
MERGE (u1)-[a:ES_AMIGO_DE]-(u2)
SET
    a.fecha_amistad = date(row.fecha_amistad);


// RELACIÓN: PERTENECE_A
// Restaurante -> TipoCocina

LOAD CSV WITH HEADERS
FROM 'file:///pertenece_a.csv' AS row
MATCH (r:Restaurante {id_restaurante: toInteger(row.id_restaurante)})
MATCH (t:TipoCocina {id_tipo_cocina: toInteger(row.id_tipo_cocina)})
MERGE (r)-[:PERTENECE_A]->(t);

// RELACIÓN: OFRECE
// Restaurante -> Platillo

LOAD CSV WITH HEADERS
FROM 'file:///ofrece.csv' AS row
MATCH (r:Restaurante {id_restaurante: toInteger(row.id_restaurante)})
MATCH (p:Platillo {id_platillo: toInteger(row.id_platillo)})
MERGE (r)-[o:OFRECE]->(p)
SET
    o.precio = toFloat(row.precio),
    o.disponible = toBoolean(row.disponible);

// RELACIÓN: PREPARA
// Chef -> Platillo

LOAD CSV WITH HEADERS
FROM 'file:///prepara.csv' AS row
MATCH (c:Chef {id_chef: toInteger(row.id_chef)})
MATCH (p:Platillo {id_platillo: toInteger(row.id_platillo)})
MERGE (c)-[pr:PREPARA]->(p)
SET
    pr.estilo = row.estilo,
    pr.especialidad = row.especialidad;

// RELACIÓN: TRABAJA_EN
// Chef -> Restaurante


LOAD CSV WITH HEADERS
FROM 'file:///trabaja_en.csv' AS row
MATCH (c:Chef {id_chef: toInteger(row.id_chef)})
MATCH (r:Restaurante {id_restaurante: toInteger(row.id_restaurante)})
MERGE (c)-[te:TRABAJA_EN]->(r)
SET
    te.fecha_inicio = date(row.fecha_inicio),
    te.puesto = row.puesto;

// RELACIÓN: LE_GUSTA
// Usuario -> TipoCocina

LOAD CSV WITH HEADERS
FROM 'file:///le_gusta.csv' AS row
MATCH (u:Usuario {id_usuario: toInteger(row.id_usuario)})
MATCH (t:TipoCocina {id_tipo_cocina: toInteger(row.id_tipo_cocina)})
MERGE (u)-[lg:LE_GUSTA]->(t)
SET
    lg.nivel_interes = toInteger(row.nivel_interes);