// 1. Total de snapshots por batalla
db.battle_snapshots.aggregate([
  { $group: { _id: "$id_battle", total_rounds: { $sum: 1 } } }
])

// 2. Cantidad de items por estado en el marketplace
db.marketplace_items.aggregate([
  { $group: { _id: "$status", count: { $sum: 1 } } }
])

// 3. Entrenadores con tema ‘dark’
db.trainer_profiles.aggregate([
  { $match: { "preferences.theme": "dark" } },
  { $project: { id_trainer: 1, preferences: 1 } }
])

// Batallas con al menos 1 mensaje en chat
db.chat_messages.aggregate([
  { $project: { id_battle: 1, total_messages: { $size: "$messages" } } },
  { $match: { total_messages: { $gte: 1 } } }
])


// 5. Conteo de comentarios por entrenador
db.battle_comments.aggregate([
  { $unwind: "$comments" },
  { $group: { _id: "$comments.id_trainer", total_comments: { $sum: 1 } } }
])

// 6. Event logs con perfil del entrenador (lookup)
db.event_logs.aggregate([
  { $lookup: {
      from: "trainer_profiles",
      localField: "event_id",
      foreignField: "id_trainer",
      as: "trainer_info"
    }
  }
])

// 7. Items con datos del vendedor (lookup)
db.marketplace_items.aggregate([
  { $lookup: {
      from: "trainer_profiles",
      localField: "seller_id",
      foreignField: "id_trainer",
      as: "seller"
    }
  },
  { $project: { item_id: 1, price: 1, seller: 1 } }
])

// 8. Total de pasos de estrategia por batalla
db.battle_ai_strategies.aggregate([
  { $project: { id_battle: 1, total_steps: { $size: "$strategy_steps" } } }
])

// 9. Cantidad de insignias por entrenador
db.badge_achievements.aggregate([
  { $project: { id_trainer: 1, badge_count: { $size: "$badges" } } }
])

// 10. Últimos logs por tipo de evento
db.event_logs.aggregate([
  { $sort: { created_at: -1 } },
  { $group: { _id: "$type", latest: { $first: "$$ROOT" } } }
])

// 11. Promedio duración de sesiones de entrenamiento
db.training_sessions.aggregate([
  { $group: { _id: null, avg_duration: { $avg: "$duration" } } }
])

// 12. Total de mensajes por batalla
db.chat_messages.aggregate([
  { $project: { id_battle: 1, total_messages: { $size: "$messages" } } }
])

// 13. Entrenadores con más de 1 insignia
db.badge_achievements.aggregate([
  { $match: { $expr: { $gt: [{ $size: "$badges" }, 1] } } }
])

// 14. Items con precio mayor a 500
db.marketplace_items.aggregate([
  { $match: { price: { $gt: 500 } } },
  { $project: { item_id: 1, price: 1 } }
])

// 15. Ranking de pokémon más entrenados
db.training_sessions.aggregate([
  { $unwind: "$pokemons" },
  { $group: { _id: "$pokemons.name", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
])

// 16. Cantidad de rondas por batalla
db.battle_snapshots.aggregate([
  { $group: { _id: "$id_battle", rounds: { $sum: 1 } } }
])

// 17. Mensajes enviados por usuario
db.chat_messages.aggregate([
  { $unwind: "$messages" },
  { $group: { _id: "$messages.sender", msg_count: { $sum: 1 } } }
])

// 18. Total de comentarios por batalla
db.battle_comments.aggregate([
  { $project: { id_battle: 1, total_comments: { $size: "$comments" } } }
])

// 19. Entrenadores con widget stats activo
db.trainer_profiles.aggregate([
  { $match: { "layout.widgets": { $in: ["stats", "ranking", "chat"] } } },
  { $project: { id_trainer: 1, layout: 1 } }
])


// 20. Sesiones con 1 o más pokémon entrenados
db.training_sessions.aggregate([
  { $match: { $expr: { $gte: [{ $size: "$pokemons" }, 1] } } }
])
