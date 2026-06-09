USE BancoDB;

DELIMITER $$

DROP PROCEDURE IF EXISTS SP_ReproteMovimientosCuenta$$

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