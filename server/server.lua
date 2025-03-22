RegisterNetEvent('TTH_Location.Location')
AddEventHandler('TTH_Location.Location', function(price, label, model)
  local status, error = pcall(function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
      print('Invalid player')
      return
    end

    -- Validate the price
    if type(price) ~= 'number' or price < 0 then
      print('Invalid price')
      return
    end

    -- Validate the car model
    local modelExists = IsModelValid(model)
    if not modelExists then
      print('Invalid car model')
      return
    end

    if xPlayer.getMoney() >= price then
      xPlayer.removeMoney(price)
    elseif xPlayer.getAccount("bank").money >= price then
      xPlayer.removeAccountMoney("bank", price)
    else
      NotifyNoMoney()
      return
    end

    -- Trigger car spawn
    TriggerClientEvent('TTH_Location.Location:spawnCar', _source, model)
    LogToDiscord(_source, xPlayer.getName(), model)
  end)
  if not status then
    print('^1An error occurred: ' .. error)
  end
end)

function IsModelValid(model)
  for _, v in pairs(Config.Cars.vehicles) do
    if v.model == model then return true end
  end
  for _, v in pairs(Config.TwoWheels.vehicles) do
    if v.model == model then return true end
  end
  return false
end

function NotifyNoMoney()
  TriggerClientEvent('esx:showAdvancedNotification', source,
    Language[Config.lang].NotifNoMoney["sender"],
    Language[Config.lang].NotifNoMoney["subject"],
    Language[Config.lang].NotifNoMoney["msg"],
    Config.textureDict, 1)
end

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

  PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({ embeds = { embed } }),
    { ['Content-Type'] = 'application/json' })
end

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() == resourceName) then
    print('The resource ' .. resourceName .. ' has been started. ^5:) Have a good day!')
    print("^6This script was made by YOMAN1792")
    print("For any questions please add me on discord : ^2YOMAN1792")
  end
end)

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() == resourceName) then
    print('The resource ' .. resourceName .. ' was stopped. ^5:) Have a good day!')
    print("For any questions please add me : ^2YOMAN1792")
  end
end)
