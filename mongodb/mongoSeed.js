const { MongoClient } = require('mongodb');
const { faker } = require('@faker-js/faker');

const uri = "mongodb://mongo:mongo@localhost:27017";
const client = new MongoClient(uri);

async function seedMongo() {
  try {
    await client.connect();
    const db = client.db("pokemon_nosql");

    // 1. battle_snapshots
    const battleSnapshots = Array.from({ length: 5 }).map((_, i) => ({
      id_battle: 100 + i,
      round: i + 1,
      state_json: {
        pokemons: [
          { id: faker.number.int({ min: 1, max: 100 }), hp: faker.number.int({ min: 20, max: 100 }) },
          { id: faker.number.int({ min: 1, max: 100 }), hp: faker.number.int({ min: 20, max: 100 }) }
        ],
        turn: faker.person.fullName()
      }
    }));
    await db.collection("battle_snapshots").insertMany(battleSnapshots);

    // 2. trainer_profiles
    const trainerProfiles = Array.from({ length: 5 }).map((_, i) => ({
      id_trainer: i + 1,
      preferences: { theme: "dark", notifications: true },
      layout: { sidebar: true, widgets: ["stats", "ranking"] },
      achievements: ["badge1", "badge2"]
    }));
    await db.collection("trainer_profiles").insertMany(trainerProfiles);

    // 3. marketplace_items
    const marketplaceItems = Array.from({ length: 5 }).map((_, i) => ({
      item_id: `itm_${i + 1}`,
      seller_id: faker.number.int({ min: 1, max: 5 }),
      price: faker.number.int({ min: 100, max: 1000 }),
      description: faker.commerce.productDescription(),
      status: faker.helpers.arrayElement(["available", "sold", "reserved"])
    }));
    await db.collection("marketplace_items").insertMany(marketplaceItems);

    // 4. event_logs
    const eventLogs = Array.from({ length: 5 }).map((_, i) => ({
      event_id: `evt_${i + 1}`,
      type: faker.helpers.arrayElement(["battle_start", "battle_end", "item_used"]),
      data: { detail: faker.lorem.sentence() },
      created_at: new Date()
    }));
    await db.collection("event_logs").insertMany(eventLogs);

    // 5. training_sessions
    const trainingSessions = Array.from({ length: 5 }).map((_, i) => ({
      session_id: `sess_${i + 1}`,
      id_trainer: faker.number.int({ min: 1, max: 5 }),
      pokemons: Array.from({ length: 2 }).map(() => ({
        id_pokemon: faker.number.int({ min: 1, max: 150 }),
        name: faker.animal.insect(),
        level: faker.number.int({ min: 5, max: 50 })
      })),
      duration: faker.number.int({ min: 15, max: 120 }),
      notes: faker.lorem.sentence()
    }));
    await db.collection("training_sessions").insertMany(trainingSessions);

    // 6. battle_ai_strategies
    const aiStrategies = Array.from({ length: 3 }).map(() => ({
      id_battle: faker.number.int({ min: 100, max: 105 }),
      strategy_steps: [
        { step: 1, action: "attack", target: 2 },
        { step: 2, action: "defend" }
      ]
    }));
    await db.collection("battle_ai_strategies").insertMany(aiStrategies);

    // 7. battle_comments
    const battleComments = Array.from({ length: 3 }).map(() => ({
      id_battle: faker.number.int({ min: 100, max: 105 }),
      comments: Array.from({ length: 2 }).map(() => ({
        id_trainer: faker.number.int({ min: 1, max: 5 }),
        comment: faker.hacker.phrase(),
        created_at: new Date()
      }))
    }));
    await db.collection("battle_comments").insertMany(battleComments);

    // 8. battle_tournaments
    const battleTournaments = Array.from({ length: 3 }).map(() => ({
      id_tournament: faker.number.int({ min: 1, max: 10 }),
      id_battle: faker.number.int({ min: 100, max: 105 }),
      round: faker.number.int({ min: 1, max: 5 }),
      results: {
        winner: faker.number.int({ min: 1, max: 5 }),
        loser: faker.number.int({ min: 6, max: 10 })
      }
    }));
    await db.collection("battle_tournaments").insertMany(battleTournaments);

    // 9. chat_messages
    const chatMessages = Array.from({ length: 3 }).map(() => ({
      id_battle: faker.number.int({ min: 100, max: 105 }),
      messages: Array.from({ length: 2 }).map(() => ({
        sender: faker.number.int({ min: 1, max: 5 }),
        text: faker.lorem.sentence(),
        timestamp: new Date()
      }))
    }));
    await db.collection("chat_messages").insertMany(chatMessages);

    // 10. badge_achievements
    const badgeAchievements = Array.from({ length: 5 }).map((_, i) => ({
      id_trainer: i + 1,
      badges: [faker.word.noun(), faker.word.noun()]

    }));
    await db.collection("badge_achievements").insertMany(badgeAchievements);

    console.log("✅ MongoDB poblado con éxito");
  } catch (e) {
    console.error("❌ Error al poblar MongoDB:", e);
  } finally {
    await client.close();
  }
}

seedMongo();

