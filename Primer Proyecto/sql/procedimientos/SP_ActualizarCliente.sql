USE BancoDB;

DELIMITER $$

DROP PROCEDURE IF EXISTS SP_ActualizarCliente$$

CREATE PROCEDURE SP_ActualizarCLiente(
    IN p_ClienteDNI VARCHAR(20),
    IN p_Direccion VARCHAR(200),
    IN p_Telefono VARCHAR(20),
    IN p_Correo VARCHAR(100)
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;

    SELECT COUNT(*) INTO v_existe
    FROM Cliente
    WHERE ClienteDNI = p_ClienteDNI;

    IF v_existe = 0 THEN
        SELECT 'ERROR: El cliente no existe' AS Mensaje;
    ELSEIF p_ClienteDNI IS NULL OR p_ClienteDNI = '' THEN
        SELECT 'ERROR: El DNI del cliente no puede estar vacío.' AS Mensaje;
    ELSEIF p_Direccion IS NULL OR p_Direccion = '' THEN
        SELECT 'ERROR: La dirección del cliente no puede estar vacía.' AS Mensaje;
    ELSEIF p_Telefono IS NULL OR p_Telefono = '' THEN
        SELECT 'ERROR: El teléfono del cliente no puede estar vacío.' AS Mensaje;
    ELSEIF p_Correo IS NULL OR p_Correo = '' THEN
        SELECT 'ERROR: El correo del cliente no puede estar vacío.' AS Mensaje;
    ELSE
        START TRANSACTION;
            UPDATE Cliente
            SET Direccion = p_Direccion,
                Telefono = p_Telefono,
                Correo = p_Correo
            WHERE ClienteDNI = p_ClienteDNI;

        COMMIT;

        -- Para mostrar datos del cliente que se actualizo
        SELECT ClienteDNI, Nombre, Direccion, Telefono, Correo, 'Cliente actualizado exitosamente' AS Mensaje FROM Cliente
        WHERE ClienteDNI = p_ClienteDNI;
    END IF;
END$$

DELIMITER ;

-- Prueba Actualizar cliente
CALL SP_ActualizarCliente(
    '10001',
    'Zona 10, Nueva Dirección',
    '55551234',
    'jose.nuevo@mail.com'
);

-- Prueba Cliente que no existe
CALL SP_ActualizarCliente(
    '99998',
    'Zona 1',
    '55550000',
    'noexiste@mail.com'
);
