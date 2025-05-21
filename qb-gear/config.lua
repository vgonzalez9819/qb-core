Config = {}

-- Stat Definitions
Config.Stats = {
    weapon_damage = {
        label = "Weapon Damage",
        description = "Increases weapon damage output.",
        type = "percentage",
        applyTo = "damage_out",
        round = 1,
        max = 100,
        default = 0,
        visible = true,
        modifyFunction = function(base, bonus) return base * (1 + bonus/100) end
    },
    reload_speed = {
        label = "Reload Speed",
        description = "Reduces reload time.",
        type = "percentage",
        applyTo = "reload_time",
        round = 1,
        default = 0,
        visible = true,
        modifyFunction = function(base, bonus) return base * (1 - bonus/100) end
    },
    crit_chance = {
        label = "Critical Chance",
        description = "Chance to deal double damage.",
        type = "percentage",
        applyTo = "crit_chance",
        round = 1,
        max = 100,
        default = 0,
        visible = true,
        modifyFunction = function(base, bonus) return base + bonus end
    },
    armor = {
        label = "Armor",
        description = "Reduces incoming damage.",
        type = "percentage",
        applyTo = "damage_in",
        round = 0,
        default = 0,
        visible = true,
        modifyFunction = function(base, bonus) return base * (1 - bonus/100) end
    }
}

-- Gear Slots
Config.GearSlots = {
    head     = { label = "Helmet",       allowedTypes = {"helmet"},  displayOrder = 1 },
    chest    = { label = "Chest Armor",  allowedTypes = {"armor"},   displayOrder = 2 },
    gloves   = { label = "Gloves",       allowedTypes = {"glove"},   displayOrder = 3 },
    backpack = { label = "Backpack",     allowedTypes = {"backpack"}, displayOrder = 4 },
    mod_1    = { label = "Weapon Mod",  allowedTypes = {"mod"},     displayOrder = 5 }
}

-- Rarity
Config.Rarities = {
    common = { label = "Common", color = "#AAAAAA", multiplier = 0.75, maxStats = 1 },
    rare = { label = "Rare", color = "#0070FF", multiplier = 1.25, maxStats = 3 },
    epic = { label = "Epic", color = "#A335EE", multiplier = 1.5, maxStats = 5, allowPassive = true },
    legendary = { label = "Legendary", color = "#FF8000", multiplier = 2.0, maxStats = 6, allowPassive = true, onEquip = "TriggerSpecialEffect" }
}

-- Durability
Config.Durability = {
    enabled = true,
    max = 100,
    decay = {
        onHit = 1,
        onEquip = 0,
        onUse = 0,
    },
    behavior = {
        breakRemovesStats = true,
        allowRepair = true,
        notifyPlayer = true
    }
}

-- Loot Generation
Config.LootRoll = {
    statPool = {"weapon_damage", "armor", "crit_chance", "reload_speed"},
    minStats = 1,
    maxStats = 4,
    rarityInfluence = true,
    baseValueRange = {
        weapon_damage = {min = 5, max = 15},
        armor = {min = 10, max = 30},
        crit_chance = {min = 2, max = 10},
        reload_speed = {min = 5, max = 20},
    },
    randomizeOnCreate = true,
}

Config.StatEffects = {
    weapon_damage = "applyDamageOut",
    reload_speed  = "adjustReloadTime",
    move_speed    = "applyMoveSpeed",
    crit_chance   = "rollCriticalHit",
    armor         = "reduceIncomingDamage",
}

Config.UI = {
    enableGearPanel = true,
    showDurability = true,
    showStatDetails = true,
    showSetBonuses = true,
}

Config.Integration = {
    inventory = "tgiann",
    hud = "qb-hud",
    combatSystem = "qb-gear",
    healthSystem = "qb-core",
    exportStats = true,
}
