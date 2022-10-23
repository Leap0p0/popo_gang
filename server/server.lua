ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local society_name = nil
local gangpoint = {}
local job = nil

local function InitGangs()
    MySQL.Async.fetchAll('SELECT * FROM gang', {}, function(data)
        for k,v in pairs(data) do
            local society = 'society_'..v.name
            TriggerEvent('esx_society:registerSociety', v.name, v.label, society, society, society, {type = 'public'})
        end
    end)
end

Citizen.CreateThread(function()
    InitGangs()
end)

RegisterNetEvent('popo_gang:register_gang')
AddEventHandler('popo_gang:register_gang', function(coord)
    local _src = source
    society_name = "society_"..coord.gang_name
    MySQL.Async.execute('INSERT INTO gang (name, label, coord) VALUES (@name, @label, @coord)', {
        ['@name'] = coord.gang_name,
        ['@label'] = coord.label_name,
        ['@coord'] = json.encode(coord)
    })
    MySQL.Async.execute('INSERT INTO jobs (name, label, SecondaryJob) VALUES (@name, @label, @SecondaryJob)', {
        ['@name'] = coord.gang_name,
        ['@label'] = coord.label_name,
        ['@SecondaryJob'] = 1
    })
    
end)


RegisterNetEvent('popo_gang:register_job_grades')
AddEventHandler('popo_gang:register_job_grades', function(coord)
    MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, skin_female)', {
        ['@job_name'] = coord.gang_name,
        ['@grade'] = 0,
        ['@name'] = "petit",
        ['@label'] = coord.name_petit,
        ['@salary'] = 0,
        ['@skin_male'] = "{}",
        ['@skin_female'] = "{}"
    })
    MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, skin_female)', {
        ['@job_name'] = coord.gang_name,
        ['@grade'] = 1,
        ['@name'] = "moyen",
        ['@label'] = coord.name_moyen,
        ['@salary'] = 0,
        ['@skin_male'] = "{}",
        ['@skin_female'] = "{}"
    })
    MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, skin_female)', {
        ['@job_name'] = coord.gang_name,
        ['@grade'] = 2,
        ['@name'] = "grand",
        ['@label'] = coord.name_grand,
        ['@salary'] = 0,
        ['@skin_male'] = "{}",
        ['@skin_female'] = "{}"
    })
    MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, skin_female)', {
        ['@job_name'] = coord.gang_name,
        ['@grade'] = 3,
        ['@name'] = "boss",
        ['@label'] = coord.name_boss,
        ['@salary'] = 0,
        ['@skin_male'] = "{}",
        ['@skin_female'] = "{}"
    })
end)

RegisterNetEvent('popo_gang:register_Inventory_account')
AddEventHandler('popo_gang:register_Inventory_account', function(coord)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    society_name = "society_"..xPlayer.job2.name
    MySQL.Async.execute('INSERT INTO addon_inventory (name, label, shared) VALUES (@name, @label, @shared)', {
        ['@name'] = society_name,
        ['@label'] = coord.label_name,
        ['@shared'] = 1
    })
    MySQL.Async.execute('INSERT INTO addon_account (name, label, shared) VALUES (@name, @label, @shared)', {
        ['@name'] = society_name,
        ['@label'] = coord.label_name,
        ['@shared'] = 1
    })
end)

CreateThread(function()
    MySQL.Async.fetchAll("SELECT * FROM gang", {}, function(result)
        for i, row in pairs(result) do
            local data = json.decode(row.coord)
            data.gang_name = row.name
            data.label_name = row.label
            data.first_coord = vector3(data.first_coord.x, data.first_coord.y, data.first_coord.z)
            data.second_coord = vector3(data.second_coord.x, data.second_coord.y, data.second_coord.z)
            table.insert(gangpoint, data)
        end

        print(( _U('load').."^3%i^7".._U('load_bis')):format(#result))
    end)
end)

RegisterNetEvent("popo_gang:requestgang", function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{['@identifier'] = xPlayer.identifier}, function(result)
    	job = result[1].job2
    end)
    TriggerClientEvent("popo_gang:nbgang", _src, gangpoint)
end)

RegisterServerEvent('popogang:getStockItems')
AddEventHandler('popogang:getStockItems', function(itemName, count, so_name)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    local job_society = "society_"..xPlayer.job2.name
	TriggerEvent('esx_addoninventory:getSharedInventory', job_society, function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
		end
		TriggerClientEvent('esx:showNotification', _source, 'Tu as pris '..count..' '.. item.label..' dans le coffre')
	end)
end)

ESX.RegisterServerCallback('popogang:getStockItems', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job_society = "society_"..xPlayer.job2.name
    TriggerEvent('esx_addoninventory:getSharedInventory', job_society, function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('popogang:putStockItems')
AddEventHandler('popogang:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    local job_society = "society_"..xPlayer.job2.name
	TriggerEvent('esx_addoninventory:getSharedInventory', job_society, function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
		end
        TriggerClientEvent('esx:showNotification', _source, 'tu as ajouté '..count..' '.. item.label..' au coffre')
	end)
end)

ESX.RegisterServerCallback('popogang:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})
end)

RegisterServerEvent('popogang:handcuff')
AddEventHandler('popogang:handcuff', function(target)
  TriggerClientEvent('popogang:handcuff', target)
end)

RegisterServerEvent('popogang:drag')
AddEventHandler('popogang:drag', function(target)
  local _source = source
  TriggerClientEvent('popogang:drag', target, _source)
end)

RegisterServerEvent('popogang:putInVehicle')
AddEventHandler('popogang:putInVehicle', function(target)
  TriggerClientEvent('popogang:putInVehicle', target)
end)

RegisterServerEvent('popogang:OutVehicle')
AddEventHandler('popogang:OutVehicle', function(target)
    TriggerClientEvent('popogang:OutVehicle', target)
end)

ESX.RegisterServerCallback('popogang:getOtherPlayerData',function(source, cb, target)

    if Config.EnableESXIdentity then
  
      local xPlayer = ESX.GetPlayerFromId(target)
  
      local identifier = GetPlayerIdentifiers(target)[1]
  
      local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
      })
  
      local user      = result[1]
      local firstname     = user['firstname']
      local lastname      = user['lastname']
      local sex           = user['sex']
      local dob           = user['dateofbirth']
      local height        = user['height'] .. " Inches"
  
      local data = {
        name        = GetPlayerName(target),
        job         = xPlayer.job,
        inventory   = xPlayer.inventory,
        accounts    = xPlayer.accounts,
        weapons     = xPlayer.loadout,
        firstname   = firstname,
        lastname    = lastname,
        sex         = sex,
        dob         = dob,
        height      = height
      }
  
      TriggerEvent('esx_status:getStatus', _source, 'drunk', function(status)
  
        if status ~= nil then
          data.drunk = math.floor(status.percent)
        end
  
      end)
  
      if Config.EnableLicenses then
  
        TriggerEvent('esx_license:getLicenses', _source, function(licenses)
          data.licenses = licenses
          cb(data)
        end)
  
      else
        cb(data)
      end
  
    else
  
      local xPlayer = ESX.GetPlayerFromId(target)
  
      local data = {
        name       = GetPlayerName(target),
        job        = xPlayer.job,
        inventory  = xPlayer.inventory,
        accounts   = xPlayer.accounts,
        weapons    = xPlayer.loadout
      }
  
      TriggerEvent('esx_status:getStatus', _source, 'drunk', function(status)
  
        if status ~= nil then
          data.drunk = status.getPercent()
        end
  
      end)
  
      TriggerEvent('esx_license:getLicenses', _source, function(licenses)
        data.licenses = licenses
      end)
  
      cb(data)
  
    end
  
  end)

  RegisterServerEvent('popogang:confiscatePlayerItem')
AddEventHandler('popogang:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then

    local label = sourceXPlayer.getInventoryItem(itemName).label

    targetXPlayer.removeInventoryItem(itemName, amount)
    sourceXPlayer.addInventoryItem(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confinv') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confinv') .. amount .. ' ' .. label )

  end

  if itemType == 'item_account' then

    targetXPlayer.removeAccountMoney(itemName, amount)
    sourceXPlayer.addAccountMoney(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confdm') .. amount .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confdm') .. amount)

  end

  if itemType == 'item_weapon' then

    targetXPlayer.removeWeapon(itemName)
    sourceXPlayer.addWeapon(itemName, amount)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_have_confweapon') .. ESX.GetWeaponLabel(itemName) .. _U('from') .. targetXPlayer.name)
    TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. _U('confweapon') .. ESX.GetWeaponLabel(itemName))

  end

end)

ESX.RegisterServerCallback('popogang:getVehicleInfos',function(source, cb, plate)

    if Config.EnableESXIdentity then
  
      MySQL.Async.fetchAll(
        'SELECT * FROM owned_vehicles',
        {},
        function(result)
  
          local foundIdentifier = nil
  
          for i=1, #result, 1 do
  
            local vehicleData = json.decode(result[i].vehicle)
  
            if vehicleData.plate == plate then
              foundIdentifier = result[i].owner
              break
            end
  
          end
  
          if foundIdentifier ~= nil then
  
            MySQL.Async.fetchAll(
              'SELECT * FROM users WHERE identifier = @identifier',
              {
                ['@identifier'] = foundIdentifier
              },
              function(result)
  
                local ownerName = result[1].firstname .. " " .. result[1].lastname
  
                local infos = {
                  plate = plate,
                  owner = ownerName
                }
  
                cb(infos)
  
              end
            )
  
          else
  
            local infos = {
            plate = plate
            }
  
            cb(infos)
  
          end
  
        end
      )
  
    else
  
      MySQL.Async.fetchAll(
        'SELECT * FROM owned_vehicles',
        {},
        function(result)
  
          local foundIdentifier = nil
  
          for i=1, #result, 1 do
  
            local vehicleData = json.decode(result[i].vehicle)
  
            if vehicleData.plate == plate then
              foundIdentifier = result[i].owner
              break
            end
  
          end
  
          if foundIdentifier ~= nil then
  
            MySQL.Async.fetchAll(
              'SELECT * FROM users WHERE identifier = @identifier',
              {
                ['@identifier'] = foundIdentifier
              },
              function(result)
  
                local infos = {
                  plate = plate,
                  owner = result[1].name
                }
  
                cb(infos)
  
              end
            )
  
          else
  
            local infos = {
            plate = plate
            }
  
            cb(infos)
  
          end
  
        end
      )
  
    end
  
  end)