USE BancoDB;

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