USE BancoDB;

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

-- Pruebas rápidas del procedimiento

-- Prueba transferencia correcta
CALL SP_RealizarTransferencia(1001, 1002, 25.00);

-- Prueba monto inválido
CALL SP_RealizarTransferencia(1001, 1002, -25.00);

-- Prueba misma cuenta
CALL SP_RealizarTransferencia(1001, 1001, 25.00);

-- Prueba saldo insuficiente
CALL SP_RealizarTransferencia(1001, 1002, 999999.00);

-- Prueba cuenta origen inexistente
CALL SP_RealizarTransferencia(99999, 1002, 100.00);

-- Prueba cuenta destino inexistente
CALL SP_RealizarTransferencia(1001, 99999, 100.00);
