local stats = {}

local function ApplyStats(newStats)
    stats = newStats or {}
    local ped = PlayerPedId()
    local moveMult = 1.0 + ((stats.moveSpeed or 0) / 100.0)
    moveMult = math.min(moveMult, 1.49)
    SetRunSprintMultiplierForPlayer(PlayerId(), moveMult)
    local maxHealth = 200 + (stats.healthBonus or 0)
    SetEntityMaxHealth(ped, maxHealth)
    if GetEntityHealth(ped) > maxHealth then
        SetEntityHealth(ped, maxHealth)
    end
end

RegisterNetEvent('qb-gear:client:ApplyStats', function(newStats)
    ApplyStats(newStats)
end)

-- Display stats in chat
RegisterNetEvent('qb-gear:client:ShowStats', function(current)
    local msg = 'Current Gear Stats:\n'
    for k, v in pairs(current) do
        msg = msg .. ('%s: %s\n'):format(k, v)
    end
    TriggerEvent('chat:addMessage', {args = {msg}})
end)

-- reapplies after spawn
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('qb-gear:server:RequestStats')
end)

RegisterNetEvent('qb-gear:client:SyncStats', function(newStats)
    ApplyStats(newStats)
end)
