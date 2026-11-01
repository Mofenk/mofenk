-- ===================================================================== --
-- MofenkHub - Script Testing Semua Elemen UI Ultimate Pro
-- ===================================================================== --

local MofenkUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/MofenkUI.lua"))()

local Window = MofenkUI.CreateWindow({
	Name = "MofenkHub | Ultimate Test",
	Theme = "CyberBlue",
})

Window:Notify("Sistem Siap", "MofenkUI Ultimate berhasil dimuat!", 4)

local FarmTab = Window:CreateTab("Auto Farm", "⚡")
local SettingsTab = Window:CreateTab("Settings", "⚙️")

-- ==================== TAB: AUTO FARM ====================
FarmTab:AddSection("Kategori Farming Utama")

FarmTab:AddToggle("Auto Roll Dice", false, function(state)
	Window:Notify("Auto Roll", "Status: " .. tostring(state), 2)
end)

FarmTab:AddSlider("Kecepatan Roll (Detik)", 1, 10, 3, function(val)
	print("Delay diatur ke:", val)
end)

FarmTab:AddDropdown("Pilih Prioritas Item", {"Legendary", "Mythic", "Secret Item"}, function(selected)
	Window:Notify("Filter Item", "Dipilih: " .. selected, 2)
end)

FarmTab:AddButton("Klaim Semua Hadiah", function()
	Window:Notify("Success", "Berhasil mengklaim hadiah!", 2)
end)

-- ==================== TAB: SETTINGS ====================
SettingsTab:AddSection("Konfigurasi & Keamanan")

SettingsTab:AddTextBox("Discord Webhook URL", "", function(text)
	Window:Notify("Webhook", "URL berhasil disimpan!", 2)
end)

SettingsTab:AddKeybind("Shortcut Buka/Tutup Menu", Enum.KeyCode.Insert, function(key)
	print("Tombol shortcut ditekan:", key.Name)
end)

SettingsTab:AddColorPicker("Warna Aksen ESP", Color3.fromRGB(255, 255, 255), function(color)
	print("Warna diubah:", color)
end)
