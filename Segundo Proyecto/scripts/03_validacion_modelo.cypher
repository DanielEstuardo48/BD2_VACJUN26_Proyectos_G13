// Validación del modelo de grafos

// V1: Conteo de nodos por tipo
MATCH (u:Usuario) RETURN 'Usuarios' AS tipo, count(u) AS total
UNION ALL
MATCH (r:Restaurante) RETURN 'Restaurantes' AS tipo, count(r) AS total
UNION ALL
MATCH (c:Chef) RETURN 'Chefs' AS tipo, count(c) AS total
UNION ALL
MATCH (p:Platillo) RETURN 'Platillos' AS tipo, count(p) AS total
UNION ALL
MATCH (t:TipoCocina) RETURN 'TiposCocina' AS tipo, count(t) AS total;

// V2: Conteo de relaciones por tipo
MATCH ()-[r:CALIFICÓ]->() RETURN 'CALIFICÓ' AS relacion, count(r) AS total
UNION ALL
MATCH ()-[r:VISITÓ]->() RETURN 'VISITÓ' AS relacion, count(r) AS total
UNION ALL
MATCH ()-[r:ES_AMIGO_DE]->() RETURN 'ES_AMIGO_DE' AS relacion, count(r) AS total
UNION ALL
MATCH ()-[r:PERTENECE_A]->() RETURN 'PERTENECE_A' AS relacion, count(r) AS total
UNION ALL
MATCH ()-[r:OFRECE]->() RETURN 'OFRECE' AS relacion, count(r) AS total
UNION ALL
MATCH ()-[r:PREPARA]->() RETURN 'PREPARA' AS relacion, count(r) AS total
UNION ALL
MATCH ()-[r:TRABAJA_EN]->() RETURN 'TRABAJA_EN' AS relacion, count(r) AS total
UNION ALL
MATCH ()-[r:LE_GUSTA]->() RETURN 'LE_GUSTA' AS relacion, count(r) AS total;

// V3: Verificar que todos los restaurantes tienen al menos un tipo de cocina
MATCH (r:Restaurante)
WHERE NOT (r)-[:PERTENECE_A]->(:TipoCocina)
RETURN r.nombre AS restaurante_sin_tipo_cocina;
// Debe devolver 0 resultados

// V4: Verificar que todos los chefs trabajan en al menos un restaurante
MATCH (c:Chef)
WHERE NOT (c)-[:TRABAJA_EN]->(:Restaurante)
RETURN c.nombre AS chef_sin_restaurante;
// Debe devolver 0 resultados

// V5: Verificar que las calificaciones están en rango 1-5
MATCH ()-[c:CALIFICÓ]->()
WHERE c.puntuacion < 1 OR c.puntuacion > 5
RETURN count(c) AS calificaciones_fuera_de_rango;
// Debe devolver 0

// V6: Verificar que ningún restaurante ofrece el mismo platillo más de una vez
MATCH (r:Restaurante)-[:OFRECE]->(p:Platillo)
WITH r, p, count(*) AS veces
WHERE veces > 1
RETURN r.nombre AS restaurante, p.nombre AS platillo, veces;
// Debe devolver 0 resultados