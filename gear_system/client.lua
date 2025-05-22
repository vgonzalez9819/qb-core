local currentStats = {}

RegisterNetEvent('gear_system:client:applyStats', function(stats)
    currentStats = stats
    if stats.weapon_damage then
        SetPlayerWeaponDamageModifier(PlayerId(), 1.0 + stats.weapon_damage / 100.0)
    end
    if stats.move_speed then
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0 + stats.move_speed / 100.0)
    end
end)

RegisterNetEvent('gear_system:client:setGear', function(gear)
    SendNUIMessage({action = 'setGear', gear = gear, slots = Config.GearSlots})
end)

RegisterNetEvent('gear_system:client:open', function()
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'open'})
    TriggerServerEvent('gear_system:server:requestGear')
end)

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('unequip', function(data, cb)
    TriggerServerEvent('gear_system:server:unequip', data.slot)
    cb('ok')
end)

RegisterNUICallback('equip', function(data, cb)
    TriggerServerEvent('gear_system:server:equip', data.item)
    cb('ok')
end)

RegisterCommand('equipment', function()
    TriggerEvent('gear_system:client:open')
end)

-- open/close with qb-inventory events if they exist
RegisterNetEvent('qb-inventory:client:openInventory', function()
    TriggerEvent('gear_system:client:open')
end)

RegisterNetEvent('qb-inventory:client:closeInventory', function()
    SetNuiFocus(false, false)
    SendNUIMessage({action = 'close'})
end)
