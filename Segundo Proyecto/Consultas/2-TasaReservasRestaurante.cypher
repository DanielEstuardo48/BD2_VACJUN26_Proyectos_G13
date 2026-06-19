// Consulta para calcular la tasa de reservas en cada restaurante
MATCH (:Usuario)-[v:VISITÓ]->(r:Restaurante)
WITH
    r,
    count(v) AS total_visitas,
    sum(CASE WHEN v.con_reserva = true THEN 1 ELSE 0 END) AS visitas_con_reserva
RETURN
    r.id_restaurante AS id_restaurante,
    r.nombre AS restaurante,
    total_visitas,
    visitas_con_reserva,
    round((toFloat(visitas_con_reserva) / total_visitas) * 100, 2) AS porcentaje_reservas
ORDER BY porcentaje_reservas DESC, total_visitas DESC;