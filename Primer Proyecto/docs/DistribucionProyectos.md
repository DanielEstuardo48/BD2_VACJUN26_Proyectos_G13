# Informe de Distribución de Trabajo
## Proyecto 1 – Transformación de Información
### Sistemas de Bases de Datos 2

**Universidad de San Carlos de Guatemala**  
**Facultad de Ingeniería**  
**Ingeniería en Ciencias y Sistemas**  

**Grupo 13**

---

## Objetivo del Informe

El presente informe tiene como finalidad documentar la distribución de tareas realizada entre los integrantes del grupo para el desarrollo del Proyecto 1, asegurando una participación equitativa en las diferentes fases del proyecto, incluyendo análisis, diseño, implementación, migración de datos, desarrollo de procedimientos almacenados, documentación y administración de la base de datos.

---

# Integrante 1

## Daniel Estuardo Salvatierra Macajola
### Carné: 202202768

### Actividades realizadas

#### Diseño e implementación de la base de datos

- Diseño inicial del modelo relacional de la base de datos bancaria.
- Elaboración del archivo DDL para la creación de todas las tablas del sistema.
- Definición de claves primarias, claves foráneas y restricciones de integridad.
- Implementación de las relaciones entre entidades del modelo bancario.

#### Migración de datos

- Desarrollo del script de migración utilizando Python.
- Lectura de los archivos CSV proporcionados.
- Limpieza y transformación de datos.
- Eliminación de registros duplicados.
- Inserción de la información en las tablas normalizadas.
- Validación de la integridad referencial durante el proceso de carga.

#### Desarrollo de procedimientos almacenados

Implementación de los siguientes procedimientos:

- `SP_RegistrarCliente`
- `SP_ActualizarCliente`
- `SP_AbrirCuenta`

#### Documentación técnica

- Elaboración de la descripción del proceso de normalización.
- Desarrollo del análisis de Primera Forma Normal (1FN).
- Desarrollo del análisis de Segunda Forma Normal (2FN).
- Desarrollo del análisis de Tercera Forma Normal (3FN).
- Elaboración del diccionario de datos.
- Creación del diagrama Entidad-Relación (ER).
- Documentación de las relaciones entre entidades.

### Entregables generados

- `sql/ddl/01_crear_tablas.sql`
- `scripts/migrar_datos.py`
- `SP_RegistrarCliente.sql`
- `SP_ActualizarCliente.sql`
- `SP_AbrirCuenta.sql`
- Diccionario de datos
- Descripción del proceso de normalización
- Diagrama Entidad-Relación

---

# Integrante 2

## Daniel Alejandro Castellanos Rodríguez
### Carné: 202200176

### Actividades realizadas

#### Desarrollo de operaciones bancarias

Implementación de la lógica transaccional para las operaciones bancarias principales del sistema.

#### Desarrollo de procedimientos almacenados

Implementación de los siguientes procedimientos:

- `SP_RegistrarDeposito`
- `SP_RegistrarRetiro`
- `SP_RealizarTransferencia`

#### Implementación de control transaccional

Diseño e implementación de:

- `START TRANSACTION`
- `COMMIT`
- `ROLLBACK`

para garantizar la atomicidad y consistencia de las operaciones financieras.

#### Validaciones implementadas

- Verificación de existencia de cuentas bancarias.
- Verificación de cuentas activas.
- Validación de montos mayores a cero.
- Verificación de existencia de empleados.
- Validación de saldo suficiente para retiros.
- Validación de saldo suficiente para transferencias.
- Prevención de transferencias hacia la misma cuenta.
- Registro automático de movimientos bancarios.

#### Control de concurrencia

- Implementación de bloqueos mediante `SELECT ... FOR UPDATE`.
- Validación de acceso concurrente utilizando múltiples sesiones activas.
- Pruebas de bloqueo y liberación de registros.
- Verificación de consistencia de saldos durante operaciones simultáneas.

#### Pruebas realizadas

- Pruebas de depósitos exitosos.
- Pruebas de retiros exitosos.
- Pruebas de transferencias exitosas.
- Pruebas de errores por monto inválido.
- Pruebas de errores por cuentas inexistentes.
- Pruebas de errores por empleados inexistentes.
- Pruebas de saldo insuficiente.
- Pruebas de concurrencia.

#### Documentación

- Elaboración de la documentación de pruebas transaccionales.
- Elaboración del Manual de Usuario.
- Documentación de los procedimientos almacenados desarrollados.
- Documentación de las pruebas de concurrencia.

### Entregables generados

- `SP_RegistrarDeposito.sql`
- `SP_RegistrarRetiro.sql`
- `SP_RealizarTransferencia.sql`
- `sql/pruebas/02_pruebas_operaciones.sql`
- `docs/pruebas_transacciones.md`
- Manual de Usuario

---

# Integrante 3

## Carlos Fernando Matta Peña
### Carné: 202302190

### Actividades realizadas

#### Desarrollo de procedimientos almacenados

Implementación de los siguientes procedimientos:

- `SP_ReporteClientesSucursal`
- `SP_CerrarCuenta`
- `SP_ReporteMovimientosCuenta`

#### Administración de usuarios y permisos

Implementación de la gestión de roles y privilegios dentro del sistema gestor de bases de datos.

Creación de los roles:

- Cajero
- Gerente
- Administrador

Configuración de permisos mediante:

- `CREATE USER`
- `GRANT`

#### Administración de respaldos

Diseño e implementación de la estrategia de respaldo solicitada por el proyecto.

Creación de:

- Respaldo completo de la base de datos.
- Tres respaldos incrementales.
- Scripts de recuperación.

#### Documentación

- Documentación del proceso de generación de respaldos.
- Documentación del proceso de recuperación.
- Elaboración de ejemplos de restauración.
- Explicación de los comandos utilizados para respaldar y recuperar la información.

### Entregables generados

- `SP_ReporteClientesSucursal.sql`
- `SP_CerrarCuenta.sql`
- `SP_ReporteMovimientosCuenta.sql`
- Scripts de creación de usuarios y roles
- Scripts de asignación de permisos
- Respaldo completo
- Respaldos incrementales
- Documentación de respaldos y recuperación

---

# Conclusión

La distribución del trabajo se realizó de forma equilibrada, asignando responsabilidades específicas a cada integrante según las distintas fases del proyecto. Esto permitió desarrollar de manera paralela los componentes de diseño, migración, operaciones bancarias, administración y documentación, garantizando el cumplimiento de los requerimientos establecidos para el Proyecto 1 de Sistemas de Bases de Datos 2.