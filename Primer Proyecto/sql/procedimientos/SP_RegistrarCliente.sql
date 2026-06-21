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
    ELSEIF p_FechaNacimiento IS NULL THEN
        SELECT 'ERROR: La fecha de nacimiento del cliente no puede estar vacía.' AS Mensaje;
    ELSEIF p_Direccion IS NULL OR p_Direccion = '' THEN
        SELECT 'ERROR: La dirección del cliente no puede estar vacía.' AS Mensaje;
    ELSEIF p_Telefono IS NULL OR p_Telefono = '' THEN
        SELECT 'ERROR: El teléfono del cliente no puede estar vacío.' AS Mensaje;
    ELSEIF p_Correo IS NULL OR p_Correo = '' THEN
        SELECT 'ERROR: El correo del cliente no puede estar vacío.' AS Mensaje;
    ELSE
        START TRANSACTION;

            INSERT INTO Cliente (ClienteDNI, Nombre, FechaNacimiento, Direccion, Telefono, Correo)
            VALUES (p_ClienteDNI, p_Nombre, p_FechaNacimiento, p_Direccion, p_Telefono, p_Correo);
        
        COMMIT;

        SELECT p_ClienteDNI AS ClienteDNI, p_Nombre AS Nombre, 'Cliente registrado exitosamente.' AS Mensaje;

    END IF;
END $$

DELIMITER ;

