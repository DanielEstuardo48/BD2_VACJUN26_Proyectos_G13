-- RESPALDO INCREMENTAL 02
-- Procedimientos de operaciones bancarias

USE BancoDB;

DELIMITER $$

DROP PROCEDURE IF EXISTS SP_RegistrarDeposito$$

CREATE PROCEDURE SP_RegistrarDeposito(
    IN p_CuentaID INT,
    IN p_Monto DECIMAL(15,2),
    IN p_Descripcion VARCHAR(255),
    IN p_EmpleadoID INT
)
BEGIN
    -- Variables de control para validar datos y estado de la cuenta
    DECLARE v_existeCuenta INT DEFAULT 0;
    DECLARE v_existeEmpleado INT DEFAULT 0;
    DECLARE v_estadoCuenta VARCHAR(20);

    -- Si ocurre un error SQL, deshace la transacción y devuelve mensaje
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR: Ocurrio un error durante el deposito. Se realizo ROLLBACK.' AS Mensaje;
    END;

    -- Verifica si la cuenta y el empleado existen
    SELECT COUNT(*) INTO v_existeCuenta
    FROM Cuenta
    WHERE CuentaID = p_CuentaID;

    SELECT COUNT(*) INTO v_existeEmpleado
    FROM Empleado
    WHERE EmpleadoID = p_EmpleadoID;

    -- Validaciones de entrada antes de iniciar transacción
    IF p_CuentaID IS NULL THEN
        SELECT 'ERROR: La cuenta no puede estar vacia.' AS Mensaje;
    ELSEIF p_Monto IS NULL OR p_Monto <= 0 THEN
        SELECT 'ERROR: El monto debe ser mayor a 0.' AS Mensaje;
    ELSEIF v_existeCuenta = 0 THEN
        SELECT 'ERROR: La cuenta no existe.' AS Mensaje;
    ELSEIF v_existeEmpleado = 0 THEN
        SELECT 'ERROR: El empleado no existe.' AS Mensaje;
    ELSE
        START TRANSACTION;

            -- Bloquea la fila de la cuenta para evitar cambios simultáneos
            SELECT EstadoCuenta INTO v_estadoCuenta
            FROM Cuenta
            WHERE CuentaID = p_CuentaID
            FOR UPDATE;

            IF v_estadoCuenta <> 'ACTIVA' THEN
                ROLLBACK;
                SELECT 'ERROR: La cuenta no esta activa.' AS Mensaje;
            ELSE
                -- Registra el depósito en el historial de transacciones
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
                    'DEPOSITO',
                    p_Monto,
                    p_Descripcion,
                    p_CuentaID,
                    p_EmpleadoID
                );

                -- Actualiza el saldo de la cuenta
                UPDATE Cuenta
                SET SaldoActual = SaldoActual + p_Monto
                WHERE CuentaID = p_CuentaID;

                COMMIT;

                -- Devuelve saldo actual y confirmación
                SELECT CuentaID,
                       SaldoActual,
                       'Deposito registrado exitosamente.' AS Mensaje
                FROM Cuenta
                WHERE CuentaID = p_CuentaID;
            END IF;
    END IF;
END$$

DELIMITER ;

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

DELIMITER $$

DROP PROCEDURE IF EXISTS SP_RealizarTransferencia$$

CREATE PROCEDURE SP_RealizarTransferencia(
    IN p_CuentaOrigenID INT,
    IN p_CuentaDestinoID INT,
    IN p_Monto DECIMAL(15,2)
)
BEGIN
    -- Variables de validación y control de la transferencia
    DECLARE v_existeOrigen INT DEFAULT 0;
    DECLARE v_existeDestino INT DEFAULT 0;
    DECLARE v_estadoOrigen VARCHAR(20);
    DECLARE v_estadoDestino VARCHAR(20);
    DECLARE v_saldoOrigen DECIMAL(15,2);
    DECLARE v_transferenciaID VARCHAR(20);
    DECLARE v_empleadoID INT;

    -- Si ocurre un error SQL, deshace toda la operación
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR: Ocurrio un error durante la transferencia. Se realizo ROLLBACK.' AS Mensaje;
    END;

    -- Verifica existencia de cuentas
    SELECT COUNT(*) INTO v_existeOrigen
    FROM Cuenta
    WHERE CuentaID = p_CuentaOrigenID;

    SELECT COUNT(*) INTO v_existeDestino
    FROM Cuenta
    WHERE CuentaID = p_CuentaDestinoID;

    -- Toma un empleado para registrar la transacción
    SELECT EmpleadoID INTO v_empleadoID
    FROM Empleado
    ORDER BY EmpleadoID
    LIMIT 1;

    -- Validaciones de entrada y reglas básicas
    IF p_CuentaOrigenID IS NULL OR p_CuentaDestinoID IS NULL THEN
        SELECT 'ERROR: La cuenta origen y destino son obligatorias.' AS Mensaje;
    ELSEIF p_Monto IS NULL OR p_Monto <= 0 THEN
        SELECT 'ERROR: El monto debe ser mayor a 0.' AS Mensaje;
    ELSEIF p_CuentaOrigenID = p_CuentaDestinoID THEN
        SELECT 'ERROR: La cuenta origen y destino no pueden ser la misma.' AS Mensaje;
    ELSEIF v_existeOrigen = 0 THEN
        SELECT 'ERROR: La cuenta origen no existe.' AS Mensaje;
    ELSEIF v_existeDestino = 0 THEN
        SELECT 'ERROR: La cuenta destino no existe.' AS Mensaje;
    ELSEIF v_empleadoID IS NULL THEN
        SELECT 'ERROR: No existe ningun empleado para registrar la transferencia.' AS Mensaje;
    ELSE
        START TRANSACTION;

            -- Bloquea ambas cuentas en orden para evitar bloqueos cruzados (deadlock)
            IF p_CuentaOrigenID < p_CuentaDestinoID THEN
                SELECT EstadoCuenta, SaldoActual
                INTO v_estadoOrigen, v_saldoOrigen
                FROM Cuenta
                WHERE CuentaID = p_CuentaOrigenID
                FOR UPDATE;

                SELECT EstadoCuenta
                INTO v_estadoDestino
                FROM Cuenta
                WHERE CuentaID = p_CuentaDestinoID
                FOR UPDATE;
            ELSE
                SELECT EstadoCuenta
                INTO v_estadoDestino
                FROM Cuenta
                WHERE CuentaID = p_CuentaDestinoID
                FOR UPDATE;

                SELECT EstadoCuenta, SaldoActual
                INTO v_estadoOrigen, v_saldoOrigen
                FROM Cuenta
                WHERE CuentaID = p_CuentaOrigenID
                FOR UPDATE;
            END IF;

            IF v_estadoOrigen <> 'ACTIVA' THEN
                ROLLBACK;
                SELECT 'ERROR: La cuenta origen no esta activa.' AS Mensaje;
            ELSEIF v_estadoDestino <> 'ACTIVA' THEN
                ROLLBACK;
                SELECT 'ERROR: La cuenta destino no esta activa.' AS Mensaje;
            ELSEIF v_saldoOrigen < p_Monto THEN
                ROLLBACK;
                SELECT 'ERROR: Saldo insuficiente para realizar la transferencia.' AS Mensaje;
            ELSE
                -- Genera ID de transferencia y registra salida/entrada
                SET v_transferenciaID = CONCAT('TRF', DATE_FORMAT(NOW(), '%Y%m%d%H%i%s'));

                UPDATE Cuenta
                SET SaldoActual = SaldoActual - p_Monto
                WHERE CuentaID = p_CuentaOrigenID;

                UPDATE Cuenta
                SET SaldoActual = SaldoActual + p_Monto
                WHERE CuentaID = p_CuentaDestinoID;

                INSERT INTO Transaccion (
                    TransferenciaID,
                    Fecha,
                    TipoTransaccion,
                    Monto,
                    Descripcion,
                    CuentaID,
                    EmpleadoID
                )
                VALUES (
                    v_transferenciaID,
                    NOW(),
                    'TRANSFERENCIA_SALIDA',
                    p_Monto,
                    CONCAT('Transferencia enviada a cuenta ', p_CuentaDestinoID),
                    p_CuentaOrigenID,
                    v_empleadoID
                );

                INSERT INTO Transaccion (
                    TransferenciaID,
                    Fecha,
                    TipoTransaccion,
                    Monto,
                    Descripcion,
                    CuentaID,
                    EmpleadoID
                )
                VALUES (
                    v_transferenciaID,
                    NOW(),
                    'TRANSFERENCIA_ENTRADA',
                    p_Monto,
                    CONCAT('Transferencia recibida de cuenta ', p_CuentaOrigenID),
                    p_CuentaDestinoID,
                    v_empleadoID
                );

                COMMIT;

                SELECT v_transferenciaID AS TransferenciaID,
                       p_CuentaOrigenID AS CuentaOrigenID,
                       p_CuentaDestinoID AS CuentaDestinoID,
                       p_Monto AS Monto,
                       'Transferencia realizada exitosamente.' AS Mensaje;
            END IF;
    END IF;
END$$

DELIMITER ;
