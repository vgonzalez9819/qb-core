local Gear = {}

-- compile modify functions
local function compileFunc(str)
    local fn = load(str)
    if type(fn) == 'function' then
        return fn
    end
    return function(base, bonus) return base end
end

for stat, def in pairs(Config.Stats) do
    def._modify = compileFunc(def.modifyFunction)
end

local function getEmptyGear()
    local t = {}
    for slot in pairs(Config.GearSlots) do
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

local function calculateStats(src)
    local playerGear = getPlayerGear(src)
    local stats = {}
    for name, def in pairs(Config.Stats) do
        stats[name] = def.default
    end

    for _, item in pairs(playerGear) do
        if item and item.stats then
            local rarity = Config.Rarities[item.rarity] or { multiplier = 1.0 }
            for stat, value in pairs(item.stats) do
                if stats[stat] then
                    stats[stat] = stats[stat] + value * rarity.multiplier
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

function getPlayerStats(src)
    return calculateStats(src)
end
exports('getPlayerStats', getPlayerStats)

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

RegisterNetEvent('gear_system:server:equip', function(itemName)
    local src = source
    local itemDef = Config.Equipment[itemName]
    if not itemDef then return end
    local slot = itemDef.slot
    local gearSlot = Config.GearSlots[slot]
    if not gearSlot then return end

    if exports['qb-inventory'] then
        exports['qb-inventory']:RemoveItem(src, itemName, 1)
    end

    local playerGear = getPlayerGear(src)
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
    applyStats(src)
    TriggerClientEvent('gear_system:client:setGear', src, playerGear)
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
    applyStats(src)
    TriggerClientEvent('gear_system:client:setGear', src, playerGear)
end)

RegisterNetEvent('gear_system:server:requestGear', function()
    local src = source
    TriggerClientEvent('gear_system:client:setGear', src, getPlayerGear(src))
end)

AddEventHandler('playerDropped', function()
    Gear[source] = nil
end)

RegisterCommand('gearstats', function(src)
    local stats = calculateStats(src)
    print('Gear stats for', src, json.encode(stats))
end)

RegisterCommand('equipment', function(src)
    TriggerClientEvent('gear_system:client:open', src)
    TriggerClientEvent('gear_system:client:setGear', src, getPlayerGear(src))
end)
