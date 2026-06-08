USE BancoDB;

DELIMITER $$

DROP PROCEDURE IF EXISTS SP_RegistrarCliente $$ -- Esto es para que no de error si el procedimiento ya existe

-- Registro de nuevo cliente
CREATE PROCEDURE SP_RegistrarCliente(
    IN p_ClienteDNI VARCHAR(20),
    IN p_Nombre VARCHAR(150),
    IN p_FechaNacimiento DATE,
    IN p_Direccion VARCHAR(200),
    IN p_Telefono VARCHAR(20),
    IN p_Correo VARCHAR(100)
)
BEGIN
    DECLARE v_existe INT DEFAULT 0; -- Variable para verificar si el cliente ya existe

    -- Verificar si el cliente ya existe
    SELECT COUNT(*) INTO v_existe
    FROM Cliente
    WHERE ClienteDNI = p_ClienteDNI;

    IF v_existe > 0 THEN
        SELECT 'Error: El cliente ya existe.' AS Mensaje;
    ELSEIF p_ClienteDNI IS NULL OR p_ClienteDNI = '' THEN
        SELECT 'ERROR: El DNI del cliente no puede estar vacío.' AS Mensaje;
    ELSEIF p_Nombre IS NULL OR p_Nombre = '' THEN
        SELECT 'ERROR: El nombre del cliente no puede estar vacío.' AS Mensaje;
    ELSE
        START TRANSACTION;

            INSERT INTO Cliente (ClienteDNI, Nombre, FechaNacimiento, Direccion, Telefono, Correo)
            VALUES (p_ClienteDNI, p_Nombre, p_FechaNacimiento, p_Direccion, p_Telefono, p_Correo);

            SAVEPOINT cliente_guardado; -- Punto de guardado
        
        COMMIT;

        SELECT p_ClienteDNI AS ClienteDNI, p_Nombre AS Nombre, 'Cliente registrado exitosamente.' AS Mensaje;

    END IF;
END $$

DELIMITER ;


-- Prueba 1 de cliente nuevo
CALL SP_RegistrarCliente(
    '99999',
    'Luis Prueba',
    '2000-05-15',
    'Zona 1, Ciudad',
    '55559999',
    'luis.prueba@mail.com'
);

-- DNI duplicado
CALL SP_RegistrarCliente(
    '10001',
    'Jose Morales',
    '2001-03-12',
    'Colonia Centro 5-21',
    '55510001',
    'jose.morales@mail.com'
);

SELECT * FROM Cliente;