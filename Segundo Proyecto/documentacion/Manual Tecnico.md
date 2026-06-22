<div align="center">

**Universidad de San Carlos de Guatemala**  
**Facultad de Ingeniería**  
**Sistema de Bases de Datos 2 - Proyecto 2**  

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

4. [Carga masiva de datos](#4-carga-masiva-de-datos)  
    4.1 [Archivos CSV utilizados](#41-archivos-csv-utilizados)  
    4.2 [Cantidades cargadas](#42-cantidades-cargadas)  
    4.3 [Proceso de carga](#43-proceso-de-carga)  
    4.4 [Validación de carga](#44-validación-de-carga)  

5. [Consultas Cypher desarrolladas](#5-consultas-cypher-desarrolladas)  
    5.1 [Consulta 1: Diversidad de tipos de cocina por restaurante](#51-consulta-1-diversidad-de-tipos-de-cocina-por-restaurante)  
    5.2 [Consulta 2: Tasa de reservas por restaurante](#52-consulta-2-tasa-de-reservas-por-restaurante)  
    5.3 [Consulta 3: Usuarios con mayor gasto promedio por visita](#53-consulta-3-usuarios-con-mayor-gasto-promedio-por-visita)  
    5.4 [Consulta 4: Usuarios con mayor frecuencia de visitas en un periodo](#54-consulta-4-usuarios-con-mayor-frecuencia-de-visitas-en-un-periodo)  
    5.5 [Consulta 5: Restaurantes sin visitas en los últimos N días](#55-consulta-5-restaurantes-sin-visitas-en-los-últimos-n-días)  
    5.6 [Consulta 6: Chefs con mayor movilidad laboral](#56-consulta-6-chefs-con-mayor-movilidad-laboral)  
    5.7 [Consulta 7: Platillos con mayor variación de precio entre restaurantes](#57-consulta-7-platillos-con-mayor-variación-de-precio-entre-restaurantes)  
    5.8 [Consulta 8: Crecimiento de visitas por tipo de cocina entre dos periodos](#58-consulta-8-crecimiento-de-visitas-por-tipo-de-cocina-entre-dos-periodos)  
    5.9 [Consulta 9: Recomendación de restaurantes a un usuario](#59-consulta-9-recomendación-de-restaurantes-a-un-usuario)  

6. [Análisis de red](#6-análisis-de-red)  
    6.1 [Análisis 1: Restaurantes altamente conectados](#61-análisis-1-restaurantes-altamente-conectados)  
    6.2 [Análisis 2: Ruta más corta entre usuarios](#62-análisis-2-ruta-más-corta-entre-usuarios)  

7. [Script Cypher de creación del esquema](#7-script-cypher-de-creación-del-esquema)  
    7.1 [Constraints de unicidad](#71-constraints-de-unicidad)  
    7.2 [Índices utilizados](#72-índices-utilizados)  
    7.3 [Justificación técnica](#73-justificación-técnica)  
    7.4 [Validación de constraints e índices](#74-validación-de-constraints-e-índices)  

8. [Ventajas de utilizar Neo4j para este problema](#8-ventajas-de-utilizar-neo4j-para-este-problema)  
    8.1 [Modelado natural de relaciones](#81-modelado-natural-de-relaciones)  
    8.2 [Consultas eficientes sobre relaciones](#82-consultas-eficientes-sobre-relaciones)  
    8.3 [Facilidad para sistemas de recomendación](#83-facilidad-para-sistemas-de-recomendación)  
    8.4 [Análisis de redes](#84-análisis-de-redes)  
    8.5 [Flexibilidad del modelo](#85-flexibilidad-del-modelo)  
    8.6 [Conclusión técnica](#86-conclusión-técnica)  

9. [Estructura del repositorio](#9-estructura-del-repositorio)  

10. [Conclusiones](#10-conclusiones)  

11. [Aporte del equipo](#11-aporte-del-equipo)  
    11.1 [Aporte de Daniel Estuardo Salvatierra](#111-aporte-de-daniel-estuardo-salvatierra)  
    11.2 [Aporte de Daniel Alejandro Castellanos Rodriguez](#112-aporte-de-daniel-alejandro-castellanos-rodriguez)  
    11.3 [Aporte de Carlos Fernando Matta Peña](#113-aporte-de-carlos-fernando-matta-peña)  
    11.4 [Aporte general del equipo](#114-aporte-general-del-equipo)  
       

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
| id_usuario | Integer | Identificador único del usuario |
| nombre | String | Nombre del usuario |
| email | String | Correo electrónico del usuario |
| edad | Integer | Edad en años |
| pais | String | País de residencia |

#### Restaurante

| Propiedad | Tipo | Notas |
|---|---|---|
| id_restaurante | Integer | Identificador único del restaurante |
| nombre | String | Nombre del establecimiento |
| anio_apertura | Integer | Año de apertura del restaurante |
| rango_precios | String | Rango de precios utilizado: Bajo, Medio o Alto |
| descripcion | String | Descripción breve del restaurante |

#### TipoCocina

| Propiedad | Tipo | Notas |
|---|---|---|
| id_tipo_cocina | Integer | Identificador único del tipo de cocina |
| nombre | String | Nombre de la categoría gastronómica |
| descripcion | String | Descripción del tipo de cocina |

#### Chef

| Propiedad | Tipo | Notas |
|---|---|---|
| id_chef | Integer | Identificador único del chef |
| nombre | String | Nombre del chef |
| fecha_nacimiento | Date | Fecha de nacimiento en formato `YYYY-MM-DD` |
| nacionalidad | String | Nacionalidad del chef |

#### Platillo

| Propiedad | Tipo | Notas |
|---|---|---|
| id_platillo | Integer | Identificador único del platillo |
| nombre | String | Nombre del platillo |
| precio | Float | Precio de referencia del platillo |
| descripcion | String | Descripción de la preparación |

### 1.3 Identificadores únicos — formato y justificación

Para este proyecto se decidió utilizar identificadores numéricos enteros en las entidades principales del grafo. Esta decisión permite simplificar la generación de datos mediante Python y facilita la carga masiva desde archivos CSV utilizando conversiones directas con `toInteger()` en Cypher.

Ejemplos de identificadores utilizados:

- id_usuario: 1, 2, 3, ...
- id_restaurante: 1, 2, 3, ...
- id_tipo_cocina: 1, 2, 3, ...
- id_chef: 1, 2, 3, ...
- id_platillo: 1, 2, 3, ...

El uso de identificadores enteros facilita la relación entre los archivos CSV de nodos y los archivos CSV de relaciones, ya que cada relación referencia directamente los identificadores de los nodos existentes. Además, esta estructura permite validar fácilmente la integridad de los datos durante la carga masiva.

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


## 4. Carga masiva de datos

La carga masiva de datos se realizó mediante archivos CSV y scripts Cypher utilizando la instrucción `LOAD CSV WITH HEADERS`. Para la generación de datos se utilizó un script en Python llamado `generar_datos.py`, ubicado dentro de la carpeta `scripts`.

Los archivos CSV generados fueron almacenados en la carpeta `data` del proyecto y posteriormente copiados al directorio `import` de Neo4j para permitir su lectura desde Cypher.

### 4.1 Archivos CSV utilizados

| Archivo | Descripción |
|---|---|
| usuarios.csv | Contiene los usuarios del sistema |
| restaurantes.csv | Contiene los restaurantes registrados |
| chefs.csv | Contiene los chefs del sistema |
| platillos.csv | Contiene los platillos disponibles |
| tipos_cocina.csv | Contiene las categorías gastronómicas |
| califico.csv | Relaciones de calificación entre usuarios y restaurantes |
| visito.csv | Relaciones de visita entre usuarios y restaurantes |
| amistades.csv | Relaciones de amistad entre usuarios |
| pertenece_a.csv | Relación entre restaurantes y tipos de cocina |
| ofrece.csv | Relación entre restaurantes y platillos |
| prepara.csv | Relación entre chefs y platillos |
| trabaja_en.csv | Relación entre chefs y restaurantes |
| le_gusta.csv | Relación entre usuarios y tipos de cocina |

### 4.2 Cantidades cargadas

| Elemento | Cantidad |
|---|---:|
| Usuarios | 500 |
| Restaurantes | 200 |
| Chefs | 100 |
| Platillos | 50 |
| Tipos de cocina | 15 |
| VISITÓ | 1600 |
| CALIFICÓ | 1200 |
| ES_AMIGO_DE | 900 |
| PERTENECE_A | 350 |
| OFRECE | 800 |
| PREPARA | 350 |
| TRABAJA_EN | 250 |
| LE_GUSTA | 1000 |

### 4.3 Proceso de carga

Primero se cargaron los nodos principales del grafo mediante el archivo `04_load_nodes.cypher`. Posteriormente se cargaron las relaciones mediante el archivo `05_load_relationships.cypher`.

La carga de nodos utiliza `MERGE` para evitar duplicados y `SET` para asignar las propiedades correspondientes.

Ejemplo:

```cypher
LOAD CSV WITH HEADERS
FROM 'file:///usuarios.csv' AS row
MERGE (u:Usuario {id_usuario: toInteger(row.id_usuario)})
SET
    u.nombre = row.nombre,
    u.email = row.email,
    u.edad = toInteger(row.edad),
    u.pais = row.pais;
```
La carga de relaciones utiliza MATCH para localizar los nodos existentes y luego MERGE o CREATE para crear la relación correspondiente.

Ejemplo:

```cypher
LOAD CSV WITH HEADERS
FROM 'file:///visito.csv' AS row
MATCH (u:Usuario {id_usuario: toInteger(row.id_usuario)})
MATCH (r:Restaurante {id_restaurante: toInteger(row.id_restaurante)})
CREATE (u)-[v:VISITÓ]->(r)
SET
    v.fecha_visita = date(row.fecha_visita),
    v.consumo = toFloat(row.consumo),
    v.con_reserva = toBoolean(row.con_reserva);
```
### 4.4 Validación de carga

```cypher
MATCH (u:Usuario)
WITH count(u) AS usuarios
MATCH (r:Restaurante)
WITH usuarios, count(r) AS restaurantes
MATCH (c:Chef)
WITH usuarios, restaurantes, count(c) AS chefs
MATCH (p:Platillo)
WITH usuarios, restaurantes, chefs, count(p) AS platillos
MATCH (t:TipoCocina)
RETURN
    usuarios,
    restaurantes,
    chefs,
    platillos,
    count(t) AS tipos_cocina;
```

![Validación de nodos](image/4.2_evidencianodos.png)

```cypher
MATCH ()-[r]->()
RETURN type(r) AS relacion, count(r) AS total
ORDER BY total DESC;
```

![Validacion de relaciones](image/4.2_evidenciarelaciones.png)

## 5. Consultas Cypher desarrolladas

En esta sección se documentan las consultas Cypher implementadas para el sistema de recomendación de restaurantes en Neo4j. Estas consultas permiten analizar diversidad gastronómica, visitas, reservas, gasto promedio, actividad de restaurantes, movilidad de chefs, variación de precios, crecimiento por tipo de cocina y recomendaciones personalizadas.

Las consultas desarrolladas fueron:

| No. | Consulta | Responsable |
| --- | --- | --- |
| 1 | Diversidad de tipos de cocina por restaurante | *Daniel Estuardo Salvatierra Macajola |
| 2 | Tasa de reservas por restaurante | Daniel Alejandro Castellanos Rodriguez |
| 3 | Usuarios con mayor gasto promedio por visita | Daniel Alejandro Castellanos Rodriguez |
| 4 | Usuarios con mayor frecuencia de visitas en un periodo | Daniel Alejandro Castellanos Rodriguez |
| 5 | Restaurantes sin visitas en los últimos N días | Carlos Fernando Matta Peña |
| 6 | Chefs con mayor movilidad laboral | *Daniel Estuardo Salvatierra Macajola |
| 7 | Platillos con mayor variación de precio entre restaurantes | *Daniel Estuardo Salvatierra Macajola |
| 8 | Crecimiento de visitas por tipo de cocina entre dos periodos | Carlos Fernando Matta Peña |
| 9 | Recomendación de restaurantes a un usuario | Carlos Fernando Matta Peña |

---

### 5.1 Consulta 1: Diversidad de tipos de cocina por restaurante

#### Objetivo

Medir la diversidad gastronómica de cada restaurante a partir de la cantidad de tipos de cocina asociados. Esta consulta permite identificar qué restaurantes ofrecen una propuesta culinaria más variada dentro del sistema.

#### Entidades involucradas

| Entidad | Descripción |
| --- | --- |
| `Restaurante` | Establecimiento gastronómico registrado en la plataforma. |
| `TipoCocina` | Categoría gastronómica a la que puede pertenecer un restaurante. |

#### Relaciones involucradas

| Relación | Descripción |
| --- | --- |
| `PERTENECE_A` | Relación que conecta un restaurante con uno o varios tipos de cocina. |

#### Parámetros utilizados

No utiliza parámetros externos.

#### Código Cypher

```cypher
// Consulta 1: Diversidad de tipos de cocina por restaurante

MATCH (r:Restaurante)-[:PERTENECE_A]->(t:TipoCocina)
RETURN
    r.id_restaurante AS id_restaurante,
    r.nombre AS restaurante,
    r.rango_precios AS precio,
    count(t) AS total_tipos_cocina,
    collect(t.nombre) AS tipos_cocina
ORDER BY total_tipos_cocina DESC;
```

#### Explicación

La consulta busca todos los restaurantes que poseen una relación `PERTENECE_A` con algún nodo `TipoCocina`. Luego agrupa los resultados por restaurante, cuenta cuántos tipos de cocina tiene asociados y reúne los nombres de dichos tipos en una lista.

#### Resultado esperado

Se espera obtener una tabla con los restaurantes, su rango de precios, la cantidad de tipos de cocina asociados y el listado de dichas categorías gastronómicas.

#### Interpretación

Los restaurantes con mayor cantidad de tipos de cocina pueden considerarse más diversos, ya que ofrecen una propuesta gastronómica más amplia. Esta información puede utilizarse para análisis de variedad culinaria o para mejorar recomendaciones a usuarios con gustos variados.

#### Evidencia

![Consulta 1 - Diversidad de tipos de cocina](image/5.1.png)

---

### 5.2 Consulta 2: Tasa de reservas por restaurante

#### Objetivo

Calcular el porcentaje de visitas realizadas con reserva para cada restaurante. Esta consulta permite identificar qué restaurantes reciben mayor cantidad de visitas planificadas por parte de los usuarios.

#### Entidades involucradas

| Entidad | Descripción |
| --- | --- |
| `Usuario` | Persona registrada en la plataforma que puede visitar restaurantes. |
| `Restaurante` | Establecimiento gastronómico que recibe visitas. |

#### Relaciones involucradas

| Relación | Descripción |
| --- | --- |
| `VISITÓ` | Relación que indica que un usuario visitó un restaurante. Contiene la propiedad `con_reserva`. |

#### Parámetros utilizados

No utiliza parámetros externos.

#### Código Cypher

```cypher
// Consulta 2: Tasa de reservas por restaurante

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
```

#### Explicación

La consulta recorre las relaciones `VISITÓ` entre usuarios y restaurantes. Para cada restaurante se cuenta el total de visitas y se suman únicamente aquellas en las que la propiedad `con_reserva` tiene valor `true`.

Luego se calcula el porcentaje de reservas dividiendo las visitas con reserva entre el total de visitas del restaurante y multiplicando el resultado por 100.

#### Resultado esperado

Se espera obtener una tabla con el identificador del restaurante, nombre, total de visitas, visitas con reserva y porcentaje de reservas.

#### Interpretación

Los restaurantes con mayor porcentaje de reservas pueden considerarse establecimientos donde los usuarios planifican más sus visitas. Esto puede ser útil para analizar demanda, ocupación o comportamiento de consumo.

#### Evidencia

![Consulta 2 - Tasa de reservas por restaurante](image/5.2.png)

---

### 5.3 Consulta 3: Usuarios con mayor gasto promedio por visita

#### Objetivo

Identificar los usuarios que presentan el mayor gasto promedio por visita. Esta consulta permite analizar el comportamiento de consumo de los usuarios dentro del sistema.

#### Entidades involucradas

| Entidad | Descripción |
| --- | --- |
| `Usuario` | Persona que realiza visitas a restaurantes. |
| `Restaurante` | Establecimiento visitado por los usuarios. |

#### Relaciones involucradas

| Relación | Descripción |
| --- | --- |
| `VISITÓ` | Relación que almacena información de cada visita, incluyendo el consumo realizado. |

#### Parámetros utilizados

No utiliza parámetros externos.

#### Código Cypher

```cypher
// Consulta 3: Usuarios con mayor gasto promedio por visita

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
```

#### Explicación

La consulta busca todas las visitas realizadas por los usuarios. Luego agrupa los resultados por usuario y calcula tres métricas principales: total de visitas, gasto promedio y gasto total.

La función `avg()` calcula el consumo promedio por visita, mientras que `sum()` calcula el gasto acumulado del usuario.

#### Resultado esperado

Se espera obtener una tabla con los usuarios que tienen mayor gasto promedio por visita, mostrando también su cantidad de visitas y gasto total.

#### Interpretación

Esta consulta permite identificar usuarios con alto nivel de consumo. Desde una perspectiva de negocio, estos usuarios podrían considerarse clientes frecuentes de alto valor o candidatos para promociones personalizadas.

#### Evidencia

![Consulta 3 - Usuarios con mayor gasto promedio](image/5.3.png)

---

### 5.4 Consulta 4: Usuarios con mayor frecuencia de visitas en un periodo

#### Objetivo

Identificar los usuarios que realizaron más visitas dentro de un periodo específico. Esta consulta permite analizar frecuencia de uso y actividad de los usuarios en un rango de fechas determinado.

#### Entidades involucradas

| Entidad | Descripción |
| --- | --- |
| `Usuario` | Persona que realiza visitas dentro del sistema. |
| `Restaurante` | Restaurante visitado por los usuarios. |

#### Relaciones involucradas

| Relación | Descripción |
| --- | --- |
| `VISITÓ` | Relación que almacena la fecha en la que un usuario visitó un restaurante. |

#### Parámetros utilizados

| Parámetro | Valor utilizado | Descripción |
| --- | --- | --- |
| `fecha_inicio` | `2025-01-01` | Fecha inicial del periodo evaluado. |
| `fecha_fin` | `2025-12-31` | Fecha final del periodo evaluado. |

#### Código Cypher

```cypher
// Consulta 4: Usuarios con mayor frecuencia de visitas en un periodo

WITH date('2025-01-01') AS fecha_inicio,
     date('2025-12-31') AS fecha_fin

MATCH (u:Usuario)-[v:VISITÓ]->(r:Restaurante)
WHERE v.fecha_visita >= fecha_inicio
  AND v.fecha_visita <= fecha_fin
WITH
    u,
    count(v) AS total_visitas_periodo,
    collect(DISTINCT r.nombre)[0..5] AS restaurantes_visitados
RETURN
    u.id_usuario AS id_usuario,
    u.nombre AS usuario,
    u.email AS email,
    total_visitas_periodo,
    restaurantes_visitados
ORDER BY total_visitas_periodo DESC
LIMIT 20;
```

#### Explicación

La consulta define un rango de fechas mediante `fecha_inicio` y `fecha_fin`. Luego busca las relaciones `VISITÓ` cuya propiedad `fecha_visita` se encuentre dentro de ese periodo.

Después agrupa los resultados por usuario, cuenta el total de visitas realizadas en ese rango y muestra algunos restaurantes visitados como referencia.

#### Resultado esperado

Se espera obtener una tabla con los usuarios que realizaron mayor cantidad de visitas dentro del periodo definido.

#### Interpretación

Esta consulta permite identificar usuarios con alta frecuencia de uso de la plataforma durante un periodo específico. Puede utilizarse para analizar actividad, fidelidad o comportamiento recurrente.

#### Evidencia

![Consulta 4 - Usuarios con mayor frecuencia de visitas](image/5.4.png)

---

### 5.5 Consulta 5: Restaurantes sin visitas en los últimos N días

#### Objetivo

Identificar restaurantes que no han recibido visitas recientes dentro de un periodo definido. Esta consulta permite detectar restaurantes con baja actividad en la plataforma, lo cual puede ser útil para análisis comercial, campañas de promoción o seguimiento de establecimientos con poca interacción por parte de los usuarios.

#### Entidades involucradas

| Entidad | Descripción |
| --- | --- |
| `Restaurante` | Establecimiento gastronómico registrado en el sistema. |
| `Usuario` | Persona que utiliza la plataforma y puede visitar restaurantes. |

#### Relaciones involucradas

| Relación | Descripción |
| --- | --- |
| `VISITÓ` | Relación que indica que un usuario visitó un restaurante. |

#### Parámetros utilizados

| Parámetro | Valor utilizado | Descripción |
| --- | --- | --- |
| `fecha_referencia` | `2026-06-30` | Fecha base desde la cual se evalúa el periodo. |
| `dias_sin_visita` | `90` | Cantidad de días usados para determinar si un restaurante no ha tenido visitas recientes. |

#### Código Cypher

```cypher
// Consulta 5: Restaurantes sin visitas en los últimos N días

WITH date('2026-06-30') AS fecha_referencia,
     90 AS dias_sin_visita

MATCH (r:Restaurante)

WHERE NOT EXISTS {
    MATCH (:Usuario)-[v:VISITÓ]->(r)
    WHERE v.fecha_visita >= fecha_referencia - duration({days: dias_sin_visita})
}

OPTIONAL MATCH (:Usuario)-[ultima:VISITÓ]->(r)

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

![Consulta 5 - Restaurantes sin visitas recientes](image/5.5.png)

---

### 5.6 Consulta 6: Chefs con mayor movilidad laboral

#### Objetivo

Determinar cuáles chefs han trabajado en mayor cantidad de restaurantes. Esta consulta permite analizar la movilidad laboral de los chefs dentro del sistema gastronómico.

#### Entidades involucradas

| Entidad | Descripción |
| --- | --- |
| `Chef` | Persona encargada de la preparación culinaria. |
| `Restaurante` | Establecimiento en el que trabaja o ha trabajado un chef. |

#### Relaciones involucradas

| Relación | Descripción |
| --- | --- |
| `TRABAJA_EN` | Relación que conecta un chef con un restaurante e incluye propiedades como puesto y fecha de inicio. |

#### Parámetros utilizados

No utiliza parámetros externos.

#### Código Cypher

```cypher
// Consulta 6: Chefs con mayor movilidad laboral

MATCH (c:Chef)-[t:TRABAJA_EN]->(r:Restaurante)
RETURN
    c.id_chef AS id_chef,
    c.nombre AS chef,
    c.nacionalidad AS nacionalidad,
    count(r) AS total_restaurantes,
    collect(r.nombre) AS restaurantes,
    collect(t.puesto) AS puestos
ORDER BY total_restaurantes DESC;
```

#### Explicación

La consulta busca todos los chefs que tienen una relación `TRABAJA_EN` con uno o más restaurantes. Luego agrupa los resultados por chef y cuenta la cantidad de restaurantes asociados.

También se recopila el listado de restaurantes y puestos ocupados para tener mayor detalle del historial laboral.

#### Resultado esperado

Se espera obtener una tabla con los chefs ordenados por la cantidad de restaurantes en los que han trabajado.

#### Interpretación

Un chef con mayor cantidad de restaurantes asociados puede considerarse con alta movilidad laboral. Esta información puede ser útil para analizar experiencia, trayectoria o participación en diferentes establecimientos.

#### Evidencia

![Consulta 6 - Chefs con mayor movilidad laboral](image/5.6.png)
---

### 5.7 Consulta 7: Platillos con mayor variación de precio entre restaurantes

#### Objetivo

Detectar los platillos que presentan mayor variación de precio entre distintos restaurantes. Esta consulta permite comparar el precio de un mismo platillo cuando es ofrecido por diferentes establecimientos.

#### Entidades involucradas

| Entidad | Descripción |
| --- | --- |
| `Restaurante` | Establecimiento que ofrece platillos. |
| `Platillo` | Preparación gastronómica ofrecida por uno o varios restaurantes. |

#### Relaciones involucradas

| Relación | Descripción |
| --- | --- |
| `OFRECE` | Relación que conecta un restaurante con un platillo e incluye el precio ofertado. |

#### Parámetros utilizados

No utiliza parámetros externos.

#### Código Cypher

```cypher
// Consulta 7: Platillos con mayor variación de precio

MATCH (r:Restaurante)-[o:OFRECE]->(p:Platillo)
WITH
    p,
    count(r) AS total_restaurantes,
    min(o.precio) AS precio_minimo,
    max(o.precio) AS precio_maximo,
    avg(o.precio) AS precio_promedio,
    collect(r.nombre + ': Q' + toString(o.precio)) AS detalle_precios
WHERE total_restaurantes > 1
RETURN
    p.id_platillo AS id_platillo,
    p.nombre AS platillo,
    total_restaurantes,
    precio_minimo,
    precio_maximo,
    round(precio_promedio * 100) / 100 AS precio_promedio,
    precio_maximo - precio_minimo AS variacion,
    detalle_precios
ORDER BY variacion DESC;
```

#### Explicación

La consulta recorre las relaciones `OFRECE` entre restaurantes y platillos. Luego agrupa los resultados por platillo para calcular el precio mínimo, precio máximo, precio promedio y la diferencia entre el precio más alto y el más bajo.

La condición `WHERE total_restaurantes > 1` asegura que solo se analicen platillos ofrecidos por más de un restaurante, ya que solo así es posible comparar precios.

#### Resultado esperado

Se espera obtener un listado de platillos ordenados por mayor variación de precio entre restaurantes.

#### Interpretación

Los platillos con mayor variación de precio pueden indicar diferencias en calidad, presentación, ubicación del restaurante o estrategia comercial. Esta información puede apoyar análisis de precios dentro de la plataforma.

#### Evidencia

![Consulta 7 - Platillos con mayor variación de precio](image/5.7.png)

---

### 5.8 Consulta 8: Crecimiento de visitas por tipo de cocina entre dos periodos

#### Objetivo

Comparar la cantidad de visitas recibidas por cada tipo de cocina en dos periodos distintos. Esta consulta permite identificar qué categorías gastronómicas aumentaron, disminuyeron o mantuvieron su actividad dentro del sistema.

#### Entidades involucradas

| Entidad | Descripción |
| --- | --- |
| `TipoCocina` | Categoría gastronómica a la que pertenece un restaurante. |
| `Restaurante` | Establecimiento asociado a uno o varios tipos de cocina. |
| `Usuario` | Persona que realiza visitas a restaurantes. |

#### Relaciones involucradas

| Relación | Descripción |
| --- | --- |
| `PERTENECE_A` | Relación entre un restaurante y un tipo de cocina. |
| `VISITÓ` | Relación entre un usuario y un restaurante visitado. |

#### Parámetros utilizados

| Parámetro | Valor utilizado | Descripción |
| --- | --- | --- |
| `inicio_periodo_1` | `2026-01-01` | Fecha inicial del primer periodo. |
| `fin_periodo_1` | `2026-03-31` | Fecha final del primer periodo. |
| `inicio_periodo_2` | `2026-04-01` | Fecha inicial del segundo periodo. |
| `fin_periodo_2` | `2026-06-30` | Fecha final del segundo periodo. |

#### Código Cypher

```cypher
// Consulta 8: Crecimiento de visitas por tipo de cocina

WITH date('2026-01-01') AS inicio_periodo_1,
     date('2026-03-31') AS fin_periodo_1,
     date('2026-04-01') AS inicio_periodo_2,
     date('2026-06-30') AS fin_periodo_2

MATCH (t:TipoCocina)

OPTIONAL MATCH (t)<-[:PERTENECE_A]-(r1:Restaurante)<-[v1:VISITÓ]-(:Usuario)
WHERE v1.fecha_visita >= inicio_periodo_1
  AND v1.fecha_visita <= fin_periodo_1

WITH t, inicio_periodo_1, fin_periodo_1, inicio_periodo_2, fin_periodo_2,
     count(DISTINCT v1) AS visitas_periodo_1

OPTIONAL MATCH (t)<-[:PERTENECE_A]-(r2:Restaurante)<-[v2:VISITÓ]-(:Usuario)
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

Se espera obtener un listado de tipos de cocina con visitas del primer periodo, visitas del segundo periodo, diferencia de visitas y porcentaje de crecimiento.

#### Interpretación

Esta consulta permite analizar tendencias de consumo. Un crecimiento positivo indica que el tipo de cocina recibió más visitas en el segundo periodo. Un valor negativo indica disminución de actividad. Esta información puede apoyar decisiones sobre promociones, recomendaciones o análisis de preferencias gastronómicas.

#### Evidencia

![Consulta 8 - Crecimiento de visitas por tipo de cocina](image/5.8.png)

---

### 5.9 Consulta 9: Recomendación de restaurantes a un usuario

#### Objetivo

Recomendar restaurantes a un usuario específico tomando como base restaurantes que calificó positivamente, chefs compartidos y restaurantes que aún no ha visitado. Esta consulta representa la funcionalidad principal del sistema de recomendación.

#### Entidades involucradas

| Entidad | Descripción |
| --- | --- |
| `Usuario` | Persona a quien se le genera la recomendación. |
| `Restaurante` | Establecimiento evaluado como posible recomendación. |
| `Chef` | Profesional culinario que conecta restaurantes entre sí. |
| `TipoCocina` | Categoría gastronómica del restaurante recomendado. |

#### Relaciones involucradas

| Relación | Descripción |
| --- | --- |
| `CALIFICÓ` | Relación donde un usuario califica un restaurante. |
| `VISITÓ` | Relación usada para evitar recomendar restaurantes ya visitados. |
| `TRABAJA_EN` | Relación que conecta chefs con restaurantes. |
| `PERTENECE_A` | Relación que identifica el tipo de cocina del restaurante. |

#### Parámetros utilizados

| Parámetro | Valor utilizado | Descripción |
| --- | --- | --- |
| `id_usuario` | `137` | Usuario al que se le generan recomendaciones. |
| `puntuacion_minima` | `4` | Calificación mínima para considerar un restaurante como referencia positiva. |

#### Código Cypher

```cypher
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
```

#### Explicación

La consulta inicia seleccionando un usuario específico mediante su identificador numérico. Luego busca los restaurantes que ese usuario calificó con una puntuación igual o mayor a 4. Estos restaurantes se consideran referencias positivas.

A partir de esos restaurantes, se identifican los chefs que trabajan en ellos. Luego se buscan otros restaurantes donde también trabajen esos chefs. Estos restaurantes se consideran candidatos a recomendación porque comparten chefs con restaurantes que el usuario valoró positivamente.

Para evitar recomendar restaurantes repetidos, se utiliza `NOT EXISTS`, verificando que el usuario no haya visitado previamente el restaurante candidato. También se agregan datos complementarios como tipos de cocina y promedio de calificación general.

#### Resultado esperado

Se espera obtener un listado de restaurantes recomendados para el usuario, mostrando restaurante recomendado, rango de precios, chefs compartidos, restaurantes base, tipos de cocina, coincidencias de chefs y promedio de calificación.

#### Interpretación

Esta consulta demuestra el uso de Neo4j como base de datos orientada a grafos, ya que la recomendación no se basa únicamente en datos aislados, sino en conexiones entre usuarios, restaurantes y chefs. El sistema puede sugerir restaurantes que tienen relación indirecta con lugares que el usuario ya calificó positivamente.

#### Evidencia

![Consulta 9 - Recomendación de restaurantes](image/5.9.png)


## 6. Análisis de red

En esta sección se documentan los análisis de red implementados en el proyecto. Estos análisis permiten aprovechar la estructura de grafo de Neo4j para recorrer relaciones entre usuarios, restaurantes, chefs y platillos.

Los análisis implementados fueron:

| No. | Análisis | Descripción |
|---|---|---|
| 1 | Restaurantes altamente conectados | Identifica restaurantes con mayor cantidad de conexiones relevantes |
| 2 | Ruta más corta entre usuarios | Calcula los grados de separación entre usuarios mediante relaciones de amistad |

---

### 6.1 Análisis 1: Restaurantes altamente conectados

#### Objetivo

Identificar los restaurantes con mayor nivel de conectividad dentro del grafo, considerando chefs asociados, platillos ofrecidos, tipos de cocina, visitas y calificaciones recibidas.

#### Entidades involucradas

| Entidad | Descripción |
|---|---|
| `Restaurante` | Nodo principal del análisis |
| `Chef` | Chef que trabaja en un restaurante |
| `Platillo` | Platillo ofrecido por un restaurante |
| `TipoCocina` | Categoría gastronómica del restaurante |
| `Usuario` | Usuario que visita o califica restaurantes |

#### Relaciones involucradas

| Relación | Descripción |
|---|---|
| `TRABAJA_EN` | Conecta chefs con restaurantes |
| `OFRECE` | Conecta restaurantes con platillos |
| `PERTENECE_A` | Conecta restaurantes con tipos de cocina |
| `VISITÓ` | Conecta usuarios con restaurantes visitados |
| `CALIFICÓ` | Conecta usuarios con restaurantes calificados |

#### Código Cypher

```cypher
MATCH (r:Restaurante)

OPTIONAL MATCH (c:Chef)-[:TRABAJA_EN]->(r)
WITH r, count(DISTINCT c) AS total_chefs

OPTIONAL MATCH (r)-[:OFRECE]->(p:Platillo)
WITH r, total_chefs, count(DISTINCT p) AS total_platillos

OPTIONAL MATCH (r)-[:PERTENECE_A]->(t:TipoCocina)
WITH r, total_chefs, total_platillos, count(DISTINCT t) AS total_tipos_cocina

OPTIONAL MATCH ()-[:VISITÓ]->(r)
WITH r, total_chefs, total_platillos, total_tipos_cocina, count(*) AS total_visitas

OPTIONAL MATCH ()-[cal:CALIFICÓ]->(r)
WITH
    r,
    total_chefs,
    total_platillos,
    total_tipos_cocina,
    total_visitas,
    count(cal) AS total_calificaciones,
    avg(cal.puntuacion) AS promedio_calificacion

RETURN
    r.id_restaurante AS id_restaurante,
    r.nombre AS restaurante,
    r.rango_precios AS precio,
    total_chefs,
    total_platillos,
    total_tipos_cocina,
    total_visitas,
    total_calificaciones,
    round(coalesce(promedio_calificacion, 0) * 100) / 100 AS promedio_calificacion,
    total_chefs + total_platillos + total_tipos_cocina + total_visitas + total_calificaciones AS score_conectividad
ORDER BY score_conectividad DESC
LIMIT 50;
```

Grafo de consulta:

```cypher
MATCH path =
(c:Chef)-[:TRABAJA_EN]->(r:Restaurante)-[:OFRECE]->(p:Platillo)
WHERE r.id_restaurante IN [1, 2, 3, 4, 5]
RETURN path
LIMIT 50;
```

#### Resultado esperado

Se espera obtener un ranking de restaurantes ordenados por su nivel de conectividad. El score de conectividad se calcula sumando chefs, platillos, tipos de cocina, visitas y calificaciones asociadas al restaurante.

### Interpretación

Un restaurante con mayor score de conectividad tiene más relaciones dentro del grafo. Esto significa que está más conectado con chefs, platillos, tipos de cocina y actividad de usuarios. Este análisis permite identificar restaurantes relevantes dentro de la red gastronómica.

#### Evidencia

![Analisis 1 - Restaurantes altamente Conectados](image/6.1.png)

![Analisis 1 - Grafo](<image/6.1 grafo.png>)

### 6.2 Análisis 2: Ruta más corta entre usuarios

#### Objetivo

Calcular la ruta más corta entre dos usuarios a partir de las relaciones de amistad existentes en el grafo. Este análisis permite conocer los grados de separación entre usuarios dentro de la red social del sistema.

#### Entidades involucradas

| Entidad | Descripción |
|---|---|
| `Usuario` | Nodo que representa a una persona registrada en la plataforma. |

#### Relaciones involucradas

| Relación | Descripción |
|---|---|
| `ES_AMIGO_DE` | Relación de amistad entre dos usuarios. |

#### Parámetros utilizados

| Parámetro | Valor utilizado | Descripción |
|---|---:|---|
| `usuario_origen` | 28 | Usuario desde donde inicia la búsqueda. |
| `usuario_destino` | 24 | Usuario objetivo de la búsqueda. |

#### Código Cypher

```cypher
WITH 28 AS usuario_origen,
     24 AS usuario_destino

MATCH (origen:Usuario {id_usuario: usuario_origen})
MATCH (destino:Usuario {id_usuario: usuario_destino})

MATCH path = shortestPath(
    (origen)-[:ES_AMIGO_DE*..6]-(destino)
)

RETURN
    origen.id_usuario AS usuario_origen,
    destino.id_usuario AS usuario_destino,
    length(path) AS grados_separacion,
    [n IN nodes(path) | n.nombre] AS usuarios_en_ruta,
    path;
```

#### Explicación

La consulta selecciona un usuario origen y un usuario destino mediante su propiedad `id_usuario`. Luego utiliza la función `shortestPath()` para encontrar el camino más corto entre ambos usuarios a través de relaciones `ES_AMIGO_DE`.

El patrón `[:ES_AMIGO_DE*..6]` permite buscar rutas de amistad con una profundidad máxima de seis niveles. Esto evita recorridos demasiado extensos y mantiene el análisis controlado.

La consulta devuelve los identificadores de los usuarios evaluados, la cantidad de grados de separación, los nombres de los usuarios que forman parte de la ruta y el camino completo para visualizarlo como grafo en Neo4j Browser.

#### Resultado esperado

Se espera obtener la ruta más corta entre dos usuarios conectados por relaciones de amistad. El resultado debe mostrar los grados de separación y los usuarios intermedios que conectan al usuario origen con el usuario destino.

#### Interpretación

Este análisis permite observar la conectividad social dentro del sistema. Si dos usuarios están conectados por pocos grados de separación, significa que pertenecen a una red cercana de amistad. Esta información puede ser útil para futuras recomendaciones basadas en amigos, comportamiento social o patrones de consumo similares.

#### Evidencia

![Análisis 2_ Ruta más corta entre usuario](image/6.2.png)
---

## 7. Script Cypher de creación del esquema

Neo4j no utiliza un esquema rígido como una base de datos relacional tradicional. Sin embargo, permite definir restricciones e índices para garantizar integridad de datos y mejorar el rendimiento de las consultas.

En este proyecto, el esquema se estableció mediante constraints e índices sobre las propiedades identificadoras de los nodos principales. Esto permite evitar duplicados durante la carga masiva y optimizar las búsquedas realizadas con `MATCH` y `MERGE`.

### 7.1 Constraints de unicidad

Las restricciones de unicidad se aplican sobre las propiedades que identifican de forma única a los nodos principales del grafo. Estas restricciones permiten evitar registros duplicados y garantizan la integridad de los datos al momento de realizar cargas masivas o crear nuevos nodos mediante Cypher.

En la base de datos Neo4j del proyecto se definieron los siguientes constraints de unicidad:

```cypher
CREATE CONSTRAINT usuario_id_unico IF NOT EXISTS
FOR (u:Usuario)
REQUIRE u.id_usuario IS UNIQUE;

CREATE CONSTRAINT usuario_email_unico IF NOT EXISTS
FOR (u:Usuario)
REQUIRE u.email IS UNIQUE;

CREATE CONSTRAINT restaurante_id_unico IF NOT EXISTS
FOR (r:Restaurante)
REQUIRE r.id_restaurante IS UNIQUE;

CREATE CONSTRAINT chef_id_unico IF NOT EXISTS
FOR (c:Chef)
REQUIRE c.id_chef IS UNIQUE;

CREATE CONSTRAINT platillo_id_unico IF NOT EXISTS
FOR (p:Platillo)
REQUIRE p.id_platillo IS UNIQUE;

CREATE CONSTRAINT tipococina_id_unico IF NOT EXISTS
FOR (t:TipoCocina)
REQUIRE t.id_tipo_cocina IS UNIQUE;
```

### 7.2 Índices utilizados

Los índices permiten mejorar el rendimiento de las búsquedas por propiedades utilizadas frecuentemente en las consultas Cypher. En Neo4j, los constraints de unicidad generan automáticamente índices asociados para las propiedades únicas, por lo que también aparecen dentro del listado de índices de la base de datos.

Además de los índices asociados a constraints, se crearon índices explícitos para acelerar búsquedas por nombre en entidades consultadas frecuentemente.

```cypher
CREATE INDEX restaurante_nombre_idx IF NOT EXISTS
FOR (r:Restaurante)
ON (r.nombre);

CREATE INDEX chef_nombre_idx IF NOT EXISTS
FOR (c:Chef)
ON (c.nombre);

CREATE INDEX tipococina_nombre_idx IF NOT EXISTS
FOR (t:TipoCocina)
ON (t.nombre);
```

### 7.3 Justificación técnica

Las restricciones de unicidad permiten evitar que existan nodos duplicados con el mismo identificador. Esto es importante porque la carga masiva utiliza `MERGE`, y dicha instrucción depende de los identificadores para determinar si un nodo ya existe o si debe ser creado.

Los índices permiten mejorar el rendimiento de búsquedas por propiedades frecuentes como nombre, email o identificador. Esto resulta útil durante la ejecución de consultas Cypher y durante la creación de relaciones, ya que los scripts de carga utilizan `MATCH` para localizar nodos existentes.

### 7.4 Validación de constraints e índices

Para validar que las restricciones e índices fueron creados correctamente se utilizaron las siguientes instrucciones:

```cypher
SHOW CONSTRAINTS;
```

```cypher
SHOW INDEXES;
```

#### Resultado esperado

Se espera visualizar las restricciones de unicidad creadas para los nodos `Usuario`, `Restaurante`, `Chef`, `Platillo` y `TipoCocina`, así como los índices definidos para optimizar búsquedas por nombre.

#### Evidencia

![Constraints](image/CONSTRAINTS.png)

![Índices](image/INDEXES.png)
---

## 8. Ventajas de utilizar Neo4j para este problema

Neo4j fue seleccionado como motor de base de datos debido a que el problema planteado se basa principalmente en relaciones entre entidades. En un sistema de recomendación de restaurantes, las conexiones entre usuarios, restaurantes, chefs, platillos y tipos de cocina son tan importantes como los datos individuales de cada entidad.

### 8.1 Modelado natural de relaciones

Neo4j permite representar el dominio del problema de forma natural mediante nodos y relaciones. Por ejemplo, un usuario puede visitar restaurantes, calificarlos, tener amigos y mostrar preferencia por tipos de cocina. Estas interacciones se representan directamente como relaciones del grafo.

Ejemplos de relaciones del modelo:

```cypher
(:Usuario)-[:VISITÓ]->(:Restaurante)
(:Usuario)-[:CALIFICÓ]->(:Restaurante)
(:Usuario)-[:ES_AMIGO_DE]->(:Usuario)
(:Chef)-[:TRABAJA_EN]->(:Restaurante)
(:Restaurante)-[:OFRECE]->(:Platillo)
(:Restaurante)-[:PERTENECE_A]->(:TipoCocina)
```

Este modelo resulta más intuitivo que una estructura relacional tradicional con múltiples tablas intermedias, ya que las relaciones se almacenan como elementos principales del grafo.

### 8.2 Consultas eficientes sobre relaciones

Cypher permite recorrer relaciones de forma directa mediante patrones. Esto facilita consultas como recomendaciones basadas en chefs compartidos, rutas más cortas entre usuarios y análisis de restaurantes conectados.

Por ejemplo, la recomendación de restaurantes se obtiene recorriendo el siguiente patrón:

```cypher
(Usuario)-[:CALIFICÓ]->(Restaurante)<-[:TRABAJA_EN]-(Chef)-[:TRABAJA_EN]->(Restaurante)
```

En una base de datos relacional, este análisis requeriría múltiples operaciones `JOIN`. En Neo4j, el recorrido se expresa de manera directa mediante relaciones.

### 8.3 Facilidad para sistemas de recomendación

El sistema de recomendación se beneficia del modelo de grafos porque las recomendaciones dependen de conexiones indirectas. En este proyecto, un restaurante puede ser recomendado porque comparte chefs con restaurantes bien valorados por el usuario y porque todavía no ha sido visitado.

Esto permite generar recomendaciones más inteligentes, basadas en patrones de relación y no únicamente en atributos aislados.

### 8.4 Análisis de redes

Neo4j permite aplicar análisis propios de grafos, como la ruta más corta entre usuarios. Esto permite medir grados de separación dentro de la red social del sistema.

También permite identificar restaurantes altamente conectados considerando chefs, platillos, visitas, calificaciones y tipos de cocina relacionados.

### 8.5 Flexibilidad del modelo

El modelo de grafos puede ampliarse fácilmente. Por ejemplo, en futuras versiones podrían agregarse nuevos nodos como `Ciudad`, `Reserva`, `Promocion` o `EventoGastronomico`, sin necesidad de rediseñar completamente la base de datos.

También podrían agregarse nuevas relaciones como:

```cypher
(:Usuario)-[:RESERVÓ]->(:Restaurante)
(:Restaurante)-[:UBICADO_EN]->(:Ciudad)
(:Usuario)-[:RECIBIÓ]->(:Promocion)
```

Esto demuestra que Neo4j permite extender el modelo de forma flexible sin afectar la estructura principal del grafo.

### 8.6 Conclusión técnica

Neo4j es adecuado para este proyecto porque permite representar relaciones complejas de forma clara, realizar recorridos eficientes sobre el grafo y construir consultas de recomendación basadas en conexiones entre entidades.

El sistema desarrollado aprovecha las ventajas de las bases de datos de grafos para analizar usuarios, restaurantes, chefs, platillos, tipos de cocina, visitas, calificaciones y amistades. Por esta razón, Neo4j representa una opción apropiada para sistemas donde las relaciones son el componente principal del análisis.

---

## 9. Estructura del repositorio

El proyecto fue organizado en carpetas separadas para facilitar la revisión, ejecución y mantenimiento de los archivos utilizados en Neo4j.

```text
BD2_VACJUN26_Proyectos_G13/
└── Segundo Proyecto/
    ├── README.md
    ├── data/
    │   ├── usuarios.csv
    │   ├── restaurantes.csv
    │   ├── chefs.csv
    │   ├── platillos.csv
    │   ├── tipos_cocina.csv
    │   ├── califico.csv
    │   ├── visito.csv
    │   ├── amistades.csv
    │   ├── pertenece_a.csv
    │   ├── ofrece.csv
    │   ├── prepara.csv
    │   ├── trabaja_en.csv
    │   └── le_gusta.csv
    ├── scripts/
    │   ├── 01_constraints_indices.cypher
    │   ├── 04_load_nodes.cypher
    │   ├── 05_load_relationships.cypher
    │   ├── 06_validacion_carga.cypher
    │   ├── consultas_integrante_1.cypher
    │   ├── consultas_integrante_2.cypher
    │   ├── consultas_integrante_3.cypher
    │   ├── restaurantes_conectados.cypher
    │   └── ruta_mas_corta.cypher
    ├── documentacion/
    │   ├── Manual_Tecnico.md
    │   ├── Manual_Usuario.md
    │   ├── Diagrama_Modelo_Grafos.png
    │   └── image/
    └── src/
        └── generar_datos.py
```

## 10. Conclusiones

El uso de Neo4j permitió representar de forma natural las relaciones entre usuarios, restaurantes, chefs, platillos y tipos de cocina, facilitando la construcción de un sistema de recomendación basado en conexiones reales del grafo.

La carga masiva mediante archivos CSV permitió insertar una cantidad considerable de datos de prueba, cumpliendo con los mínimos requeridos para usuarios, restaurantes, chefs, platillos y tipos de cocina. Además, las validaciones realizadas confirmaron que los nodos y relaciones fueron cargados correctamente.

Las consultas Cypher desarrolladas permitieron analizar distintos aspectos del negocio, como diversidad gastronómica, reservas, frecuencia de visitas, gasto promedio, movilidad de chefs, variación de precios y crecimiento de visitas por tipo de cocina.

Los análisis de red demostraron una de las principales ventajas de Neo4j, ya que fue posible calcular rutas más cortas entre usuarios e identificar restaurantes altamente conectados mediante recorridos directos sobre las relaciones del grafo.

En conclusión, Neo4j resultó adecuado para este proyecto porque permite consultar relaciones complejas de forma clara, eficiente y flexible, especialmente en escenarios donde las recomendaciones dependen de conexiones indirectas entre entidades.


## 11. Aporte del equipo

El desarrollo del proyecto fue dividido de acuerdo con las responsabilidades técnicas necesarias para implementar correctamente el sistema de recomendación de restaurantes en Neo4j. Cada integrante aportó en una parte específica del proyecto, permitiendo cubrir el modelado del grafo, la carga masiva de datos, la implementación de consultas Cypher, el análisis de redes y la documentación final.

### 11.1 Aporte de Daniel Estuardo Salvatierra

El aporte de Daniel Estuardo Salvatierra se enfocó en el modelado de grafos, la definición de la estructura base de la base de datos y la implementación de consultas estructurales dentro del proyecto de restaurantes en Neo4j.

Su trabajo consistió en diseñar el modelo conceptual del grafo, definiendo los nodos principales del sistema: `Usuario`, `Restaurante`, `TipoCocina`, `Chef` y `Platillo`. Además, se establecieron las relaciones necesarias entre dichas entidades, tales como `CALIFICÓ`, `VISITÓ`, `ES_AMIGO_DE`, `PERTENECE_A`, `OFRECE`, `PREPARA`, `TRABAJA_EN` y `LE_GUSTA`, tomando en cuenta sus direcciones, propiedades y reglas de negocio.

También se encargó de la creación de constraints e índices en Neo4j, con el objetivo de garantizar la integridad de los datos y mejorar el rendimiento de las búsquedas. Estas restricciones permiten evitar duplicados en identificadores importantes como usuarios, restaurantes, chefs, platillos y tipos de cocina.

Dentro de sus consultas asignadas se desarrollaron análisis relacionados con la diversidad de tipos de cocina por restaurante, la movilidad laboral de chefs y la variación de precios de platillos entre restaurantes. Asimismo, se trabajó en el análisis de restaurantes altamente conectados, evaluando la cantidad de chefs, platillos y relaciones relevantes asociadas a cada restaurante.

Este aporte fue fundamental para que el resto del proyecto pudiera construirse correctamente, ya que el modelo de grafos define la base sobre la cual se realizan la carga de datos, las consultas analíticas, las recomendaciones y los análisis de red.

### 11.2 Aporte de Daniel Alejandro Castellanos Rodriguez

El aporte de Daniel Alejandro Castellanos Rodriguez se enfocó en la generación de datos, estructura de archivos CSV, carga masiva de información y validación de datos dentro de la base de datos Neo4j.

Su trabajo consistió en preparar los archivos necesarios para cargar los nodos principales del sistema, incluyendo usuarios, restaurantes, chefs, platillos y tipos de cocina. También se trabajó en los archivos correspondientes a las relaciones del modelo, tales como visitas, calificaciones, amistades, preferencias de cocina, ofertas de platillos, preparación de platillos y relaciones laborales entre chefs y restaurantes.

Además, se implementaron scripts de carga masiva utilizando `LOAD CSV`, aplicando `MERGE` para evitar la creación de nodos duplicados y asegurar que las relaciones se conectaran correctamente con nodos existentes. Esta parte fue importante para cumplir con las cantidades mínimas solicitadas en el proyecto: 500 usuarios, 200 restaurantes, 100 chefs, 50 platillos y 15 tipos de cocina.

También se realizaron validaciones de carga mediante consultas Cypher, verificando el total de nodos y relaciones insertadas. Estas validaciones permitieron comprobar que los datos fueron cargados correctamente y que el grafo contaba con suficiente información para ejecutar las consultas del sistema.

Dentro de sus consultas asignadas se desarrollaron análisis relacionados con la tasa de reservas por restaurante, los usuarios con mayor gasto promedio por visita y los usuarios con mayor frecuencia de visitas en un periodo determinado.

Este aporte permitió que la base de datos contara con datos coherentes, completos y suficientes para validar el funcionamiento del sistema de recomendación y de las consultas analíticas implementadas.

### 11.3 Aporte de Carlos Fernando Matta Peña

El aporte del Carlos Fernando Matta Peña se enfocó en la construcción de consultas analíticas, sistema de recomendación y análisis de red dentro del proyecto de restaurantes en Neo4j.

Las consultas desarrolladas permiten detectar restaurantes sin visitas recientes, analizar el crecimiento de visitas por tipo de cocina y recomendar restaurantes a usuarios específicos utilizando relaciones del grafo. Además, se implementó un análisis de ruta más corta entre usuarios, con el objetivo de evaluar la conectividad social dentro del sistema.

Este aporte contribuye directamente al objetivo principal del proyecto, ya que demuestra cómo Neo4j permite analizar relaciones complejas entre usuarios, restaurantes, chefs, visitas, calificaciones y tipos de cocina. A diferencia de un modelo relacional tradicional, el enfoque basado en grafos facilita recorrer conexiones indirectas y encontrar patrones útiles para recomendaciones.

### 11.4 Aporte general del equipo

De forma conjunta, el equipo logró construir una base de datos de grafos funcional en Neo4j para representar un sistema de recomendación de restaurantes. El trabajo se organizó en tres áreas principales: modelado del grafo, carga masiva de datos y consultas de análisis/recomendación.

El equipo aplicó correctamente conceptos de bases de datos orientadas a grafos, utilizando nodos, relaciones, propiedades, constraints, índices y consultas Cypher. Además, se documentaron los resultados obtenidos, permitiendo evidenciar el funcionamiento del sistema y la utilidad de Neo4j para resolver problemas donde las relaciones entre entidades son un elemento central.

El aporte colaborativo permitió cumplir con los requerimientos principales del proyecto, incluyendo la implementación del modelo, la carga de datos, las consultas obligatorias, los análisis de red y la documentación técnica correspondiente.