@echo off
echo ==== Iniciando carga de datos SQL + Python para Pokémon ====

setlocal enabledelayedexpansion

REM ---------- POSTGRES ----------
set FIRST_RUN=1
echo [PostgreSQL] Ejecutando archivos SQL...
for %%F in (init views functions procedures triggers indexes hashing) do (
    echo [PostgreSQL] %%F.sql
    docker cp postgres/%%F.sql pokemon_postgres:/tmp/%%F.sql
    docker exec pokemon_postgres sh -c "PGPASSWORD=wendy1105 psql -U postgres -d pokemon_db -f /tmp/%%F.sql" 1>nul
    if "!FIRST_RUN!"=="1" (
        echo [PostgreSQL] Ejecutando init_data.py...
        python postgres/init_data.py
        set FIRST_RUN=0
    )
)

REM ---------- MYSQL ----------
set FIRST_RUN=1
echo [MySQL] Ejecutando archivos SQL...
for %%F in (init views functions procedures triggers indexes hashing) do (
    echo [MySQL] %%F.sql
    docker cp mysql/%%F.sql pokemon_mysql:/tmp/%%F.sql
    docker exec -i pokemon_mysql bash -c "mysql -u root -pwendy0511 pokemon_db < /tmp/%%F.sql 1>nul 2>&1"
    if "!FIRST_RUN!"=="1" (
        echo [MySQL] Ejecutando init_data.py...
        python mysql/init_data.py
        set FIRST_RUN=0
    )
)

echo ==== ✅ Carga SQL + Datos finalizada ====
pause