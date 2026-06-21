USE BancoDB;

-- Usuarios y permisos

-- Limpiar usuarios si existen

DROP USER IF EXISTS 'cajero'@'%';
DROP USER IF EXISTS 'gerente'@'%';
DROP USER IF EXISTS 'admin_banco'@'%';

-- Crear usuarios

CREATE USER 'cajero'@'%' IDENTIFIED BY 'Cajero123!';
CREATE USER 'gerente'@'%' IDENTIFIED BY 'Gerente123!';
CREATE USER 'admin_banco'@'%' IDENTIFIED BY 'AdminBanco123!';

-- Asignar roles y permisos para cajero

GRANT EXECUTE ON PROCEDURE BancoDB.SP_AbrirCuenta TO 'cajero'@'%';
GRANT EXECUTE ON PROCEDURE BancoDB.SP_ActualizarCliente TO 'cajero'@'%';
GRANT EXECUTE ON PROCEDURE BancoDB.SP_RegistrarDeposito TO 'cajero'@'%';
GRANT EXECUTE ON PROCEDURE BancoDB.SP_RegistrarRetiro TO 'cajero'@'%';
GRANT EXECUTE ON PROCEDURE BancoDB.SP_RealizarTransferencia TO 'cajero'@'%';
GRANT EXECUTE ON PROCEDURE BancoDB.SP_CerrarCuenta TO 'cajero'@'%';

-- Asignar roles y permisos para gerente
GRANT EXECUTE ON PROCEDURE BancoDB.SP_ReporteClientesSucursal TO 'gerente'@'%';
GRANT EXECUTE ON PROCEDURE BancoDB.SP_ReporteMovimientosCuenta TO 'gerente'@'%';
GRANT EXECUTE ON PROCEDURE BancoDB.SP_RegistrarCliente TO 'gerente'@'%';

-- Asignar roles y permisos para admin_banco
GRANT ALL PRIVILEGES ON BancoDB.* TO 'admin_banco'@'%';

-- Aplicar cambios
FLUSH PRIVILEGES;

-- Verificar permisos asignados
SELECT
    User,
    host
FROM mysql.user 
WHERE user IN ('cajero', 'gerente', 'admin_banco');

-- Verificar permisos asignados
SHOW GRANTS FOR 'cajero'@'%';
SHOW GRANTS FOR 'gerente'@'%';
SHOW GRANTS FOR 'admin_banco'@'%';