-- ===================================================================== --
-- 👑 MOFENKHUB UI TEST MODE — ANIME DICE
-- Fokus testing UI saja, tanpa automation game dan remote logic
-- ===================================================================== --
--!nocheck

task.wait(0.2)

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

local function getMofenkUI()
    if _G and _G.MofenkUI then
        return _G.MofenkUI
    end

    local ok, uiScript = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/MofenkUI.lua")
    end)
    if not ok or type(uiScript) ~= "string" or uiScript == "" then
        warn("[MofenkHub UI Test] Unable to load MofenkUI.lua from repository.")
        return nil
    end

    local fn, err = loadstring(uiScript)
    if not fn then
        warn("[MofenkHub UI Test] Failed to compile MofenkUI.lua: " .. tostring(err))
        return nil
    end

    local loaded = fn()
    if loaded then
        _G.MofenkUI = loaded
    end
    return loaded
end

local MofenkUI = getMofenkUI()
if not MofenkUI then
    warn("[MofenkHub UI Test] MofenkUI not available. UI test stopped.")
    return
end

local Window = MofenkUI.CreateWindow({
    Name = "MofenkHub | Anime Dice (UI Test)",
    Theme = "Monochrome",
    ToggleStyle = "Icon",
    ProfileTitle = "VIP Premium",
})

local dashboard = Window:CreateTab("Dashboard", "📊")
local farming = Window:CreateTab("Farming", "⛏️")
local inventory = Window:CreateTab("Inventory", "🎒")
local settings = Window:CreateTab("Settings", "⚙️")

local Config = {
    autoRoll = false,
    autoCollect = false,
    autoLevel = false,
    autoRebirth = false,
    buyDice = true,
    equipDice = true,
    sellAuto = false,
    keepBest = 0,
    autoLockRarity = true,
    towerFarm = false,
    afk = true,
    webhook = false,
    webhookUrl = "",
    delayCollect = 2,
    maxLevel = 40,
}

dashboard:AddSection("Status")
dashboard:AddInfoCard("Runtime", "UI Test Mode")
dashboard:AddInfoCard("Game", tostring(MarketplaceService.GameName or "Anime Dice"))
dashboard:AddInfoCard("Mode", "Testing only")
dashboard:AddButton("Refresh UI", function()
    Window:Notify("UI Test", "UI refreshed successfully.", 2)
end)

farming:AddSection("Auto Logic")
farming:AddToggle("Auto Roll Dice", false, function(v)
    Config.autoRoll = v
    Window:Notify("Toggle", "Auto Roll Dice = " .. tostring(v), 1)
end)
farming:AddToggle("Auto Collect Plot", false, function(v)
    Config.autoCollect = v
    Window:Notify("Toggle", "Auto Collect Plot = " .. tostring(v), 1)
end)
farming:AddSlider("Collect Delay", 1, 10, 2, function(v)
    Config.delayCollect = v
end)
farming:AddToggle("Auto Level Up", false, function(v)
    Config.autoLevel = v
end)
farming:AddSlider("Max Level", 1, 100, 40, function(v)
    Config.maxLevel = v
end)
farming:AddToggle("Auto Rebirth", false, function(v)
    Config.autoRebirth = v
end)

inventory:AddSection("Inventory")
inventory:AddToggle("Auto Sell", false, function(v)
    Config.sellAuto = v
end)
inventory:AddSlider("Keep Best", 0, 50, 0, function(v)
    Config.keepBest = v
end)
inventory:AddToggle("Auto Lock Rarity", true, function(v)
    Config.autoLockRarity = v
end)

settings:AddSection("System")
settings:AddToggle("Anti-AFK", true, function(v)
    Config.afk = v
end)
settings:AddToggle("Webhook Discord", false, function(v)
    Config.webhook = v
end)
settings:AddTextBox("Webhook URL", "", function(v)
    Config.webhookUrl = v
end)
settings:AddButton("Save Config", function()
    Window:Notify("Saved", "UI config saved for testing.", 2)
end)

Window:Notify("UI Test", "Anime Dice UI loaded successfully in test mode.", 3)

return true
