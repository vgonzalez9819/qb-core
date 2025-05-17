local QBCore = exports['qb-core']:GetCoreObject()

local repairOpen = false
local currentVehicle = nil

RegisterCommand('repairveh', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        vehicle = QBCore.Functions.GetClosestVehicle(GetEntityCoords(ped))
    end
    if vehicle ~= 0 then
        currentVehicle = vehicle
        local plate = QBCore.Functions.GetPlate(vehicle)
        TriggerServerEvent('qb-vehicle:server:loadHP', plate)
    else
        QBCore.Functions.Notify('No vehicle nearby', 'error')
    end
end)

RegisterNetEvent('qb-vehicle:client:setHP', function(hp, vip)
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'open', hp = hp, vip = vip})
    repairOpen = true
end)

RegisterNetEvent('qb-vehicle:client:repaired', function()
    if repairOpen then
        SendNUIMessage({action = 'close'})
        SetVehicleEngineHealth(currentVehicle, 1000.0)
        SetVehicleEngineOn(currentVehicle, true, true)
        SetNuiFocus(false, false)
        repairOpen = false
    end
end)

RegisterNUICallback('repair', function(data, cb)
    if not currentVehicle then return end
    local plate = QBCore.Functions.GetPlate(currentVehicle)
    TriggerServerEvent('qb-vehicle:server:repair', {plate = plate, hp = data.hp, vip = data.vip})
    cb('ok')
end)

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    repairOpen = false
    cb('ok')
end)
