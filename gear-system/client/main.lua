local PlayerStats = {}

local effectHandlers = {
    applyToDamageOut = function(value)
        LocalPlayer.state.weaponDamageBonus = value
    end,
    applyToDamageIn = function(value)
        LocalPlayer.state.armorBonus = value
    end,
    SetRunSprintMultiplierForPlayer = function(value)
        local mult = 1.0 + (value / 100.0)
        SetRunSprintMultiplierForPlayer(PlayerId(), mult)
    end,
    handleCritCheck = function(value)
        LocalPlayer.state.critChance = value
    end,
    SetEntityMaxHealth = function(value)
        local ped = PlayerPedId()
        SetEntityMaxHealth(ped, GetEntityMaxHealth(ped) + value)
    end
}

local function ApplyStatEffects(stats)
    for stat, val in pairs(stats) do
        local handlerName = Config.StatEffects[stat]
        local handler = effectHandlers[handlerName]
        if handler then
            handler(val)
        end
    end
end

RegisterNetEvent('qb-gear:client:updateStats', function(stats)
    PlayerStats = stats
    ApplyStatEffects(stats)
end)

exports('GetPlayerStats', function()
    return PlayerStats
end)

-- Durability reduction on damage
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' and Config.Durability.enabled and Config.Durability.reduceOnHit then
        if args[1] == PlayerPedId() then
            TriggerServerEvent('qb-gear:server:durabilityHit')
        end
    end
end)
