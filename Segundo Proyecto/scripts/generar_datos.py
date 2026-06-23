import csv
import random
from datetime import datetime, timedelta
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
DATA_DIR.mkdir(exist_ok=True)


def escribir_csv(nombre_archivo, encabezados, filas):
    ruta = DATA_DIR / nombre_archivo
    with open(ruta, "w", newline="", encoding="utf-8") as archivo:
        writer = csv.writer(archivo)
        writer.writerow(encabezados)
        writer.writerows(filas)
    print(f"Archivo generado: {ruta}")

def fecha_aleatoria(inicio="2024-01-01", fin="2026-06-22"):
    fecha_inicio = datetime.strptime(inicio, "%Y-%m-%d")
    fecha_fin = datetime.strptime(fin, "%Y-%m-%d")
    dias = (fecha_fin - fecha_inicio).days
    return (fecha_inicio + timedelta(days=random.randint(0, dias))).strftime("%Y-%m-%d")

# NODOS
paises = ["Guatemala", "México", "El Salvador", "Honduras", "Costa Rica", "Colombia", "Argentina", "España"]
rangos_precios = ["Bajo", "Medio", "Alto"]
nacionalidades = ["Guatemalteca", "Mexicana", "Italiana", "Francesa", "Japonesa", "Peruana", "Española"]
tipos_cocina = [
    "Guatemalteca", "Mexicana", "Italiana", "Japonesa", "China",
    "Peruana", "Española", "Francesa", "Mediterránea", "Vegetariana",
    "Vegana", "Mariscos", "Parrillada", "Comida Rápida", "Postres"
]

usuarios = [
    [i, f"Usuario {i}", f"usuario{i}@correo.com", random.randint(18, 65), random.choice(paises)]
    for i in range(1, 501)
]

restaurantes = [
    [
        i,
        f"Restaurante {i}",
        random.randint(1990, 2025),
        random.choice(rangos_precios),
        f"Descripción del restaurante {i}"
    ]
    for i in range(1, 201)
]

chefs = [
    [
        i,
        f"Chef {i}",
        fecha_aleatoria("1965-01-01", "2000-12-31"),
        random.choice(nacionalidades)
    ]
    for i in range(1, 101)
]

platillos = [
    [
        i,
        f"Platillo {i}",
        round(random.uniform(25, 180), 2),
        f"Descripción del platillo {i}"
    ]
    for i in range(1, 51)
]

tipos = [
    [i, tipos_cocina[i - 1], f"Descripción de cocina {tipos_cocina[i - 1]}"]
    for i in range(1, 16)
]

# RELACIONES
califico = []
for i in range(1, 1201):
    califico.append([
        random.randint(1, 500),
        random.randint(1, 200),
        random.randint(1, 5),
        fecha_aleatoria(),
        f"Comentario de calificación {i}"
    ])

visito = []
for i in range(1, 1601):
    visito.append([
        random.randint(1, 500),
        random.randint(1, 200),
        fecha_aleatoria(),
        round(random.uniform(40, 500), 2),
        random.choice(["true", "false"])
    ])

amistades = set()
while len(amistades) < 900:
    u1 = random.randint(1, 500)
    u2 = random.randint(1, 500)
    if u1 != u2:
        amistades.add(tuple(sorted((u1, u2))))

amistades = [
    [u1, u2, fecha_aleatoria()]
    for u1, u2 in amistades
]

pertenece_a = set()
while len(pertenece_a) < 350:
    pertenece_a.add((random.randint(1, 200), random.randint(1, 15)))

pertenece_a = [
    [id_restaurante, id_tipo_cocina]
    for id_restaurante, id_tipo_cocina in pertenece_a
]

ofrece = set()
while len(ofrece) < 800:
    ofrece.add((random.randint(1, 200), random.randint(1, 50)))

ofrece = [
    [
        id_restaurante,
        id_platillo,
        round(random.uniform(30, 220), 2),
        random.choice(["true", "false"])
    ]
    for id_restaurante, id_platillo in ofrece
]

prepara = set()
while len(prepara) < 350:
    prepara.add((random.randint(1, 100), random.randint(1, 50)))

prepara = [
    [
        id_chef,
        id_platillo,
        random.choice(["Tradicional", "Moderno", "Fusión", "Gourmet"]),
        random.choice(["Entrada", "Plato fuerte", "Postre", "Especialidad de la casa"])
    ]
    for id_chef, id_platillo in prepara
]

trabaja_en = set()
while len(trabaja_en) < 250:
    trabaja_en.add((random.randint(1, 100), random.randint(1, 200)))

trabaja_en = [
    [
        id_chef,
        id_restaurante,
        fecha_aleatoria("2015-01-01", "2026-06-22"),
        random.choice(["Chef principal", "Sous chef", "Chef ejecutivo", "Chef invitado"])
    ]
    for id_chef, id_restaurante in trabaja_en
]

le_gusta = set()
while len(le_gusta) < 1000:
    le_gusta.add((random.randint(1, 500), random.randint(1, 15)))

le_gusta = [
    [
        id_usuario,
        id_tipo_cocina,
        random.randint(1, 5)
    ]
    for id_usuario, id_tipo_cocina in le_gusta
]

# Generar archivos CSV
escribir_csv("usuarios.csv", ["id_usuario", "nombre", "email", "edad", "pais"], usuarios)
escribir_csv("restaurantes.csv", ["id_restaurante", "nombre", "anio_apertura", "rango_precios", "descripcion"], restaurantes)
escribir_csv("chefs.csv", ["id_chef", "nombre", "fecha_nacimiento", "nacionalidad"], chefs)
escribir_csv("platillos.csv", ["id_platillo", "nombre", "precio", "descripcion"], platillos)
escribir_csv("tipos_cocina.csv", ["id_tipo_cocina", "nombre", "descripcion"], tipos)

escribir_csv("califico.csv", ["id_usuario", "id_restaurante", "puntuacion", "fecha", "comentario"], califico)
escribir_csv("visito.csv", ["id_usuario", "id_restaurante", "fecha_visita", "consumo", "con_reserva"], visito)
escribir_csv("amistades.csv", ["id_usuario_1", "id_usuario_2", "fecha_amistad"], amistades)
escribir_csv("pertenece_a.csv", ["id_restaurante", "id_tipo_cocina"], pertenece_a)
escribir_csv("ofrece.csv", ["id_restaurante", "id_platillo", "precio", "disponible"], ofrece)
escribir_csv("prepara.csv", ["id_chef", "id_platillo", "estilo", "especialidad"], prepara)
escribir_csv("trabaja_en.csv", ["id_chef", "id_restaurante", "fecha_inicio", "puesto"], trabaja_en)
escribir_csv("le_gusta.csv", ["id_usuario", "id_tipo_cocina", "nivel_interes"], le_gusta)

print("Generación de datos completada correctamente.")