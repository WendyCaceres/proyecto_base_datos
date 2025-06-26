### UNIVERSIDAD PRIVADA BOLIVIANA

### LA PAZ

### FACULTAD DE INGENIERÍA Y ARQUITECTURA

## Proyecto Final Base de Datos Avanzada

**POKEDATA LEAGUE**

**Estudiantes:**

Wendy Evelyn Cáceres Vasquez - 68874

Ivan Iver Poma Maidana - 70419

### Docente: Paul Landaeta

## La Paz – Bolivia – Junio de 2025


## Índice


- Abstract...................................................................................................................................
- 1. Introducción.......................................................................................................................
- 2. Objetivos.............................................................................................................................
   - Objetivo General................................................................................................................
   - Objetivos Específicos.........................................................................................................
- 3. Requisitos...........................................................................................................................
      - Requisitos Funcionales................................................................................................
      - Requisitos No Funcionales...........................................................................................
- 4. Diseño Conceptual.............................................................................................................
      - Modelo Entidad-Relación.............................................................................................
      - Diagrama Relacional SQL............................................................................................
      - Normalización hasta 3FN.............................................................................................
      - Diseño documental de la Base de Datos (Referencial y Embebido)............................
         - Modelo Embebido...................................................................................................
         - Modelo Referencial.................................................................................................
         - Relación entre MongoDB y PostgreSQL................................................................
      - Diagrama de flujo del ETL..........................................................................................
            - [Anexo 1 - Diagrama Flujo ETL]...............................................................
      - Diseño de la base de Base de Datos SnowFlake......................................................
            - [Anexo 2 - Diagrama SnowFlake].............................................................
- 5. Diseño de la Base de Datos............................................................................................
      - Modelo NoSQL...........................................................................................................
            - [Anexo 3 - Diseño colecciones].................................................................
      - Estructura de documentos y colecciones...................................................................
- 6. Arquitectura y Justificación Técnica.............................................................................
            - [Anexo 4 - Arquitectura Docker]................................................................
- 7. Implementación................................................................................................................
      - Funciones...................................................................................................................
      - SP...............................................................................................................................
      - Triggers......................................................................................................................
      - Views..........................................................................................................................
      - Indices........................................................................................................................
      - Transacciones ACID...................................................................................................
      - Base de datos Distribuidas.........................................................................................
      - REDIS (CACHE)........................................................................................................
            - [Anexo 5 - Diagrama Redis]......................................................................
      - Consultas MongoDB..................................................................................................
            - [Anexo 6 - Consulta MongoDB]................................................................
            - [Anexo 7- Consulta MongoDB].................................................................
            - [Anexo 8 - Consulta MongoDB]................................................................
   - Herramientas y tecnologías utilizadas........................................................................
- 8. Pruebas y Evaluación......................................................................................................
      - [Anexo 9 - Consulta Funciones]................................................................
      - [Anexo 9.1 - Consulta Funciones].............................................................
      - [Anexo 10 - Consulta Funciones]..............................................................
      - [Anexo 11 - Consulta SP]..........................................................................
      - [Anexo 12 - Consultas Triggers]...............................................................
      - [Anexo 12.1 - Consulta Triggers]..............................................................
      - [Anexo 13 - Consultas Triggers]...............................................................
      - [Anexo 14 - Consulta Views].....................................................................
      - [Anexo 15 - Consulta Views].....................................................................
      - [Anexo 16 - Indices]..................................................................................
      - [Anexo 17 -Indices]...................................................................................
- 9. Conclusiones y Recomendaciones................................................................................
- 10. Referencias.....................................................................................................................
- 11. Anexos............................................................................................................................
      - [Anexo 18 - Diagrama ELT]......................................................................


## Abstract...................................................................................................................................

El proyecto PokeData League se ocupa del desafío de administrar un ecosistema de Pokémon

dinámico, un lugar donde los entrenadores compiten en batallas y logran ganar insignias, al igual que

transacciones. El problema encontrado es garantizar que los entrenadores puedan consultar sin retrasar

el servicio, tener batallas equilibradas y activas y ver sus logros y saldos. La solución propuesta es

una base de datos MySQL y PostgreSQL que simula una Liga Pokémon digital. Las características

reutilizables se implementan para autenticar capacitadores y consultar con los créditos de Pokecoin.

Se diseñaron triggers para registrar automáticamente la creación de insignias, cambios en saldos y

resultados de batallas. Las vistas simplifican las consultas complejas, lo cual permite a los

entrenadores ver sus insignias activas, clasificaciones y batallas finalizadas con un solo comando. Los

procedimientos almacenados con manejo de excepciones garantizan operaciones seguras, como

cancelar batallas o retirar PokéCoins. En conclusión, se destaca que PokeData League ofrece una

plataforma que es robusta, segura y escalable, ideal para entornos competitivos como el mundo del

Pokémon, con potencial para expandirse a análisis de estrategias de batalla o gestión de torneos.


## 1. Introducción.......................................................................................................................

PokeData League trata de dar una experiencia competitiva, integrando una base de datos relacional

para así gestionar todas las interacciones de los entrenadores, batallas, torneos y las transacciones. Al

igual que donde todos los entrenadores llegan a competir en batallas épicas, coleccionan insignias y

gestionan recursos como los PokéCoins para llegar a la cima de la Liga Pokémon.

El universo Pokémon es un mundo gigante lleno de personas alrededor de todo el mundo, lo cual tiene
una demanda de sistemas robustos y que lleguen a soportar grandes volúmenes de datos para tener

experiencias extraordinarias. Los principales afectados son los entrenadores; ellos necesitan consultar

sus logros, clasificaciones y su saldo. Los problemas específicos encontrados son:

```
● Los entrenadores necesitan consultar sus insignias y rankings para ver y planificar las
estrategias.
● Los sistemas pueden llegar a no ser escalables, lo cual no soporta grandes cantidades de datos,
lo cual perjudica los Campeonatos Mundiales de Pokémon.
```
Con nuestra base de datos tratamos de arreglar esos problemas para hacer el universo del Pokémon un

lugar sin problemas.

## 2. Objetivos.............................................................................................................................

### Objetivo General................................................................................................................

Diseñar e implementar una base de datos para PokeData League que logre gestionar los datos de los

entrenadores, batallas, insignias y transacciones, garantizando un buen rendimiento para un entorno de
Pokémon competitivo.

### Objetivos Específicos.........................................................................................................

1. Implementar una base de datos que permita consultar datos de entrenadores, batallas e
    insignias.
2. Acceso a la información de los entrenadores como sus clasificaciones y resultados de batallas.
3. Garantizar las transacciones de PokéCoins.
4. Configurar backups y tener un backup en caso de algún problema.


## 3. Requisitos...........................................................................................................................

#### Requisitos Funcionales................................................................................................

```
Nombre Registro^ de^ entrenadores^
```
```
Nombre Autenticación de entrenadores
```
```
Nombre Visualización de batallas
```
```
Nombre Registro^ de^ transacciones^ de^ PokéCoins^
```
```
Nombre Cancelación^ de^ transacciones^
```
```
Nombre Visualización^ de^ historial^
```
```
Nombre Registro^ y^ finalización^ de^ batallas^
```
#### Requisitos No Funcionales...........................................................................................

```
Nombre Encriptación^ de^ datos^ sensibles^
```
```
Nombre Optimización^ de^ consultas^
```

```
Nombre Nombres^ claros^ en^ funciones^ y^ procedimientos^
```
```
Nombre Escalabilidad
```
## 4. Diseño Conceptual.............................................................................................................

#### Modelo Entidad-Relación.............................................................................................

Nuestras entidades principales serían: usuarios, pokemones, transacciones, batallas, eventos.
Estas relaciones entre tablas nos permiten gestionar los intercambios y batallas entre entrenadores
pokémon, ofreciendo un control de sus pokémons y saldos.

#### Diagrama Relacional SQL............................................................................................

El modelo relacional en PostgreSQL define PK en cada tabla y FK para garantizar integridad entre
entrenadores, pokemons, transacciones, batallas.


#### Normalización hasta 3FN.............................................................................................

Las tablas fueron normalizadas hasta la tercera forma Normal para eliminar las redundancias:
● 1FN: Atributos atómicos
● 2FN: Descomposición de dependencias parciales
● 3FN: Eliminación de dependencias transitivas


#### Diseño documental de la Base de Datos (Referencial y Embebido)............................

En la parte de base de datos NoSQL del proyecto Pokémon, se decidió trabajar con MongoDB
adoptando una estructura donde se combinen los documentos embebidos y las referencias entre las
colecciones.
Al momento de hacer esta combinación nos permite tener consultas más rápidas, rendimiento y
flexibilidad para manejar entidades reutilizables o crecientes como el historial o comentarios aspectos
que son esenciales para una base de datos con múltiples entidades y relaciones.
Se tuvieron que tomar en cuenta algunos factores con los cuales el MongoDB se conectaría al
Postgres en el caso de consultas. Al igual en elegir que tabla sería un modelo embebido o referencial.
Se evaluaron criterios como :
● Frecuencia de acceso a los datos
● Dependencia entre entidades
● Posibilidad de reutilización entre colecciones
● Tamaño y crecimiento proyectado de los datos

##### Modelo Embebido...................................................................................................

El modelo embebido fue usado en casos donde los datos tienen una relación jerárquica o se acceden
frecuentemente en conjunto sin necesidad de realizar múltiples consultas. Algunas colecciones que
siguen esta lógica son :
● trainer_profiles :
Contiene preferenciales visuales, logros individuales, configuración de interfaz. Estos datos son
particulares de cada entrenador, lo cual no se reutilizan y se accede a ellos constantemente cuando se
muestra el perfil.


● badge_achievements
Las insignias ganadas por un entrenador se guardan en un arreglo dentro del documento. Esto
simplifica el acceso al historial de logros. Sin necesidad de búsquedas adicionales.
● battle_comments
Son los comentarios agrupados por batalla. Como estos están ligados fuertemente a una batalla y no
necesitan accederse individualmente. Se embeben directamente en el documento.
● chat_messages
Mensajes enviados en una batalla en tiempo real. El diseño embebido permite recuperar todo el chat
de una batalla, optimizando el rendimiento.
● event_logs
Cada log contiene información relacionada con un evento, como por ejemplo la acción realizada, el
tipo del evento y su contexto. Son registros autocontenidos por lo que se gestiona como un documento
embebido.
● training_sessions
Esta colección incluye un arreglo embebido de pokémon entrenados. Dado que se accede a toda la
sesión como un bloque, embebemos los pokémon temporalmente, sin separarlos.

##### Modelo Referencial.................................................................................................

El modelo referencial se aplicó en colecciones donde los documentos pueden:
● Relacionarse con múltiples entidades
● Necesitan ser actualizados por separado
● Ser accedidos de manera independiente
● Crecer de forma significativa con el tiempo
Algunas colecciones que siguen esta lógica son :
● battle_snapshots
Esta relacionada con el id_battle a la tabla de batallas de el PostgresSQL. Donde cada snapshot
representa el estado de una batalla y esta puede crecer con el tiempo. A tenerlo como documentos
separados evitamos inflar los documentos de batallas.
● battle_ai_strategies
Vincula las estrategias por batallas. Como cada estrategia tiene múltiples pasos y puede cambiar con
el tiempo, se relaciona con el id_battle de la tabla batallas de PostgresSQL.
● marketplace_items
Son los objetos en venta tienen un seller_id referenciado dado que este puede tener un cambio de
dueño o estado (vendido, reservado). Requieren actualización frecuente sin afectar el documento del
entrenador.
● battle_tournaments
Relaciona las batallas y torneos por le id_tournament y id_battle. Esta colección permite analizar
batallas por torneo y manejar la lógica del torneo por separado.

##### Relación entre MongoDB y PostgreSQL................................................................

Las colecciones referenciales en MongoDB se conectan a PostgreSQL, a través de IDs externos como:
● id_trainer -> Tabla trainers
● id_battle -> Tabla battles
● id_tournament -> Tabla tournaments


#### Diagrama de flujo del ETL..........................................................................................

###### [Anexo 1 - Diagrama Flujo ETL]...............................................................

#### Diseño de la base de Base de Datos SnowFlake......................................................

###### [Anexo 2 - Diagrama SnowFlake].............................................................


## 5. Diseño de la Base de Datos............................................................................................

#### Modelo NoSQL...........................................................................................................

Al usar MongoDB podemos tener datos semi-estructurados y consultas frecuentes, como perfiles de
entrenadores, logs de eventos y sesiones de entrenamiento, lo cual optimiza el rendimiento en
operaciones de lectura. Las colecciones hacen un reflejo de la estructura proporcionada y las consultas
de agregación.

###### [Anexo 3 - Diseño colecciones].................................................................

#### Estructura de documentos y colecciones...................................................................

En el modelo NoSQL implementado con MongoDB, se uso para diseñar colecciones que almacenan
documentos en formato JSON, lo cual prioriza la flexibilidad y eficiencia. Al igual que permite hacer
consultas rápidas en colecciones como trainer y items mediante índices y agregaciones ($lookup,
$unwind). El modelo embebido en chat_messages y badge_achievements reduce latencia en lecturas
frecuentes, mientras que el modelo referencial en battle_tournaments evita duplicación.


## 6. Arquitectura y Justificación Técnica.............................................................................

###### [Anexo 4 - Arquitectura Docker]................................................................

**Justificación Técnica**

```
● Extracción
```
- SQL Scripts: Saca datos de PostgreSQL, MySQL y MongoDB porque son rápidos y
encajan con tus bases relacionales.

```
● Transformación
```
- Python: Procesa y calcula (ej. ganancias, usuarios activos) con librerías como Pandas,
ideal para tu variedad de datos.

```
● Carga
```
- SQL: Guarda resultados en una base de datos para reportes, usando tu infraestructura
existente.

```
● Reportes
```
- Incluye Ganancia por apuesta, Usuarios activos, Ganancias sistema vs usuarios, Apuestas
por día, Venta de ítems y Ganancia por ítems, basados en tus datos.

```
● Integración con Docker
```
- Dentro de Docker ahorra recursos, escala fácil y usa los mismos volúmenes, manteniendo
todo consistente.

```
● Beneficios
```
- Automatiza reportes, reduce errores y se adapta a tu proyecto Pokémon.


## 7. Implementación................................................................................................................

Nuestra solución se base en nuestras tablas mas importantes y las mas usadas, trainers, battles y
badges, etc las cuales usamos para la creación de todas nuestras funciones.

#### Funciones...................................................................................................................

```
● autenticar_entrenador_email_name
○ Funcion : Verifica si un entrenador existe usando su `email` y `name`.
○ Meta : Autenticar al usuario sin requerir la contraseña en texto plano.
● get_saldo_entrenador
○ Función: Devuelve el saldo de un entrenador
○ Meta: Consultar rapidamente cuanto saldo tiene un entrenador
```
#### SP...............................................................................................................................

```
● actualizar_saldo_entrenador
○ Función: Cambia el saldo (`poke_coins`) de un entrenador a un nuevo valor.
○ Meta: Mantener el saldo actualizado y registrar la transacción en una tabla de
auditoría.
● sp_retirar_poke_coins_new
○ Función: Resta un monto del saldo de un entrenador, validando que tenga fondos
suficientes.
○ Meta: Permitir retiros de PokéCoins de forma segura y controlada.
```
#### Triggers......................................................................................................................

```
● tr_validad_poke_coins_no_negativo
○ Función: Impide que se actualice un entrenador con saldo negativo.
○ Meta: Garantizar la integridad del campo `poke_coins` evitando valores inválidos.
● tr_log_resultado_batalla
○ Función: Registra en una tabla de logs JSON los cambios realizados en el resultado
de una batalla.
○ Meta: Mantener un historial de modificaciones a resultados de batallas.
```
#### Views..........................................................................................................................

```
● vistas_top_entrenadores_insignias
○ Función: Muestra los entrenadores ordenados por la cantidad de insignias que
poseen.
○ Meta: Facilitar un ranking o top de entrenadores más destacados.
● vistas_batallas_finalizadas
○ Función: Lista todas las batallas con estado `Completed` junto a sus resultados.
○ Meta: Ver rápidamente el historial de batallas finalizadas sin tener que filtrar
manualmente.
```

#### Indices........................................................................................................................

```
● idx_badges_status
○ Función: Acelera las consultas que filtran por `status` en la tabla `badges`.
○ Meta: Mejorar el rendimiento de filtros como `WHERE status = 'Activa'`.
● idx_moves_battle
○ Función: Acelera las consultas que buscan movimientos (`moves`) de una batalla
específica.
○ Meta: Optimizar el rendimiento de `SELECT * FROM moves WHERE id_battle =
?`.
```
#### Transacciones ACID...................................................................................................

En PokeData League, las propiedades ACID (Atomicidad, Consistencia, Aislamiento, Durabilidad)
que son fundamentales ya que estas garantizan la fiabilidad que se tiene dentro de las operaciones
transaccionales, y en especial uso en la parte de saldos de PokéCoins, en los resultados de batallas e
insignias que se obtiene. Lo cual hace que las transacciones lleguen a ser completas, consistentes,
seguras frente a concurrencia y persistentes.

**1. Atomicidad**

La atomicidad garantiza que las operaciones de una transacción se complete de manera exitosa y si en
algun caso llegara a fallar que se revierta.

Por ejemplo

En nuestro proyecto PokeData League la funcion que usamos es autenticar_entrenador ya que esta asi
una verificación primero para que un entrenador pueda hacer sus transacciones. Luego tenemos
sp_registrar_transaccion ya que este SP inserta una transacción a la tabla transactions y luego esto
actualiza el saldo de PokéCoins en trainers lo cual hace que el saldo del entrenador se actualice.

**2. Consistencia**

La consistencia asegura que las operaciones de una transacción que estan dentro de la base de datos
cambie su estado, es decir que de estar valido a otro.

Por ejemplo

En nuestro proyecto de PokeData League usamos get_saldo_entrenador ya que esta función la usamos
para verificar el estado actual del saldo antes de que suceda algun cambio. Luego tenemos el


sp_retirar_poke_coins este lo que hace es verificar que el monto que se quiera retirar sea positivo o
que el entrenador tenga suficiente saldo antes de actualizar el trainers.poke_coins.

**3. Aislamiento**

El aislamiento garantiza que las transacciones se logren ejecutar de una manera aislada es decir que no
haya interferencias entre las transacciones que esten ocurriendo.

Por ejemplo

En nuestro proyecto de PokeData League en get_saldo_entrenador como se dijo este consulta el saldo
del entrenador y eso lo hace de manera aislada para evitar que haya sobreescritura dentro del saldo.
Luego en el sp_registrar_transacccion esta realiza una consulta al saldo es decir a
get_saldo_entrenador lo cual hace que se actualice la tabla transactions.

**4. Durabilidad**

La durabilidad logra garantizar que los cambios que sufre una transacción que ya este confirmada
persistan permanentemente.

Por ejemplo

En nuestro proyecto de PokeData League en autenticar_entrenador como se dijo esto verifica las
credenciales que tiene un entrenador y estas luego se usan para las transacciones. Luego en el
sp_insertar_entrenador aca se inserta un nuevo entrenador a la tabla trainers lo cual incluye las
PokéCoins.

#### Base de datos Distribuidas.........................................................................................

Para la base de datos distribuidas se realizaron base de datos distribuidas en la parte de crear shardings
para las transacciones de la base de datos MySql, lo cual crea una mejor distribución de qué
transacciones se están realizando en cada región. Por ejemplo, si estoy haciendo una transacción en la
región norte, quiero que este registro se vaya al Sharding 1 y si quiero hacer una transacción en la
región sur, quiero que ese registro se vaya al Sharding 2. O en el caso de que se realizara una
transacción a otro tipo de región quiero que se vaya alguno de los dos aleatoriamente.

#### REDIS (CACHE)........................................................................................................

El Redis cache se creo básicamente para el cache de los registros continuos que se hacen en pokemon,
por ejemplo el historial de batallas, los comentarios, los movimientos que se hicieron. Todo esto para
que el rendimiento de sea mejor y no se este guardando registros antiguos ni innecesarios. Solamente
los recientes.


###### [Anexo 5 - Diagrama Redis]......................................................................

#### Consultas MongoDB..................................................................................................

La parte de consultas en la base de datos NoSQL se creó para conectarse al postgres y realizar
consultas desestructuradas, como por ejemplo a tablas como los entrenadores, pokemons, items. Todo
esto para que haya una forma más sencilla de realizar consultas.

Consultas mas relevantes :
● Cantidad de insignias por entrenador

###### [Anexo 6 - Consulta MongoDB]................................................................

```
● Items con precio mayor a 500
```

###### [Anexo 7- Consulta MongoDB].................................................................

```
● Total de comentarios por batalla
```
###### [Anexo 8 - Consulta MongoDB]................................................................

### Herramientas y tecnologías utilizadas........................................................................

```
● Base Relacional
○ PostgresSQL 15
● Base NoSQL
○ MongoDB
● Caché
○ Redis
● Contenedores
○ Docker
● Scripts
○ Python
■ Faker, pymongo, msql2, pg, redis
● Automatización:
○ Node.js
● Cliente DB:
○ DBeaver
```

**Para levantar el proyecto :**

**1. Clonar el repositorio**

```
● https://github.com/WendyCaceres/proyecto_base_datos.git
● cd proyecto-base-datos
```
**2. Ejecutar en la raíz del proyecto**
● Levanta todos los servicios:
    ○ PostresSQL
       ■ master y slave
    ○ MongoDB
    ○ Redis
    ○ MySQL
       ■ shard1 y shard
    ○ ETL

docker compose up -d

**3. Backup y Restore (Para que puedas llenar los datos a las tablas)
● Si desea realizar un backup entre a la base de datos que desea realizar el**
    **backup**
       **○ MySQL**
          ■ cd mysql
          ■ node scripts/generateBackup.js
       **○ PostgresSQL**
          ■ cd postgres
          ■ node scripts/generateBackup.js
**● MySQL**
    ○ cd .\mysql\
    ○ cd .\scripts\
    ○ node .\restoreDb.js
**● Postgres**
    ○ cd .\postgres\
    ○ cd .\scripts\
    ○ node .\restoreDb.js
**● MongoDB**
    ○ cd .\mongodb\
    ○ node .\mongoSeed.js
**● ETL**
    ○ docker exec -it etl_service bash
    ○ node etl_script.js

## 8. Pruebas y Evaluación......................................................................................................

```
Funciones
```

```
● autenticar_entrenador_email_name
```
#### [Anexo 9 - Consulta Funciones]................................................................

#### [Anexo 9.1 - Consulta Funciones].............................................................

```
● get_saldo_entrenador
```

#### [Anexo 10 - Consulta Funciones]..............................................................

**SPs**

```
● actualizar_saldo_entrenador
```

#### [Anexo 11 - Consulta SP]..........................................................................

**Triggers**
● tr_validad_poke_coins_no_negativo

#### [Anexo 12 - Consultas Triggers]...............................................................

#### [Anexo 12.1 - Consulta Triggers]..............................................................


```
● tr_log_resultado_batalla
```
#### [Anexo 13 - Consultas Triggers]...............................................................

**Views**
● vistas_top_entrenadores_insignias


#### [Anexo 14 - Consulta Views].....................................................................

```
● vistas_batallas_finalizadas
```

#### [Anexo 15 - Consulta Views].....................................................................

```
Índices
● idx_badges_status
```
#### [Anexo 16 - Indices]..................................................................................

```
● idx_badges_trainer_status
```

#### [Anexo 17 -Indices]...................................................................................

## 9. Conclusiones y Recomendaciones................................................................................

El desarrollo de nuestro proyecto PokeData League fue una buena forma de poner en practica todos
los conocimientos adquiridos que tuvimos en clases, lo cual genero una forma de poder ver nuestras
capacidades para poder diseñar y gestionar un sistema de base de datos con la inspiración del
competitivo universo del Pokémon.

Como nuestro objetivo general fue de diseñar e implementar una base de datos que gestione datos de
entrenadores, batallas, insignias y transacciones, garantizando un rendimiento óptimo en un entorno
competitivo, se podria decir que cumplimos de manera excelente con lo propuesto. Al igual que con
los problemas encontrados que fueron cumplidos mediante consultas a través de stored
procedures(SP) como sp_retirar_poke_coins y sp_cancelar_batalla que permitió que los entrenadores
accedan a la información crítica sobre batallas e insignias, mientras que nuestra estructura de tablas
como ser la de battle_comments y battle_history nos facilitó el acceso a clasificaciones y resultados.

Un tema sensible comos er las transacciones de PokéCoins se lograron asegurar mediante
sp_registrar_transaccion, que integra validaciones y actualizaciones de manera constante, lo cual
garantiza una integridad en la Liga.

Nuestra implementación en las diferentes base de datos como ser PostgreSQL, MySQL, MongoDB,
Redis nos dio la oportunidad de crear tablas como trainers, battles, badges, transactions y logs_json lo
cual genero una infraestructura escalable y eficiente.

La integración de las transacciones ACID, en funciones importantes para nuestro proyecto como ser
sp_retirar_poke_coins y sp_cancelar_batalla, garantizo que la integridad en los saldos de PokéCoins y
en los estados de batallas donde hay mucha concurrencia. Nuestras estructuras de datos en las tablas
como battle_pokemon y battle_sponsors, junto al uso de JSONB en battles.result, logro dale un reflejo
de complejidad de las dinámicas de la Liga Pokémon.

Este proyecto no solo resolvió los problemas identificados, sino que los trascendió, convirtiendo a
PokeBase League en un faro de innovación tecnológica dentro del universo Pokémon. La experiencia


fortaleció nuestro dominio técnico en diseño relacional, transacciones ACID y procedimientos
almacenados, mientras que el trabajo en equipo nos permitió planificar etapas, tomar decisiones
estratégicas y enfrentar desafíos con una visión profesional que resuena más allá de lo académico,
preparándonos para liderar proyectos que podrían conquistar nuevos horizontes en el mundo
tecnológico y competitivo.

Este proyecto no solo ha perfeccionado nuestras habilidades técnicas en diseño de bases de datos y
optimización, sino que también ha fortalecido nuestra capacidad para tomar decisiones estratégicas,
planificar en equipo y enfrentar desafíos reales con una visión profesional que trasciende lo
académico.

Como recomendaciones futuras PokeData League se podria implementar índices avanzados lo cual
optimizaría las consultas complejas que pueden surgir, lo cual reduciria el tiempo de las respuestas. Al
igual que podria implementar un modulo de análisis en tiempo real el cual utilizaria las particiones de
logs_json para rastrear tendencias en las transacciones y en el rendimiento de batallas, lo cual
transformaria la Liga. Y para una escalabilidad futura, la integración de mas contenedores de Docker
eso facilitaría la distribución ya que hay torneos mundiales y con eso la latencia seria minima.

## 10. Referencias.....................................................................................................................

Incidentes de Downtime en Pokémon GO - Comunidad y Reportes

```
● https://downdetector.com/status/pokemon-go/
```
Implementación de Triggers en PostgreSQL

```
● https://www.postgresql.org/docs/current/triggers.html
```
Implementación de logs_json

```
● https://www.cybertec-postgresql.com/p/postgresql-triggers-best-practices/
```
Go Fest 2017, caidas por sobrecarga

```
● https://www.polygon.com/pokemon-go/2017/7/22/16013790/pokemon-go-fest-2017-s
erver-issues-refunds
```
Caidas de servidores en eventos globales 2020

```
● https://www.ign.com/articles/pokemon-go-server-issues-plague-global-challenge-202
0
```
Documentación PostgreSQL

```
● https://www.postgresql.org/docs/current/high-availability.html
```
Guía de particiones

```
● https://www.postgresql.org/docs/current/ddl-partitioning.html
```

Triggers y reglas

```
● https://www.compose.com/articles/using-postgresql-triggers-and-rules/
```
## 11. Anexos............................................................................................................................

#### [Anexo 18 - Diagrama ELT]......................................................................

[Anexo 1 - Diagrama Flujo ETL]............................................................................................. 10

[Anexo 2 - Diagrama SnowFlake].......................................................................................... 10

[Anexo 3 - Diseño colecciones].............................................................................................. 11
[Anexo 4 - Arquitectura Docker]............................................................................................. 12

[Anexo 5 - Diagrama Redis]................................................................................................... 16
[Anexo 6 - Consulta MongoDB].............................................................................................. 16

[Anexo 7- Consulta MongoDB]............................................................................................... 17

[Anexo 8 - Consulta MongoDB].............................................................................................. 17
[Anexo 9 - Consulta Funciones]............................................................................................. 19

[Anexo 9.1 - Consulta Funciones].......................................................................................... 19

[Anexo 10 - Consulta Funciones]........................................................................................... 20
[Anexo 11 - Consulta SP]....................................................................................................... 21

[Anexo 12 - Consultas Triggers]............................................................................................. 21

[Anexo 12.1 - Consulta Triggers]............................................................................................ 21
[Anexo 13 - Consultas Triggers]............................................................................................. 22

[Anexo 14 - Consulta Views].................................................................................................. 23

[Anexo 15 - Consulta Views].................................................................................................. 24
[Anexo 16 - Indices]............................................................................................................... 24

[Anexo 17 -Indices]................................................................................................................ 25

[Anexo 18 - Diagrama ELT].................................................................................................... 27
