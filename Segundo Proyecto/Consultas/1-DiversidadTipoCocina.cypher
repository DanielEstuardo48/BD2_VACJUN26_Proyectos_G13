// Consulta 1: Diversidad de tipos de cocina por restaurante

MATCH (r:Restaurante)-[:PERTENECE_A]->(t:TipoCocina) 
RETURN 
    r.nombre AS restaurante,
    r.rango_precios AS precio,
    count(t) AS total_tipos_cocina,
    collect(t.nombre) AS tipos_cocina
ORDER BY total_tipos_cocina DESC;