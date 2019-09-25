ESX = nil

-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('kuana:getVehiclespre', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = {}

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = xPlayer.getIdentifier()}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicules, {vehicle = vehicle, state = v.state, plate = v.plate})
		end
		cb(vehicules)
	end)
end)

ESX.RegisterServerCallback('kuana:getimpostodinheiro', function (source, cb)
	local _source = source 
	local xPlayer = ESX.GetPlayerFromId(_source)
	local dinheiro = MySQL.Sync.fetchScalar("SELECT dinheiro FROM impostos WHERE checkmoney = @checkmoney", {['@checkmoney'] = "checkmoney"})

	cb(dinheiro)
end)

RegisterNetEvent('kuana:setmoneypre')
AddEventHandler('kuana:setmoneypre', function(quantidade)
	local _source = source 
	local xPlayer = ESX.GetPlayerFromId(_source)
	local moneyatual = xPlayer.getMoney()
	local cofremoney = MySQL.Sync.fetchScalar("SELECT dinheiro FROM impostos WHERE checkmoney = @checkmoney", {["@checkmoney"] = "checkmoney"})
	local checkmoney = moneyatual - quantidade 
	if checkmoney >= 0 then
		xPlayer.removeMoney(quantidade)
	
		MySQL.Async.execute("UPDATE impostos SET dinheiro = @money WHERE checkmoney = @checkmoney",
			{
				["@money"] = cofremoney + quantidade,
				["@checkmoney"] = "checkmoney"
			}
		)
	else
		TriggerClientEvent('esx:showNotification', _source, "Tu ~r~nao~w~ tens essa ~y~quantia~w~.")
	end
end)

RegisterNetEvent('kuana:removemoneypre')
AddEventHandler('kuana:removemoneypre', function(quantidade, dinheiro)
	local _source = source 
	local xPlayer = ESX.GetPlayerFromId(_source)

		xPlayer.removeMoney(quantidade)
	
		MySQL.Async.execute("UPDATE impostos SET dinheiro = @money WHERE checkmoney = @checkmoney",
			{
				["@money"] = dinheiro - quantidade,
				["@checkmoney"] = "checkmoney"
			}
		)
end)

RegisterNetEvent('kuana:setmoneypessoa')
AddEventHandler('kuana:setmoneypessoa', function(quantidade)
	local _source = source 
	local xPlayer = ESX.GetPlayerFromId(_source)
	local moneyatual = xPlayer.getMoney()
	local cofremoney = MySQL.Sync.fetchScalar("SELECT dinheiro FROM impostos WHERE checkmoney = @checkmoney", {["@checkmoney"] = "checkmoney"})
	local checkmoney = cofremoney - quantidade 
	if checkmoney >= 0 then
		xPlayer.addMoney(quantidade)
	
		MySQL.Async.execute("UPDATE impostos SET dinheiro = @money WHERE checkmoney = @checkmoney",
			{
				["@money"] = checkmoney,
				["@checkmoney"] = "checkmoney"
			}
		)
	else
		TriggerClientEvent('esx:showNotification', _source, "A tua empresa ~r~nao~w~ tem essa ~y~quantia~w~.")
	end
end)

RegisterNetEvent('kuana:impostosretirar')
AddEventHandler('kuana:impostosretirar', function(trabalho, cargo, listaveh)
	local _source = source 
	local xPlayer = ESX.GetPlayerFromId(_source)
	local valoraretirar = 0
	local taxa = MySQL.Sync.fetchScalar("SELECT tax FROM impostos WHERE checkmoney = @checkmoney", {['@checkmoney'] = "checkmoney"})	
	local moneyatual = xPlayer.getAccount("bank").money
	local quantoscarros = 0
	local checkcarros = false
	--[ Get all cars ]--
	for _,vv in pairs(listaveh) do
		local carprice = MySQL.Sync.fetchScalar("SELECT price FROM vehicles WHERE model = @model", {['@model'] = vv.model})
		valoraretirar = valoraretirar + (carprice * (taxa / 100))	
		quantoscarros = quantoscarros + 1
	end
	--[ end ]--
	--[ Get Salary ]--

	local salario = MySQL.Sync.fetchScalar("SELECT salary FROM job_grades WHERE job_name = @trabalho AND name = @cargo", {['@trabalho'] = trabalho, ['@cargo'] = cargo})
	valoraretirar = valoraretirar + (salario * (taxa / 100))
	--[ end ]--


	xPlayer.removeAccountMoney("bank", valoraretirar)

	MySQL.Async.execute("UPDATE users SET bank = @money WHERE identifier = @identifier",
		{
			["@money"] = moneyatual - valoraretirar,
			["@identifier"] = xPlayer.identifier
		}
	)

	TriggerClientEvent('esx:showNotification', _source, "Foi retirado pelos impostos ~r~"..valoraretirar.."$~w~ da sua conta do banco. Voce possui "..quantoscarros.." carros.")
end)