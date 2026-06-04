import pandas as pd
import mysql.connector
from mysql.connector import Error

# Conexión a la base de datos MySQL
DB_CONFIG = {
    'host': 'localhost',
    'port': 3307,
    'user': 'root',
    'password': 'banco1234',
    'database': 'BancoDB'
}

# Ruta donde estan los csvs
PATH_CLIENTES = '../datos/clientes_raw.csv'
PATH_SUCURSALES = '../datos/sucursales_raw.csv'
PATH_EMPLEADOS = '../datos/empleados_raw.csv'
PATH_CUENTAS = '../datos/cuentas_raw.csv'
PATH_TRANSACC = '../datos/transacciones_raw.csv'

def conectar():
    try:
        conexion = mysql.connector.connect(**DB_CONFIG)
        print("Conexión exitosa a la base de datos")
        return conexion
    except Error as e:
        print(f"Error al conectar a la base de datos: {e}")
        return None

def migrar_sucursales(cursor):
    print("\n Migrando sucursales...")
    df = pd.read_csv(PATH_SUCURSALES)

    # Quitar duplicados por SucursalID, solo se queda con el primero
    df = df.drop_duplicates(subset=['SucursalID'], keep='first')
    df.columns = df.columns.str.strip()  # Eliminar espacios en los nombres de las columnas

    # Insertar o actualizar cada sucursal en la base de datos
    sql = """
        INSERT INTO Sucursal (SucursalID, Nombre, Direccion, Telefono)
        VALUES (%s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            Nombre = VALUES(Nombre),
            Direccion = VALUES(Direccion),
            Telefono = VALUES(Telefono)
    """

    # Crear una lista de tuplas con los datos de las sucursales
    # sirve para pasarle a executemany, que es más eficiente que ejecutar una por una
    registros = [
        (row['SucursalID'], row['SucursalNombre'], row['SucursalDireccion'], str(row['SucursalTelefono']))
        for _, row in df.iterrows()
    ]
    # Ejecutar la consulta para insertar o actualizar las sucursales todas las veces en una sola llamada
    cursor.executemany(sql, registros)
    print(f"Se han insertado o actualizado {cursor.rowcount} sucursales.")

def migrar_clientes(cursor):
    print("\n Migrando clientes...")
    df = pd.read_csv(PATH_CLIENTES)
    df = df.drop_duplicates(subset=['ClienteDNI'], keep='first')
    df.columns = df.columns.str.strip()

    sql = """
        INSERT INTO Cliente (ClienteDNI, Nombre, FechaNacimiento, Direccion, Telefono, Correo)
        VALUES (%s, %s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            Nombre          = VALUES(Nombre),
            FechaNacimiento = VALUES(FechaNacimiento),
            Direccion       = VALUES(Direccion),
            Telefono        = VALUES(Telefono),
            Correo          = VALUES(Correo)
    """
    registros = [
        (str(row['ClienteDNI']), row['ClienteNombre'], row['ClienteFechaNacimiento'], row['ClienteDireccion'], str(row['ClienteTelefono']), row['ClienteCorreo'])
        for _, row in df.iterrows()
    ]

    cursor.executemany(sql, registros)
    print(f"Se han insertado o actualizado {cursor.rowcount} clientes.")

def migrar_empleados(cursor):
    print("\n Migrando empleados...")
    df = pd.read_csv(PATH_EMPLEADOS)
    df = df.drop_duplicates(subset=['EmpleadoID'], keep='first')
    df.columns = df.columns.str.strip()

    sql = """
        INSERT INTO Empleado (EmpleadoID, Nombre, Cargo, SucursalID)
        VALUES (%s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            Nombre     = VALUES(Nombre),
            Cargo      = VALUES(Cargo),
            SucursalID = VALUES(SucursalID)
    """

    registros = [
        (row['EmpleadoID'], row['EmpleadoNombre'],
         row['EmpleadoCargo'], row['SucursalID'])
        for _, row in df.iterrows()
    ]
    cursor.executemany(sql, registros)
    print(f"Se han insertado o actualizado {cursor.rowcount} empleados.")

def migrar_cuentas(cursor):
    print("\n Migrando cuentas...")
    df = pd.read_csv(PATH_CUENTAS)

    # Quitar duplicados por CuentaID, solo se queda con el mas reciente 
    df = df.drop_duplicates(subset=['CuentaID'], keep='last')
    df.columns = df.columns.str.strip()

    sql = """
        INSERT INTO Cuenta (CuentaID, TipoCuenta, FechaApertura,
                            SaldoActual, EstadoCuenta, ClienteDNI, SucursalID)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            TipoCuenta   = VALUES(TipoCuenta),
            SaldoActual  = VALUES(SaldoActual),
            EstadoCuenta = VALUES(EstadoCuenta)
    """

    registros = [
        (row['CuentaID'], row['TipoCuenta'], row['FechaApertura'],
         float(row['SaldoActual']), row['EstadoCuenta'],
         str(row['ClienteDNI']), row['SucursalID'])
        for _, row in df.iterrows()
    ]
    cursor.executemany(sql, registros)
    print(f"Se han insertado o actualizado {cursor.rowcount} cuentas.")

def migrar_transacciones(cursor):
    print("\n Migrando transacciones...")
    df = pd.read_csv(PATH_TRANSACC)
    df.columns = df.columns.str.strip()

    df = df.drop_duplicates(
        subset=['Fecha', 'TipoTransaccion', 'Monto', 'CuentaID', 'EmpleadoID'],
        keep='first'
    )

    registros = []
    for _, row in df.iterrows():
        # convertir nan a None para evitar errores al insertar en la base de datos
        def limpiar(val):
            try:
                if pd.isna(val):
                    return None
            except Exception:
                pass
            return val

        transferencia_id = limpiar(row['TransferenciaID'])
        descripcion      = limpiar(row['Descripcion'])

        registros.append((
            transferencia_id,
            row['Fecha'],
            row['TipoTransaccion'],
            float(row['Monto']),
            descripcion,
            int(row['CuentaID']),
            int(row['EmpleadoID'])
        ))

    sql = """
        INSERT INTO Transaccion (TransferenciaID, Fecha, TipoTransaccion,
                                 Monto, Descripcion, CuentaID, EmpleadoID)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    cursor.executemany(sql, registros)
    print(f"Se han insertado {cursor.rowcount} transacciones.")

def main():
    conexion = conectar()
    cursor = conexion.cursor()

    try:
        # El orden importa por las foreign keys
        migrar_sucursales(cursor)
        migrar_clientes(cursor)
        migrar_empleados(cursor)
        migrar_cuentas(cursor)
        migrar_transacciones(cursor)

        conexion.commit()
        print("\nMigración de datos completada exitosamente.")

    except Error as e:
        conexion.rollback()
        print(f"Error durante la migración: {e}")
        raise

    finally:
        cursor.close()
        conexion.close()
        print("Conexión a la base de datos cerrada.")

if __name__ == "__main__":
    main()
