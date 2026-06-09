-- RESPALDO INCREMENTAL 01
-- Procedimientos de clientes y cuentas

USE BancoDB;

DELIMITER $$

DROP PROCEDURE IF EXISTS SP_RegistrarCliente $$ -- Esto es para que no de error si el procedimiento ya existe

-- Registro de nuevo cliente
CREATE PROCEDURE SP_RegistrarCliente(
    IN p_ClienteDNI VARCHAR(20),
    IN p_Nombre VARCHAR(150),
    IN p_FechaNacimiento DATE,
    IN p_Direccion VARCHAR(200),
    IN p_Telefono VARCHAR(20),
    IN p_Correo VARCHAR(100)
)
BEGIN
    DECLARE v_existe INT DEFAULT 0; -- Variable para verificar si el cliente ya existe

    -- Verificar si el cliente ya existe
    SELECT COUNT(*) INTO v_existe
    FROM Cliente
    WHERE ClienteDNI = p_ClienteDNI;

    IF v_existe > 0 THEN
        SELECT 'Error: El cliente ya existe.' AS Mensaje;
    ELSEIF p_ClienteDNI IS NULL OR p_ClienteDNI = '' THEN
        SELECT 'ERROR: El DNI del cliente no puede estar vacío.' AS Mensaje;
    ELSEIF p_Nombre IS NULL OR p_Nombre = '' THEN
        SELECT 'ERROR: El nombre del cliente no puede estar vacío.' AS Mensaje;
    ELSE
        START TRANSACTION;

            INSERT INTO Cliente (ClienteDNI, Nombre, FechaNacimiento, Direccion, Telefono, Correo)
            VALUES (p_ClienteDNI, p_Nombre, p_FechaNacimiento, p_Direccion, p_Telefono, p_Correo);

            SAVEPOINT cliente_guardado; -- Punto de guardado
        
        COMMIT;

        SELECT p_ClienteDNI AS ClienteDNI, p_Nombre AS Nombre, 'Cliente registrado exitosamente.' AS Mensaje;

    END IF;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS SP_ActualizarCliente$$

CREATE PROCEDURE SP_ActualizarCLiente(
    IN p_ClienteDNI VARCHAR(20),
    IN p_Direccion VARCHAR(200),
    IN p_Telefono VARCHAR(20),
    IN p_Correo VARCHAR(100)
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;

    SELECT COUNT(*) INTO v_existe
    FROM Cliente
    WHERE ClienteDNI = p_ClienteDNI;

    IF v_existe = 0 THEN
        SELECT 'ERROR: El cliente no existe' AS Mensaje;
    ELSEIF p_ClienteDNI IS NULL OR p_ClienteDNI = '' THEN
        SELECT 'ERROR: El DNI del cliente no puede estar vacío.' AS Mensaje;
    ELSE
        START TRANSACTION;
            UPDATE Cliente
            SET Direccion = p_Direccion,
                Telefono = p_Telefono,
                Correo = p_Correo
            WHERE ClienteDNI = p_ClienteDNI;

            SAVEPOINT cliente_actualizado;

        COMMIT;

        -- Para mostrar datos del cliente que se actualizo
        SELECT ClienteDNI, Nombre, Direccion, Telefono, Correo, 'Cliente actualizado exitosamente' AS Mensaje FROM Cliente
        WHERE ClienteDNI = p_ClienteDNI;
    END IF;
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS SP_AbrirCuenta$$

CREATE PROCEDURE SP_AbrirCuenta(
    IN p_ClienteDNI VARCHAR(20),
    IN p_TipoCuenta VARCHAR(50),
    IN p_SaldoInicial DECIMAL(15,2),
    IN p_SucursalID INT
)
BEGIN 
    -- Variables para el control de los errores
    DECLARE v_existeCliente INT DEFAULT 0;
    DECLARE v_existeSucursal INT DEFAULT 0;
    DECLARE v_nuevaCuentaID INT DEFAULT 0;

    SELECT COUNT(*) INTO v_existeCliente
    FROM Cliente
    WHERE ClienteDNI = p_ClienteDNI;

    SELECT COUNT(*) INTO v_existeSucursal
    FROM Sucursal
    WHERE SucursalID = p_SucursalID;

    IF p_SaldoInicial < 0 THEN
        SELECT 'ERROR: El saldo inicial no puede ser negativo.' AS Mensaje;
    ELSEIF v_existeCliente = 0 THEN
        SELECT 'ERROR: El cliente no existe.' AS Mensaje;
    ELSEIF v_existeSucursal = 0 THEN
        SELECT 'ERROR: La sucursal no existe.' AS Mensaje;
    ELSEIF p_TipoCuenta NOT IN ('Ahorro', 'Corriente') THEN
        SELECT 'ERROR: Tipo de cuenta no válido. Debe ser "Ahorro" o "Corriente".' AS Mensaje;
    ELSE
        START TRANSACTION;
            INSERT INTO Cuenta (TipoCuenta, FechaApertura, SaldoActual, EstadoCuenta, ClienteDNI, SucursalID)
            VALUES (p_TipoCuenta, CURDATE(), p_SaldoInicial, 'ACTIVA', p_ClienteDNI, p_SucursalID);

            SET v_nuevaCuentaID = LAST_INSERT_ID(); -- Guarda el ID de la nueva cuenta para mostrarlo después

            SAVEPOINT cuenta_creada; -- Para poder hacer rollback a este punto si algo falla después
        COMMIT;

        SELECT v_nuevaCuentaID AS CuentaID,
               p_TipoCuenta AS TipoCuenta,
               p_SaldoInicial AS SaldoInicial,
               'ACTIVA' AS Estado,
               p_ClienteDNI AS ClienteDNI,
                p_SucursalID AS SucursalID,
               'Cuenta creada exitosamente' AS Mensaje;
    END IF;
END$$

DELIMITER ;



