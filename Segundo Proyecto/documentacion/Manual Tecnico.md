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