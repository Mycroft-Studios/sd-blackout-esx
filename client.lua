blackout = false

-- Blackout Start

RegisterNetEvent('sd-blackout:client:startblackout', function()
    ESX.TriggerServerCallback("sd-blackout:server:getCops", function(enoughCops)
        if enoughCops >= Config.MinimumPolice then
            ESX.TriggerServerCallback("sd-blackout:server:coolc", function(isCooldown2)
                if not isCooldown2 then
                    TriggerEvent("mythic_progbar:client:progress", {
                        name = "search_register",
                        duration = 3000,
                        label = "Preparing Explosive",
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true
                        },
                        animation = {}
                    }, function(status)
                        if not status then
                            bombanime()
                            TriggerEvent("sd-blackout:client:blackout")
                            TriggerServerEvent('sd-blackout:server:startr')
                            TriggerServerEvent('sd-blackout:server:blackoutsync')
                        else
                            ESX.ShowNotification("Cancelled.", 'error')
                        end
                    end)
                else
                    ESX.ShowNotification("Someone Recently did this.", 'error')
                end
            end)
        else
            ESX.ShowNotification("Cannot do this right now.", 'error')
        end
    end)
end)

-- Planting Bomb

RegisterNetEvent('sd-blackout:client:bombplant')
AddEventHandler('sd-blackout:client:bombplant', function()
    ESX.TriggerServerCallback('sd-blackout:server:HasItem', function(hasItem)
        if hasItem then
            TriggerEvent('sd-blackout:client:startblackout')
            Wait(1000)
        else
            ESX.ShowNotification("You dont have C4!", 'error')
        end
    end, "c4_bomb")
end)

-- Explosion

RegisterNetEvent('sd-blackout:client:lightsoff', function()
    SetArtificialLightsState(true)
    if Config.ShowVehicleLights then
        SetArtificialLightsStateAffectsVehicles(false)
    end
    TriggerEvent("chat:addMessage", {
        color = {255, 255, 255},
        -- multiline = true,
        template = '<div style="padding: 15px; margin: 15px; background-color: rgba(180, 117, 22, 0.9); border-radius: 15px;"><i class="far fa-building"style="font-size:15px"></i> | {0} </font></i></b></div>',
        args = {"City Power is currently out, we're working on restoring it!"}
    })
end)

RegisterNetEvent('sd-blackout:client:blackout')
AddEventHandler('sd-blackout:client:blackout', function()
    TriggerServerEvent("sd-blackout:Server:RemoveC4")
    ESX.ShowNotification("The explosive has been planted! Run away!", 'success')
    Wait(10500)
    AddExplosion(651.39, 100.92, 80.74, 2, 100000.0, true, false, 4.0)
    Wait(1000)
    AddExplosion(695.380, 148.735, 84.2194, 29, 6000000000000000000000000000000000000000000.0, true, false, 2.5)
    Wait(800)
    AddExplosion(677.273, 118.022, 84.2194, 29, 600000000000000000000000.0, true, false, 2.5)
    Wait(800)
    AddExplosion(661.905, 123.143, 84.2194, 29, 600000000000000000000000.0, true, false, 2.5)
    Wait(800)
    AddExplosion(703.672, 108.393, 84.2194, 29, 600000000000000000000000.0, true, false, 2.5)
    Wait(800)
    TriggerServerEvent('sd-blackout:server:lightsoff')
end)

-- Blackout Restoration

RegisterNetEvent('sd-blackout:client:restoresync', function()
    blackout = false
end)

RegisterNetEvent('sd-blackout:client:lightson', function()
    TriggerEvent("chat:addMessage", {
        color = {255, 255, 255},
        -- multiline = true,
        template = '<div style="padding: 15px; margin: 15px; background-color: rgba(180, 117, 22, 0.9); border-radius: 15px;"><i class="far fa-building"style="font-size:15px"></i> | {0} </font></i></b></div>',
        args = {"Power has been restored!"}
    })
    SetArtificialLightsState(false)
    if Config.ShowVehicleLights then
        SetArtificialLightsStateAffectsVehicles(true)
    end
    TriggerServerEvent('sd-blackout:server:restoresync')

end)

RegisterNetEvent('sd-blackout:client:fixlights')
AddEventHandler('sd-blackout:client:fixlights', function()
    TriggerServerEvent('sd-blackout:server:lightson')
    blackout = false
end)

-- Explosive Plant Animation

function bombanime()
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and
        not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Wait(50)
    end
    local ped = PlayerPedId()

    SetEntityHeading(ped, 162.54)
    Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
    local bagscene = NetworkCreateSynchronisedScene(651.39, 100.92, 80.84, rotx, roty, rotz + 1.1, 2, false, false,
        1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), 651.99, 100.92, 80.84, true, true, false)

    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2,
        -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge",
        4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Wait(1500)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local bomba = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.3, true, true, true)

    SetEntityCollision(bomba, false, true)
    AttachEntityToEntity(bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Wait(2000)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    DetachEntity(bomba, 1, 1)
    FreezeEntityPosition(bomba, true)

    NetworkStopSynchronisedScene(bagscene)
    Wait(2000)
    ClearPedTasks(ped)
    DeleteObject(bomba)
    StopParticleFxLooped(effect, 0)
end

-- Target Exports

exports["qtarget"]:AddCircleZone("Bomb", vector3(651.99, 101.11, 81.16), 2.0, {
    name = "Bomb",
    useZ = true
    -- debugPoly=true
}, {
    options = {{
        type = "client",
        event = "sd-blackout:client:bombplant",
        icon = "fas fa-bomb",
        label = "Plant Explosive"
    }, {
        type = "client",
        event = "sd-blackout:client:fixlights",
        icon = "fas fa-user-secret",
        label = "Restore Power",
        job = "police",

        canInteract = function()
            if blackout then
                return true
            else
                return false
            end
        end

    }},
    distance = 2.0
})
