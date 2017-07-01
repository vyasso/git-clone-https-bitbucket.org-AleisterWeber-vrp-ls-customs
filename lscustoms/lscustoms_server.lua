local Tunnel = require("resources/vrp/lib/Tunnel")
local Proxy = require("resources/vrp/lib/Proxy")
local MySQL = require("resources/vRP/lib/MySQL/MySQL")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","lscustoms")

local sql = MySQL.open("HOST","USER","PASSWORD","DATABASE")
local tbl = {
[1] = {locked = false},
[2] = {locked = false},
[3] = {locked = false},
[4] = {locked = false}
}
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
