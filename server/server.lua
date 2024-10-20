ESX = nil
QBCore = nil
local LockedVehicles = {}

-- Inicialización del framework
if Config.Framework == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'QB' then
    QBCore = exports['qb-core']:GetCoreObject()
end

-- Check and lock NPC vehicle
if Config.Framework == 'ESX' then
    ESX.RegisterServerCallback("forge-closeNPC:checkAndLock", function(source, cb, vehicle)
        local player = ESX.GetPlayerFromId(source)
        if player then
            local alreadyIn = false
            local data = {locked = false, alreadyIn = false}
            for _, v in pairs(LockedVehicles) do
                if vehicle == v then
                    alreadyIn = true
                    data.alreadyIn = true
                end
            end

            if not alreadyIn then
                table.insert(LockedVehicles, vehicle)
                if not Config.IsVehicleOpened() then
                    SetVehicleDoorsLocked(vehicle, Config.LockType)
                    data.locked = true
                end
            end

            cb(data)
        else
            cb(false)
        end
    end)

    -- Check and unlock NPC vehicle
    ESX.RegisterServerCallback("forge-closeNPC:checkAndUnlock", function(source, cb, vehicle)
        local player = ESX.GetPlayerFromId(source)
        if player then
            local alreadyIn = false
            local data = {locked = false, alreadyIn = false}
            for _, v in pairs(LockedVehicles) do
                if vehicle == v then
                    alreadyIn = true
                    data.alreadyIn = true
                end
            end

            if not alreadyIn then
                SetVehicleDoorsLocked(vehicle, 1)
                data.locked = true
            end

            cb(data)
        else
            cb(false)
        end
    end)

    -- Handle lockpick attempt
    ESX.RegisterServerCallback("forge-closeNPC:attemptLockpick", function(source, cb)
        local success = Config.IsLockpickSuccessful()
        cb(success)
    end)

    -- Remove 1 lockpick after an attempt
    RegisterNetEvent('forge-closeNPC:removeLockpick')
    AddEventHandler('forge-closeNPC:removeLockpick', function()
        local player = ESX.GetPlayerFromId(source)
        if player then
            local item = Config.LockpickItem
            player.removeInventoryItem(item, 1)
        end
    end)
elseif Config.Framework == 'QB' then
    -- QBCore version
    QBCore.Functions.CreateCallback("forge-closeNPC:checkAndLock", function(source, cb, vehicle)
        local player = QBCore.Functions.GetPlayer(source)
        if player then
            local alreadyIn = false
            local data = {locked = false, alreadyIn = false}
            for _, v in pairs(LockedVehicles) do
                if vehicle == v then
                    alreadyIn = true
                    data.alreadyIn = true
                end
            end

            if not alreadyIn then
                table.insert(LockedVehicles, vehicle)
                if not Config.IsVehicleOpened() then
                    SetVehicleDoorsLocked(vehicle, Config.LockType)
                    data.locked = true
                end
            end

            cb(data)
        else
            cb(false)
        end
    end)

    -- Check and unlock NPC vehicle
    QBCore.Functions.CreateCallback("forge-closeNPC:checkAndUnlock", function(source, cb, vehicle)
        local player = QBCore.Functions.GetPlayer(source)
        if player then
            local alreadyIn = false
            local data = {locked = false, alreadyIn = false}
            for _, v in pairs(LockedVehicles) do
                if vehicle == v then
                    alreadyIn = true
                    data.alreadyIn = true
                end
            end

            if not alreadyIn then
                SetVehicleDoorsLocked(vehicle, 1)
                data.locked = true
            end

            cb(data)
        else
            cb(false)
        end
    end)

    -- Handle lockpick attempt
    QBCore.Functions.CreateCallback("forge-closeNPC:attemptLockpick", function(source, cb)
        local success = Config.IsLockpickSuccessful()
        cb(success)
    end)

    -- Remove 1 lockpick after an attempt
    RegisterNetEvent('forge-closeNPC:removeLockpick')
    AddEventHandler('forge-closeNPC:removeLockpick', function()
        local player = QBCore.Functions.GetPlayer(source)
        if player then
            local item = Config.LockpickItem
            player.Functions.RemoveItem(item, 1)
        end
    end)
end
