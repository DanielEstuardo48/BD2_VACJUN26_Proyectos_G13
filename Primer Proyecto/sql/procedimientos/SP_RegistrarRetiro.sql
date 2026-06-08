USE BancoDB;

DELIMITER $$

DROP PROCEDURE IF EXISTS SP_RegistrarRetiro$$

CREATE PROCEDURE SP_RegistrarRetiro(
    IN p_CuentaID INT,
    IN p_Monto DECIMAL(15,2),
    IN p_Descripcion VARCHAR(255),
    IN p_EmpleadoID INT
)
BEGIN
    -- Variables de control y datos de la cuenta
    DECLARE v_existeCuenta INT DEFAULT 0;
    DECLARE v_existeEmpleado INT DEFAULT 0;
    DECLARE v_estadoCuenta VARCHAR(20);
    DECLARE v_saldoActual DECIMAL(15,2);

    -- Si ocurre un error SQL, revierte toda la operación
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR: Ocurrio un error durante el retiro. Se realizo ROLLBACK.' AS Mensaje;
    END;

    -- Validar existencia de cuenta y empleado
    SELECT COUNT(*) INTO v_existeCuenta
    FROM Cuenta
    WHERE CuentaID = p_CuentaID;

    SELECT COUNT(*) INTO v_existeEmpleado
    FROM Empleado
    WHERE EmpleadoID = p_EmpleadoID;

    -- Validaciones de entrada
    IF p_CuentaID IS NULL THEN
        SELECT 'ERROR: La cuenta no puede estar vacia.' AS Mensaje;
    ELSEIF p_Monto IS NULL OR p_Monto <= 0 THEN
        SELECT 'ERROR: El monto debe ser mayor a 0.' AS Mensaje;
    ELSEIF v_existeCuenta = 0 THEN
        SELECT 'ERROR: La cuenta no existe.' AS Mensaje;
    ELSEIF v_existeEmpleado = 0 THEN
        SELECT 'ERROR: El empleado no existe.' AS Mensaje;
    ELSE
        -- Inicia transacción para asegurar consistencia
        START TRANSACTION;

            -- Bloquea la cuenta y obtiene estado/saldo actual
            SELECT EstadoCuenta, SaldoActual
            INTO v_estadoCuenta, v_saldoActual
            FROM Cuenta
            WHERE CuentaID = p_CuentaID
            FOR UPDATE;

            -- Validar estado de cuenta y fondos disponibles
            IF v_estadoCuenta <> 'ACTIVA' THEN
                ROLLBACK;
                SELECT 'ERROR: La cuenta no esta activa.' AS Mensaje;
            ELSEIF v_saldoActual < p_Monto THEN
                ROLLBACK;
                SELECT 'ERROR: Saldo insuficiente para realizar el retiro.' AS Mensaje;
            ELSE
                -- Registrar el movimiento de retiro
                INSERT INTO Transaccion (
                    Fecha,
                    TipoTransaccion,
                    Monto,
                    Descripcion,
                    CuentaID,
                    EmpleadoID
                )
                VALUES (
                    NOW(),
                    'RETIRO',
                    p_Monto,
                    p_Descripcion,
                    p_CuentaID,
                    p_EmpleadoID
                );

                -- Descontar el monto del saldo de la cuenta
                UPDATE Cuenta
                SET SaldoActual = SaldoActual - p_Monto
                WHERE CuentaID = p_CuentaID;

                -- Confirmar cambios y devolver resultado
                COMMIT;

                SELECT CuentaID,
                       SaldoActual,
                       'Retiro registrado exitosamente.' AS Mensaje
                FROM Cuenta
                WHERE CuentaID = p_CuentaID;
            END IF;
    END IF;
END$$

DELIMITER ;

-- Prueba retiro correcto
CALL SP_RegistrarRetiro(1001, 50.00, 'Retiro de prueba', 501);

-- Prueba monto inválido
CALL SP_RegistrarRetiro(1001, -50.00, 'Retiro invalido', 501);

-- Prueba saldo insuficiente
CALL SP_RegistrarRetiro(1001, 999999.00, 'Retiro sin saldo suficiente', 501);

-- Prueba cuenta inexistente
CALL SP_RegistrarRetiro(99999, 50.00, 'Cuenta inexistente', 501);

-- Prueba empleado inexistente
CALL SP_RegistrarRetiro(1001, 50.00, 'Empleado inexistente', 99999);

-- Prueba cuenta sin fondos (Cuenta 1006 tiene saldo 0)
CALL SP_RegistrarRetiro(1006, 50.00, 'Cuenta sin fondos', 501);