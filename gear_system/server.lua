local Gear = {}

-- utility to compile modify functions
local function compileFunc(str)
    local fn = load(str)
    if type(fn) == 'function' then
        return fn
    end
    return function(base, bonus) return base end
end

-- prepare modify functions
for stat, data in pairs(Config.Stats) do
    data._modify = compileFunc(data.modifyFunction)
end

local function getEmptyGear()
    local t = {}
    for slot, _ in pairs(Config.GearSlots) do
        t[slot] = nil
    end
    return t
end

local function getPlayerGear(src)
    if not Gear[src] then
        Gear[src] = getEmptyGear()
    end
    return Gear[src]
end

local function getIdentifier(src)
    return GetPlayerIdentifier(src, 0)
end

local function loadPlayerGear(src)
    local id = getIdentifier(src)
    if not id then return end
    local data = GetResourceKvpString('gear:' .. id)
    if data then
        Gear[src] = json.decode(data)
    else
        Gear[src] = getEmptyGear()
    end
end

local function savePlayerGear(src)
    local id = getIdentifier(src)
    if not id then return end
    SetResourceKvp('gear:' .. id, json.encode(Gear[src] or getEmptyGear()))
end

local function calculateStats(src)
    local playerGear = getPlayerGear(src)
    local stats = {}
    for name, def in pairs(Config.Stats) do
        stats[name] = def.default
    end

    for slot, item in pairs(playerGear) do
        if item and item.stats then
            local rarity = Config.Rarities[item.rarity] or {multiplier = 1.0}
            for stat, value in pairs(item.stats) do
                if stats[stat] then
                    stats[stat] = stats[stat] + (value * rarity.multiplier)
                end
            end
        end
    end

    return stats
end

local function applyStats(src)
    local stats = calculateStats(src)
    TriggerClientEvent('gear_system:client:applyStats', src, stats)
end

-- exported
function getPlayerStats(src)
    return calculateStats(src)
end

exports('getPlayerStats', getPlayerStats)

-- durability handling
local function decayDurability(src, slot, amount)
    if not Config.Durability.enabled then return end
    local gear = getPlayerGear(src)[slot]
    if not gear then return end
    gear.durability = gear.durability - amount
    if gear.durability <= 0 then
        gear.durability = 0
        if Config.Durability.breakRemovesStats then
            getPlayerGear(src)[slot] = nil
        end
    end
end

-- equipping gear
RegisterNetEvent('gear_system:server:equip', function(itemName, metadata)
    local src = source
    local itemDef = Config.Equipment[itemName]
    if not itemDef then return end
    local slot = itemDef.slot
    local gearSlot = Config.GearSlots[slot]
    if not gearSlot then return end

    -- remove from inventory and update metadata via qb-inventory
    if exports['qb-inventory'] then
        exports['qb-inventory']:RemoveItem(src, itemName, 1)
    end

    local playerGear = getPlayerGear(src)
    -- if slot occupied return old item to inventory
    if playerGear[slot] then
        local old = playerGear[slot]
        if exports['qb-inventory'] then
            exports['qb-inventory']:AddItem(src, old.name, 1, nil, old)
        end
    end

    local gearData = {
        name = itemName,
        rarity = itemDef.rarity,
        durability = itemDef.durability,
        stats = itemDef.stats,
        slot = slot,
        type = itemDef.type
    }
    playerGear[slot] = gearData
    savePlayerGear(src)
    applyStats(src)
end)

-- event for qb-inventory to trigger on item use
RegisterNetEvent('gear_system:server:useItem', function(itemName, metadata)
    TriggerEvent('gear_system:server:equip', itemName, metadata)
end)

RegisterNetEvent('gear_system:server:unequip', function(slot)
    local src = source
    local playerGear = getPlayerGear(src)
    local gear = playerGear[slot]
    if not gear then return end
    playerGear[slot] = nil
    if exports['qb-inventory'] then
        exports['qb-inventory']:AddItem(src, gear.name, 1, nil, gear)
    end
    savePlayerGear(src)
    applyStats(src)
end)

-- stat effect implementations
AddEventHandler('playerDropped', function(reason)
    savePlayerGear(source)
    Gear[source] = nil
end)

AddEventHandler('playerJoining', function()
    loadPlayerGear(source)
    -- apply stats after short delay to ensure player entity exists
    SetTimeout(1000, function()
        applyStats(source)
    end)
end)

RegisterNetEvent('gear_system:server:requestGear', function()
    TriggerClientEvent('gear_system:client:setGear', source, getPlayerGear(source))
end)

-- command to print stats
RegisterCommand('gearstats', function(src)
    local stats = calculateStats(src)
    print('Gear stats for', src, json.encode(stats))
end)

RegisterCommand('equipment', function(src)
    TriggerClientEvent('gear_system:client:open', src)
end)
