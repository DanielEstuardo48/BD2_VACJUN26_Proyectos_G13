USE BancoDB;

-- PRUEBAS DE DEPÓSITO

SELECT CuentaID, SaldoActual 
FROM Cuenta 
WHERE CuentaID = 1001;

CALL SP_RegistrarDeposito(1001, 100.00, 'Deposito de prueba', 501);

SELECT CuentaID, SaldoActual 
FROM Cuenta 
WHERE CuentaID = 1001;

CALL SP_RegistrarDeposito(1001, -100.00, 'Deposito invalido', 501);

CALL SP_RegistrarDeposito(99999, 100.00, 'Cuenta inexistente', 501);

CALL SP_RegistrarDeposito(1001, 100.00, 'Empleado inexistente', 99999);

-- PRUEBAS DE RETIRO

SELECT CuentaID, SaldoActual 
FROM Cuenta 
WHERE CuentaID = 1001;

CALL SP_RegistrarRetiro(1001, 50.00, 'Retiro de prueba', 501);

SELECT CuentaID, SaldoActual 
FROM Cuenta 
WHERE CuentaID = 1001;

CALL SP_RegistrarRetiro(1001, -50.00, 'Retiro invalido', 501);

CALL SP_RegistrarRetiro(1001, 999999.00, 'Retiro sin saldo suficiente', 501);

CALL SP_RegistrarRetiro(99999, 50.00, 'Cuenta inexistente', 501);

CALL SP_RegistrarRetiro(1006, 50.00, 'Cuenta sin fondos', 501);

-- PRUEBAS DE TRANSFERENCIA

SELECT CuentaID, SaldoActual
FROM Cuenta
WHERE CuentaID IN (1001, 1002);

CALL SP_RealizarTransferencia(1001, 1002, 25.00);

SELECT CuentaID, SaldoActual
FROM Cuenta
WHERE CuentaID IN (1001, 1002);

CALL SP_RealizarTransferencia(1001, 1002, -25.00);

CALL SP_RealizarTransferencia(1001, 1001, 25.00);

CALL SP_RealizarTransferencia(1001, 1002, 999999.00);

CALL SP_RealizarTransferencia(99999, 1002, 100.00);

CALL SP_RealizarTransferencia(1001, 99999, 100.00);

-- VERIFICACIÓN FINAL

SELECT 
    MovimientoID,
    TransferenciaID,
    TipoTransaccion,
    Monto,
    CuentaID,
    EmpleadoID,
    Fecha
FROM Transaccion
ORDER BY MovimientoID DESC
LIMIT 15;

SELECT CuentaID, SaldoActual, EstadoCuenta
FROM Cuenta
ORDER BY CuentaID;