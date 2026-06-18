// CONSTRAINTS son el equivalente a llave primaria

// Usuario
CREATE CONSTRAINT usuario_id_unico IF NOT EXISTS
FOR (u:Usuario) REQUIRE u.id_usuario IS UNIQUE;

// Email unico por usuario
CREATE CONSTRAINT usuario_email_unico IF NOT EXISTS
FOR (u:Usuario) REQUIRE u.email IS UNIQUE;

// Restaurante
CREATE CONSTRAINT restaurante_id_unico IF NOT EXISTS
FOR (r:Restaurante) REQUIRE r.id_restaurante IS UNIQUE;

// TipoCocina
CREATE CONSTRAINT tipococina_id_unico IF NOT EXISTS
FOR (t:TipoCocina) REQUIRE t.id_tipo_cocina IS UNIQUE;

// Chef
CREATE CONSTRAINT chef_id_unico IF NOT EXISTS
FOR (c:Chef) REQUIRE c.id_chef IS UNIQUE;

// Platillo
CREATE CONSTRAINT platillo_id_unico IF NOT EXISTS
FOR (p:Platillo) REQUIRE p.id_platillo IS UNIQUE;

// Buscar tipos de cocina por nombre
CREATE INDEX tipococina_nombre_idx IF NOT EXISTS
FOR (t:TipoCocina) ON (t.nombre);

// Buscar restaurantes por nombre
CREATE INDEX restaurante_nombre_idx IF NOT EXISTS
FOR (r:Restaurante) ON (r.nombre);

// Buscar chefs por nombre
CREATE INDEX chef_nombre_idx IF NOT EXISTS
FOR (c:Chef) ON (c.nombre);