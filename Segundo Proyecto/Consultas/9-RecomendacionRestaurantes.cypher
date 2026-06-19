// Consulta 9: Recomendación de restaurantes a un usuario

WITH 137 AS id_usuario,
     4 AS puntuacion_minima

MATCH (u:Usuario {id_usuario: id_usuario})-[cal:CALIFICÓ]->(r_base:Restaurante)
WHERE cal.puntuacion >= puntuacion_minima

MATCH (chef:Chef)-[:TRABAJA_EN]->(r_base)
MATCH (chef)-[:TRABAJA_EN]->(r_recomendado:Restaurante)

WHERE r_recomendado <> r_base
  AND NOT EXISTS {
      MATCH (u)-[:VISITÓ]->(r_recomendado)
  }

OPTIONAL MATCH (r_recomendado)-[:PERTENECE_A]->(tipo:TipoCocina)
OPTIONAL MATCH (r_recomendado)<-[calificacion:CALIFICÓ]-(:Usuario)

WITH
    r_recomendado,
    collect(DISTINCT chef.nombre) AS chefs_compartidos,
    collect(DISTINCT r_base.nombre) AS restaurantes_base,
    collect(DISTINCT tipo.nombre) AS tipos_cocina,
    avg(calificacion.puntuacion) AS promedio_calificacion,
    count(DISTINCT chef) AS coincidencias_chefs

RETURN
    r_recomendado.id_restaurante AS id_restaurante,
    r_recomendado.nombre AS restaurante_recomendado,
    r_recomendado.rango_precios AS rango_precios,
    chefs_compartidos,
    restaurantes_base,
    tipos_cocina,
    coincidencias_chefs,
    round(coalesce(promedio_calificacion, 0) * 100) / 100 AS promedio_calificacion

ORDER BY coincidencias_chefs DESC, promedio_calificacion DESC
LIMIT 10;