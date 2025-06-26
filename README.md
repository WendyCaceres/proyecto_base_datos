# 🏆 PokeData League

Sistema de base de datos avanzado para gestionar la Liga Pokémon. Este proyecto crea un entorno competitivo donde los entrenadores libran batallas épicas, coleccionan insignias y gestionan PokéCoins para alcanzar la cima. ¡Prepárate para el desafío definitivo!

## 📚 Documentación

### 🏗️ Arquitectura
- Arquitectura basada en PostgreSQL con particiones para escalabilidad.
- Diseño relacional optimizado para soportar hasta 30,000 transacciones, reflejando la intensidad de un torneo Pokémon global

## ⚙️ Tecnologías

- PostgreSQL 15
- MongoDB
- Redis
- Docker & Docker Compose
- Python (Faker)
- Node.js

## 🚀 Inicio Rápido

1. **Clonar el repositorio**
```bash
git clone <repo-url>
cd proyecto-base-datos
```

3. **Levantar servicios**
```bash
docker-compose up -d
```

4.**Llenado de datos**
MySQL
```bash
cd .\mysql\
cd .\scripts\
node .\restoreDb.js
```

Postgres
```bash
cd .\postgres\
cd .\scripts\
node .\restoreDb.js
```

MongoDB
```bash
cd .\mongodb\
node .\mongoSeed.js
```

ETL 
```bash
docker exec -it etl_service bash
node etl_script.js
```

4. **Inicializar base de datos**
```bash
./init_data.bat
```


## 👥 Equipo

- Wendy Evelyn Cáceres Vasquez
- Ivan Iver Poma Maidana
