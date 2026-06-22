// RESTAURANTES ALTAMENTE CONECTADOS

MATCH (r:Restaurante)

OPTIONAL MATCH (c:Chef)-[:TRABAJA_EN]->(r)
WITH r, count(DISTINCT c) AS total_chefs

OPTIONAL MATCH (r)-[:OFRECE]->(p:Platillo)
WITH r, total_chefs, count(DISTINCT p) AS total_platillos

OPTIONAL MATCH (r)-[:PERTENECE_A]->(t:TipoCocina)
WITH r, total_chefs, total_platillos, count(DISTINCT t) AS total_tipos_cocina

OPTIONAL MATCH ()-[v:VISITÓ]->(r)
WITH r, total_chefs, total_platillos, total_tipos_cocina, count(DISTINCT v) AS total_visitas

OPTIONAL MATCH ()-[cal:CALIFICÓ]->(r)
WITH
    r,
    total_chefs,
    total_platillos,
    total_tipos_cocina,
    total_visitas,
    count(DISTINCT cal) AS total_calificaciones,
    avg(cal.puntuacion) AS promedio_calificacion

RETURN
    r.id_restaurante AS id_restaurante,
    r.nombre AS restaurante,
    r.rango_precios AS precio,
    total_chefs,
    total_platillos,
    total_tipos_cocina,
    total_visitas,
    total_calificaciones,
    round(coalesce(promedio_calificacion, 0) * 100) / 100 AS promedio_calificacion,
    total_chefs + total_platillos + total_tipos_cocina +
    total_visitas + total_calificaciones AS score_conectividad

ORDER BY score_conectividad DESC
LIMIT 50;

//Grafo

MATCH path =
(c:Chef)-[:TRABAJA_EN]->(r:Restaurante)-[:OFRECE]->(p:Platillo)

WHERE r.id_restaurante IN [1,2,3,4,5]

RETURN path
LIMIT 50;