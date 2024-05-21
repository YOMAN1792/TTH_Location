-- Function to create a menu option
local function createMenuOption(label, price, model)
    local args = { price = price, label = label, model = model }
    return {
        title = label,
        description = string.format(Language[Config.lang].Menu["locationDescriptionFormat"], label, price),
        args = args,
        onSelect = function(selected, secondary)
            -- If debug mode is on, print some important information to the console
            if Config.Debug == true then
                print("onSelect called")
                print("selected: ", selected)
                print("args: ", args)
                if args then
                    print("args.price: ", args.price)
                    print("args.label: ", args.label)
                    print("args.model: ", args.model)
                end
            end
            -- Trigger a server event to handle the selection
            TriggerServerEvent('{-TTH_Location-}::Location', args.price, args.label, args.model)
            -- Hide the context menu
            lib.hideContext()
        end
    }
end

-- Function to populate the context menu options
local function updateMenuOptions()
    local options = {}

    -- Add scooter options
    table.insert(options, { title = Language[Config.lang].TwoWheels["title"], disabled = true })
    for k, v in pairs(Config.TwoWheels.vehicles) do
        table.insert(options, createMenuOption(v.label, v.price, v.model))
    end

    -- Add car options
    table.insert(options, { title = Language[Config.lang].Cars["title"], disabled = true })
    for k, v in pairs(Config.Cars.vehicles) do
        table.insert(options, createMenuOption(v.label, v.price, v.model))
    end


    -- Update the context menu options
    lib.registerContext({ id = 'Location', title = Language[Config.lang].Menu["Title"], options = options })
end

-- Call the function once to initialize the menu
updateMenuOptions()

-- Create a thread to show the context menu when the player is near the location
Citizen.CreateThread(function()
    local waitTime = 500            -- Default wait time
    local notificationShown = false -- Track if the notification has been shown
    while true do
        Citizen.Wait(waitTime)
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local nearMenu = false
        for k in pairs(Config.PositionArea) do
            local dist = #(plyCoords - Config.PositionArea[k])
            if dist <= 1.0 then
                nearMenu = true
                if not notificationShown then
                    ESX.ShowNotification(Language[Config.lang].Menu["Notification"])
                    notificationShown = true
                end
                if IsControlJustPressed(1, 51) then
                    lib.showContext('Location')
                end
                break -- Exit the loop as soon as we find a nearby menu to reduce latency
            end
        end
        -- Adjust the wait time based on whether the player is near a menu
        waitTime = nearMenu and 0 or 500
        if not nearMenu then
            notificationShown = false -- Reset the notification tracking when the player is not near a menu
        end
    end
end)

-- Register a network event that spawns a car when triggered
RegisterNetEvent('{-TTH_Location-}::Location:spawnCar')
AddEventHandler('{-TTH_Location-}::Location:spawnCar', function(car)
    local status, error = pcall(function()
        local model = GetHashKey(car)
        local playerId = GetPlayerServerId(PlayerId())
        local playerName = GetPlayerName(PlayerId())

        -- Check if the model is loaded
        if not HasModelLoaded(model) then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
        end

        local retval = PlayerPedId()

        -- Show a notification when the car is spawned
        ESX.ShowAdvancedNotification(
            Language[Config.lang].NotifVehicleSpawn["sender"],
            Language[Config.lang].NotifVehicleSpawn["subject"],
            Language[Config.lang].NotifVehicleSpawn["msg"],
            Config.textureDict, 1)
        RequestModel(car)
        while not HasModelLoaded(car) do
            RequestModel(car)
            Citizen.Wait(0)
        end

        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
        Citizen.Wait(500)
        local vehicle = CreateVehicle(car,
            Config.VehiclePosition.x,
            Config.VehiclePosition.y,
            Config.VehiclePosition.z,
            Config.VehiclePosition.heading, true, false)
        SetEntityAsMissionEntity(vehicle, true, true)
        local plaque = Config.PlateName
        SetVehicleNumberPlateText(vehicle, plaque)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        TriggerServerEvent('{-TTH_Location-}::Location:DiscordLog', playerId, playerName, car)
    end)
    if not status then
        print('^1An error occurred: ' .. error)
    end
end)

-- PED
Citizen.CreateThread(function()
    local hash = GetHashKey("cs_lazlow")
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
    end
    for k, v in pairs(Config.PosPed) do
        ped = CreatePed("PED_TYPE_CIVMALE", "cs_lazlow", v.x, v.y, v.z, v.a, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
    end
end)


-- -- BLIPS
Citizen.CreateThread(function()
    for k, v in pairs(Config.BlipMap) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)

        SetBlipSprite(blip, 225)
        SetBlipScale(blip, 0.9)
        SetBlipColour(blip, 43)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Language[Config.lang].Menu["BlipName"])
        EndTextCommandSetBlipName(blip)
    end
end)
