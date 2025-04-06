TTH_Location = {}
TTH_Location.Location = {}

-- Debugging function to print messages only if debugging is enabled
local function debugPrint(...)
  if Config.Debug then
      print(...)
  end
end

local function isValidPrice(price)
  return type(price) == 'number' and price >= 0
end

-- Event to handle vehicle rental (Main server-side entrypoint for renting a car)
RegisterNetEvent('TTH_Location.Location', function(price, label, model)
  local status, err = pcall(function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
      debugPrint('^1Error: Invalid player')
      return
    end
    
    -- Validate the price input
    if not isValidPrice(price) then
      debugPrint('^1Error: Invalid price -> ' .. tostring(price))
      return
    end    
    
    -- Validate if the car model is available in the configuration
    if not IsModelValid(model) then
      debugPrint('^1Error: Invalid car model -> ' .. tostring(model))
      return
    end

    -- Check money (cash and bank)
    local cash = xPlayer.getMoney()
    local bank = xPlayer.getAccount("bank").money

    if cash >= price then
      xPlayer.removeMoney(price)
    elseif bank >= price then
      xPlayer.removeAccountMoney("bank", price)
    else
      NotifyNoMoney(source)
      return
    end

    -- Spawn the vehicle for the player
    TTH_Location.Location:spawnCar(source, model)
  end)

  -- Catch and print any unexpected error
  if not status then
    print('^1An error occurred: ' .. tostring(err))
  end
end)

-- Function to spawn the vehicle for the player
function TTH_Location.Location:spawnCar(playerId, car)
  local xPlayer = ESX.GetPlayerFromId(playerId)
  local coords = vector3(Config.VehiclePosition.x, Config.VehiclePosition.y, Config.VehiclePosition.z)
  local heading = Config.VehiclePosition.heading

  if not car then
    debugPrint("^1Error: No car model provided")
    return
  end
  
  -- Notify the player that their vehicle has spawned
  TriggerClientEvent('esx:showAdvancedNotification', playerId,
    Language[Config.lang].NotifVehicleSpawn["sender"],
    Language[Config.lang].NotifVehicleSpawn["subject"],
    Language[Config.lang].NotifVehicleSpawn["msg"],
    Config.textureDict, 1
  )

  -- Attempt to spawn the vehicle in the game world
  ESX.OneSync.SpawnVehicle(car, coords, heading, {}, function(networkId)
    if networkId and networkId ~= 0 then
      Wait(100)
      local vehicle = NetworkGetEntityFromNetworkId(networkId)
      if DoesEntityExist(vehicle) then
        local playerPed = GetPlayerPed(playerId)
        SetVehicleNumberPlateText(vehicle, Config.PlateName)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

        -- Log the action to Discord
        LogToDiscord(playerId, xPlayer.getName(), car)
      else
        debugPrint("^1Error: Vehicle entity not found for network ID -> " .. tostring(networkId))
      end
    else
      debugPrint("^1Error: Vehicle spawn failed -> " .. tostring(car))
    end
  end)
end

-- Function to check if a model is valid based on configuration
function IsModelValid(model)
  local isValid = false

  if Config.Cars then
    for _, v in ipairs(Config.Cars.vehicles) do
      if v.model == model then
        isValid = true
        break
      end
    end
  end
  
  if not isValid and Config.TwoWheels then
    for _, v in ipairs(Config.TwoWheels.vehicles) do
      if v.model == model then
        isValid = true
        break
      end
    end
  end
  
  return isValid  
end

-- Function to notify a player that they don't have enough money
function NotifyNoMoney(playerId)
  TriggerClientEvent('esx:showAdvancedNotification', playerId,
    Language[Config.lang].NotifNoMoney["sender"],
    Language[Config.lang].NotifNoMoney["subject"],
    Language[Config.lang].NotifNoMoney["msg"],
    Config.textureDict, 1
  )
end

-- Function to log vehicle rentals to Discord via a webhook
function LogToDiscord(playerId, playerName, car)
  local webhookURL = Secret.DiscordWebhook
  local embed = {
    ['color'] = 3447003,
    ['title'] = 'A player has spawned a car',
    ['description'] =
        '**Player :** ' .. playerName .. '\n' ..
        '**ID :** ' .. playerId .. '\n' ..
        '**Vehicle :** ' .. car,
  }

  if not webhookURL or webhookURL == '' then
    debugPrint("^1Error: Discord webhook is not set!")
    return
  end

  PerformHttpRequest(webhookURL, function(err, text, headers) 
    if err ~= 200 and err ~= 204 then -- Ignore 204 (No Content) responses
      debugPrint("^1Error sending webhook: " .. tostring(err))
    end
  end, 'POST', json.encode({ embeds = { embed } }), { ['Content-Type'] = 'application/json' })
end

-- Event triggered when the resource starts
RegisterNetEvent('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() == resourceName) then
    print('The resource ' .. resourceName .. ' has been started. ^5:) Have a good day!')
    print("^6This script was made by YOMAN1792")
    print("For any questions please add me on discord : ^2YOMAN1792")
  end
end)

-- Event triggered when the resource stops
RegisterNetEvent('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() == resourceName) then
    print('The resource ' .. resourceName .. ' was stopped. ^5:) Have a good day!')
    print("For any questions please add me : ^2YOMAN1792")
  end
end)
