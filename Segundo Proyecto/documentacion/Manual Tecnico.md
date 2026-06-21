<div align="center">

**Universidad de San Carlos de Guatemala**  
**Facultad de Ingenieria**  
**Sistema de Bases de Datos 2 - P**  

**Grupo - 13**  
**Participantes:**    
**Daniel Estuardo Salvatierra Macajola - 202202768**   
**Daniel Alejandro Castellanos Rodriguez - 202200176**   
**Carlos Fernando Matta Peña - 202302190**   


**Guatemala 22 de Junio 2026**  

</div>

<h1 align="center">Proyecto 2 - Manual Técnico</h1>

## Tabla de Contenidos
1. [Diseño lógico del modelo de grafos](#1-diseño-lógico-del-modelo-de-grafos)  
   1.1 [Identificación de entidades](#11-identificación-de-entidades)  
   1.2 [Nodos con sus propiedades y tipos de dato](#12-nodos-con-sus-propiedades-y-tipos-de-dato)  
   1.3 [Identificadores únicos — formato y justificación](#13-identificadores-únicos--formato-y-justificación)  
   1.4 [Relaciones con dirección y propiedades](#14-relaciones-con-dirección-y-propiedades)  
2. [Reglas de negocio reflejadas en el modelo](#2-reglas-de-negocio-reflejadas-en-el-modelo) 
3. [Imagen de grafo de ejemplo](#3-imagen-de-grafo-de-ejemplo)   
4. [Consultas Cypher desarrolladas](#4-consultas-cypher-desarrolladas)  
   4.1 [Consulta 5: Restaurantes sin visitas en los últimos N días](#41-consulta-5-restaurantes-sin-visitas-en-los-últimos-n-días)         
   4.2 [Consulta 8: Crecimiento de visitas por tipo de cocina entre dos periodos](#42-consulta-8-crecimiento-de-visitas-por-tipo-de-cocina-entre-dos-periodos)          
   4.3 [Consulta 9: Recomendación de restaurantes a un usuario](#43-consulta-9-recomendación-de-restaurantes-a-un-usuario)      
5. [Análisis de red](#5-análisis-de-red)   
   5.1 [Ruta más corta entre usuarios](#51-ruta-más-corta-entre-usuarios)
6. [Aporte del Integrante 3](#6-aporte-del-integrante-3) 

## 1. Diseño lógico del modelo de grafos

### 1.1 Identificación de entidades
El primer paso del diseño fue identificar qué entidades del mundo real se convierten en nodos del grafo. La regla general es: si la entidad tiene identidad propia y atributos propios, es un nodo. Si solo representa una conexión entre dos entidades, es una relación.

Las entidades identificadas fueron:  
- Usuario — persona que utiliza la plataforma y genera interacciones.  
- Restaurante — establecimiento gastronómico registrado en el sistema.  
- TipoCocina — categoría gastronómica que clasifica restaurantes.  
- Chef — profesional culinario vinculado a restaurantes y platillos.  
- Platillo — preparación culinaria ofrecida por los restaurantes.  

### 1.2 Nodos con sus propiedades y tipos de dato
 
#### Usuario
| Propiedad | Tipo | Notas |
|---|---|---|
| id_usuario | String | Identificador único con prefijo `U` |
| nombre | String | Nombre completo |
| email | String | Único en todo el sistema |
| edad | Integer | Edad en años |
| pais | String | País de residencia |
 
#### Restaurante
| Propiedad | Tipo | Notas |
|---|---|---|
| id_restaurante | String | Identificador único con prefijo `R` |
| nombre | String | Nombre del establecimiento |
| anio_apertura | Integer | Año de apertura del local |
| rango_precios | String | Valores: `$`, `$$`, `$$$` |
| descripcion | String | Descripción breve del restaurante |
 
#### TipoCocina
| Propiedad | Tipo | Notas |
|---|---|---|
| id_tipo_cocina | String | Identificador único con prefijo `T` |
| nombre | String | Único — no puede haber dos tipos iguales |
| descripcion | String | Descripción de la categoría |
 
#### Chef
| Propiedad | Tipo | Notas |
|---|---|---|
| id_chef | String | Identificador único con prefijo `C` |
| nombre | String | Nombre completo del chef |
| fecha_nacimiento | Date | Formato `YYYY-MM-DD` |
| nacionalidad | String | País de origen |
 
#### Platillo
| Propiedad | Tipo | Notas |
|---|---|---|
| id_platillo | String | Identificador único con prefijo `P` |
| nombre | String | Nombre del platillo |
| precio | Float | Precio de referencia o catálogo |
| descripcion | String | Descripción de la preparación |

### 1.3 Identificadores únicos — formato y justificación
 
Se decidió usar strings con prefijo alfabético y número de 4 dígitos (`U0001`, `R0001`, etc.) en lugar de enteros simples o UUIDs, por las siguientes razones:
 
- **Legibilidad inmediata**: al revisar resultados o archivos CSV, el prefijo indica de qué tipo de entidad se trata sin necesidad de contexto adicional.
- **Facilidad de generación**: el Integrante 2 puede generarlos con un simple loop (`f"U{i:04d}"`) en Python, sin librerías externas.
- **Coherencia entre archivos**: todos los CSV de relaciones referencian los mismos IDs, reduciendo errores de integración.
- **Sin colisiones entre tipos**: `U0001` y `R0001` son distintos aunque compartan el número, lo que evita confusiones.

Ejemplos de ids unicos
- id_usuario: U0001, U0002, U0003, ...
- id_restaurante: R0001, R0002, R0003, ...
- id_tipo_cocina: T0001, T0002, T0003, ...
- id_chef: C0001, C0002, C0003, ...
- id_platillo: P0001, P0002, P0003, ...

### 1.4 Relaciones con dirección y propiedades
 
La dirección de cada relación se definió siguiendo el principio de **quién origina la acción**. La entidad que "hace" algo apunta hacia la entidad que "recibe" la acción.
 
| Relación | Dirección | Propiedades | Descripción |
|---|---|---|---|
| CALIFICÓ | (Usuario)→(Restaurante) | puntuacion `[1-5]`, fecha, comentario | Un usuario emite una calificación hacia un restaurante |
| VISITÓ | (Usuario)→(Restaurante) | fecha_visita, consumo, con_reserva | Un usuario realiza una visita a un restaurante |
| ES_AMIGO_DE | (Usuario)→(Usuario) | fecha_amistad | Relación de amistad entre dos usuarios |
| LE_GUSTA | (Usuario)→(TipoCocina) | nivel_interes `[1-5]` | Un usuario declara preferencia por un tipo de cocina |
| PERTENECE_A | (Restaurante)→(TipoCocina) | — | Un restaurante se clasifica dentro de un tipo de cocina |
| OFRECE | (Restaurante)→(Platillo) | precio, disponible | Un restaurante ofrece un platillo a un precio específico |
| PREPARA | (Chef)→(Platillo) | estilo, especialidad | Un chef tiene la habilidad de preparar un platillo |
| TRABAJA_EN | (Chef)→(Restaurante) | fecha_inicio, puesto | Un chef está vinculado laboralmente a un restaurante |
 
---

## 2. Reglas de negocio reflejadas en el modelo
 
Las reglas definidas para el sistema son las siguientes:
 
| Regla de negocio | Cómo se refleja en el modelo |
|---|---|
| Un usuario puede calificar múltiples restaurantes | Múltiples relaciones `CALIFICÓ` desde un mismo nodo `Usuario` |
| Las calificaciones deben estar entre 1 y 5 | Propiedad `puntuacion` en `CALIFICÓ`; validada en carga de datos |
| Un restaurante puede pertenecer a varios tipos de cocina | Múltiples relaciones `PERTENECE_A` desde un mismo `Restaurante` |
| Un restaurante no puede ofrecer el mismo platillo más de una vez | Constraint implícito: solo puede existir una relación `OFRECE` entre el mismo par `(Restaurante, Platillo)` |
| Un chef puede trabajar en varios restaurantes | Múltiples relaciones `TRABAJA_EN` desde un mismo `Chef` |
| El sistema recomienda basándose en chefs compartidos | La consulta de recomendación recorre el camino `(Usuario)-[:CALIFICÓ]->(Restaurante)<-[:TRABAJA_EN]-(Chef)-[:TRABAJA_EN]->(otroRestaurante)` |
 
---

## 3. Imagen de grafo de ejemplo  
![Ejemplo de grafo](/Segundo%20Proyecto/documentacion/image/Screenshot%202026-06-18%20135555.png)



## 4. Consultas Cypher desarrolladas

En esta sección se documentan las consultas Cypher correspondientes al **Integrante 3**, enfocadas en análisis temporal, crecimiento de visitas, recomendación de restaurantes y análisis de conectividad entre usuarios.

Las consultas desarrolladas fueron:

| No. | Consulta                                                     | Responsable                |
| --- | ------------------------------------------------------------ | -------------------------- |
| 5   | Restaurantes sin visitas en los últimos N días               | Carlos Fernando Matta Peña |
| 8   | Crecimiento de visitas por tipo de cocina entre dos periodos | Carlos Fernando Matta Peña |
| 9   | Recomendación de restaurantes a un usuario                   | Carlos Fernando Matta Peña |

---

### 4.1 Consulta 5: Restaurantes sin visitas en los últimos N días

#### Objetivo

Identificar restaurantes que no han recibido visitas recientes dentro de un periodo definido. Esta consulta permite detectar restaurantes con baja actividad en la plataforma, lo cual puede ser útil para análisis comercial, campañas de promoción o seguimiento de establecimientos con poca interacción por parte de los usuarios.

#### Entidades involucradas

| Entidad       | Descripción                                                     |
| ------------- | --------------------------------------------------------------- |
| `Restaurante` | Establecimiento gastronómico registrado en el sistema.          |
| `Usuario`     | Persona que utiliza la plataforma y puede visitar restaurantes. |

#### Relaciones involucradas

| Relación | Descripción                                               |
| -------- | --------------------------------------------------------- |
| `VISITÓ` | Relación que indica que un usuario visitó un restaurante. |

#### Parámetros utilizados

| Parámetro          | Valor utilizado | Descripción                                                                               |
| ------------------ | --------------- | ----------------------------------------------------------------------------------------- |
| `fecha_referencia` | `2026-06-30`    | Fecha base desde la cual se evalúa el periodo.                                            |
| `dias_sin_visita`  | `90`            | Cantidad de días usados para determinar si un restaurante no ha tenido visitas recientes. |

#### Código Cypher

```cypher
// Consulta 5: Restaurantes sin visitas en los últimos N días

// Parámetros de prueba
WITH date('2026-06-30') AS fecha_referencia,
     90 AS dias_sin_visita

MATCH (r:Restaurante)

WHERE NOT EXISTS {
    MATCH (:Usuario)-[v:`VISITÓ`]->(r)
    WHERE v.fecha_visita >= fecha_referencia - duration({days: dias_sin_visita})
}

OPTIONAL MATCH (:Usuario)-[ultima:`VISITÓ`]->(r)

RETURN
    r.id_restaurante AS id_restaurante,
    r.nombre AS restaurante,
    r.rango_precios AS rango_precios,
    max(ultima.fecha_visita) AS ultima_visita,
    dias_sin_visita AS dias_evaluados

ORDER BY ultima_visita ASC;
```

#### Explicación

La consulta inicia definiendo una fecha de referencia y una cantidad de días a evaluar. Luego se recorren todos los nodos `Restaurante` y se utiliza `NOT EXISTS` para verificar que no exista una visita reciente hacia ese restaurante dentro del periodo establecido.

Posteriormente, se utiliza `OPTIONAL MATCH` para obtener la última visita registrada, incluso si el restaurante no tiene visitas. Esto permite incluir restaurantes sin actividad y mostrar su estado dentro del análisis.

#### Resultado esperado

Se espera obtener una tabla con los restaurantes que no han recibido visitas dentro del periodo evaluado. Si un restaurante nunca ha sido visitado, el campo `ultima_visita` puede aparecer vacío.

#### Interpretación

El resultado permite identificar restaurantes con poca o nula actividad reciente. Desde el punto de vista del negocio, estos restaurantes podrían requerir promociones, revisión de su oferta gastronómica o estrategias para aumentar su visibilidad dentro del sistema.

#### Evidencia

![Consulta 5 - Restaurantes sin visitas recientes](/Segundo%20Proyecto/documentacion/capturas/consulta_5_restaurantes_sin_visitas.png)

---

### 4.2 Consulta 8: Crecimiento de visitas por tipo de cocina entre dos periodos

#### Objetivo

Comparar la cantidad de visitas recibidas por cada tipo de cocina en dos periodos distintos. Esta consulta permite identificar qué categorías gastronómicas aumentaron, disminuyeron o mantuvieron su actividad dentro del sistema.

#### Entidades involucradas

| Entidad       | Descripción                                               |
| ------------- | --------------------------------------------------------- |
| `TipoCocina`  | Categoría gastronómica a la que pertenece un restaurante. |
| `Restaurante` | Establecimiento asociado a uno o varios tipos de cocina.  |
| `Usuario`     | Persona que realiza visitas a restaurantes.               |

#### Relaciones involucradas

| Relación      | Descripción                                          |
| ------------- | ---------------------------------------------------- |
| `PERTENECE_A` | Relación entre un restaurante y un tipo de cocina.   |
| `VISITÓ`      | Relación entre un usuario y un restaurante visitado. |

#### Parámetros utilizados

| Parámetro          | Valor utilizado | Descripción                        |
| ------------------ | --------------- | ---------------------------------- |
| `inicio_periodo_1` | `2026-01-01`    | Fecha inicial del primer periodo.  |
| `fin_periodo_1`    | `2026-03-31`    | Fecha final del primer periodo.    |
| `inicio_periodo_2` | `2026-04-01`    | Fecha inicial del segundo periodo. |
| `fin_periodo_2`    | `2026-06-30`    | Fecha final del segundo periodo.   |

#### Código Cypher

```cypher
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
```

#### Explicación

La consulta define dos rangos de fechas para comparar el comportamiento de visitas. Primero se recorren los nodos `TipoCocina`. Luego, mediante `OPTIONAL MATCH`, se cuentan las visitas asociadas a restaurantes de cada tipo de cocina durante el primer periodo.

Después, utilizando `WITH`, se conserva el conteo del primer periodo y se realiza un segundo conteo para el periodo siguiente. Finalmente, se calcula la diferencia entre ambos periodos y el porcentaje de crecimiento.

La expresión `CASE` permite evitar divisiones entre cero cuando un tipo de cocina no tuvo visitas en el primer periodo.

#### Resultado esperado

Se espera obtener un listado de tipos de cocina con:

* visitas del primer periodo,
* visitas del segundo periodo,
* diferencia de visitas,
* porcentaje de crecimiento.

#### Interpretación

Esta consulta permite analizar tendencias de consumo. Un crecimiento positivo indica que el tipo de cocina recibió más visitas en el segundo periodo. Un valor negativo indica disminución de actividad. Esta información puede apoyar decisiones sobre promociones, recomendaciones o análisis de preferencias gastronómicas.

#### Evidencia

![Consulta 8 - Crecimiento de visitas por tipo de cocina](/Segundo%20Proyecto/documentacion/capturas/consulta_8_crecimiento_tipo_cocina.png)

---

### 4.3 Consulta 9: Recomendación de restaurantes a un usuario

#### Objetivo

Recomendar restaurantes a un usuario específico tomando como base restaurantes que calificó positivamente, chefs compartidos y restaurantes que aún no ha visitado. Esta consulta representa la funcionalidad principal del sistema de recomendación.

#### Entidades involucradas

| Entidad       | Descripción                                              |
| ------------- | -------------------------------------------------------- |
| `Usuario`     | Persona a quien se le genera la recomendación.           |
| `Restaurante` | Establecimiento evaluado como posible recomendación.     |
| `Chef`        | Profesional culinario que conecta restaurantes entre sí. |
| `TipoCocina`  | Categoría gastronómica del restaurante recomendado.      |

#### Relaciones involucradas

| Relación      | Descripción                                                      |
| ------------- | ---------------------------------------------------------------- |
| `CALIFICÓ`    | Relación donde un usuario califica un restaurante.               |
| `VISITÓ`      | Relación usada para evitar recomendar restaurantes ya visitados. |
| `TRABAJA_EN`  | Relación que conecta chefs con restaurantes.                     |
| `PERTENECE_A` | Relación que identifica el tipo de cocina del restaurante.       |

#### Parámetros utilizados

| Parámetro           | Valor utilizado | Descripción                                                                  |
| ------------------- | --------------- | ---------------------------------------------------------------------------- |
| `id_usuario`        | `U0001`         | Usuario al que se le generan recomendaciones.                                |
| `puntuacion_minima` | `4`             | Calificación mínima para considerar un restaurante como referencia positiva. |

#### Código Cypher

```cypher
// Consulta 9: Recomendación de restaurantes a un usuario

// Parámetros de prueba
WITH "U0001" AS id_usuario,
     4 AS puntuacion_minima

MATCH (u:Usuario {id_usuario: id_usuario})-[cal:`CALIFICÓ`]->(r_base:Restaurante)
WHERE cal.puntuacion >= puntuacion_minima

MATCH (chef:Chef)-[:TRABAJA_EN]->(r_base)
MATCH (chef)-[:TRABAJA_EN]->(r_recomendado:Restaurante)

WHERE r_recomendado <> r_base
  AND NOT EXISTS {
      MATCH (u)-[:`VISITÓ`]->(r_recomendado)
  }

OPTIONAL MATCH (r_recomendado)-[:PERTENECE_A]->(tipo:TipoCocina)
OPTIONAL MATCH (r_recomendado)<-[calificacion:`CALIFICÓ`]-(:Usuario)

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
```

#### Explicación

La consulta inicia seleccionando un usuario específico mediante su identificador. Luego busca los restaurantes que ese usuario calificó con una puntuación igual o mayor a 4. Estos restaurantes se consideran referencias positivas.

A partir de esos restaurantes, se identifican los chefs que trabajan en ellos. Luego se buscan otros restaurantes donde también trabajen esos chefs. Estos restaurantes se consideran candidatos a recomendación porque comparten chefs con restaurantes que el usuario valoró positivamente.

Para evitar recomendar restaurantes repetidos, se utiliza `NOT EXISTS`, verificando que el usuario no haya visitado previamente el restaurante candidato. También se agregan datos complementarios como tipos de cocina y promedio de calificación general.

#### Resultado esperado

Se espera obtener un listado de restaurantes recomendados para el usuario, mostrando:

* restaurante recomendado,
* rango de precios,
* chefs compartidos,
* restaurantes base,
* tipos de cocina,
* coincidencias de chefs,
* promedio de calificación.

#### Interpretación

Esta consulta demuestra el uso de Neo4j como base de datos orientada a grafos, ya que la recomendación no se basa únicamente en datos aislados, sino en conexiones entre usuarios, restaurantes y chefs. El sistema puede sugerir restaurantes que tienen relación indirecta con lugares que el usuario ya calificó positivamente.

#### Evidencia

![Consulta 9 - Recomendación de restaurantes](/Segundo%20Proyecto/documentacion/capturas/consulta_9_recomendacion.png)

---

## 5. Análisis de red

Además de las consultas de negocio, se implementó un análisis de red basado en rutas entre usuarios. Este análisis permite aprovechar una de las principales ventajas de Neo4j: recorrer conexiones entre nodos de forma directa y eficiente.

---

### 5.1 Ruta más corta entre usuarios

#### Objetivo

Calcular los grados de separación entre dos usuarios utilizando la relación de amistad `ES_AMIGO_DE`. Este análisis permite identificar qué tan conectados están dos usuarios dentro de la red social gastronómica.

#### Entidades involucradas

| Entidad   | Descripción                                 |
| --------- | ------------------------------------------- |
| `Usuario` | Persona registrada dentro de la plataforma. |

#### Relaciones involucradas

| Relación      | Descripción                                               |
| ------------- | --------------------------------------------------------- |
| `ES_AMIGO_DE` | Relación que conecta a dos usuarios mediante una amistad. |

#### Parámetros utilizados

| Parámetro         | Valor utilizado | Descripción                             |
| ----------------- | --------------- | --------------------------------------- |
| `usuario_origen`  | `U0001`         | Usuario desde donde inicia la búsqueda. |
| `usuario_destino` | `U0003`         | Usuario destino al que se desea llegar. |

#### Código Cypher

```cypher
// Análisis de red: Ruta más corta entre usuarios

// Parámetros de prueba
WITH "U0001" AS usuario_origen,
     "U0003" AS usuario_destino

MATCH (origen:Usuario {id_usuario: usuario_origen})
MATCH (destino:Usuario {id_usuario: usuario_destino})

MATCH ruta = shortestPath((origen)-[:ES_AMIGO_DE*..6]-(destino))

RETURN
    origen.nombre AS usuario_origen,
    destino.nombre AS usuario_destino,
    length(ruta) AS grados_separacion,
    [nodo IN nodes(ruta) | nodo.nombre] AS usuarios_en_ruta,
    ruta;
```

#### Explicación

La consulta define un usuario origen y un usuario destino. Luego busca ambos nodos `Usuario` dentro del grafo. Después se utiliza la función `shortestPath`, que permite encontrar la ruta más corta entre ambos usuarios siguiendo relaciones `ES_AMIGO_DE`.

El patrón `[:ES_AMIGO_DE*..6]` permite recorrer relaciones de amistad con una profundidad máxima de seis niveles. Esto evita recorridos demasiado extensos y mantiene controlado el análisis.

Finalmente, se devuelve el usuario origen, el usuario destino, los grados de separación, los usuarios intermedios en la ruta y el grafo de la ruta encontrada.

#### Resultado esperado

Se espera obtener la ruta más corta entre dos usuarios conectados mediante relaciones de amistad. El resultado debe mostrar cuántos grados de separación existen entre ambos y qué usuarios forman parte del camino.

#### Interpretación

Este análisis permite observar la conectividad social dentro del sistema. Si dos usuarios están conectados por pocos grados de separación, significa que pertenecen a una red cercana de amistad. Esta información podría utilizarse posteriormente para recomendaciones basadas en amigos, gustos compartidos o visitas realizadas por usuarios cercanos dentro del grafo.

#### Evidencia

![Análisis de red - Ruta más corta entre usuarios](/Segundo%20Proyecto/documentacion/capturas/analisis_ruta_mas_corta.png)

---

## 6. Aporte del Integrante 3

El aporte del Integrante 3 se enfocó en la construcción de consultas analíticas, sistema de recomendación y análisis de red dentro del proyecto de restaurantes en Neo4j.

Las consultas desarrolladas permiten detectar restaurantes sin visitas recientes, analizar el crecimiento de visitas por tipo de cocina y recomendar restaurantes a usuarios específicos utilizando relaciones del grafo. Además, se implementó un análisis de ruta más corta entre usuarios, con el objetivo de evaluar la conectividad social dentro del sistema.

Este aporte contribuye directamente al objetivo principal del proyecto, ya que demuestra cómo Neo4j permite analizar relaciones complejas entre usuarios, restaurantes, chefs, visitas, calificaciones y tipos de cocina. A diferencia de un modelo relacional tradicional, el enfoque basado en grafos facilita recorrer conexiones indirectas y encontrar patrones útiles para recomendaciones.
