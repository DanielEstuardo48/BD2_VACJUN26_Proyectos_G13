// Consulta 6: Chefs con mayor movilidad laboral

MATCH (c:Chef)-[t:TRABAJA_EN]->(r:Restaurante)
RETURN 
    c.nombre AS chef,
    c.nacionalidad AS nacionalidad,
    count(r) AS total_restaurantes,
    collect(r.nombre) AS restaurantes,
    collect(t.puesto) AS puestos
ORDER BY total_restaurantes DESC;