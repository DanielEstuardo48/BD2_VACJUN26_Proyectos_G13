// Análisis de red: Restaurantes altamente conectados

MATCH (r:Restaurante) // Este match es para encontrar todos los restaurantes
OPTIONAL MATCH (c:Chef)-[:TRABAJA_EN]->(r) // Este match es para encontrar los chefs que trabajan en cada restaurante
OPTIONAL MATCH (r)-[:OFRECE]->(p:Platillo) // Este match es para encontrar los platillos que ofrece cada restaurante
OPTIONAL MATCH (r)-[:PERTENECE_A]->(t:TipoCocina) // Este match es para encontrar el tipo de cocina al que pertenece cada restaurante
OPTIONAL MATCH ()-[:VISITÓ]->(r) // Este match es para encontrar los usuarios que han visitado cada restaurante
OPTIONAL MATCH ()-[cal:CALIFICÓ]->(r) // Este match es para encontrar las calificaciones que han recibido cada restaurante
WITH // Este with es para agrupar por restaurante y calcular el conteo de chefs, platillos, tipos de cocina, calificaciones y el promedio de calificación
    r.nombre AS restaurante,
    r.rango_precios AS precio,
    count(DISTINCT c) AS total_chefs,
    count(DISTINCT p) AS total_platillos,
    count(DISTINCT t) AS total_tipos_cocina,
    count(DISTINCT cal) AS total_calificaciones,
    avg(cal.puntuacion) AS promedio_calificacion
RETURN
    restaurante,
    precio,
    total_chefs,
    total_platillos,
    total_tipos_cocina,
    total_calificaciones,
    round(coalesce(promedio_calificacion, 0) * 100) / 100 AS promedio_calificacion,
    total_chefs + total_platillos + total_tipos_cocina AS score_conectividad
ORDER BY score_conectividad DESC;

// Ver grafo
MATCH path = (c:Chef)-[:TRABAJA_EN]->(r:Restaurante)-[:OFRECE]->(p:Platillo)
RETURN path;