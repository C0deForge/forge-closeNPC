ESX = nil
QBCore = nil
local checkedVehicles = {}
local LockpickInProgress = false

-- Framework detection
if Config.Framework == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'QB' then
    QBCore = exports['qb-core']:GetCoreObject()
end

-- Check if vehicle has already been processed
function isAlreadyChecked(vehicle)
    local checked = false
    for _, v in pairs(checkedVehicles) do
        if v == vehicle then
            checked = true
            break
        end
    end
    return checked
end

-- Main thread to manage NPC vehicle locking
CreateThread(function()
    while true do
        local wait = 300
        local plyPed = PlayerPedId()
        local vehicle = GetVehiclePedIsTryingToEnter(plyPed)

        if DoesEntityExist(vehicle) then
            local populationType = GetEntityPopulationType(vehicle)
            if populationType == 2 or populationType == 4 or populationType == 5 or populationType == 6 then
                if not isAlreadyChecked(vehicle) then
                    if Config.Framework == 'ESX' then
                        ESX.TriggerServerCallback("forge-closeNPC:checkAndLock", function(data)
                            local alreadyIn = data.alreadyIn
                            local locked = data.locked
                            if not alreadyIn then
                                if locked then
                                    SetVehicleDoorsLocked(vehicle, Config.LockType)
                                    if Config.Debug then
                                        print("[DEBUG] Vehicle with plate " .. GetVehicleNumberPlateText(vehicle) .. " has been locked.")
                                    end
                                end
                                table.insert(checkedVehicles, vehicle)
                            end
                        end, vehicle)
                    elseif Config.Framework == 'QB' then
                        QBCore.Functions.TriggerCallback("forge-closeNPC:checkAndLock", function(data)
                            local alreadyIn = data.alreadyIn
                            local locked = data.locked
                            if not alreadyIn then
                                if locked then
                                    SetVehicleDoorsLocked(vehicle, Config.LockType)
                                    if Config.Debug then
                                        print("[DEBUG] Vehicle with plate " .. GetVehicleNumberPlateText(vehicle) .. " has been locked.")
                                    end
                                end
                                table.insert(checkedVehicles, vehicle)
                            end
                        end, vehicle)
                    end
                end

                if GetVehicleDoorsLockedForPlayer(vehicle, plyPed) then
                    ClearPedTasks(plyPed)
                    if Config.Debug then
                        print("[DEBUG] Player prevented from entering the locked vehicle.")
                    end
                end
            end
        end
        Wait(wait)
    end
end)

-- Unlock the vehicle if lockpick is successful
RegisterNetEvent("forge-closeNPC:unlockVehicle")
AddEventHandler("forge-closeNPC:unlockVehicle", function(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    SetVehicleDoorsLocked(vehicle, 1) -- Unlock the vehicle
    SetVehicleDoorsLockedForAllPlayers(vehicle, false) -- Ensure it's unlocked for all players
    if Config.Debug then
        print("[DEBUG] Vehicle with plate " .. plate .. " has been unlocked.")
    end
end)

-- Start lockpick minigame with animations
function startLockpick()
    if LockpickInProgress then
        Config.Notify(Config.Translations.LockpickInProgress)
        return
    end

    LockpickInProgress = true
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)

    if DoesEntityExist(vehicle) then
        local lockStatus = GetVehicleDoorLockStatus(vehicle)
        local plate = GetVehicleNumberPlateText(vehicle)
        if lockStatus == 1 then
            Config.Notify(Config.Translations.VehicleAlreadyUnlocked)
            LockpickInProgress = false
            return
        end

        -- Make the player look at the car
        local vehicleCoords = GetEntityCoords(vehicle)
        TaskTurnPedToFaceCoord(playerPed, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, 1000)
        Wait(1000) -- We wait a second to ensure the player is looking at the car

        -- Play the "missmechanic:work_in" animation to start the lockpicking process
        RequestAnimDict("missmechanic")
        while not HasAnimDictLoaded("missmechanic") do
            Wait(100)
        end
        TaskPlayAnim(playerPed, "missmechanic", "work_in", 8.0, -8.0, -1, 1, 0, false, false, false)

        -- After "work_in" finishes, switch to "work_base" while the minigame is in progress
        Wait(1000) -- Small delay to allow "work_in" to finish
        TaskPlayAnim(playerPed, "missmechanic", "work_base", 8.0, -8.0, -1, 1, 0, false, false, false)

        -- Check if player has the lockpick item using the selected Inventory (OX or QB)
        local hasLockpick = false
        if Config.Inventory == 'OX' then
            hasLockpick = exports.ox_inventory:Search('count', Config.LockpickItem) > 0
        elseif Config.Inventory == 'QB' then
            hasLockpick = QBCore.Functions.HasItem(Config.LockpickItem)
        end

        if hasLockpick then
            -- Trigger the police alert from config.lua
            Config.AlertPolice(coords, plate)

            -- Start lockpicking minigame
            local success = exports['lockpick']:startLockpick()

            -- Consume 1 lockpick item after the attempt (whether successful or not)
            TriggerServerEvent('forge-closeNPC:removeLockpick')

            -- Play the "missmechanic:work_out" animation once the minigame is over
            TaskPlayAnim(playerPed, "missmechanic", "work_out", 8.0, -8.0, -1, 0, 0, false, false, false)

            -- Wait for the duration of the "work_out" animation
            Wait(3000) -- Adjust the time if needed for how long you want the animation to last

            -- Stop the animation
            ClearPedTasksImmediately(playerPed)

            if success then
                TriggerEvent("forge-closeNPC:unlockVehicle", vehicle)
                Config.Notify(Config.Translations.LockpickSuccess)
            else
                Config.Notify(Config.Translations.LockpickFailed)
            end
        else
            Config.Notify(Config.Translations.NoLockpickItem)
            ClearPedTasksImmediately(playerPed) -- Clear animations if no lockpick is available
        end
    else
        Config.Notify(Config.Translations.NoVehicleNearby)
    end
    LockpickInProgress = false
end

-- Exports for lockpick interaction
exports('startLockpick', function(data, slot)
    startLockpick()
end)
