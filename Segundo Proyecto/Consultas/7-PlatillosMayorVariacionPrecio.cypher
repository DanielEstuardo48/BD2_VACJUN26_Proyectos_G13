// Consulta 7: Platillos con mayor variación de precio 
MATCH (r:Restaurante)-[o:OFRECE]->(p:Platillo) // Este match es para encontrar los restaurantes, los platillos que ofrecen y el precio al que los ofrecen
WITH // Este with es para agrupar por platillo y calcular el conteo de restaurantes que lo ofrecen
    p.nombre AS platillo,
    count(r) AS total_restaurantes,
    min(o.precio) AS precio_minimo,
    max(o.precio) AS precio_maximo,
    avg(o.precio) AS precio_promedio,
    collect(r.nombre + ': Q' + toString(o.precio)) AS detalle_precios
WHERE total_restaurantes > 1 // Solo platillos que sean ofrecidos por más de un restaurante para poder comparar precios
RETURN
    platillo,
    total_restaurantes,
    precio_minimo,
    precio_maximo,
    round(precio_promedio * 100) / 100 AS precio_promedio,
    precio_maximo - precio_minimo AS variacion,
    detalle_precios
ORDER BY variacion DESC;