RegisterNetEvent('TTH_Location.Location')
AddEventHandler('TTH_Location.Location', function(price, label, model)
  local status, error = pcall(function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xMoney = xPlayer.getMoney()
    local car = model

    if xPlayer == nil then
      print('Invalid player')
      return
    end

    -- Validate the price
    if type(price) ~= 'number' or price < 0 then
      print('Invalid price')
      return
    end

    -- Validate the car model
    local modelExists = false
    for _, v in pairs(Config.Cars.vehicles) do
      if v.model == model then
        modelExists = true
        break
      end
    end
    for _, v in pairs(Config.TwoWheels.vehicles) do
      if v.model == model then
        modelExists = true
        break
      end
    end
    if not modelExists then
      print('Invalid car model')
      return
    end

    if xMoney >= price then
      xPlayer.removeMoney(price)
    elseif xPlayer.getAccount("bank").money >= price then
      xPlayer.removeAccountMoney("bank", price)
    else
      TriggerClientEvent('esx:showAdvancedNotification', source,
        Language[Config.lang].NotifNoMoney["sender"],
        Language[Config.lang].NotifNoMoney["subject"],
        Language[Config.lang].NotifNoMoney["msg"],
        Config.textureDict, 1)
      return
    end
    TriggerClientEvent('TTH_Location.Location:spawnCar', _source, car)
  end)

  AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' has been started. ^5:) Have a good day!')
    print("^6This script was made by YOMAN1792")
    print("For any questions please add me on discord : ^2YOMAN1792")
  end)

  AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' was stopped. ^5:) Have a good day!')
    print("For any questions please add me : ^2YOMAN1792")
  end)

  RegisterNetEvent('TTH_Location.Location:DiscordLog')
  AddEventHandler('TTH_Location.Location:DiscordLog', function(playerId, playerName, car)
    local webhookURL = Secret.DiscordWebhook

    local embed = {
      ['color'] = 3447003,
      ['title'] = 'A player has spawned a car',
      ['description'] =
          '**Player :** ' .. playerName .. '\n' ..
          '**ID :** ' .. playerId .. '\n' ..
          '**Vehicle :** ' .. car,
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({ embeds = { embed } }),
      { ['Content-Type'] = 'application/json' })
  end)

  if not status then
    print('^1An error occurred: ' .. error)
  end
end)
