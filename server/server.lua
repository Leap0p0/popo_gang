ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--TriggerEvent('esx_society:registerSociety', 'tattoo', 'tattoo', 'society_tattoo', 'society_tattoo', 'society_tattoo', {type = 'private'})

local society_name = nil

RegisterNetEvent('popo_gang:register_gang')
AddEventHandler('popo_gang:register_gang', function(coord)
    local _src = source
    society_name = "society"..coord.gang_name
    MySQL.Async.execute('INSERT INTO gang (name, label, coord) VALUES (@name, @label, @label)', {
        ['@name'] = coord.gang_name,
        ['@label'] = coord.label_name,
        ['@coord'] = json.encode(coord)
    })
    MySQL.Async.execute('INSERT INTO gang (name, label, SecondaryJob) VALUES (@name, @label, @SecondaryJob)', {
        ['@name'] = coord.gang_name,
        ['@label'] = coord.label_name,
        ['@SecondaryJob'] = 1
    })
end)


RegisterNetEvent('popo_gang:register_Inventory_account')
AddEventHandler('popo_gang:register_Inventory', function(coord)
    local _src = source
    society_name = "society"..coord.gang_name
    MySQL.Async.execute('INSERT INTO addon_inventory (name, label, shared) VALUES (@name, @label, @shared)', {
        ['@name'] = society_name,
        ['@label'] = coord.gang_name,
        ['@shared'] = 1
    })
    MySQL.Async.execute('INSERT INTO addon_account (name, label, shared) VALUES (@name, @label, @shared)', {
        ['@name'] = society_name,
        ['@label'] = coord.gang_name,
        ['@shared'] = 1
    })
end)

--[[RegisterServerEvent('popo_tattoo_job:getStockItems')
AddEventHandler('popo_tattoo_job:getStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tattoo', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', _source, 'Quantité invalide')
		end
		TriggerClientEvent('esx:showNotification', _source, 'tu as pris '..count..' '.. item.label..' au coffre')
	end)
end)

ESX.RegisterServerCallback('popo_tattoo_job:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tattoo', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('popo_tattoo_job:putStockItems')
AddEventHandler('popo_tattoo_job:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tattoo', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', _source, 'Quantité invalide')
		end
        TriggerClientEvent('esx:showNotification', _source, 'tu as ajouté '..count..' '.. item.label..' au coffre')
	end)
end)

ESX.RegisterServerCallback('popo_tattoo_job:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})
end)]]--
