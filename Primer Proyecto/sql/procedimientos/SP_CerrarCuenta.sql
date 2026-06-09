USE BancoDB;

DELIMITER $$

DROP PROCEDURE IF EXISTS SP_CerrarCuenta$$

CREATE PROCEDURE SP_CerrarCuenta(
    IN p_CuentaID INT
)

BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_estado VARCHAR(20);
    DECLARE v_saldo DECIMAL(15,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR: Ocurrio un error al intentar cerrar la cuenta, se realizo un ROLLBACK.' AS Mensaje;

    end;

    IF p_CuentaID IS NULL THEN
        SELECT 'ERROR: El Id de la cuenta tiene que ser obligatorio.' AS Mensaje;
    ELSE
        SELECT COUNT(*) INTO v_existe
        FROM Cuenta
            WHERE CuentaID = p_CuentaID;

        IF v_existe = 0 THEN
            SELECT 'ERROR: La cuenta seleccionada no existe.' AS Mensaje;
        ELSE
            START TRANSACTION;
                SELECT EstadoCuenta, SaldoActual
                INTO v_estado, v_saldo
                FROM Cuenta
                WHERE CuentaID = p_CuentaID
                FOR UPDATE;

                IF v_estado <> 'ACTIVA' THEN
                    ROLLBACK;
                    SELECT 'ERROR: La cuenta que se selecciono ya se encuetra inactiva.' AS Mensaje;

                ELSEIF v_saldo <> 0 THEN
                    ROLLBACK;
                    SELECT CONCAT ('ERROR: La cuenta tiene que tener saldo 0 para poder cerrarse. Esta cuenta tiene: ', v_saldo) AS Mensaje;
                ELSE
                    UPDATE Cuenta
                    SET EstadoCuenta = 'INACTIVA'
                    WHERE CuentaID = p_CuentaID;

                    COMMIT;

                    SELECT
                        p_CuentaID AS CuentaID,
                        'INACTIVA' AS EstadoCuenta,
                        'Cuenta cerrada con exito.' AS Mensaje;
                end if;
        end if;
    end if;
end $$

DELIMITER ;
