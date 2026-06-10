USE BancoDB;

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

-- Pruebas
CALL SP_AbrirCuenta('10001', 'Ahorro', 1500.00, 1);
-- error de saldo negativo
CALL SP_AbrirCuenta('10001', 'Ahorro', -500.00, 1);
-- error de ciente que no existe
CALL SP_AbrirCuenta('99998', 'Ahorro', 1000.00, 1);
-- Error de sucursal que no existe
CALL SP_AbrirCuenta('10001', 'Ahorro', 1000.00, 99);
-- error de tipo de cuenta que no existe
CALL SP_AbrirCuenta('10001', 'Inversión', 1000.00, 1);

