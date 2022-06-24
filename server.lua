local Cooldown = false

-- Syncing Server Side Events

RegisterNetEvent('sd-blackout:server:blackoutsync', function()
    TriggerClientEvent('sd-blackout:client:blackoutsync', -1)
end)

RegisterNetEvent('sd-blackout:server:restoresync', function()
    TriggerClientEvent('sd-blackout:client:restoresync', -1)
end)

RegisterNetEvent('sd-blackout:server:lightsoff', function()
    TriggerClientEvent('sd-blackout:client:lightsoff', -1)
end)

RegisterNetEvent('sd-blackout:Server:RemoveC4', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem("c4_bomb", 1)
end)


RegisterNetEvent('sd-blackout:server:lightson', function()
    TriggerClientEvent('sd-blackout:client:lightson', -1)
end)


-- Starting Cooldown

RegisterServerEvent('sd-blackout:server:startr', function()
    TriggerEvent('sd-blackout:server:coolout')
end)

-- Minimum Cop Callback

ESX.RegisterServerCallback('sd-blackout:server:getCops', function(source, cb)
    local players = ESX.GetExtendedPlayers("job", "police")
    cb(ESX.Table.SizeOf(players))
end)

ESX.RegisterServerCallback('sd-blackout:server:HasItem', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(item)
    cb(item.count > 0)
end)


-- Cooldown

RegisterServerEvent('sd-blackout:server:coolout', function()
    Cooldown = true
    local timer = Config.Cooldown * 1000
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            Cooldown = false
        end
    end
end)

ESX.RegisterServerCallback("sd-blackout:server:coolc",function(source, cb)
    if Cooldown then
        cb(true)
    else
        cb(false) 
    end
end)
