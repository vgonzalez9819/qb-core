Config = {}

Config.Equipment = {
    ["tactical_helmet"] = {
        label = "Tactical Helmet",
        slot = "head",
        type = "helmet",
        rarity = "rare",
        durability = 100,
        stats = {
            armor = 10,
            crit_chance = 3
        }
    },
    ["military_vest"] = {
        label = "Military Vest",
        slot = "chest",
        type = "armor",
        rarity = "epic",
        durability = 80,
        stats = {
            armor = 30,
            weapon_damage = 8
        }
    }
}

Config.GearSlots = {
    head = { label = "Helmet", allowedTypes = {"helmet"} },
    chest = { label = "Body Armor", allowedTypes = {"armor"} },
    gloves = { label = "Gloves", allowedTypes = {"glove"} },
    mod_1 = { label = "Attachment 1", allowedTypes = {"mod"} }
}

Config.Stats = {
    weapon_damage = {
        label = "Weapon Damage",
        type = "percentage",
        default = 0,
        max = 100,
        modifyFunction = "function(base, bonus) return base * (1 + bonus / 100) end"
    },
    move_speed = {
        label = "Movement Speed",
        type = "percentage",
        default = 0,
        max = 50,
        modifyFunction = "function(base, bonus) return base * (1 + bonus / 100) end"
    }
}

Config.Rarities = {
    common = { color = "#AAAAAA", multiplier = 0.75 },
    rare = { color = "#0070FF", multiplier = 1.25 },
    epic = { color = "#A335EE", multiplier = 1.5 },
    legendary = { color = "#FF8000", multiplier = 2.0 }
}

Config.Durability = {
    enabled = true,
    breakRemovesStats = true,
    decay = {
        onHit = 1,
        onEquip = 0
    }
}

Config.StatEffects = {
    weapon_damage = "applyWeaponDamage",
    move_speed = "applyMovementSpeed"
}
