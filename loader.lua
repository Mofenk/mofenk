-- ===================================================================== --
-- 👑 MOFENKHUB UNIVERSAL LOADER & ROUTER (SAFE VERSION)
-- ===================================================================== --

local PlaceId = game.PlaceId

local SupportedGames = {
	-- Anime Dice Place ID & Raw Link yang valid
	[113290951185459] = "https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/games/animedice.lua",
}

local targetScriptUrl = SupportedGames[PlaceId]

if targetScriptUrl then
	print("[MofenkHub] ✅ Game terdeteksi! Mengunduh skrip modular...")
	local successHttp, response = pcall(function()
		return game:HttpGet(targetScriptUrl)
	end)
	
	if successHttp and response and response ~= "" and not string.find(response, "404") then
		local fn, compileErr = loadstring(response)
		if fn then
			local successExec, execErr = pcall(fn)
			if not successExec then
				warn("[MofenkHub] ❌ Gagal mengeksekusi skrip game: " .. tostring(execErr))
			end
		else
			warn("[MofenkHub] ❌ Gagal kompilasi skrip: " .. tostring(compileErr))
		end
	else
		warn("[MofenkHub] ❌ Gagal mengunduh skrip: Link Raw salah atau HTTP 404 (File tidak ditemukan).")
	end
else
	warn("[MofenkHub] ⚠️ Game ini belum didukung atau tidak terdaftar dalam Hub!")
end
