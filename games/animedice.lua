-- ===================================================================== --
-- 👑 MOFENKHUB — ANIMEDICE UI TESTING & CONFIG MANAGEMENT
-- ===================================================================== --

--!nocheck
task.wait(0.2)
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local MofenkUI = getgenv().MofenkUI or loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/MofenkUI.lua?v=" .. tostring(tick())))()

if not MofenkUI then
    warn("[MofenkHub] MofenkUI tidak ditemukan!")
    return
end

-- Konfigurasi & State Lokal untuk Anime Dice
local F = {
    cfgName = "AnimeDiceConfig1",
    autoLoadEnabled = false,
    autoRoll = false,
    collect = false,
    collectDelay = 2.0,
    keepRarities = {"Mythic", "Secret", "Divine", "Godly"},
    webhookEnabled = false,
    webhookUrl = ""
}

local CFG_FOLDER = "MofenkHub_Configs"
if makefolder and not isfolder(CFG_FOLDER) then pcall(function() makefolder(CFG_FOLDER) end) end

local function getCfgPath(name) 
    return CFG_FOLDER .. "/" .. (name or F.cfgName or "DefaultConfig") .. ".json" 
end

local function saveConfig(name)
    if writefile then
        pcall(function() 
            writefile(getCfgPath(name), HttpService:JSONEncode(F))
            MofenkUI:Notify({ Title = "Config System", Content = "Berhasil menyimpan config: " .. tostring(name), Duration = 3 })
        end)
    end
end

local function loadConfig(name)
    local path = getCfgPath(name)
    if readfile and isfile and isfile(path) then
        pcall(function() 
            local d = HttpService:JSONDecode(readfile(path))
            for k, v in pairs(d) do F[k] = v end 
            MofenkUI:Notify({ Title = "Config System", Content = "Berhasil memuat config: " .. tostring(name), Duration = 3 })
        end)
    end
end

-- Membuat Window Utama
local Window = MofenkUI:CreateWindow({
    Name = "MOFENK HUB | Anime Dice AI Smart Planner"
})

-- 1. Membuat Tab Profil Universal (Lengkap dengan Avatar & Bingkai)
Window:CreateProfileTab()

-- 2. Tab Farming & Auto Roll
local TabFarm = Window:CreateTab("Farming", "⛏️")
local GroupFarm = TabFarm:CreateGroup("Auto Farm & Roll Setup")

GroupFarm:AddToggle("Auto Roll Dice", F.autoRoll, function(state)
    F.autoRoll = state
    print("Auto Roll:", state)
end)

GroupFarm:AddToggle("Auto Collect Plot Balance", F.collect, function(state)
    F.collect = state
    print("Auto Collect:", state)
end)

GroupFarm:AddSlider("Delay Collect Plot (Detik)", 0.5, 10.0, F.collectDelay, function(val)
    F.collectDelay = val
    print("Delay Collect diubah:", val)
end)

GroupFarm:AddDropdown("Rarity yang Disimpan (Keep)", {"Common", "Epic", "Legendary", "Mythic", "Secret", "Divine", "Godly"}, F, "keepRarities", true)

-- 3. Tab Settings & Config Management
local TabSet = Window:CreateTab("Settings", "⚙️")
local GroupConfig = TabSet:CreateGroup("📁 File Configuration Management")

GroupConfig:AddToggle("Auto Load Config Saat Nyala", F.autoLoadEnabled, function(state)
    F.autoLoadEnabled = state
end)

GroupConfig:AddInput("Nama File Config:", F, "cfgName", false)

GroupConfig:AddButton("💾 Save Config Sekarang", function()
    saveConfig(F.cfgName)
end)

GroupConfig:AddButton("📂 Load Config Pilihan", function()
    loadConfig(F.cfgName)
end)

GroupConfig:AddButton("🗑️ Delete Config Pilihan", function()
    pcall(function()
        local path = getCfgPath(F.cfgName)
        if delfile and isfile and isfile(path) then
            delfile(path)
            MofenkUI:Notify({ Title = "Config System", Content = "Config berhasil dihapus.", Duration = 3 })
        end
    end)
end)

-- Webhook Group
local GroupWeb = TabSet:CreateGroup("🔔 Discord Webhook Notifier")
GroupWeb:AddToggle("Aktifkan Webhook Discord", F.webhookEnabled, function(state)
    F.webhookEnabled = state
end)
GroupWeb:AddInput("Webhook URL:", F, "webhookUrl", false)

GroupWeb:AddButton("🔔 Test Kirim Webhook", function()
    MofenkUI:Notify({ Title = "Webhook", Content = "Test webhook berhasil dikirim!", Duration = 3 })
end)

print("[MofenkHub] Anime Dice full testing & config UI loaded successfully.")
