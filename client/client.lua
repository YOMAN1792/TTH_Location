-- Function to handle debug mod
local function debugPrint(...)
    if Config.Debug then
        print(...)
    end
end

-- Function to create a menu option
    local function createMenuOption(label, price, model)
        return {
            title = label,
            description = string.format(Language[Config.lang].Menu["locationDescriptionFormat"], label, price),
            args = { price = price, label = label, model = model },
            onSelect = function(args, selected)
                -- If debug mode is on, print some important information to the console
                    debugPrint("onSelect called")
                    debugPrint("selected: ", selected)
                    debugPrint("args: ", args)

                    if args then
                        debugPrint("args.price: ", args.price)
                        debugPrint("args.label: ", args.label)
                        debugPrint("args.model: ", args.model)
                    end

                -- Trigger a server event to handle the selection
                if args.price and args.label and args.model then
                    TriggerServerEvent('TTH_Location.Location', args.price, args.label, args.model)
                else
                    debugPrint("^1Error: Missing arguments for TriggerServerEvent. Ensure price, label, and model are valid.")
                end

                -- Hide the context menu
                lib.hideContext()
            end
        }
    end

-- Function to populate the context menu options
local function updateMenuOptions()
    local options = {
        { title = Language[Config.lang].TwoWheels["title"], disabled = true }
    }

    for _, v in ipairs(Config.TwoWheels.vehicles) do
        table.insert(options, createMenuOption(v.label, v.price, v.model))
    end

    table.insert(options, { title = Language[Config.lang].Cars["title"], disabled = true })

    for _, v in ipairs(Config.Cars.vehicles) do
        table.insert(options, createMenuOption(v.label, v.price, v.model))
    end

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
        debugPrint("Entered interaction zone")
    end

    function point:leave()
        canInteract = false
        ESX.HideUI()
        debugPrint("Left interaction zone")
    end
end)

-- PED
Citizen.CreateThread(function()
    local pedModel = "cs_lazlow"
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(0)
    end

    for _, v in ipairs(Config.PosPed) do
        local ped = CreatePed(4, pedModel, v.x, v.y, v.z, v.a, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
    end
end)

-- BLIPS
Citizen.CreateThread(function()
    for _, v in ipairs(Config.BlipMap) do
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