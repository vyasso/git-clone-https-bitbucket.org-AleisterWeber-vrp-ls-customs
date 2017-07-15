-- vRP framework
local Tunnel = require("resources/vrp/lib/Tunnel")
local MySQL = require("resources/vrp/lib/MySQL/MySQL")
local Proxy = require("resources/vrp/lib/Proxy")

local sql = MySQL.open("HOST","USERNAME","PASSWORD","DATABASE") -- EDIT these values to the values of your sql servers

vRP = Proxy.getInterface("vRP") --call the server-side API functions, get the vRP interface.
vRPclient = Tunnel.getInterface("vRP","lscustoms") -- Tunnel access client to vRP with unique id

local tbl = {
				[1] = {locked = false},
				[2] = {locked = false},
				[3] = {locked = false},
				[4] = {locked = false},
			}
local paymentInfo = {}

RegisterServerEvent('lockGarage')
AddEventHandler('lockGarage', function(b,garage)
	tbl[tonumber(garage)].locked = b
	TriggerClientEvent('lockGarage',-1,tbl)
	print(json.encode(tbl))
end)

RegisterServerEvent('getGarageInfo')
AddEventHandler('getGarageInfo', function()
	TriggerClientEvent('lockGarage',-1,tbl)
	print(json.encode(tbl))
end)

RegisterServerEvent('UpdateVeh')
AddEventHandler('UpdateVeh', function(plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor, mods)

	local mods = mods
    local primarycolor = primarycolor
    local secondarycolor = secondarycolor
    local pearlescentcolor = pearlescentcolor
    local wheelcolor = wheelcolor
		local carid = string.sub(plate,7)
		print(carid)
		if primarycolor then
			q_update = sql:prepare("update vrp_user_vehicles set vehicle_colorprimary ='".. primarycolor .."' where car_id='".. carid .."'")
			q_update:execute()
		end
		if secondarycolor then
			q_update = sql:prepare("update vrp_user_vehicles set vehicle_colorsecondary ='".. secondarycolor .."' where car_id='".. carid .."'")
			q_update:execute()
		end
		if pearlescentcolor  then
			q_update = sql:prepare("update vrp_user_vehicles set vehicle_pearlescentcolor ='".. pearlescentcolor .."' where car_id='".. carid .."'")
			q_update:execute()
		end
		if wheelcolor then
			q_update = sql:prepare("update vrp_user_vehicles set vehicle_wheelcolor ='".. wheelcolor .."' where car_id='".. carid .."'")
			q_update:execute()
		end

		for i,t in pairs(mods) do
        	print('Attempting to update mods')
        	if t.mod ~= nil then
           		print("Mod#: "..i.." Value: " .. t.mod)
			    local q_update = sql:prepare("update vrp_user_vehicles set mod"..i.." = '"..t.mod.."' where car_id='"..carid.."'")
					  q_update:execute()
        	end
		end
end)

-- Payment Events
RegisterServerEvent('receivePaymentInfo')
AddEventHandler('receivePaymentInfo', function(modPrice)	
	local user_id = vRP.getUserId({source}, function(user_id) return user_id end)
	local wallet = vRP.getMoney({user_id})
	local nWallet = wallet - modPrice
	local paidAmount = vRP.tryPayment({user_id, modPrice})
	local blockPurchase = false
	
 	print("Player ID :" .. user_id .. " | Price : " .. modPrice .. " | Wallet : " .. wallet .. " | New Wallet : " .. nWallet) -- DEBUG message for jink

 	if paidAmount then
 		vRP.tryPayment({user_id, modPrice})
 		vRPclient.notify(user_id,{"Thanks for your purchase!"})
 		print("Debited" .. modPrice)
 	elseif not paidAmount then
 		local blockPurchase = not blockPurchase
 		vvRPclient.notify(user_id,{"Unsuccessful purchase!"})
 		TriggerClientEvent('blockPurchase', blockPurchase)
 		print("Payment not successful")
 	end

end)
