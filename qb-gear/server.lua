local QBCore = exports['qb-core']:GetCoreObject()

local PlayerGear = {}
local PlayerStats = {}

local function CalculateStats(src)
    local gear = PlayerGear[src]
    local totals = {}
    if gear then
        for slot, item in pairs(gear) do
            if item and item.info and item.info.stats then
                for stat, value in pairs(item.info.stats) do
                    totals[stat] = (totals[stat] or 0) + value
                end
            end
        end
    end
    PlayerStats[src] = totals
    TriggerClientEvent('qb-gear:client:UpdateStats', src, totals)
end

local function EquipItem(src, slot, item)
    local ply = QBCore.Functions.GetPlayer(src)
    if not ply or not item then return end

    local slotConf = Config.GearSlots[slot]
    if not slotConf then return end

    if not PlayerGear[src] then PlayerGear[src] = {} end

    -- ensure allowed type
    if item.type and not QBCore.Shared.SplitStr(slotConf.allowedTypes, item.type) then
        return
    end

    -- unequip old item
    if PlayerGear[src][slot] then
        local old = PlayerGear[src][slot]
        ply.Functions.AddItem(old.name, 1, false, old.info)
    end

    PlayerGear[src][slot] = item
    CalculateStats(src)
end

local function UnequipItem(src, slot)
    local ply = QBCore.Functions.GetPlayer(src)
    if not ply or not PlayerGear[src] then return end
    local item = PlayerGear[src][slot]
    if not item then return end

    ply.Functions.AddItem(item.name, 1, false, item.info)
    PlayerGear[src][slot] = nil
    CalculateStats(src)
end

QBCore.Functions.CreateCallback('qb-gear:server:EquipItem', function(src, cb, slot, item)
    EquipItem(src, slot, item)
    cb(true)
end)

QBCore.Functions.CreateCallback('qb-gear:server:UnequipItem', function(src, cb, slot)
    UnequipItem(src, slot)
    cb(true)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    PlayerGear[src] = nil
    PlayerStats[src] = nil
end)

if Config.Integration.exportStats then
    exports('GetPlayerStats', function(id)
        return PlayerStats[id] or {}
    end)
end
