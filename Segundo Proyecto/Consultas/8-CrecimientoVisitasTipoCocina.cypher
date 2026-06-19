// Consulta 8: Crecimiento de visitas por tipo de cocina


WITH date('2026-01-01') AS inicio_periodo_1,
     date('2026-03-31') AS fin_periodo_1,
     date('2026-04-01') AS inicio_periodo_2,
     date('2026-06-30') AS fin_periodo_2

MATCH (t:TipoCocina)

OPTIONAL MATCH (t)<-[:PERTENECE_A]-(r1:Restaurante)<-[v1:`VISITÓ`]-(:Usuario)
WHERE v1.fecha_visita >= inicio_periodo_1
  AND v1.fecha_visita <= fin_periodo_1

WITH t, inicio_periodo_1, fin_periodo_1, inicio_periodo_2, fin_periodo_2,
     count(DISTINCT v1) AS visitas_periodo_1

OPTIONAL MATCH (t)<-[:PERTENECE_A]-(r2:Restaurante)<-[v2:`VISITÓ`]-(:Usuario)
WHERE v2.fecha_visita >= inicio_periodo_2
  AND v2.fecha_visita <= fin_periodo_2

WITH t,
     visitas_periodo_1,
     count(DISTINCT v2) AS visitas_periodo_2

RETURN
    t.id_tipo_cocina AS id_tipo_cocina,
    t.nombre AS tipo_cocina,
    visitas_periodo_1,
    visitas_periodo_2,
    visitas_periodo_2 - visitas_periodo_1 AS diferencia_visitas,
    CASE
        WHEN visitas_periodo_1 = 0 AND visitas_periodo_2 > 0 THEN 100.0
        WHEN visitas_periodo_1 = 0 AND visitas_periodo_2 = 0 THEN 0.0
        ELSE round(((toFloat(visitas_periodo_2 - visitas_periodo_1) / visitas_periodo_1) * 100) * 100) / 100
    END AS porcentaje_crecimiento

ORDER BY porcentaje_crecimiento DESC;