local QBCore = exports['qb-core']:GetCoreObject()

local function fetchVehicle(plate)
    local result = MySQL.single.await('SELECT * FROM vehicle_durability WHERE plate = ?', {plate})
    return result
end

RegisterNetEvent('qb-vehicle:server:loadHP', function(plate)
    local src = source
    local data = fetchVehicle(plate)
    if not data then
        MySQL.insert('INSERT INTO vehicle_durability (plate, hp, vip) VALUES (?, 1000, 0)', {plate})
        data = {hp = 1000, vip = 0}
    end
    TriggerClientEvent('qb-vehicle:client:setHP', src, data.hp, data.vip == 1)
end)

RegisterNetEvent('qb-vehicle:server:updateHP', function(plate, hp)
    MySQL.update('UPDATE vehicle_durability SET hp = ?, last_updated = NOW() WHERE plate = ?', {hp, plate})
end)

RegisterNetEvent('qb-vehicle:server:repair', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local plate = data.plate
    local hp = data.hp
    local vip = data.vip
    if hp >= 1000 then return end

    -- simple material check
    if not Player.Functions.RemoveItem('repairkit', 1) then
        TriggerClientEvent('QBCore:Notify', src, 'Missing repair kit', 'error')
        return
    end

    MySQL.update('UPDATE vehicle_durability SET hp = ? WHERE plate = ?', {1000, plate})
    TriggerClientEvent('qb-vehicle:client:repaired', src)
end)
