local QBCore = exports['qb-core']:GetCoreObject()
local Gear = {}

local function deepcopy(orig)
    local copy = {}
    for k, v in pairs(orig) do
        if type(v) == 'table' then
            copy[k] = deepcopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local function MergeStats(stats, itemStats)
    for stat, value in pairs(itemStats or {}) do
        stats[stat] = (stats[stat] or 0) + (tonumber(value) or 0)
    end
end

local function CalculateStats(gear)
    local totals = deepcopy(Config.DefaultStats)
    for _, data in pairs(gear or {}) do
        MergeStats(totals, data.info and data.info.stats)
    end
    return totals
end

local function SaveGear(Player, gear, stats)
    Player.Functions.SetMetaData('gear', gear)
    Player.Functions.SetMetaData('gearstats', stats)
    Player.Functions.UpdatePlayerData()
end

local function LoadPlayerGear(Player)
    local gear = Player.PlayerData.metadata.gear or {}
    local stats = CalculateStats(gear)
    Gear[Player.PlayerData.source] = {gear = gear, stats = stats}
    TriggerClientEvent('qb-gear:client:ApplyStats', Player.PlayerData.source, stats)
end

RegisterNetEvent('QBCore:Server:PlayerLoaded', function(Player)
    LoadPlayerGear(Player)
end)

AddEventHandler('playerDropped', function()
    local src = source
    Gear[src] = nil
end)

local function GetPlayerGear(Player)
    return Gear[Player.PlayerData.source] and Gear[Player.PlayerData.source].gear or {}
end

local function SetPlayerGear(Player, gear)
    local stats = CalculateStats(gear)
    Gear[Player.PlayerData.source] = {gear = gear, stats = stats}
    SaveGear(Player, gear, stats)
    TriggerClientEvent('qb-gear:client:ApplyStats', Player.PlayerData.source, stats)
end

-- Export for other resources to get current stats
exports('GetPlayerStats', function(playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if not Player then return nil end
    local data = Gear[playerId]
    return data and data.stats or deepcopy(Config.DefaultStats)
end)

RegisterNetEvent('qb-gear:server:EquipGear', function(slot, invSlot)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local item = Player.Functions.GetItemBySlot(invSlot)
    if not item then return end
    if not item.info or item.info.slot ~= slot then return end

    local gear = GetPlayerGear(Player)
    if gear[slot] then
        -- return existing item
        Player.Functions.AddItem(gear[slot].name, 1, false, gear[slot].info)
    end
    if not Player.Functions.RemoveItem(item.name, 1, invSlot) then return end
    gear[slot] = {name = item.name, info = item.info}
    SetPlayerGear(Player, gear)
end)

RegisterNetEvent('qb-gear:server:UnequipGear', function(slot)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local gear = GetPlayerGear(Player)
    if not gear[slot] then return end
    Player.Functions.AddItem(gear[slot].name, 1, false, gear[slot].info)
    gear[slot] = nil
    SetPlayerGear(Player, gear)
end)

RegisterNetEvent('qb-gear:server:RequestStats', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local data = Gear[src]
    if not data then
        LoadPlayerGear(Player)
        data = Gear[src]
    end
    TriggerClientEvent('qb-gear:client:SyncStats', src, data.stats)
end)

-- Simple command to view stats
QBCore.Commands.Add('gearstats', 'Show current gear stats', {}, false, function(src)
    local stats = exports['qb-gear']:GetPlayerStats(src)
    TriggerClientEvent('qb-gear:client:ShowStats', src, stats)
end)
