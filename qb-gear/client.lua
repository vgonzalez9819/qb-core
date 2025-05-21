local QBCore = exports['qb-core']:GetCoreObject()
local Stats = {}

local function applyDamageOut(val)
    SetPlayerWeaponDamageModifier(PlayerId(), 1.0 + (val or 0) / 100)
end

local function adjustReloadTime(val)
    -- Placeholder: actual implementation depends on weapon system
end

local function applyMoveSpeed(val)
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0 + (val or 0) / 100)
end

local function rollCriticalHit(val)
    -- Placeholder for critical hit logic
end

local function reduceIncomingDamage(val)
    SetPlayerWeaponDefenseModifier(PlayerId(), 1.0 - (val or 0) / 100)
end

local effectMap = {
    weapon_damage = applyDamageOut,
    reload_speed = adjustReloadTime,
    move_speed = applyMoveSpeed,
    crit_chance = rollCriticalHit,
    armor = reduceIncomingDamage,
}

RegisterNetEvent('qb-gear:client:UpdateStats', function(newStats)
    Stats = newStats or {}
    for stat, func in pairs(effectMap) do
        if Stats[stat] then
            func(Stats[stat])
        else
            func(0)
        end
    end
end)
