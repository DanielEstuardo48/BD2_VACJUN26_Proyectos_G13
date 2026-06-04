CREATE DATABASE IF NOT EXISTS BancoDB
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE BancoDB;

-- Tabla de Sucursal
CREATE TABLE Sucursal (
    SucursalID  INT NOT NULL,
    Nombre  VARCHAR(100) NOT NULL,
    Direccion   VARCHAR(200) NOT NULL,
    Telefono    VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Sucursal PRIMARY KEY (SucursalID)
);

-- Tabla de cliente
CREATE TABLE Cliente (
    ClienteDNI  VARCHAR(20) NOT NULL,
    Nombre  VARCHAR(150)    NOT NULL,
    FechaNacimiento DATE    NOT NULL,
    Direccion   VARCHAR(200)    NOT NULL,
    Telefono    VARCHAR(20) NOT NULL,
    Correo  VARCHAR(100)    NOT NULL,
    CONSTRAINT PK_Cliente PRIMARY KEY (ClienteDNI)
);

-- Tabla de Empleado
CREATE TABLE Empleado (
    EmpleadoID  INT NOT NULL,
    Nombre  VARCHAR(150)    NOT NULL,
    Cargo   VARCHAR(100)    NOT NULL,
    SucursalID  INT NOT NULL,
    CONSTRAINT PK_Empleado PRIMARY KEY (EmpleadoID),
    CONSTRAINT FK_Emp_Suc   FOREIGN KEY (SucursalID)
                      REFERENCES Sucursal(SucursalID)
);

-- Tabla de Cuenta
CREATE TABLE Cuenta (
    CuentaID      INT            NOT NULL,
    TipoCuenta    VARCHAR(50)    NOT NULL,
    FechaApertura DATE           NOT NULL,
    SaldoActual   DECIMAL(15,2)  NOT NULL DEFAULT 0.00,
    EstadoCuenta  VARCHAR(20)    NOT NULL DEFAULT 'ACTIVA',
    ClienteDNI    VARCHAR(20)    NOT NULL,
    SucursalID    INT            NOT NULL,
    CONSTRAINT PK_Cuenta       PRIMARY KEY (CuentaID),
    CONSTRAINT FK_Cta_Cliente  FOREIGN KEY (ClienteDNI)
        REFERENCES Cliente(ClienteDNI),
    CONSTRAINT FK_Cta_Suc     FOREIGN KEY (SucursalID)
        REFERENCES Sucursal(SucursalID),
    CONSTRAINT CHK_Saldo      CHECK (SaldoActual >= 0),
    CONSTRAINT CHK_Tipo       CHECK (TipoCuenta IN ('Ahorro','Corriente')),
    CONSTRAINT CHK_Estado     CHECK (EstadoCuenta IN ('ACTIVA','INACTIVA'))
);

-- Tabla de Transaccion
CREATE TABLE Transaccion (
    MovimientoID     INT           NOT NULL AUTO_INCREMENT,
    TransferenciaID  VARCHAR(20)   NULL,
    Fecha            DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TipoTransaccion  VARCHAR(30)   NOT NULL,
    Monto            DECIMAL(15,2) NOT NULL,
    Descripcion      VARCHAR(255)  NULL,
    CuentaID         INT           NOT NULL,
    EmpleadoID       INT           NOT NULL,
    CONSTRAINT PK_Transaccion    PRIMARY KEY (MovimientoID),
    CONSTRAINT FK_Tx_Cuenta      FOREIGN KEY (CuentaID)
        REFERENCES Cuenta(CuentaID),
    CONSTRAINT FK_Tx_Empleado    FOREIGN KEY (EmpleadoID)
        REFERENCES Empleado(EmpleadoID),
    CONSTRAINT CHK_TipoTx        CHECK (TipoTransaccion IN
        ('DEPOSITO','RETIRO','TRANSFERENCIA_SALIDA','TRANSFERENCIA_ENTRADA')),
    CONSTRAINT CHK_Monto         CHECK (Monto > 0)
);