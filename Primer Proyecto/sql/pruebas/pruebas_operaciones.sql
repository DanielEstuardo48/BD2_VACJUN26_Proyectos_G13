USE BancoDB;

-- Registrar Cliente
CALL SP_RegistrarCliente(
    '99999',
    'Luis Prueba',
    '2000-05-15',
    'Zona 1, Ciudad',
    '55559999',
    'luis.prueba@mail.com'
);

-- Cliente Duplicado (Error)
CALL SP_RegistrarCliente(
    '10001',
    'Cliente Duplicado',
    '2000-01-01',
    'Zona 1',
    '55550000',
    'duplicado@mail.com'
);

-- Actualizar Cliente
CALL SP_ActualizarCliente(
    '10001',
    'Zona 10, Nueva Dirección',
    '55551234',
    'jose.nuevo@mail.com'
);

-- Abrir Cuenta
CALL SP_AbrirCuenta(
    '10001',
    'Ahorro',
    -1500.00,
    1
);

-- Abrir cuentas (error)
CALL SP_AbrirCuenta('10001', 'Ahorro', -500.00, 1);
CALL SP_AbrirCuenta('99998', 'Ahorro', 1000.00, 1);
CALL SP_AbrirCuenta('10001', 'Inversion', 1000.00, 1);

--
-- PRUEBAS DE DEPÓSITO

SELECT CuentaID, SaldoActual 
FROM Cuenta 
WHERE CuentaID = 1001;

CALL SP_RegistrarDeposito(1001, 100.00, 'Deposito de prueba', 501);

SELECT CuentaID, SaldoActual 
FROM Cuenta 
WHERE CuentaID = 1001;

-- Errores RegistroDeposito
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

-- Retiros Errores
CALL SP_RegistrarRetiro(1001, -50.00, 'Retiro invalido', 501);

CALL SP_RegistrarRetiro(1001, 999999.00, 'Retiro sin saldo suficiente', 501);

CALL SP_RegistrarRetiro(99999, 50.00, 'Cuenta inexistente', 501);

CALL SP_RegistrarRetiro(1006, 50.00, 'Cuenta sin fondos', 501);

-- PRUEBAS DE TRANSFERENCIA

SELECT CuentaID, SaldoActual
FROM Cuenta
WHERE CuentaID IN (1001, 1002);

CALL SP_RealizarTransferencia(1001, 1002, 250000000.00);

SELECT CuentaID, SaldoActual
FROM Cuenta
WHERE CuentaID IN (1001, 1002);

-- Errores Transferencia
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

-- Cerrar Cuenta
SELECT CuentaID, SaldoActual, EstadoCuenta
FROM Cuenta
WHERE SaldoActual = 0;

CALL SP_CerrarCuenta(1006);

SELECT CuentaID, SaldoActual, EstadoCuenta
FROM Cuenta
WHERE CuentaID = 1006;

CALL SP_CerrarCuenta(1001);

-- Reportes
CALL SP_ReporteClientesSucursal('Centro');

CALL SP_ReporteMovimientosCuenta(
    1001,
    '2027-01-01',
    '2026-12-31'
);

-- Error Reportes
CALL SP_ReporteMovimientosCuenta(1001, '2026-12-31', '2026-01-01');

CALL SP_ReporteMovimientosCuenta(99999, '2026-01-01', '2026-12-31');

CALL SP_ReporteClientesSucursal('Sucursal Inexistente');