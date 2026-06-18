// Datos de prueba comentar depues porque no se usaran sino los csvs

//  NODOS: TipoCocina 
CREATE (:TipoCocina {
  id_tipo_cocina: "T0001",
  nombre: "Italiana",
  descripcion: "Cocina tradicional italiana, pasta, pizza y más."
});

CREATE (:TipoCocina {
  id_tipo_cocina: "T0002",
  nombre: "Japonesa",
  descripcion: "Cocina japonesa, sushi, ramen y tempura."
});

CREATE (:TipoCocina {
  id_tipo_cocina: "T0003",
  nombre: "Mexicana",
  descripcion: "Cocina mexicana, tacos, enchiladas y mole."
});

//  NODOS: Restaurante 
CREATE (:Restaurante {
  id_restaurante: "R0001",
  nombre: "La Trattoria",
  anio_apertura: 2010,
  rango_precios: "$$",
  descripcion: "Restaurante italiano tradicional en el centro."
});

CREATE (:Restaurante {
  id_restaurante: "R0002",
  nombre: "Sakura Sushi",
  anio_apertura: 2015,
  rango_precios: "$$$",
  descripcion: "Auténtica experiencia japonesa con ingredientes importados."
});

CREATE (:Restaurante {
  id_restaurante: "R0003",
  nombre: "El Comal",
  anio_apertura: 2008,
  rango_precios: "$",
  descripcion: "Sabores mexicanos caseros en ambiente familiar."
});

//  NODOS: Chef 
CREATE (:Chef {
  id_chef: "C0001",
  nombre: "Marco Rossi",
  fecha_nacimiento: date("1978-03-15"),
  nacionalidad: "Italiana"
});

CREATE (:Chef {
  id_chef: "C0002",
  nombre: "Yuki Tanaka",
  fecha_nacimiento: date("1985-07-22"),
  nacionalidad: "Japonesa"
});

CREATE (:Chef {
  id_chef: "C0003",
  nombre: "Carlos Mendoza",
  fecha_nacimiento: date("1980-11-05"),
  nacionalidad: "Mexicana"
});

//  NODOS: Platillo 
CREATE (:Platillo {
  id_platillo: "P0001",
  nombre: "Carbonara",
  precio: 85.00,
  descripcion: "Pasta con huevo, queso pecorino y guanciale."
});

CREATE (:Platillo {
  id_platillo: "P0002",
  nombre: "Salmón Nigiri",
  precio: 120.00,
  descripcion: "Nigiri de salmón fresco sobre arroz de sushi."
});

CREATE (:Platillo {
  id_platillo: "P0003",
  nombre: "Tacos de Barbacoa",
  precio: 45.00,
  descripcion: "Tacos de barbacoa de res con cebolla y cilantro."
});

//  NODOS: Usuario 
CREATE (:Usuario {
  id_usuario: "U0001",
  nombre: "Ana García",
  email: "ana.garcia@email.com",
  edad: 28,
  pais: "Guatemala"
});

CREATE (:Usuario {
  id_usuario: "U0002",
  nombre: "Pedro López",
  email: "pedro.lopez@email.com",
  edad: 35,
  pais: "Guatemala"
});

CREATE (:Usuario {
  id_usuario: "U0003",
  nombre: "María Martínez",
  email: "maria.martinez@email.com",
  edad: 24,
  pais: "México"
});



// Conexiones entre nodos

//  PERTENECE_A: Restaurante -> TipoCocina 
MATCH (r:Restaurante {id_restaurante: "R0001"}), (t:TipoCocina {id_tipo_cocina: "T0001"})
CREATE (r)-[:PERTENECE_A]->(t);

MATCH (r:Restaurante {id_restaurante: "R0002"}), (t:TipoCocina {id_tipo_cocina: "T0002"})
CREATE (r)-[:PERTENECE_A]->(t);

MATCH (r:Restaurante {id_restaurante: "R0003"}), (t:TipoCocina {id_tipo_cocina: "T0003"})
CREATE (r)-[:PERTENECE_A]->(t);

// R0001 también pertenece a T0003 (restaurante con dos tipos de cocina)
// Esto sirve para probar la consulta de diversidad de cocina
MATCH (r:Restaurante {id_restaurante: "R0001"}), (t:TipoCocina {id_tipo_cocina: "T0003"})
CREATE (r)-[:PERTENECE_A]->(t);

//  TRABAJA_EN: Chef -> Restaurante 
MATCH (c:Chef {id_chef: "C0001"}), (r:Restaurante {id_restaurante: "R0001"})
CREATE (c)-[:TRABAJA_EN {fecha_inicio: date("2010-01-15"), puesto: "Chef Ejecutivo"}]->(r);

MATCH (c:Chef {id_chef: "C0002"}), (r:Restaurante {id_restaurante: "R0002"})
CREATE (c)-[:TRABAJA_EN {fecha_inicio: date("2015-06-01"), puesto: "Chef Principal"}]->(r);

MATCH (c:Chef {id_chef: "C0003"}), (r:Restaurante {id_restaurante: "R0003"})
CREATE (c)-[:TRABAJA_EN {fecha_inicio: date("2008-03-10"), puesto: "Chef Ejecutivo"}]->(r);

// C0001 también trabajó en R0002 (chef con movilidad laboral)
// Esto sirve para probar la consulta de movilidad de chefs
MATCH (c:Chef {id_chef: "C0001"}), (r:Restaurante {id_restaurante: "R0002"})
CREATE (c)-[:TRABAJA_EN {fecha_inicio: date("2018-09-01"), puesto: "Chef Invitado"}]->(r);

//  OFRECE: Restaurante -> Platillo 
MATCH (r:Restaurante {id_restaurante: "R0001"}), (p:Platillo {id_platillo: "P0001"})
CREATE (r)-[:OFRECE {precio: 90.00, disponible: true}]->(p);

MATCH (r:Restaurante {id_restaurante: "R0002"}), (p:Platillo {id_platillo: "P0002"})
CREATE (r)-[:OFRECE {precio: 135.00, disponible: true}]->(p);

MATCH (r:Restaurante {id_restaurante: "R0003"}), (p:Platillo {id_platillo: "P0003"})
CREATE (r)-[:OFRECE {precio: 45.00, disponible: true}]->(p);

// R0002 también ofrece P0001 pero a precio diferente
// Esto sirve para probar la consulta de variación de precio entre restaurantes
MATCH (r:Restaurante {id_restaurante: "R0002"}), (p:Platillo {id_platillo: "P0001"})
CREATE (r)-[:OFRECE {precio: 110.00, disponible: true}]->(p);

//  PREPARA: Chef -> Platillo 
MATCH (c:Chef {id_chef: "C0001"}), (p:Platillo {id_platillo: "P0001"})
CREATE (c)-[:PREPARA {estilo: "Tradicional", especialidad: "Pasta"}]->(p);

MATCH (c:Chef {id_chef: "C0002"}), (p:Platillo {id_platillo: "P0002"})
CREATE (c)-[:PREPARA {estilo: "Clásico", especialidad: "Sushi"}]->(p);

MATCH (c:Chef {id_chef: "C0003"}), (p:Platillo {id_platillo: "P0003"})
CREATE (c)-[:PREPARA {estilo: "Casero", especialidad: "Tacos"}]->(p);

//  CALIFICÓ: Usuario -> Restaurante 
MATCH (u:Usuario {id_usuario: "U0001"}), (r:Restaurante {id_restaurante: "R0001"})
CREATE (u)-[:CALIFICÓ {puntuacion: 5, fecha: date("2026-01-10"), comentario: "Excelente pasta, muy auténtica."}]->(r);

MATCH (u:Usuario {id_usuario: "U0001"}), (r:Restaurante {id_restaurante: "R0002"})
CREATE (u)-[:CALIFICÓ {puntuacion: 4, fecha: date("2026-02-14"), comentario: "Buen sushi, ambiente agradable."}]->(r);

MATCH (u:Usuario {id_usuario: "U0002"}), (r:Restaurante {id_restaurante: "R0001"})
CREATE (u)-[:CALIFICÓ {puntuacion: 3, fecha: date("2026-03-05"), comentario: "Buena comida pero servicio lento."}]->(r);

MATCH (u:Usuario {id_usuario: "U0003"}), (r:Restaurante {id_restaurante: "R0003"})
CREATE (u)-[:CALIFICÓ {puntuacion: 5, fecha: date("2026-01-20"), comentario: "Los mejores tacos que he probado."}]->(r);

//  VISITÓ: Usuario -> Restaurante 
MATCH (u:Usuario {id_usuario: "U0001"}), (r:Restaurante {id_restaurante: "R0001"})
CREATE (u)-[:VISITÓ {fecha_visita: date("2026-01-10"), consumo: 180.00, con_reserva: true}]->(r);

MATCH (u:Usuario {id_usuario: "U0001"}), (r:Restaurante {id_restaurante: "R0002"})
CREATE (u)-[:VISITÓ {fecha_visita: date("2026-02-14"), consumo: 320.00, con_reserva: true}]->(r);

MATCH (u:Usuario {id_usuario: "U0002"}), (r:Restaurante {id_restaurante: "R0001"})
CREATE (u)-[:VISITÓ {fecha_visita: date("2026-03-05"), consumo: 95.00, con_reserva: false}]->(r);

MATCH (u:Usuario {id_usuario: "U0003"}), (r:Restaurante {id_restaurante: "R0003"})
CREATE (u)-[:VISITÓ {fecha_visita: date("2026-01-20"), consumo: 60.00, con_reserva: false}]->(r);

//  ES_AMIGO_DE: Usuario -> Usuario 
MATCH (u1:Usuario {id_usuario: "U0001"}), (u2:Usuario {id_usuario: "U0002"})
CREATE (u1)-[:ES_AMIGO_DE {fecha_amistad: date("2024-05-01")}]->(u2);

MATCH (u1:Usuario {id_usuario: "U0002"}), (u2:Usuario {id_usuario: "U0003"})
CREATE (u1)-[:ES_AMIGO_DE {fecha_amistad: date("2025-01-15")}]->(u2);

//  LE_GUSTA: Usuario -> TipoCocina 
MATCH (u:Usuario {id_usuario: "U0001"}), (t:TipoCocina {id_tipo_cocina: "T0001"})
CREATE (u)-[:LE_GUSTA {nivel_interes: 5}]->(t);

MATCH (u:Usuario {id_usuario: "U0001"}), (t:TipoCocina {id_tipo_cocina: "T0002"})
CREATE (u)-[:LE_GUSTA {nivel_interes: 4}]->(t);

MATCH (u:Usuario {id_usuario: "U0002"}), (t:TipoCocina {id_tipo_cocina: "T0003"})
CREATE (u)-[:LE_GUSTA {nivel_interes: 3}]->(t);

MATCH (u:Usuario {id_usuario: "U0003"}), (t:TipoCocina {id_tipo_cocina: "T0003"})
CREATE (u)-[:LE_GUSTA {nivel_interes: 5}]->(t);