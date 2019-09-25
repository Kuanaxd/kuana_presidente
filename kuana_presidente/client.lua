--[Tempo De Impostos]--

local tempo = 10 * 60000 -- Normal: 10min / Dont touch in the 60000

--[end]--

local Blip = nil
ESX = nil
local PlayerData = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	createBlip()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	createBlip()
end)

function createBlip()
	if Blip ~= nil then
		RemoveBlip(Blip)
	else
		Blip = AddBlipForCoord(-136.7, 6198.76, 31.38)
		SetBlipSprite (Blip, 77)
		SetBlipDisplay(Blip, 4)
		SetBlipScale  (Blip, 0.8)
		SetBlipColour (Blip, 21)
		SetBlipAsShortRange(Blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Governo")
		EndTextCommandSetBlipName(Blip)
	end
end

local verificardinheiro = false
local verificarmenu = false

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local distance = GetDistanceBetweenCoords(-77.58, -826.41, 242.39, x, y, z, 1)
		if PlayerData.job ~= nil and PlayerData.job.name == "governo" then
			if distance <= 5 then
				Drawing.draw3DText(-77.58, -826.41, 242.39, "[~g~E~w~] ~g~Descer~w~ no Elevador", 4, 0.1, 0.05, 255, 255, 255, 255)
				DrawMarker(27, -77.58, -826.41, 242.39 + 0.2, 0, 0, 0, 0, 0, 0, 0.3,0.3,0.3, 0, 232, 255, 155, 0, 0, 0, 0, 0, 0, 0)
				if distance < 1.1 and (IsControlJustPressed(1, 51)) then
					SetEntityCoords(ped, -79.27, -796.6, 43.23)
					FreezeEntityPosition(ped, true)
					Citizen.Wait(500)
					FreezeEntityPosition(ped, false)	
				end
			end
		end

		local distance2 = GetDistanceBetweenCoords(-57.80, -804.25, 43.23, x, y, z, 1)
		if PlayerData.job ~= nil and PlayerData.job.name == "governo" then
			if distance2 <= 10 then
				Drawing.draw3DText(-57.80, -804.25, 43.23, "[~g~E~w~] ~g~Entrar~w~ para o Escritorio", 4, 0.1, 0.05, 255, 255, 255, 255)
				DrawMarker(27, -57.80, -804.25, 43.23 + 0.2, 0, 0, 0, 0, 0, 0, 0.3,0.3,0.3, 0, 232, 255, 155, 0, 0, 0, 0, 0, 0, 0)
				if distance2 < 1.1 and (IsControlJustPressed(1, 51)) then
					SetEntityCoords(ped, -76.67, -830.29, 242.39)
					FreezeEntityPosition(ped, true)
					Citizen.Wait(500)
					FreezeEntityPosition(ped, false)	
				end
			end
		end

		local distance3 = GetDistanceBetweenCoords(-72.63, -816.06, 242.39, x, y, z, 1)
		if PlayerData.job ~= nil and PlayerData.job.name == "governo" then
			if distance3 <= 2 then
				Drawing.draw3DText(-72.63, -816.06, 242.39, "[~g~E~w~] Chamar ~g~Carros~w~", 4, 0.1, 0.05, 255, 255, 255, 255)
				DrawMarker(27, -72.63, -816.06, 242.39 + 0.2, 0, 0, 0, 0, 0, 0, 0.3,0.3,0.3, 0, 232, 255, 155, 0, 0, 0, 0, 0, 0, 0)
				if distance3 < 1.1 and (IsControlJustReleased(1, 51)) then
					verificarmenu = true
					animped2(ped)
				end
			end
		end

		local distance4 = GetDistanceBetweenCoords(-80.81, -802.35, 242.4, x, y, z, 1)
		if PlayerData.job ~= nil and PlayerData.job.name == "governo" then
			if distance4 <= 2 then
				Drawing.draw3DText(-80.81, -802.35, 242.4, "[~g~E~w~] ~g~Acessar~w~ Conta", 4, 0.1, 0.05, 255, 255, 255, 255)
				DrawMarker(27, -80.81, -802.35, 242.4 + 0.2, 0, 0, 0, 0, 0, 0, 0.3,0.3,0.3, 0, 232, 255, 155, 0, 0, 0, 0, 0, 0, 0)
				if distance4 < 1.1 and (IsControlJustReleased(1, 51)) then
						verificardinheiro = true
						FreezeEntityPosition(ped, true)
						SetEntityCoords(ped, -80.47, -801.44, 241.9)
						SetEntityHeading(ped, 243.14)
						animped(ped)
				end
			end
		end
	end
end)

function openmenu(ped)
	ESX.TriggerServerCallback("kuana:getimpostodinheiro",function(dinheiro)
		local dinheiroconta = "0"
		local elements = {
			{label = "Colocar" , value = "colocar"},
			{label = "Retirar" , value = "retirar"}
		}


			dinheiroconta = "Conta: "..dinheiro.."$"
			table.insert( elements, {label = dinheiroconta , value = "nada"})

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'kuanaitem',
			{
				title    = "Cofre Menu",
				align    = 'top-left',
				elements = elements,
			},
			function(data, menu)
				menu.close()
				if data.current.value == "colocar" then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'put_item_countcofreq', {
						title = "Quantidade"
					}, function(data4, menu4)

						local quantity = tonumber(data4.value)

						if quantity == nil then
							ESX.ShowNotification("Quantidade invalida")
						else
							menu4.close()

							TriggerServerEvent("kuana:setmoneypre", tonumber(data4.value))
							Citizen.Wait(200)
							menu4.close()
							openmenu(ped)
						end
					end, function(data4, menu4)
						menu4.close()
						openmenu(ped)
					end)

				elseif data.current.value == "retirar" then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'put_item_countcofreq', {
						title = "Quantidade"
					}, function(data4, menu4)

						local quantity = tonumber(data4.value)

						if quantity == nil then
							ESX.ShowNotification("Quantidade invalida")
						else
							menu4.close()

							TriggerServerEvent("kuana:setmoneypessoa", tonumber(data4.value))
							Citizen.Wait(200)
							menu4.close()
							openmenu(ped)
						end
					end, function(data4, menu4)
						menu4.close()
						openmenu(ped)
					end)

				end
			end,
			function(data, menu)
				menu.close()
				verificardinheiro = false
				ClearPedTasks(ped)
				SetEntityCoords(ped, -80.81, -802.35, 242.4)
				FreezeEntityPosition(ped, false)
				--CurrentAction = 'open_garage_action'
			end
		)	
	end)
end

function openmenu2(ped)
	ESX.TriggerServerCallback("kuana:getimpostodinheiro",function(dinheiro)
		local cods = { -72.63 + 0, -816.06 + 0, 242.39 + 1}
		local dinheiroconta = "0"
		local elements = {
			{label = "Limosine - 500$" , value = "stretch"},
			{label = "Kuruma - 1000$" , value = "kuruma"}
		}


			dinheiroconta = "Conta: "..dinheiro.."$"
			table.insert( elements, {label = dinheiroconta , value = "nada"})

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'kuanaitem',
			{
				title    = "Cofre Menu",
				align    = 'top-left',
				elements = elements,
			},
			function(data, menu)
				if data.current.value == "stretch" then
					if dinheiro >= 500 then
						ESX.Game.SpawnVehicle("stretch", vector3(-44.89, -787.75, 44.15), 264.06, function(callback_vehicle)

						end)	
						TriggerServerEvent("kuana:removemoneypre", 500, dinheiro)
						ESX.ShowNotification("O seu carro ~g~chegou~w~, ele vai ficar ~y~la em baixo~w~ a espera.")	
					else
						ESX.ShowNotification("A tua empresa ~r~nao~w~ tem essa ~y~quantia~w~.")
					end
				elseif data.current.value == "kuruma" then
					if dinheiro >= 1000 then
						ESX.Game.SpawnVehicle("kuruma", vector3(-44.89, -787.75, 44.15), 264.06, function(callback_vehicle)
							
						end)	
						TriggerServerEvent("kuana:removemoneypre", 1000, dinheiro)
						ESX.ShowNotification("O seu carro ~g~chegou~w~, ele vai ficar ~y~la em baixo~w~ a espera.")	
					else
						ESX.ShowNotification("A tua empresa ~r~nao~w~ tem essa ~y~quantia~w~.")
					end
				end
			end,
			function(data, menu)
				menu.close()
				verificarmenu = false
				ClearPedTasks(ped)
				FreezeEntityPosition(ped, false)
				--CurrentAction = 'open_garage_action'
			end
		)	
	end)
end

function animped(ped)
	if verificardinheiro == true then
		openmenu(ped)
		ESX.Streaming.RequestAnimDict("anim@amb@clubhouse@boss@male@", function()
			TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@boss@male@", "computer_idle", 8.0, -8.0, -1, 0, 0, false, false, false)
			Citizen.SetTimeout(10000, function()
				animped(ped)
			end)
		end)
	else

	end
end

function animped2(ped)
	if verificarmenu == true then
		openmenu2(ped)
		ESX.Streaming.RequestAnimDict("cellphone@", function()
			TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_call_listen_base", 8.0, -8.0, -1, 0, 0, false, false, false)
			Citizen.SetTimeout(6000, function()
				animped2(ped)
			end)
		end)
	else

	end
end

RegisterCommand("stoppre", function()
	verificarmenu = false
end)

Drawing = setmetatable({}, Drawing)
Drawing.__index = Drawing

function Drawing.draw3DText(x,y,z,textInput,fontId,scaleX,scaleY,r, g, b, a)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*14
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+1, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end



-----------------------------------------------------------------------------------------


Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(tempo)
		if PlayerData.job ~= nil and PlayerData.job.name ~= "governo" then
			local vehicules = {}
			ESX.TriggerServerCallback('kuana:getVehiclespre', function(listacarros)
				for _,v in pairs(listacarros) do
					local hashVehicule = v.vehicle.model
					local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)			
					table.insert(vehicules, {model = vehicleName})
				end
				TriggerServerEvent("kuana:impostosretirar", PlayerData.job.name, PlayerData.job.grade_name, vehicules)
			end)
		end
	end
end)