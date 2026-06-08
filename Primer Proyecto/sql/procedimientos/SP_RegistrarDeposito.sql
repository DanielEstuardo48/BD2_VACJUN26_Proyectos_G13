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
    -- Variables auxiliares
    DECLARE v_existe_cuenta INT DEFAULT 0;     
    DECLARE v_estado VARCHAR(20);             
    DECLARE v_existe_empleado INT DEFAULT 0;  

    -- Manejo de excepciones: en caso de error se revierte la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR: Ocurrió un error durante el depósito. Se realizó ROLLBACK.' AS Mensaje;
    END;

    -- Verificar existencia de la cuenta
    SELECT COUNT(*)
    INTO v_existe_cuenta
    FROM Cuenta
    WHERE CuentaID = p_CuentaID;

    -- Verificar existencia del empleado
    SELECT COUNT(*)
    INTO v_existe_empleado
    FROM Empleado
    WHERE EmpleadoID = p_EmpleadoID;

    -- Validaciones iniciales
    IF p_Monto IS NULL OR p_Monto <= 0 THEN
        SELECT 'ERROR: El monto debe ser mayor a 0.' AS Mensaje;

    ELSEIF v_existe_cuenta = 0 THEN
        SELECT 'ERROR: La cuenta no existe.' AS Mensaje;

    ELSEIF v_existe_empleado = 0 THEN
        SELECT 'ERROR: El empleado no existe.' AS Mensaje;

    ELSE
        -- Iniciar transacción y bloquear fila de cuenta
        START TRANSACTION;

        SELECT EstadoCuenta
        INTO v_estado
        FROM Cuenta
        WHERE CuentaID = p_CuentaID
        FOR UPDATE; 

        -- Verificar que la cuenta esté activa
        IF v_estado <> 'ACTIVA' THEN
            ROLLBACK;
            SELECT 'ERROR: La cuenta no está activa.' AS Mensaje;
        ELSE
            
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

            -- Actualizar saldo de la cuenta
            UPDATE Cuenta
            SET SaldoActual = SaldoActual + p_Monto
            WHERE CuentaID = p_CuentaID;

            COMMIT;

            -- Respuesta exitosa concisa
            SELECT 
                p_CuentaID AS CuentaID,
                p_Monto AS MontoDepositado,
                'Depósito registrado exitosamente.' AS Mensaje;
        END IF;
    END IF;
END$$

DELIMITER ;