local currentStats = {}

RegisterNetEvent('gear_system:client:updateStats', function(stats)
    currentStats = stats
end)

RegisterNetEvent('gear_system:client:open', function()
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'open'})
    lib.callback('gear_system:server:getGear', false, function(gear)
        SendNUIMessage({action = 'setGear', gear = gear, slots = Config.GearSlots})
    end)
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
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'open'})
    lib.callback('gear_system:server:getGear', false, function(gear)
        SendNUIMessage({action = 'setGear', gear = gear, slots = Config.GearSlots})
    end)
end)
