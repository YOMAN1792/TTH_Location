-- Function to create a menu option
local function createMenuOption(label, price, model)
    local args = { price = price, label = label, model = model }
    return {
        title = label,
        description = string.format(Language[Config.lang].Menu["locationDescriptionFormat"], label, price),
        args = args,
        onSelect = function(selected)
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
            if args.price and args.label and args.model then
                TriggerServerEvent('TTH_Location.Location', args.price, args.label, args.model)
            else
                print("^1Error: Missing arguments for TriggerServerEvent. Ensure price, label, and model are valid.")
            end
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
    local canInteract = false
    local point = ESX.Point:new({
        coords = Config.PositionArea[1],
        distance = Config.Distance,
        hidden = Config.Hidden,
    })

    ESX.RegisterInteraction('interactWithPed', function()
        lib.showContext('Location')
    end, function()
        return canInteract
    end)

    function point:enter()
        canInteract = true
        ESX.TextUI(Language[Config.lang].Menu["Notification"]:format(ESX.GetInteractKey()))
        if Config.Debug == true then
            print("Enter")
        end
    end

    function point:leave()
        canInteract = false
        ESX.HideUI()
        if Config.Debug == true then
            print("Leave")
        end
    end
end)

-- Register a network event that spawns a car when triggered
RegisterNetEvent('TTH_Location.Location:spawnCar')
AddEventHandler('TTH_Location.Location:spawnCar', function(car)
    local status, error = pcall(function()
        local playerId = GetPlayerServerId(PlayerId())
        local playerName = GetPlayerName(PlayerId())

        -- Show a notification when the car is spawned
        ESX.ShowAdvancedNotification(
            Language[Config.lang].NotifVehicleSpawn["sender"],
            Language[Config.lang].NotifVehicleSpawn["subject"],
            Language[Config.lang].NotifVehicleSpawn["msg"],
            Config.textureDict, 1
        )

        local coords = vector3(Config.VehiclePosition.x, Config.VehiclePosition.y, Config.VehiclePosition.z)
        local heading = Config.VehiclePosition.heading

        ESX.Game.SpawnVehicle(car, coords, heading, function(vehicle)
            if DoesEntityExist(vehicle) then
                SetEntityAsMissionEntity(vehicle, true, true)
                SetVehicleNumberPlateText(vehicle, Config.PlateName)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

                -- Send a Discord log
                TriggerServerEvent('TTH_Location.Location:DiscordLog', playerId, playerName, car)
            else
                print("^Error : Impossible to spawn the vehicle " .. car)
            end
        end, true)
    end)

    if not status then
        print("^1An error occurred : " .. error)
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
