// Análisis de red: Ruta más corta entre usuarios

// Parámetros para definir los usuarios de origen y destino
WITH 20 AS usuario_origen,
     365 AS usuario_destino

MATCH (origen:Usuario {id_usuario: usuario_origen})
MATCH (destino:Usuario {id_usuario: usuario_destino})

MATCH ruta = shortestPath((origen)-[:ES_AMIGO_DE*..6]-(destino))

RETURN
    origen.nombre AS usuario_origen,
    destino.nombre AS usuario_destino,
    length(ruta) AS grados_separacion,
    [nodo IN nodes(ruta) | nodo.nombre] AS usuarios_en_ruta,
    ruta;