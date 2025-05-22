local currentStats = {}

local function applyWeaponDamage(bonus)
    SetPlayerWeaponDamageModifier(PlayerId(), 1.0 + bonus / 100.0)
end

local function applyMovementSpeed(bonus)
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0 + bonus / 100.0)
end

RegisterNetEvent('gear_system:client:applyStats', function(stats)
    currentStats = stats
    for stat, value in pairs(stats) do
        local fnName = Config.StatEffects[stat]
        if fnName == 'applyWeaponDamage' then
            applyWeaponDamage(value)
        elseif fnName == 'applyMovementSpeed' then
            applyMovementSpeed(value)
        end
    end
end)

RegisterNetEvent('gear_system:client:open', function()
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'open'})
    TriggerServerEvent('gear_system:server:requestGear')
end)

RegisterNetEvent('gear_system:client:setGear', function(gear)
    SendNUIMessage({action = 'setGear', gear = gear, slots = Config.GearSlots})
end)

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('unequip', function(data, cb)
    TriggerServerEvent('gear_system:server:unequip', data.slot)
    cb('ok')
end)

RegisterCommand('equipment', function()
    TriggerEvent('gear_system:client:open')
end)
