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
