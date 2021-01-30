function webhooklog(a, b, d, e, f)
	if GamixACC.AntiVPN then
		if GamixACS.AntiVPNWebhook ~= "" or GamixACS.AntiVPNWebhook ~= nil then
			PerformHttpRequest(
				GamixACS.AntiVPNWebhook,
				function(err, text, headers)
				end,
				"POST",
				json.encode(
					{
						embeds = {
							{
								author = {name = " Gamix AntiVPN", url = "https://cdn.discordapp.com/attachments/761943714649473055/762343855475392582/Blue_and_White_Gaming_Logo_3.png", icon_url = "https://cdn.discordapp.com/attachments/761943714649473055/762343855475392582/Blue_and_White_Gaming_Logo_3.png"},
								title = "Connection " .. a,
								description = "**Player:** " .. b .. "\nIP: " .. d .. "\n" .. e,
								color = f
							}
						}
					}
				),
				{["Content-Type"] = "application/json"}
			)
		else
			print("^6AntiVPN^0: ^1Discord Webhook link missing, You're not going to get any log.^0")
		end
	end
end

if GamixACC.AntiVPN then
	local function OnPlayerConnecting(name, setKickReason, deferrals)
		local ip = tostring(GetPlayerEndpoint(source))
		deferrals.defer()
		Wait(0)
		deferrals.update("Gamix: Checking VPN...")
		PerformHttpRequest(
			"https://blackbox.ipinfo.app/lookup/" .. ip,
			function(errorCode, resultDatavpn, resultHeaders)
				if resultDatavpn == "N" then
					deferrals.done()
				else
					print("^6[Gamix]^0: ^1Player ^0" .. name .. " ^1kicked for using a VPN, ^8IP: ^0" .. ip .. "^0")
					if GamixACC.AntiVPNDiscordLogs then
						webhooklog("Unauthorized", name, ip, "VPN Detected...", 16515843)
					end
					deferrals.done("Gamix: Please disable your VPN connection.")
				end
			end
		)
	end

	AddEventHandler("playerConnecting", OnPlayerConnecting)
end