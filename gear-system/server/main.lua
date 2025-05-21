local QBCore = exports['qb-core']:GetCoreObject()
local Gear = {}

local function GetPlayer(src)
    return QBCore.Functions.GetPlayer(src)
end

local function InitPlayer(player)
    player.PlayerData.metadata.gear = player.PlayerData.metadata.gear or {}
    player.PlayerData.metadata.gear_stats = player.PlayerData.metadata.gear_stats or {}
end

local function SaveGear(player)
    player.Functions.SetMetaData('gear', player.PlayerData.metadata.gear)
    player.Functions.SetMetaData('gear_stats', player.PlayerData.metadata.gear_stats)
end

local function MergeStats(gear)
    local totals = {}
    for slot, item in pairs(gear) do
        if item and item.info and item.info.stats then
            local rarity = Config.Rarities[item.info.rarity] or {statMultiplier = 1.0}
            for stat, value in pairs(item.info.stats) do
                totals[stat] = (totals[stat] or 0) + value * rarity.statMultiplier
            end
        end
    end
    return totals
end

local function ApplyStats(player, stats)
    player.PlayerData.metadata.gear_stats = stats
    SaveGear(player)
    TriggerClientEvent('qb-gear:client:updateStats', player.PlayerData.source, stats)
    TriggerEvent('qb-gear:statChanged', player.PlayerData.source, stats)
end

local function UpdatePlayerStats(player)
    local stats = MergeStats(player.PlayerData.metadata.gear)
    ApplyStats(player, stats)
end

local function IsValidSlotType(slot, itemType)
    local cfg = Config.GearSlots[slot]
    if not cfg then return false end
    for i=1, #cfg.allowedTypes do
        if cfg.allowedTypes[i] == itemType then return true end
    end
    return false
end

RegisterNetEvent('qb-gear:server:equipItem', function(slot, item)
    local src = source
    local Player = GetPlayer(src)
    if not Player or not item then return end
    InitPlayer(Player)

    if not IsValidSlotType(slot, item.info.slot_type) then return end

    -- remove item from inventory via TGIANN
    if Config.Integration.useTGIANN then
        if exports['tgiann-inventory'] then
            exports['tgiann-inventory']:RemoveItem(src, item.name, 1, item.slot)
        end
    end

    Player.PlayerData.metadata.gear[slot] = item
    UpdatePlayerStats(Player)
end)

RegisterNetEvent('qb-gear:server:unequipItem', function(slot)
    local src = source
    local Player = GetPlayer(src)
    if not Player then return end
    InitPlayer(Player)

    local item = Player.PlayerData.metadata.gear[slot]
    if not item then return end

    if Config.Integration.useTGIANN then
        if exports['tgiann-inventory'] then
            exports['tgiann-inventory']:AddItem(src, item.name, 1, false, item.info)
        end
    end

    Player.PlayerData.metadata.gear[slot] = nil
    UpdatePlayerStats(Player)
end)

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    InitPlayer(Player)
    UpdatePlayerStats(Player)
end)

exports('GetPlayerStats', function(src)
    local Player = GetPlayer(src)
    if not Player then return {} end
    InitPlayer(Player)
    return Player.PlayerData.metadata.gear_stats or {}
end)
if Config.Integration.useTGIANN then
    RegisterNetEvent("tgiann-inventory:server:gearEquip", function(slot, item)
        TriggerEvent("qb-gear:server:equipItem", slot, item)
    end)
    RegisterNetEvent("tgiann-inventory:server:gearUnequip", function(slot)
        TriggerEvent("qb-gear:server:unequipItem", slot)
    end)
end


-- Example function to generate gear metadata
function Gear.CreateItemMetadata(slotType, rarity, baseStats)
    local info = {
        slot_type = slotType,
        rarity = rarity or 'common',
        durability = Config.Durability.defaultMax,
        stats = {}
    }
    if baseStats then
        for stat, range in pairs(baseStats) do
            info.stats[stat] = math.random(range.min, range.max)
        end
    end
    return info


RegisterNetEvent('qb-gear:server:durabilityHit', function()
    local src = source
    local Player = GetPlayer(src)
    if not Player or not Config.Durability.enabled or not Config.Durability.reduceOnHit then return end
    InitPlayer(Player)
    local changed = false
    for slot, item in pairs(Player.PlayerData.metadata.gear) do
        if item and item.info and item.info.durability then
            item.info.durability = item.info.durability - 1
            if item.info.durability <= 0 and Config.Durability.breakAtZero then
                Player.PlayerData.metadata.gear[slot] = nil
            end
            changed = true
        end
    end
    if changed then
        UpdatePlayerStats(Player)
    end
end)
QBCore.Commands.Add('gearstats', 'Show your gear bonuses', {}, false, function(src)
    local Player = GetPlayer(src)
    if not Player then return end
    InitPlayer(Player)
    local stats = Player.PlayerData.metadata.gear_stats or {}
    TriggerClientEvent('chat:addMessage', src, {args = {'Gear', json.encode(stats)}})
end)

return Gear
