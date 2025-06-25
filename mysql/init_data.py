import mysql.connector
from faker import Faker
import random
import json

fake = Faker('es_ES')

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="wendy0511",
    database="pokemon_db",
    port=3307
)
cur = conn.cursor()

NUM_TRAINERS = 500
NUM_BATTLES = 200
NUM_MOVES = 1000
NUM_COMMENTS = 500
NUM_TRANSACTIONS = 1000

print("Iniciando generación de datos...")
print("Limpiando tablas...")
tables_to_clear = ['logs_json', 'battle_history', 'transactions', 'items', 'battle_comments', 'moves']
for table in tables_to_clear:
    cur.execute(f"DELETE FROM {table}")
conn.commit()

print("Insertando items...")
item_types = ['PokeBall', 'Potion', 'Revive']
for _ in range(NUM_TRAINERS):
    details = {
        "quantity": random.randint(1, 5),
        "rarity": random.choice(['Common', 'Uncommon', 'Rare'])
    }
    cur.execute("""
        INSERT INTO items (id_trainer, item_type, details, active)
        VALUES (%s, %s, %s, %s)
    """, (
        random.randint(1, NUM_TRAINERS),
        random.choice(item_types),
        json.dumps(details),
        1
    ))

print("Insertando movimientos...")
move_names = ['Thunderbolt', 'Flamethrower', 'Hydro Pump']
for _ in range(NUM_MOVES):
    cur.execute("""
        INSERT INTO moves (id_battle, move_name, power, status)
        VALUES (%s, %s, %s, %s)
    """, (
        random.randint(1, NUM_BATTLES),
        random.choice(move_names),
        random.randint(40, 120),
        1
    ))

print("Insertando comentarios...")
comments_inserted = set()
attempts = 0

while len(comments_inserted) < NUM_COMMENTS and attempts < NUM_COMMENTS * 5:
    id_trainer = random.randint(1, NUM_TRAINERS)
    id_battle = random.randint(1, NUM_BATTLES)

    if (id_trainer, id_battle) in comments_inserted:
        attempts += 1
        continue

    comments_inserted.add((id_trainer, id_battle))
    cur.execute("""
        INSERT INTO battle_comments (id_trainer, id_battle, comment)
        VALUES (%s, %s, %s)
    """, (
        id_trainer, id_battle,
        fake.sentence()
    ))


print("Insertando historial de batallas...")
for _ in range(NUM_TRAINERS // 2):
    history = {
        "total_battles": random.randint(1, 50),
        "total_wins": random.randint(0, 25),
        "favorite_pokemon": random.choice(['Pikachu', 'Charizard', 'Gengar']),
        "win_streak": random.randint(0, 10),
        "best_streak": random.randint(1, 20)
    }
    cur.execute("""
        INSERT INTO battle_history (id_trainer, history)
        VALUES (%s, %s)
    """, (random.randint(1, NUM_TRAINERS), json.dumps(history)))

print("Insertando logs del sistema...")
log_types = ['battle_started', 'item_used', 'system_error']
for _ in range(300):
    log_type = random.choice(log_types)
    if log_type == 'system_error':
        data = {
            "error": fake.sentence(),
            "module": random.choice(['battles', 'items']),
            "severity": random.choice(['low', 'medium', 'high'])
        }
    else:
        data = {
            "trainer_id": random.randint(1, NUM_TRAINERS),
            "info": fake.sentence()
        }
    cur.execute("""
        INSERT INTO logs_json (log_type, data)
        VALUES (%s, %s)
    """, (log_type, json.dumps(data)))

print("Insertando transacciones...")
transaction_types = ['Purchase', 'Reward']
for _ in range(NUM_TRANSACTIONS):
    cur.execute("""
        INSERT INTO transactions (id_trainer, transaction_type, amount, status)
        VALUES (%s, %s, %s, %s)
    """, (
        random.randint(1, NUM_TRAINERS),
        random.choice(transaction_types),
        round(random.uniform(10, 500), 2),
        random.choice(['Completed', 'Pending'])
    ))

conn.commit()
cur.close()
conn.close()
print("¡Datos generados exitosamente!")
