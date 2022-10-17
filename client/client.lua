ESX = nil

local name = nil
local label = nil
local name_suppr = nil
local first_place = nil
local second_place = nil
local builder = {
    first_coord = nil,
    second_coord = nil
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RMenu.Add("popogang", "categorie", RageUI.CreateMenu("Souhaitez-vous", "~b~ Créer / Supprimer"))
RMenu:Get("popogang", "categorie").Closed = function()
end

RMenu.Add("popogang", "create", RageUI.CreateSubMenu(RMenu:Get("popogang", "categorie"), "lolo", nil))
RMenu:Get("popogang", "create").Closed = function()
end

RMenu.Add("popogang", "delete", RageUI.CreateSubMenu(RMenu:Get("popogang", "categorie"), "eded", nil))
RMenu:Get("popogang", "delete").Closed = function()
end

local function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
		blockinput = false
        return result
    else
        Citizen.Wait(500)
		blockinput = false
        return nil
    end
end

--open the menu in RageUI--
local function openMenu()

    RageUI.Visible(RMenu:Get("popogang","categorie"), true)
    Citizen.CreateThread(function()
        while true do
            --Create / Delete--
            RageUI.IsVisible(RMenu:Get("popogang","categorie"),true,true,true,function()
                RageUI.Button("Créer" , "Créer", {RightLabel = "~g~>>>"}, true,function(h,a,s)
                    if (s) then
                    end
                end, RMenu:Get("popogang", "create"))
                RageUI.Button(_U('delete') , _U('delete'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
                    if (s) then
                    end
                end, RMenu:Get("popogang", "delete"))
            end, function()end)

            --Create Menu--
            RageUI.IsVisible(RMenu:Get("popogang","create"),true,true,true,function()
                RageUI.Button(_U('name') , _U('name'), {RightLabel = builder.gang_name}, true,function(h,a,s)
                    if (s) then
                        name = KeyboardInput("POPO_BOX", _U('name'), "", 15)
                        if name and name ~= "" then
                            builder.gang_name = tostring(name)
						    builder.gang_name = string.lower(string.gsub(builder.gang_name, "%s+", "_"))
                            print(builder.gang_name)
                        end
                    end
                end)
                RageUI.Button(_U('label') , _U('label'), {RightLabel = builder.label_name}, true,function(h,a,s)
                    if (s) then
                        label = KeyboardInput("POPO_BOX", _U('label'), "", 15)
                        if label and label ~= "" then
                            builder.label_name = tostring(label)
						    builder.label_name = string.lower(string.gsub(builder.label_name, "%s+", "_"))
                            print(builder.label_name)
                        end
                    end
                end)
			    if builder.first_coord == nil then 
				    first_place = "~r~❌"
			    else 
				    first_place = "~b~✅"
			    end 
                RageUI.Button(_U('first_point') , _U('first_point'), {RightLabel = first_place}, true,function(h,a,s)
                    if (s) then
                        local Ped = PlayerPedId()
					    local pedCoords = GetEntityCoords(Ped)
                        builder.first_coord = pedCoords
                        print(builder.first_coord)
                        ESX.ShowNotification(_U('first'))
                    end
                end)
			    if builder.second_coord == nil then 
				    second_place = "~r~❌"
			    else 
				    second_place = "~b~✅"
			    end 
                RageUI.Button(_U('second_point') , _U('second_point'), {RightLabel = second_place}, true,function(h,a,s)
                    if (s) then
                        local Ped = PlayerPedId()
					    local pedCoords = GetEntityCoords(Ped)
                        builder.second_coord = pedCoords
                        print(builder.second_coord)
                        ESX.ShowNotification(_U('second'))
                    end
                end)
                RageUI.Button(_U('create') , _U('create'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
                    if (s) then
                        if second_place == "~b~✅" and first_place == "~b~✅" and builder.gang_name and builder.label_name then
                            TriggerServerEvent('popo_gang:register_gang', builder)
                            TriggerServerEvent('popo_gang:register_Inventory_account', builder)
                            ESX.ShowNotification(_U('good_create')..builder.gang_name.._U('good_create_bis'))
                            second_place = "~r~❌"
                            first_place = "~r~❌"
                            name = nil
                            builder.gang_name = nil
                            builder.label_name = nil
                            first_place = nil
                            second_place = nil
                            builder.first_coord = nil
                            builder.second_coord = nil
                        else
                            ESX.ShowNotification(_U('no'))
                        end
                    end
                end)
            end, function()end, 1)

             --Delete Menu--
            RageUI.IsVisible(RMenu:Get("popogang","delete"),true,true,true,function()
                RageUI.Button(_U('name') , _U('name'), {RightLabel = name_suppr}, true,function(h,a,s)
                    if (s) then
                        name_suppr = KeyboardInput("POPO_BOX_BIS", _U('name'), "", 15)
                        name_suppr = tostring(name_suppr)
						name_suppr = string.lower(string.gsub(name_suppr, "%s+", "_"))
                    end
                end)
                RageUI.Button(_U('delete'), _U('delete'), {RightLabel = "~g~>>>"}, true,function(h,a,s)
                    if (s) then
                        if name_suppr and name_suppr ~= "" then
                            ESX.ShowNotification(_U('good_delete')..points.gang_name.._U('good_delete_bis'))
                        else
                            ESX.ShowNotification(_U('no_bis'))
                        end
                    end
                end)
            end, function()end, 1)
            Citizen.Wait(0)
        end
    end)
end

RegisterCommand("popogang", function()
    openMenu()
end, false)