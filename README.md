# proyecto_base_datos

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

4. **Inicializar base de datos**
```bash
./init_data.bat
```


## 👥 Equipo

- Wendy Evelyn Cáceres Vasquez
- Ivan Iver Poma Maidana
