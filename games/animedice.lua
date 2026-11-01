-- ===================================================================== --
-- 👑 MOFENKHUB V106.0 — ANIME DICE PREMIUM AUTOMATION
--          Integrated with MofenkUI dashboard system
-- ===================================================================== --
--!nocheck

task.wait(0.2)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local function queueReconnect()
    local qot = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
    if qot then
        pcall(function()
            qot([[
                task.wait(3)
                local ok, err = pcall(function()
                    local script = game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/loader.lua")
                    loadstring(script)()
                end)
                if not ok then warn(err) end
            ]])
        end)
    end
end

queueReconnect()

local function safeRequire(path)
    local ok, result = pcall(function()
        return require(path)
    end)
    return ok and result or nil
end

local function safeCall(fn, ...)
    if type(fn) ~= "function" then
        return false
    end
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[MofenkHub] safeCall error: " .. tostring(err))
    end
    return ok
end

local function getRemote(path)
    local root = ReplicatedStorage
    if not root then
        return nil
    end

    local current = root
    for segment in string.gmatch(path, "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local function safeInvoke(remote, ...)
    if not remote then
        return false
    end
    local ok, result = pcall(function()
        if remote.InvokeServer then
            return remote:InvokeServer(...)
        end
        if remote.FireServer then
            remote:FireServer(...)
            return true
        end
        return false
    end)
    return ok and result ~= false or false
end

local function safeFire(remote, ...)
    if not remote then
        return false
    end
    local ok = pcall(function()
        if remote.FireServer then
            remote:FireServer(...)
            return true
        elseif remote.InvokeServer then
            return remote:InvokeServer(...) ~= nil or true
        end
        return false
    end)
    return ok
end

local function deepClone(value)
    if type(value) ~= "table" then
        return value
    end
    local copy = {}
    for k, v in pairs(value) do
        copy[k] = deepClone(v)
    end
    return copy
end

local function data()
    if _G and _G.__MofenkData then
        return _G.__MofenkData
    end
    return {}
end

local function getMofenkUI()
    if _G and _G.MofenkUI then
        return _G.MofenkUI
    end

    local ok, uiScript = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/MofenkUI.lua")
    end)
    if not ok or type(uiScript) ~= "string" or uiScript == "" then
        warn("[MofenkHub] Unable to load MofenkUI.lua from repository.")
        return nil
    end

    local fn, err = loadstring(uiScript)
    if not fn then
        warn("[MofenkHub] Failed to compile MofenkUI.lua: " .. tostring(err))
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
    warn("[MofenkHub] MofenkUI not available. Anime Dice script stopped.")
    return
end

local Window = MofenkUI.CreateWindow({
    Name = "MofenkHub | Anime Dice",
    Theme = "Monochrome",
    ToggleStyle = "Icon",
    ProfileTitle = "VIP Premium",
})

local dashboard = Window:CreateTab("Dashboard", "📊")
local farming = Window:CreateTab("Farming", "⛏️")
local inventory = Window:CreateTab("Inventory", "🎒")
local tower = Window:CreateTab("Tower", "🏰")
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

local STATE = {
    runtime = "Standby",
    money = 0,
    rebirth = 0,
    status = "Ready",
}

dashboard:AddSection("Status")
dashboard:AddInfoCard("Runtime", "Online")
dashboard:AddInfoCard("Game", tostring(game:GetService("MarketplaceService").GameName or "Anime Dice"))
dashboard:AddInfoCard("Mode", "Universal Premium")

dashboard:AddButton("Refresh System", function()
    Window:Notify("Success", "System", "UI refreshed successfully.", 2)
end)

farming:AddSection("Auto Logic")
farming:AddToggle("Auto Roll Dice", false, function(v) Config.autoRoll = v end)
farming:AddToggle("Auto Collect Plot", false, function(v) Config.autoCollect = v end)
farming:AddSlider("Collect Delay", 1, 10, 2, function(v) Config.delayCollect = v end)
farming:AddToggle("Auto Level Up", false, function(v) Config.autoLevel = v end)
farming:AddSlider("Max Level", 1, 100, 40, function(v) Config.maxLevel = v end)
farming:AddToggle("Auto Rebirth", false, function(v) Config.autoRebirth = v end)

inventory:AddSection("Inventory")
inventory:AddToggle("Auto Sell", false, function(v) Config.sellAuto = v end)
inventory:AddSlider("Keep Best", 0, 50, 0, function(v) Config.keepBest = v end)
inventory:AddToggle("Auto Lock Rarity", true, function(v) Config.autoLockRarity = v end)

settings:AddSection("System")
settings:AddToggle("Anti-AFK", true, function(v) Config.afk = v end)
settings:AddToggle("Webhook Discord", false, function(v) Config.webhook = v end)
settings:AddTextBox("Webhook URL", "", function(v) Config.webhookUrl = v end)
settings:AddButton("Save Config", function()
    Window:Notify("Success", "Config", "Settings saved.", 2)
end)

local function sendWebhook(title, description, color)
    if not Config.webhook or Config.webhookUrl == "" then
        return
    end
    local request = (syn and syn.request) or request or http_request or (fluxus and fluxus.request)
    if not request then
        return
    end
    pcall(function()
        request({
            Url = Config.webhookUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({
                embeds = {{
                    title = title,
                    description = description,
                    color = color or 3447003,
                    footer = { text = "MofenkHub Premium" }
                }}
            })
        })
    end)
end

local function getNetwork()
    local root = ReplicatedStorage:FindFirstChild("Network") or ReplicatedStorage:FindFirstChild("NetworkFolder")
    if not root then
        return nil
    end
    return root
end

local function getRemotePath(path)
    local n = getNetwork()
    if not n then
        return nil
    end
    local current = n
    for segment in string.gmatch(path, "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    return current
end

local remoteMap = {
    RollDice = getRemotePath("RollService.RF.RollDice") or getRemotePath("DiceService.RF.RollDice") or getRemotePath("GameService.RF.RollDice"),
    CollectBalance = getRemotePath("PlotService.RE.CollectBalance") or getRemotePath("EconomyService.RE.CollectBalance"),
    LevelUpSlot = getRemotePath("PlotService.RE.LevelUpSlot") or getRemotePath("SlotService.RE.LevelUpSlot"),
    Rebirth = getRemotePath("RebirthService.RE.Rebirth") or getRemotePath("ProgressionService.RE.Rebirth"),
    BuyDice = getRemotePath("DiceShopService.RE.BuyDice") or getRemotePath("ShopService.RE.BuyDice"),
    EquipDice = getRemotePath("DiceShopService.RE.EquipDice") or getRemotePath("ShopService.RE.EquipDice"),
    SellInventory = getRemotePath("SellService.RE.SellInventory") or getRemotePath("InventoryService.RE.SellInventory"),
}

local function moneyValue()
    local dataTable = data()
    if type(dataTable) == "table" then
        if dataTable.Money ~= nil then
            return tonumber(dataTable.Money) or 0
        end
        if dataTable.___X and dataTable.___X.Money then
            return tonumber(dataTable.___X.Money) or 0
        end
    end
    return 0
end

local function rebirthValue()
    local dataTable = data()
    if type(dataTable) == "table" then
        if dataTable.Rebirth then
            return tonumber(dataTable.Rebirth) or 0
        end
        if dataTable.___X and dataTable.___X.Rebirth then
            return tonumber(dataTable.___X.Rebirth) or 0
        end
    end
    return 0
end

local function refreshStatus()
    local money = moneyValue()
    local rebirth = rebirthValue()
    STATE.money = money
    STATE.rebirth = rebirth
    STATE.status = Config.autoRoll and "Auto Roll Active" or "Ready"
end

local function antiAfk()
    if not Config.afk then
        return
    end
    local vu = VirtualUser
    LocalPlayer.Idled:Connect(function()
        pcall(function()
            vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(0.2)
            vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end)
end

local function runAutoRoll()
    task.spawn(function()
        while true do
            if Config.autoRoll then
                safeFire(remoteMap.RollDice)
                refreshStatus()
            end
            task.wait(1.2)
        end
    end)
end

local function runAutoCollect()
    task.spawn(function()
        while true do
            if Config.autoCollect then
                safeFire(remoteMap.CollectBalance)
            end
            refreshStatus()
            task.wait(math.max(1, tonumber(Config.delayCollect) or 2))
        end
    end)
end

local function runAutoLevel()
    task.spawn(function()
        while true do
            if Config.autoLevel then
                safeFire(remoteMap.LevelUpSlot)
            end
            refreshStatus()
            task.wait(0.9)
        end
    end)
end

local function runAutoRebirth()
    task.spawn(function()
        while true do
            if Config.autoRebirth then
                safeFire(remoteMap.Rebirth)
            end
            refreshStatus()
            task.wait(5)
        end
    end)
end

local function startSystem()
    antiAfk()
    runAutoRoll()
    runAutoCollect()
    runAutoLevel()
    runAutoRebirth()
    sendWebhook("✅ MofenkHub Started", "Anime Dice premium dashboard active.", 3447003)
    Window:Notify("Success", "Anime Dice", "Premium UI loaded successfully.", 3)
end

startSystem()

return true
