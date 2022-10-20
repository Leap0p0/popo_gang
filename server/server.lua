ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local society_name = nil
local gangpoint = {}
local job = nil

local function InitGangs()
    MySQL.Async.fetchAll('SELECT * FROM gang', {}, function(data)
        for k,v in pairs(data) do
            local society = 'society_'..v.name
            print(society)
            print(v.name)
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
    society_name = "society_"..coord.gang_name
    print(society_name)
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
    local job_society = "society_"..job
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
    local job_society = "society_"..job
    TriggerEvent('esx_addoninventory:getSharedInventory', job_society, function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('popogang:putStockItems')
AddEventHandler('popogang:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    local job_society = "society_"..job
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