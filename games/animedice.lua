-- ===================================================================== --
-- 👑 MOFENKHUB — ANIMEDICE UI TESTING SCRIPT
-- ===================================================================== --

--!nocheck
task.wait(0.2)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local MofenkUI = getgenv().MofenkUI or loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/MofenkUI.lua"))()

if not MofenkUI then
    warn("[MofenkHub] MofenkUI tidak ditemukan!")
    return
end

-- Membuat Window Utama
local Window = MofenkUI:CreateWindow({
    Name = "MOFENK HUB | Anime Dice Testing UI"
})

-- Membuat Tab Profil Universal
Window:CreateProfileTab()

-- Membuat Tab Testing Fitur
local TabTest = Window:CreateTab("Testing Element")

-- Group Utama
local GroupMain = TabTest:CreateGroup("Menu Utama Auto Farm")

GroupMain:AddToggle("Auto Roll Dice (Testing)", false, function(state)
    print("Toggle Auto Roll:", state)
    MofenkUI:Notify({
        Title = "Auto Roll Status",
        Content = state ? "Auto Roll diaktifkan!" : "Auto Roll dimatikan.",
        Duration = 3
    })
end)

GroupMain:AddDropdown("Pilih Target Mode", {"Fast Mode", "Legit Mode", "RNG Infinite"}, "Fast Mode", false, function(selected)
    print("Mode terpilih:", selected)
    MofenkUI:Notify({
        Title = "Mode Diubah",
        Content = "Mode aktif: " .. tostring(selected),
        Duration = 2
    })
end)

GroupMain:AddDropdown("Pilih Multi-Select Item", {"Mythic Sword", "Secret Dice", "Divine Aura", "Godly Token"}, nil, true, function(selectedList)
    print("Item multi-select terpilih:", table.concat(selectedList, ", "))
end)

GroupMain:AddButton("Jalankan Test Notifikasi", function()
    MofenkUI:Notify({
        Title = "Testing Notifikasi",
        Content = "Sistem notifikasi berjalan dengan mulus dan estetik!",
        Duration = 3
    })
end)

-- Group Tambahan
local GroupSettings = TabTest:CreateGroup("Utility & Configs")

GroupSettings:AddButton("Reset Konfigurasi", function()
    MofenkUI:Notify({
        Title = "Config System",
        Content = "Konfigurasi berhasil di-reset ke default.",
        Duration = 2
    })
end)

print("[MofenkHub] Anime Dice UI Testing loaded successfully.")
