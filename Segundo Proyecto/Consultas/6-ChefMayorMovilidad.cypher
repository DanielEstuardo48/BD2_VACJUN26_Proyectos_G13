// Consulta 6: Chefs con mayor movilidad laboral

MATCH (c:Chef)-[t:TRABAJA_EN]->(r:Restaurante) // Este match es para encontrar los chefs y los restaurantes en los que han trabajado
RETURN // Esto va a devolver el nombre del chef, su nacionalidad, el conteo de restaurantes y una lista con los nombres de los restaurantes
    c.nombre AS chef,
    c.nacionalidad AS nacionalidad,
    count(r) AS total_restaurantes,
    collect(r.nombre) AS restaurantes,
    collect(t.puesto) AS puestos
ORDER BY total_restaurantes DESC;