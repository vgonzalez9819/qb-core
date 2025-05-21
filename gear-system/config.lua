Config = {}

Config.Stats = {
  weapon_damage = {
    label = "Weapon Damage",
    description = "Increases all weapon damage output.",
    type = "percentage",
    max = 100,
    applyTo = "outgoing",
    default = 0
  },
  armor = {
    label = "Armor",
    description = "Reduces incoming damage.",
    type = "percentage",
    max = 80,
    applyTo = "incoming"
  },
  move_speed = {
    label = "Movement Speed",
    description = "Increases sprint and run speed.",
    type = "percentage",
    applyTo = "movement",
    max = 49
  }
}

Config.GearSlots = {
  head = { label = "Helmet", allowedTypes = {"helmet", "visor"} },
  chest = { label = "Body Armor", allowedTypes = {"armor", "vest"} },
  gloves = { label = "Gloves", allowedTypes = {"gloves"} },
  backpack = { label = "Backpack", allowedTypes = {"backpack"} },
  mod_1 = { label = "Attachment Slot 1", allowedTypes = {"attachment", "mod"} }
}

Config.Rarities = {
  common = { label = "Common", color = "#AAAAAA", statMultiplier = 0.75 },
  uncommon = { label = "Uncommon", color = "#1EFF00", statMultiplier = 1.0 },
  rare = { label = "Rare", color = "#0070FF", statMultiplier = 1.25 },
  epic = { label = "Epic", color = "#A335EE", statMultiplier = 1.5 },
  legendary = { label = "Legendary", color = "#FF8000", statMultiplier = 2.0, uniqueEffects = true }
}

Config.Durability = {
  enabled = true,
  reduceOnHit = true,
  reduceOnUse = false,
  breakAtZero = true,
  showInUI = true,
  defaultMax = 100
}

Config.StatEffects = {
  weapon_damage = "applyToDamageOut",
  armor = "applyToDamageIn",
  move_speed = "SetRunSprintMultiplierForPlayer",
  crit_chance = "handleCritCheck",
  health_bonus = "SetEntityMaxHealth"
}

Config.Integration = {
  useTGIANN = true,
  healthSystem = "qb-core",
  hudResource = "qb-hud",
  useSkillCooldowns = false
}
