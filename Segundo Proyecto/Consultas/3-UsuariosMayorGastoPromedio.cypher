//Usuarios con mayor gasto promedio por visita
MATCH (u:Usuario)-[v:VISITÓ]->(r:Restaurante)
WITH
    u,
    count(v) AS total_visitas,
    avg(v.consumo) AS gasto_promedio,
    sum(v.consumo) AS gasto_total
RETURN
    u.id_usuario AS id_usuario,
    u.nombre AS usuario,
    u.email AS email,
    total_visitas,
    round(gasto_promedio, 2) AS gasto_promedio_por_visita,
    round(gasto_total, 2) AS gasto_total
ORDER BY gasto_promedio_por_visita DESC
LIMIT 20;