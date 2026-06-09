-- RESPALDO INCREMENTAL 03
-- Procedimientos de reportes, cierre de cuenta y movimientos

USE BancoDB;


-- Procedimiento para cerrar una cuenta
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

-- Procedimiento para reporte de clientes por sucursal
DELIMITER $$

DROP PROCEDURE IF EXISTS SP_ReporteClientesSucursal$$

CREATE PROCEDURE SP_ReporteClientesSucursal(
    IN p_NombreSucursal VARCHAR(100)
)

BEGIN
    DECLARE v_existeSucursal INT DEFAULT 0;

    IF p_NombreSucursal IS NULL OR TRIM(p_NombreSucursal) = '' THEN
        SELECT 'ERROR: El nombre de la sucursal es obligatorio.' AS Mensaje;
    ELSE
        SELECT COUNT(*) INTO v_existeSucursal
        FROM Sucursal
        WHERE Nombre = p_NombreSucursal;

        IF v_existeSucursal = 0 THEN
            SELECT 'ERROR: La sucursal seleccionada no existe.' AS Mensaje;
        ELSE
            SELECT
                s.SucursalID,
                s.Nombre AS NombreSucursal,
                c.ClienteDNI,
                c.Nombre AS NombreCliente,
                cu.CuentaID,
                cu.TipoCuenta,
                cu.EstadoCuenta,
                cu.SaldoActual AS SaldoCuenta
            FROM Sucursal s
            INNER JOIN Cuenta cu ON s.SucursalID = cu.SucursalID
            INNER JOIN Cliente c ON cu.ClienteDNI = c.ClienteDNI
            WHERE s.Nombre = p_NombreSucursal
            ORDER BY c.Nombre, cu.CuentaID;
        END IF;
    END IF;
END$$

DELIMITER ;

-- Procedimiento para reporte de movimientos por cuenta
DELIMITER $$

DROP PROCEDURE IF EXISTS SP_ReporteMovimientosCuenta$$

CREATE PROCEDURE SP_ReporteMovimientosCuenta(
    IN p_CuentaID INT,
    IN p_FechaInicio DATE,
    IN p_FechaFin DATE
)

BEGIN
    DECLARE v_existeCuenta INT DEFAULT 0;

    IF p_CuentaID IS NULL THEN
        SELECT 'ERROR: El Id de la cuenta es obligatorio.' AS Mensaje;

    ELSEIF p_FechaInicio IS NULL OR p_FechaFin IS NULL THEN
        SELECT 'ERROR: Las fechas de inicio y fin son obligatorias.' AS Mensaje;
    
    ELSEIF p_FechaInicio > p_FechaFin THEN
        SELECT 'ERROR: La fecha no cuadra. La fecha de inicio no puede ser mayor a la fecha de fin.' AS Mensaje;

    ELSE
        SELECT COUNT(*) INTO v_existeCuenta
        FROM Cuenta
        WHERE CuentaID = p_CuentaID;

        IF v_existeCuenta = 0 THEN
            SELECT 'ERROR: La cuenta seleccionada no existe.' AS Mensaje;
        ELSE
            SELECT
                t.MovimientoID,
                t.TransferenciaID,
                t.Fecha,
                t.TipoTransaccion,
                t.Monto,
                t.Descripcion,
                t.CuentaID,
                e.EmpleadoID,
                e.Nombre AS NombreEmpleado,
                e.Cargo
            FROM Transaccion t
            INNER JOIN Empleado e ON t.EmpleadoID = e.EmpleadoID
            WHERE t.CuentaID = p_CuentaID
                AND t.Fecha >= p_FechaInicio
                AND t.Fecha < DATE_ADD(p_FechaFin, INTERVAL 1 DAY)
            ORDER BY t.Fecha, t.MovimientoID;
        END IF;
    END IF;
END$$

DELIMITER ;