Config = {}

-- IMPORTANT: This script is only tested with ESX. While a bridge has been added for QB, 
-- it has not been fully tested in that framework. Please note that QB Core has its own 
-- system for handling vehicle lockpicking, which works very well. 
-- Although this script includes compatibility for QB, it is recommended to use it with ESX 
-- for stability and reliability, as the QB version may not work as expected.

-- Debug mode (True/False)
Config.Debug = true

-- Framework selection: ESX or QB
Config.Framework = 'ESX' -- Choose between 'ESX' or 'QB'

-- Inventory selection: OX or QB
Config.Inventory = 'OX' -- Choose between 'OX' or 'QB'

-- Lock type for NPC vehicles (Refer to FiveM docs for more types)
Config.LockType = 2

-- OX/QB Inventory item definition for the lockpick
Config.LockpickItem = 'lockpick'

-- Police alert settings
Config.AlertPoliceEnabled = true -- Enable or disable police alerts
Config.AlertProbability = 10 -- Percentage chance of alerting the police when lockpicking

-- Function to alert the police
Config.AlertPolice = function(coords, plate)
    if Config.AlertPoliceEnabled and math.random(0, 100) <= Config.AlertProbability then
        TriggerServerEvent("SendAlert:police", {
            coords = coords,
            title = 'Vehicle Theft',
            type = 'GENERAL',
            message = 'Someone is trying to hotwire a vehicle ' .. plate,
            job = 'police',
        })
        Config.Notify(Config.Translations.PoliceAlertTriggered) -- Notification translated
    end
end

-- Function to check if vehicle can be opened (10% chance that a vehicle is open) 
Config.IsVehicleOpened = function() -- If you want a percentage of cars to be unlocked, uncomment the above line and remove the return false below.
    -- local rand = math.random(0, 100)
    -- return rand <= 10 -- 10% chance the vehicle will be open
    return false -- If you dont want any vehicle to be unlocked randomly, stay with return false
end

-- Function to send notifications based on the framework
Config.Notify = function(text)
    if Config.Framework == 'ESX' then
        if ESX ~= nil then
            ESX.ShowNotification(text)
        else
            print("[ERROR] ESX is not properly initialized!")
        end
    elseif Config.Framework == 'QB' then
        if QBCore ~= nil then
            QBCore.Functions.Notify(text)
        else
            print("[ERROR] QBCore is not properly initialized!")
        end
    else
        print("[ERROR] Invalid framework selected in Config!")
    end
end

-- Translations for notifications and messages
Config.Translations = {
    LockpickInProgress = "¡Ya estás intentando forzar una cerradura!",
    LockpickFailed = "¡Fallaste al forzar la cerradura!",
    LockpickSuccess = "¡Éxito al forzar la cerradura! Vehículo desbloqueado.",
    NoLockpickItem = "¡No tienes una ganzúa!",
    NoVehicleNearby = "¡No hay vehículos cercanos!",
    VehicleAlreadyUnlocked = "Este vehículo ya está desbloqueado.",
    PoliceAlertTriggered = "¡Oh no! Un vecino ha llamado a la policía por verte ganzuando."
}


-- OX Inventory item for lockpick
-- OXInventory = {
--     ['lockpick'] = {
--         label = 'Lockpick',
--         weight = 1,
--         stack = true,
--         close = true,
--         description = 'Used to pick locks',
--         client = {
--             export = 'forge-closeNPC.startLockpick'
--         }
--     }
-- }
