ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'tattoo', 'tattoo', 'society_tattoo', 'society_tattoo', 'society_tattoo', {type = 'private'})


RegisterNetEvent('popo_gang:register_tp_point')
AddEventHandler('popo_gang:register_tp_point', function(coord)
    local _src = source
    MySQL.Async.execute('INSERT INTO gang (name, label, coord) VALUES (@name, @coord)', {
        ['@name'] = coord.gang_name,
        ['@label'] = coord.label_name,
        ['@coord'] = json.encode(coord)
    })
end)
