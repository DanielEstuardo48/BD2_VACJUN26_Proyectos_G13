// VALIDACIÓN DE CANTIDAD DE NODOS

MATCH (u:Usuario)
RETURN 'Usuarios' AS tipo, count(u) AS total;

MATCH (r:Restaurante)
RETURN 'Restaurantes' AS tipo, count(r) AS total;

MATCH (c:Chef)
RETURN 'Chefs' AS tipo, count(c) AS total;

MATCH (p:Platillo)
RETURN 'Platillos' AS tipo, count(p) AS total;

MATCH (t:TipoCocina)
RETURN 'Tipos de cocina' AS tipo, count(t) AS total;

// VALIDACIÓN DE CANTIDAD DE RELACIONES

MATCH ()-[v:VISITÓ]->()
RETURN 'VISITÓ' AS relacion, count(v) AS total;

MATCH ()-[c:CALIFICÓ]->()
RETURN 'CALIFICÓ' AS relacion, count(c) AS total;

MATCH ()-[a:ES_AMIGO_DE]-()
RETURN 'ES_AMIGO_DE' AS relacion, count(a) AS total;

MATCH ()-[p:PERTENECE_A]->()
RETURN 'PERTENECE_A' AS relacion, count(p) AS total;

MATCH ()-[o:OFRECE]->()
RETURN 'OFRECE' AS relacion, count(o) AS total;

MATCH ()-[p:PREPARA]->()
RETURN 'PREPARA' AS relacion, count(p) AS total;

MATCH ()-[t:TRABAJA_EN]->()
RETURN 'TRABAJA_EN' AS relacion, count(t) AS total;

MATCH ()-[l:LE_GUSTA]->()
RETURN 'LE_GUSTA' AS relacion, count(l) AS total;

// RESUMEN GENERAL DE NODOS

MATCH (n)
RETURN labels(n) AS etiqueta, count(n) AS total
ORDER BY total DESC;

// RESUMEN GENERAL DE RELACIONES

MATCH ()-[r]->()
RETURN type(r) AS relacion, count(r) AS total
ORDER BY total DESC;

// VALIDACIÓN DE INTEGRIDAD DE RELACIONES

MATCH (u:Usuario)-[v:VISITÓ]->(r:Restaurante)
RETURN count(v) AS visitas_validas;

MATCH (u:Usuario)-[c:CALIFICÓ]->(r:Restaurante)
RETURN count(c) AS calificaciones_validas;

MATCH (r:Restaurante)-[o:OFRECE]->(p:Platillo)
RETURN count(o) AS ofertas_validas;

MATCH (c:Chef)-[t:TRABAJA_EN]->(r:Restaurante)
RETURN count(t) AS trabajos_validos;

MATCH (u:Usuario)-[l:LE_GUSTA]->(t:TipoCocina)
RETURN count(l) AS gustos_validos;

// VALIDACIÓN DE PROPIEDADES IMPORTANTES

MATCH (u:Usuario)
WHERE u.email IS NULL OR u.nombre IS NULL
RETURN count(u) AS usuarios_con_datos_incompletos;

MATCH (r:Restaurante)
WHERE r.nombre IS NULL OR r.rango_precios IS NULL
RETURN count(r) AS restaurantes_con_datos_incompletos;

MATCH ()-[v:VISITÓ]->()
WHERE v.consumo IS NULL OR v.fecha_visita IS NULL OR v.con_reserva IS NULL
RETURN count(v) AS visitas_con_datos_incompletos;

MATCH ()-[c:CALIFICÓ]->()
WHERE c.puntuacion IS NULL OR c.puntuacion < 1 OR c.puntuacion > 5
RETURN count(c) AS calificaciones_invalidas;