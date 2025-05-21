Config = {}

-- Gear slot names
Config.GearSlots = {
    'head',
    'chest',
    'gloves',
    'backpack',
    'legs',
    'boots',
    'mod_1',
    'mod_2',
    'weapon_attachment'
}

-- Default empty stat table
Config.DefaultStats = {
    weaponDamage = 0,
    critChance = 0,
    critDamage = 0,
    reloadSpeed = 0,
    magazine = 0,
    cooldownReduction = 0,
    healthBonus = 0,
    armor = 0,
    statusResist = 0,
    moveSpeed = 0,
}

-- Example rarity multipliers used when rolling item stats
Config.RarityMultipliers = {
    common = 1.0,
    uncommon = 1.2,
    rare = 1.4,
    epic = 1.7,
    legendary = 2.0
}
