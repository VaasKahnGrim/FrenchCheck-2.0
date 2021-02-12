--Localizations
local Fetch = http.Fetch
local JsonToTable = util.JSONToTable
local error = error
local whitelist = frenchcheck.WhitelistMode
local gameKickID = game.KickID
local utilSteamIDFrom64 = util.SteamIDFrom64
local timerSimple = timer.Simple

--Variables and Tables
local failures = 0
local cache = {}--Cache it incase a frenchy tries spam joining in anger(they tend to get angry real easy lol)


--Functions
local function ipGetInfo(ip,id)
	if cache[ip] then
		if whitelist then
			if cache[ip].countryCode ~= "FR" or cache[ip].country ~= "France" then
				gameKickID(id,"We don't take kindly to people who don't take kindly round here.")
			end
		else
			if cache[ip].countryCode == "FR" or cache[ip].country == "France" then
				gameKickID(id,"We don't take kindly to people who don't take kindly round here.")
			end
		end
	else
		Fetch('https://extreme-ip-lookup.com/json/'..ip,function(b)
			if b == '404 page not found' then
				error('French Check | Could not check IP: '..ip)
			else
				local res = JsonToTable(b)
				failures = 0
				cache[ip] = res
				
				if whitelist then
					if cache[ip].countryCode ~= "FR" or cache[ip].country ~= "France" then
						gameKickID(id,"We don't take kindly to people who don't take kindly round here.")
					end
				else
					if cache[ip].countryCode == "FR" or cache[ip].country == "France" then
						gameKickID(id,"We don't take kindly to people who don't take kindly round here.")
					end
				end
			end
		end,function()
			if failures <= 5 then
				timerSimple(5,function()
					failures = failures+1

					ipGetInfo(ip,id)
				end)
			end
		end)
	end
end


--Hooks
hook.Add("CheckPassword","Baguette_Killer",function(ip,id)
	ipGetInfo(ip,utilSteamIDFrom64(id))
end)


