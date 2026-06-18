// Consulta 1: Diversidad de tipos de cocina por restaurante

MATCH (r:Restaurante)-[:PERTENECE_A]->(t:TipoCocina) // Este match es para encontrar los restaurantes y sus tipos de cocina
RETURN // Esto va a devolver el nombre del restaurante, su rango de precios, el conteo de tipos de cocina y una lista con los nombres de los tipos de cocina
    r.nombre AS restaurante,
    r.rango_precios AS precio,
    count(t) AS total_tipos_cocina,
    collect(t.nombre) AS tipos_cocina
ORDER BY total_tipos_cocina DESC;