-- ===================================================================== --
-- 👑 MOFENKHUB UNIVERSAL ROUTER
-- ===================================================================== --

local PlaceId = game.PlaceId

local SupportedGames = {
	[113290951185459] = "https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/games/animedice.lua",
}

local targetScriptUrl = SupportedGames[PlaceId]

if targetScriptUrl then
	local success, response = pcall(function()
		return game:HttpGet(targetScriptUrl)
	end)

	if success and response and response ~= "" then
		local fn, err = loadstring(response)
		if fn then
			pcall(fn)
		else
			warn("[MofenkHub] Error Kompilasi: " .. tostring(err))
		end
	else
		warn("[MofenkHub] Gagal mengunduh skrip game dari GitHub!")
	end
else
	warn("[MofenkHub] Place ID ini belum terdaftar di Hub!")
end
