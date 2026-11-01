-- ===================================================================== --
-- 👑 MOFENKHUB UNIVERSAL LOADER & ROUTER
-- ===================================================================== --

local PlaceId = game.PlaceId

-- Kamus Daftar Game yang Didukung
local SupportedGames = {
	-- Anime Dice
	[113290951185459] = "https://raw.githubusercontent.com/Mofenk/mofenk/main/games/animedice.lua",
}

local targetScriptUrl = SupportedGames[PlaceId]

if targetScriptUrl then
	print("[MofenkHub] ✅ Game terdeteksi! Memuat skrip modular...")
	local success, err = pcall(function()
		loadstring(game:HttpGet(targetScriptUrl))()
	end)
	
	if not success then
		warn("[MofenkHub] ❌ Gagal mengeksekusi skrip game: " .. tostring(err))
	end
else
	warn("[MofenkHub] ⚠️ Game ini belum didukung atau tidak terdaftar dalam Hub!")
	pcall(function()
		local StarterGui = game:GetService("StarterGui")
		StarterGui:SetCore("SendNotification", {
			Title = "MofenkHub",
			Text = "Game ini tidak didukung oleh MofenkHub!",
			Duration = 5
		})
	end)
end
