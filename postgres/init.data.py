import psycopg2
from faker import Faker
import random
from datetime import datetime, timedelta
import json

fake = Faker('es_ES')
conn = psycopg2.connect(
    host="127.0.0.1",
    database="pokedb",
    user="postgres",
    password="postgres" ,
    port=5432 

)
cur = conn.cursor()

NUM_TRAINERS = 5000
NUM_BATTLES = 800
NUM_MOVES = 3200
NUM_BADGES = 30000
NUM_POKEMON = 200
NUM_SPONSORS = 50
NUM_ROLES = 3
NUM_TOURNAMENTS = 10
NUM_TRANSACTIONS = 15000
NUM_COMMENTS = 5000

print("Iniciando generación de datos para Pokémon...")

print("Limpiando datos existentes...")
tables_to_clear = [
    'logs_json', 'battle_history', 'battle_sponsors', 'sponsors',
    'battle_pokemon', 'pokemon', 'transactions', 'badges', 'moves',
    'battle_comments', 'battle_tournaments', 'battles', 'tournaments',
    'items', 'trainer_role', 'roles', 'trainers'
]

for table in tables_to_clear:
    cur.execute(f"TRUNCATE TABLE {table} RESTART IDENTITY CASCADE")

print("Insertando roles...")
roles = ['admin', 'trainer', 'gym_leader']
for role in roles:
    cur.execute("INSERT INTO roles (role_name) VALUES (%s)", (role,))

print("Insertando torneos...")
tournaments = ['Kanto League', 'Johto Cup', 'Hoenn Championship', 'Sinnoh Tournament',
               'Unova Challenge', 'Kalos Masters', 'Alola League', 'Galar Cup',
               'Paldea Open', 'World Championship']
tournament_ids = []
for tournament in tournaments:
    cur.execute("INSERT INTO tournaments (name) VALUES (%s) RETURNING id_tournament", (tournament,))
    tournament_ids.append(cur.fetchone()[0])

print(f"Insertando {NUM_TRAINERS} entrenadores...")
trainer_ids = []
for i in range(NUM_TRAINERS):
    if i % 1000 == 0:
        print(f"  Entrenadores: {i}/{NUM_TRAINERS}")
    cur.execute("""
        INSERT INTO trainers (name, email, password, poke_coins, active)
        VALUES (%s, %s, %s, %s, %s) RETURNING id_trainer
    """, (
        fake.name(),
        fake.unique.email(),
        fake.sha256(),
        round(random.uniform(100, 5000), 2),
        random.choice([True, True, True, False])
    ))
    trainer_ids.append(cur.fetchone()[0])

print("Asignando roles a entrenadores...")
for trainer_id in trainer_ids:
    num_roles = random.choices([1, 2], weights=[85, 15])[0]
    roles_assigned = random.sample(range(1, len(roles) + 1), num_roles)
    for role_id in roles_assigned:
        cur.execute("""
            INSERT INTO trainer_role (id_trainer, id_role) 
            VALUES (%s, %s) ON CONFLICT DO NOTHING
        """, (trainer_id, role_id))

print("Insertando ítems...")
item_types = ['PokeBall', 'GreatBall', 'UltraBall', 'Potion', 'SuperPotion', 'Revive']
for _ in range(NUM_TRAINERS // 2):
    trainer_id = random.choice(trainer_ids)
    item_type = random.choice(item_types)
    details = {
        "quantity": random.randint(1, 10),
        "rarity": random.choice(['Common', 'Uncommon', 'Rare'])
    }
    cur.execute("""
        INSERT INTO items (id_trainer, item_type, details, active)
        VALUES (%s, %s, %s, %s)
    """, (trainer_id, item_type, json.dumps(details), random.choice([True, True, False])))
print(f"Insertando {NUM_POKEMON} Pokémon...")
pokemon_ids = []
pokemon_names = ['Pikachu', 'Bulbasaur', 'Charmander', 'Squirtle', 'Eevee', 'Snorlax',
                 'Gengar', 'Dragonite', 'Mewtwo', 'Charizard', 'Blastoise', 'Venusaur']
pokemon_types = ['Electric', 'Grass/Poison', 'Fire', 'Water', 'Normal', 'Ghost/Poison',
                 'Dragon/Flying', 'Psychic', 'Fire/Flying', 'Water', 'Grass/Poison','Fire/Flying']
for i in range(NUM_POKEMON):
    if i % 50 == 0:
        print(f"  Pokémon: {i}/{NUM_POKEMON}")
    pokemon_idx = random.randint(0, len(pokemon_names) - 1)
    cur.execute("""
        INSERT INTO pokemon (name, type, level, sprite_url, capture_date, active)
        VALUES (%s, %s, %s, %s, %s, %s) RETURNING id_pokemon
    """, (
        pokemon_names[pokemon_idx],
        pokemon_types[pokemon_idx],
        random.randint(1, 100),
        fake.image_url(width=200, height=200),
        fake.date_between(start_date='-5y', end_date='today'),
        random.choice([True, True, True, False])
    ))
    pokemon_ids.append(cur.fetchone()[0])
print(f"Insertando {NUM_SPONSORS} patrocinadores...")
sponsor_ids = []
sponsor_names = ['Silph Co.', 'PokéMart', 'Devon Corp.', 'Macro Cosmos', 'Aether Foundation']
for i in range(NUM_SPONSORS):
    cur.execute("""
        INSERT INTO sponsors (name, logo_url, website, contact_email, active)
        VALUES (%s, %s, %s, %s, %s) RETURNING id_sponsor
    """, (
        random.choice(sponsor_names) if i < len(sponsor_names) else fake.company(),
        fake.image_url(width=300, height=100),
        fake.url(),
        fake.company_email(),
        random.choice([True, True, False])
    ))
    sponsor_ids.append(cur.fetchone()[0])
print(f"Insertando {NUM_BATTLES} batallas...")
battle_ids = []
move_ids = []
battle_types = ['Gym', 'Wild', 'Tournament', 'Friendly']
battle_statuses = ['Scheduled', 'In Progress', 'Completed', 'Canceled']
move_names = ['Thunderbolt', 'Flamethrower', 'Hydro Pump', 'Solar Beam', 'Shadow Ball', 'Dragon Claw']

for i in range(NUM_BATTLES):
    if i % 100 == 0:
        print(f"  Batallas: {i}/{NUM_BATTLES}")
    status = random.choices(battle_statuses, weights=[40, 10, 45, 5])[0]
    battle_type = random.choice(battle_types)
    if status == 'Scheduled':
        battle_date = fake.future_datetime(end_date="+60d")
    elif status == 'In Progress':
        battle_date = fake.date_time_between(start_date='-1h', end_date='+2h')
    else:
        battle_date = fake.past_datetime(start_date='-30d')
    result = {"winner": random.choice(trainer_ids)} if status == 'Completed' else {}
    cur.execute("""
        INSERT INTO battles (battle_name, battle_type, battle_date, result, status)
        VALUES (%s, %s, %s, %s, %s) RETURNING id_battle
    """, (
        f"{battle_type} Battle - {fake.city()}",
        battle_type,
        battle_date,
        json.dumps(result),
        status
    ))
    battle_id = cur.fetchone()[0]
    battle_ids.append(battle_id)
    tournament_id = random.choice(tournament_ids)
    cur.execute("""
        INSERT INTO battle_tournaments (id_tournament, id_battle)
        VALUES (%s, %s)
    """, (tournament_id, battle_id))
    pokemon_in_battle = random.sample(pokemon_ids, 2)
    for idx, pokemon_id in enumerate(pokemon_in_battle):
        hp = random.randint(50, 100) if status != 'Completed' else random.randint(0, 100)
        cur.execute("""
            INSERT INTO battle_pokemon (id_battle, id_pokemon, is_trainer1, hp_remaining)
            VALUES (%s, %s, %s, %s)
        """, (battle_id, pokemon_id, idx == 0, hp))
    if random.random() < 0.3:
        num_sponsors = random.randint(1, 3)
        battle_sponsors = random.sample(sponsor_ids, min(num_sponsors, len(sponsor_ids)))
        for sponsor_id in battle_sponsors:
            cur.execute("""
                INSERT INTO battle_sponsors (id_battle, id_sponsor, sponsorship_type, amount,
                                            logo_position, start_date, end_date)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (
                battle_id, sponsor_id,
                random.choice(['Main Sponsor', 'Prize Sponsor', 'Official Partner']),
                round(random.uniform(1000, 50000), 2),
                random.choice(['Arena Banner', 'Trophy', 'Screen']),
                battle_date.date() - timedelta(days=random.randint(1, 30)),
                battle_date.date() + timedelta(days=random.randint(1, 10))
            ))
    num_moves = random.randint(3, 6)
    moves_used = random.sample(move_names, min(num_moves, len(move_names)))
    for move_name in moves_used:
        cur.execute("""
            INSERT INTO moves (id_battle, move_name, power, status)
            VALUES (%s, %s, %s, %s) RETURNING id_move
        """, (
            battle_id, move_name, random.randint(50, 120),
            True if status in ['Scheduled', 'In Progress'] else random.choice([True, False])
        ))
        move_ids.append(cur.fetchone()[0])

print(f"Insertando {NUM_COMMENTS} comentarios...")
comments_examples = [
    "¡Qué batalla épica!", "Este Pokémon es increíble", "Gran estrategia del entrenador",
    "¡Vamos por la victoria!", "Esa movida fue clave", "El rival se ve fuerte",
    "¡Necesitamos más acción!", "Qué combate tan reñido", "¡Gran trabajo!"
]
comments_inserted = set()
for i in range(NUM_COMMENTS):
    if i % 1000 == 0:
        print(f"  Comentarios: {i}/{NUM_COMMENTS}")
    max_attempts = 10
    for _ in range(max_attempts):
        trainer_id = random.choice(trainer_ids)
        battle_id = random.choice(battle_ids)
        if (trainer_id, battle_id) not in comments_inserted:
            comments_inserted.add((trainer_id, battle_id))
            break
    else:
        continue
    cur.execute("""
        INSERT INTO battle_comments (id_trainer, id_battle, comment)
        VALUES (%s, %s, %s)
    """, (
        trainer_id, battle_id,
        random.choice(comments_examples) + " " + fake.sentence()
    ))

print(f"Insertando {NUM_BADGES} insignias...")
badge_names = ['Boulder Badge', 'Cascade Badge', 'Thunder Badge', 'Rainbow Badge',
               'Soul Badge', 'Marsh Badge', 'Volcano Badge', 'Earth Badge']
badge_statuses = ['Earned', 'Pending', 'Failed']
for i in range(NUM_BADGES):
    if i % 5000 == 0:
        print(f"  Insignias: {i}/{NUM_BADGES}")
    battle_id = random.choice(battle_ids)
    trainer_id = random.choice(trainer_ids)
    cur.execute("SELECT status FROM battles WHERE id_battle = %s", (battle_id,))
    battle_status = cur.fetchone()[0]
    badge_status = 'Earned' if battle_status == 'Completed' else random.choice(badge_statuses)
    cur.execute("""
        INSERT INTO badges (id_trainer, id_battle, badge_name, status)
        VALUES (%s, %s, %s, %s)
    """, (
        trainer_id, battle_id, random.choice(badge_names), badge_status
    ))

print(f"Insertando {NUM_TRANSACTIONS} transacciones...")
transaction_types = ['Purchase', 'Reward', 'Entry Fee', 'Gift']
transaction_statuses = ['Completed', 'Pending', 'Failed', 'Canceled']
for i in range(NUM_TRANSACTIONS):
    if i % 2000 == 0:
        print(f"  Transacciones: {i}/{NUM_TRANSACTIONS}")
    trans_type = random.choice(transaction_types)
    amount = round(random.uniform(50, 1000), 2) if trans_type == 'Purchase' else round(random.uniform(10, 500), 2)
    status = random.choices(transaction_statuses, weights=[80, 10, 7, 3])[0]
    cur.execute("""
        INSERT INTO transactions (id_trainer, transaction_type, amount, status)
        VALUES (%s, %s, %s, %s)
    """, (
        random.choice(trainer_ids), trans_type, amount, status
    ))

print("Insertando historial de batallas...")
for trainer_id in random.sample(trainer_ids, NUM_TRAINERS // 3):
    history = {
        "total_battles": random.randint(1, 100),
        "total_wins": random.randint(0, 50),
        "favorite_pokemon": random.choice(pokemon_names),
        "win_streak": random.randint(-5, 10),
        "best_streak": random.randint(1, 15)
    }
    cur.execute("""
        INSERT INTO battle_history (id_trainer, history)
        VALUES (%s, %s)
    """, (trainer_id, json.dumps(history)))

print("Insertando logs del sistema...")
log_types = ['battle_started', 'item_used', 'badge_earned', 'transaction', 'system_error']
for _ in range(1000):
    log_type = random.choice(log_types)
    if log_type == 'battle_started':
        data = {
            "trainer_id": random.choice(trainer_ids),
            "battle_id": random.choice(battle_ids),
            "pokemon_used": random.choice(pokemon_names)
        }
    elif log_type == 'item_used':
        data = {
            "trainer_id": random.choice(trainer_ids),
            "item_type": random.choice(item_types),
            "battle_id": random.choice(battle_ids)
        }
    elif log_type == 'badge_earned':
        data = {
            "trainer_id": random.choice(trainer_ids),
            "badge_name": random.choice(badge_names)
        }
    elif log_type == 'transaction':
        data = {
            "trainer_id": random.choice(trainer_ids),
            "amount": round(random.uniform(10, 500), 2),
            "type": random.choice(transaction_types)
        }
    else: 
        data = {
            "error": fake.sentence(),
            "module": random.choice(['battles', 'items', 'trainers', 'transactions']),
            "severity": random.choice(['low', 'medium', 'high', 'critical'])
        }
    cur.execute("""
        INSERT INTO logs_json (log_type, data)
        VALUES (%s, %s)
    """, (log_type, json.dumps(data)))

print("Confirmando transacciones...")
conn.commit()
cur.close()
conn.close()

print("¡Datos generados exitosamente!")
print(f"""
Resumen de datos generados:
- Entrenadores: {NUM_TRAINERS}
- Batallas: {NUM_BATTLES}
- Movimientos: {len(move_ids)}
- Insignias: {NUM_BADGES}
- Pokémon: {NUM_POKEMON}
- Patrocinadores: {NUM_SPONSORS}
- Comentarios: {NUM_COMMENTS}
- Transacciones: {NUM_TRANSACTIONS}
- Torneos: {len(tournaments)}
- Roles: {len(roles)}
""")