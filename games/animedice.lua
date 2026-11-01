-- ===================================================================== --
-- 👑 MOFENKHUB V106.0 — ANIME DICE PREMIUM AUTOMATION
-- ===================================================================== --
--!nocheck

task.wait(0.2)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local function queueTeleport(code)
    local qot = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
    if qot then
        pcall(function()
            qot(code)
        end)
    end
end

queueTeleport([[
    task.wait(3)
    local ok, err = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/games/animedice.lua")
        loadstring(script)()
    end)
    if not ok then warn(err) end
]])

local function safeRequire(path)
    local ok, result = pcall(function()
        return require(path)
    end)
    if ok then
        return result
    end
    return nil
end

local function safeCall(fn, ...)
    if type(fn) ~= "function" then return false end
    local ok, err = pcall(fn, ...)
    if not ok then warn("[MofenkHub] safeCall error: " .. tostring(err)) end
    return ok
end

local function safeFire(remote, ...)
    if not remote then return false end
    local ok = pcall(function()
        if remote.FireServer then
            remote:FireServer(...)
            return true
        end
        if remote.InvokeServer then
            local result = remote:InvokeServer(...)
            return result ~= nil or true
        end
        return false
    end)
    return ok
end

local function isValidTable(val)
    return type(val) == "table"
end

local function deepClone(value)
    if type(value) ~= "table" then return value end
    local copy = {}
    for k, v in pairs(value) do
        copy[k] = deepClone(v)
    end
    return copy
end

local CFG_FOLDER = "MofenkHub_Configs"
if makefolder and not isfolder(CFG_FOLDER) then
    pcall(function() makefolder(CFG_FOLDER) end)
end

local _GKey = "__ANIMEDICE"
_G[_GKey] = (_G[_GKey] or 0) + 1
local generation = _G[_GKey]

local F = {
    cfgName = "MofenkConfig1",
    autoLoadEnabled = false,
    collect = false,
    collectDelay = 2.0,
    levelup = false,
    maxLevel = 40,
    rebirth = false,
    upgrades = false,
    buyDice = true,
    equipDice = true,
    autoRoll = false,
    autoBestPlaceBase = false,
    sellAuto = false,
    sellMaxInvent = false,
    keepBest = 0,
    autoFuse = false,
    keepRarities = {"Mythic", "Secret", "Divine", "Godly"},
    autoLockRarity = true,
    potionAuto = false,
    potionBest = true,
    potionSpecific = {},
    autoLockTarget = true,
    quirkAuto = false,
    quirkTargets = {},
    quirkUnits = {},
    quirkReserve = 10,
    gradeAuto = false,
    gradeTargets = {},
    gradeUnits = {},
    gemReserve = 100,
    traitAuto = false,
    traitTargets = {},
    traitUnits = {},
    rerollReserve = 50,
    tower = false,
    towerMix = false,
    towerList = {"Dragon Tower", "Demon Tower"},
    towerEquipBest = true,
    towerExitOn = false,
    towerExitFloor = 50,
    afk = true,
    codesAuto = false,
    claimQuests = false,
    webhookEnabled = false,
    webhookUrl = "",
}

local STATE = {
    towerLive = "Standby",
    towerFloor = 0,
    towerDrops = 0,
    towerTraitsGot = "Belum Ada",
    quirkStatus = "Standby",
    gradeStatus = "Standby",
    traitStatus = "Standby",
}

local function getCfgPath(name)
    return CFG_FOLDER .. "/" .. (name or F.cfgName or "DefaultConfig") .. ".json"
end

local function saveConfig(name)
    if writefile then
        pcall(function()
            writefile(getCfgPath(name), HttpService:JSONEncode(F))
            local pointerPath = CFG_FOLDER .. "/autoload_pointer.txt"
            if F.autoLoadEnabled then
                writefile(pointerPath, name or F.cfgName or "DefaultConfig")
            elseif isfile and isfile(pointerPath) then
                delfile(pointerPath)
            end
        end)
    end
end

local function loadConfig(name)
    local path = getCfgPath(name)
    if readfile and isfile and isfile(path) then
        pcall(function()
            local data = HttpService:JSONDecode(readfile(path))
            if type(data) == "table" then
                for k, v in pairs(data) do
                    F[k] = v
                end
            end
        end)
    end
end

local function formatMoney(val)
    val = tonumber(val) or 0
    if val >= 1e12 then return string.format("%.2fT", val / 1e12)
    elseif val >= 1e9 then return string.format("%.2fB", val / 1e9)
    elseif val >= 1e6 then return string.format("%.2fM", val / 1e6)
    elseif val >= 1e3 then return string.format("%.2fK", val / 1e3)
    else return tostring(math.floor(val)) end
end

local Network = ReplicatedStorage:WaitForChild("Network", 15)
local Framework = ReplicatedStorage:WaitForChild("Framework", 15)

local function svc(path)
    local node = Network
    for segment in string.gmatch(path, "[^%.]+") do
        node = node and node:FindFirstChild(segment)
    end
    return node
end

local R = {
    RollDice = svc("RollService.RF.RollDice"),
    CollectBalance = svc("PlotService.RE.CollectBalance"),
    LevelUpSlot = svc("PlotService.RE.LevelUpSlot"),
    BuyDice = svc("DiceShopService.RE.BuyDice"),
    EquipDice = svc("DiceShopService.RE.EquipDice"),
    Rebirth = svc("RebirthService.RE.Rebirth"),
    BuyUpgrade = svc("RE.BuyUpgrade") or svc("PlotService.RE.BuyPadUpgrade"),
    QuirkRoll = svc("QuirkService.RE.Roll") or svc("Quirks.RE.Roll") or svc("MutationService.RE.Roll"),
    GradeRoll = svc("GradeService.RE.Roll") or svc("Grades.RE.Roll"),
    TraitRoll = svc("TraitService.RE.Roll") or svc("Traits.RE.Roll"),
    BoostUse = svc("BoostService.RE.Use"),
    PlayTower = svc("Towers.RF.PlayTower") or svc("Towers.RE.PlayTower") or svc("TowerService.RF.PlayTower"),
    CompleteFloor = svc("Towers.RF.CompleteTowerFloor") or svc("TowerService.RF.CompleteTowerFloor"),
    CancelTower = svc("Towers.RF.CancelTower") or svc("TowerService.RF.CancelTower"),
    BestTowerTeam = svc("Towers.RE.EquipBestTowerTeam") or svc("TowerService.RE.EquipBestTowerTeam"),
    RedeemCode = svc("CodesService.RE.RedeemCode") or svc("MonetizationService.RE.RedeemCode"),
    QuestClaim = svc("QuestService.RE.Claim"),
    ClaimDaily = svc("DailyRewardService.RE.Claim"),
    ClaimOffline = svc("OfflineEarningsService.RE.Claim"),
    ClaimGroup = svc("GroupRewardService.RE.Claim"),
    SellInventory = svc("SellService.RF.SellInventory") or svc("SellService.RE.SellInventory"),
    InteractSlot = svc("PlotService.RE.InteractSlot"),
    EquipUnit = svc("UnitService.RF.Equip") or svc("UnitService.RE.Equip"),
    LockUnit = svc("UnitService.RE.SetLock") or svc("InventoryService.RE.Lock"),
}

local G = {}

G.DC = safeRequire(Framework.Features.Data.DataController)
G.PlotConfig = safeRequire(Framework.Features.Plot.PlotConfig)
G.UnitUtil = safeRequire(Framework.Features.Inventory.Kinds.Unit.UnitUtil)
G.Upgrades = safeRequire(Framework.Features.Upgrades.Upgrades)
G.Rebirths = safeRequire(Framework.Features.Rebirth.Rebirths)
G.BoostConfig = safeRequire(Framework.Features.Inventory.Kinds.Boost.BoostConfig)
G.GradesMod = safeRequire(Framework.Features.Grades.Grades)
G.TraitsMod = safeRequire(Framework.Features.Traits.Traits)
G.QuirksMod = safeRequire(Framework.Features.Quirks.Quirks) or safeRequire(Framework.Features.Mutations.Mutations)
G.QuestConfig = safeRequire(Framework.Features.Quests.QuestConfig)
G.EntryRegistry = safeRequire(Framework.Features.Inventory.EntryRegistry)
G.BuffController = safeRequire(Framework.Features.Buffs.BuffController)
G.DiceModule = safeRequire(Framework.Features.Rolling.Dice)
G.TowersConfig = safeRequire(Framework.Features.Towers.Towers)
G.UnitConfig = safeRequire(Framework.Features.Inventory.Kinds.Unit.UnitConfig)

local function data()
    return G.DC and G.DC.___X or {}
end

local function money()
    if G.DC and G.DC.Money then
        local ok, value = pcall(function()
            return G.DC:Money()
        end)
        if ok and value then return tonumber(value) or 0 end
    end
    return tonumber(data().Money) or 0
end

local function rebirthAmt()
    if G.DC and G.DC.Rebirth then
        local ok, value = pcall(function()
            return G.DC:Rebirth()
        end)
        if ok and value then return tonumber(value) or 0 end
    end
    return tonumber(data().Rebirth) or 0
end

local function inventory()
    return data().Inventory or {}
end

local function slots()
    return data().Slots or {}
end

local function isUnitEntry(entry)
    if type(entry) ~= "table" or not entry.name then return false end
    if not G.EntryRegistry or not G.EntryRegistry.getEntryConfig then return false end
    local ok, result = pcall(function()
        return G.EntryRegistry.getEntryConfig(entry.name)
    end)
    return ok and result and result.kind == "Unit"
end

local function currencyAmount(name)
    local total = 0
    for _, entry in pairs(inventory()) do
        if type(entry) == "table" and entry.name == name then
            total += tonumber(entry.amount) or 0
        end
    end
    return total
end

local function isBeingRolled(unitId)
    if not unitId then return false end
    if F.quirkAuto then
        for _, id in ipairs(F.quirkUnits or {}) do
            if id == unitId then return true end
        end
    end
    if F.gradeAuto then
        for _, id in ipairs(F.gradeUnits or {}) do
            if id == unitId then return true end
        end
    end
    if F.traitAuto then
        for _, id in ipairs(F.traitUnits or {}) do
            if id == unitId then return true end
        end
    end
    return false
end

local function getUnitRarity(unit)
    local rarity = "Common"
    if unit and unit.name then
        pcall(function()
            if G.EntryRegistry and G.EntryRegistry.getEntryConfig then
                local cfg = G.EntryRegistry.getEntryConfig(unit.name)
                if cfg and cfg.rarity then rarity = cfg.rarity end
            elseif G.UnitConfig and G.UnitConfig.entries then
                local cfg = G.UnitConfig.entries[unit.name]
                if cfg and cfg.rarity then rarity = cfg.rarity end
            end
        end)
    end
    return tostring(rarity)
end

local function baseIncome(unit)
    if not unit or not unit.name then return 0 end
    local config = G.UnitConfig and G.UnitConfig.entries and G.UnitConfig.entries[unit.name]
    if not config then return 0 end
    local attrs = unit.attributes or {}
    local level = tonumber(attrs.level) or 1
    local ok, result = pcall(function()
        if config.income then
            return config.income({
                mutation = attrs.mutation or attrs.quirk,
                grade = attrs.grade,
                trait = attrs.trait,
                level = level,
            })
        end
        return 0
    end)
    return tonumber(result) or 0
end

local function sendWebhook(title, description, colorCode)
    if not F.webhookEnabled or F.webhookUrl == "" then return end
    local req = (syn and syn.request) or request or http_request or (fluxus and fluxus.request)
    if req then
        pcall(function()
            req({
                Url = F.webhookUrl,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({
                    username = "MofenkHub-AI",
                    avatar_url = "https://i.imgur.com/3qGMB7j.png",
                    embeds = {{
                        title = title,
                        description = description,
                        color = colorCode or 3447003,
                        footer = {text = "MofenkHub Premium"},
                    }},
                }),
            })
        end)
    end
end

local MofenkUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/MofenkUI.lua"))()
local Window = MofenkUI.CreateWindow({
    Name = "MofenkHub | Anime Dice",
    ToggleStyle = "Icon",
    Theme = "Monochrome",
    ProfileTitle = "VIP Cloud Automation",
})

local T_Dash = Window:CreateTab("Dashboard", "📊")
local T_Farm = Window:CreateTab("Farming", "⛏️")
local T_Inv = Window:CreateTab("Inventory", "🎒")
local T_Pot = Window:CreateTab("Potions", "🧪")
local T_Qrk = Window:CreateTab("Quirk & Roll", "⚡")
local T_Grd = Window:CreateTab("Grade & Roll", "⭐")
local T_Trt = Window:CreateTab("Trait & Roll", "🧬")
local T_Twr = Window:CreateTab("Tower Utama", "🏰")
local T_Set = Window:CreateTab("Settings", "⚙️")

T_Dash:AddSection("Informasi Akun")
T_Dash:AddInfoCard("Status Akun", "Secure & Active")
T_Dash:AddInfoCard("Money", "Calculating...")

T_Farm:AddSection("Plot & Auto Roll")
T_Farm:AddToggle("Auto Collect Plot Balance", false, function(v) F.collect = v end)
T_Farm:AddSlider("Delay Collect (Detik)", 1, 10, 2, function(v) F.collectDelay = v end)
T_Farm:AddToggle("Auto Roll Dadu", false, function(v) F.autoRoll = v end)
T_Farm:AddToggle("AI Smart Place Unit Terbaik", false, function(v) F.autoBestPlaceBase = v end)
T_Farm:AddToggle("Auto Rebirth", false, function(v) F.rebirth = v end)
T_Farm:AddSection("Leveling & Upgrades")
T_Farm:AddToggle("Auto Level Up Unit Plot", false, function(v) F.levelup = v end)
T_Farm:AddSlider("Max Level Unit", 1, 100, 40, function(v) F.maxLevel = v end)
T_Farm:AddToggle("Auto Upgrade Skill Tree", false, function(v) F.upgrades = v end)

T_Inv:AddSection("Manajemen Unit")
T_Inv:AddToggle("Auto Sell General", false, function(v) F.sellAuto = v end)
T_Inv:AddToggle("Auto Sell Penuh", false, function(v) F.sellMaxInvent = v end)
T_Inv:AddSlider("Simpan Unit Terbaik (Keep Best)", 0, 50, 0, function(v) F.keepBest = v end)
T_Inv:AddToggle("Auto Lock Rarity Pilihan", true, function(v) F.autoLockRarity = v end)
T_Inv:AddToggle("Auto Fusion Unit", false, function(v) F.autoFuse = v end)

T_Pot:AddSection("Potion Manager")
T_Pot:AddToggle("Auto Gunakan Potion", false, function(v) F.potionAuto = v end)

T_Qrk:AddSection("Quirk Reroll Setup")
T_Qrk:AddToggle("Auto Lock Target Quirk", true, function(v) F.autoLockTarget = v end)
T_Qrk:AddToggle("Aktifkan Auto Quirk Reroll", false, function(v) F.quirkAuto = v end)
T_Qrk:AddSlider("Quirk Reserve Minimum", 0, 100, 10, function(v) F.quirkReserve = v end)

T_Grd:AddSection("Grade Reroll Setup")
T_Grd:AddToggle("Aktifkan Auto Grade Reroll", false, function(v) F.gradeAuto = v end)
T_Grd:AddSlider("Gems Reserve Minimum", 0, 500, 100, function(v) F.gemReserve = v end)

T_Trt:AddSection("Trait Reroll Setup")
T_Trt:AddToggle("Aktifkan Auto Trait Reroll", false, function(v) F.traitAuto = v end)
T_Trt:AddSlider("Reroll Scroll Reserve", 0, 200, 50, function(v) F.rerollReserve = v end)

T_Twr:AddSection("Main Tower Setup")
T_Twr:AddToggle("Auto Main Tower Farming", false, function(v) F.tower = v end)
T_Twr:AddToggle("Mode MIX / Random Tower", false, function(v) F.towerMix = v end)
T_Twr:AddToggle("Auto Equip Best Team Tower", true, function(v) F.towerEquipBest = v end)
T_Twr:AddToggle("Keluar di Lantai Tertentu", false, function(v) F.towerExitOn = v end)
T_Twr:AddSlider("Batas Lantai Exit Tower", 1, 100, 50, function(v) F.towerExitFloor = v end)

T_Set:AddSection("Konfigurasi & Sistem")
T_Set:AddToggle("Auto Load Config", false, function(v) F.autoLoadEnabled = v end)
T_Set:AddTextBox("Nama File Config", "MofenkConfig1", function(text) F.cfgName = text end)
T_Set:AddButton("Save Config Sekarang", function() saveConfig(F.cfgName); Window:Notify("Success", "Config", "File berhasil disimpan.", 2) end)
T_Set:AddButton("Load Config Pilihan", function() loadConfig(F.cfgName); Window:Notify("Info", "Config", "File berhasil dimuat.", 2) end)
T_Set:AddSection("Webhook & Utilities")
T_Set:AddToggle("Aktifkan Webhook Discord", false, function(v) F.webhookEnabled = v end)
T_Set:AddTextBox("Webhook URL", "", function(text) F.webhookUrl = text end)
T_Set:AddButton("Test Kirim Webhook", function() sendWebhook("✅ Webhook Connected!", "MofenkHub terhubung.", 3447003) end)
T_Set:AddToggle("Anti-AFK Protection", true, function(v) F.afk = v end)
T_Set:AddToggle("Auto Claim Quests & Daily", false, function(v) F.claimQuests = v end)
T_Set:AddToggle("Auto Redeem Codes", false, function(v) F.codesAuto = v end)

local vu = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if F.afk then
        pcall(function()
            vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

task.spawn(function()
    while _G.__ANIMEDICE == generation do
        if F.autoLockRarity and R.LockUnit then
            pcall(function()
                for id, unit in pairs(inventory()) do
                    if isUnitEntry(unit) and not isBeingRolled(id) then
                        local rarity = getUnitRarity(unit)
                        local selected = false
                        for _, rName in ipairs(F.keepRarities or {}) do
                            if string.lower(tostring(rarity)) == string.lower(tostring(rName)) then
                                selected = true
                                break
                            end
                        end
                        local locked = unit.attributes and unit.attributes.locked
                        if selected and not locked then
                            R.LockUnit:FireServer(id, true)
                        elseif not selected and locked then
                            R.LockUnit:FireServer(id, false)
                        end
                    end
                end
            end)
        end
        task.wait(3)
    end
end)

task.spawn(function()
    while _G.__ANIMEDICE == generation do
        if F.autoRoll then
            pcall(function()
                if R.RollDice then
                    if R.RollDice.InvokeServer then
                        R.RollDice:InvokeServer()
                    elseif R.RollDice.FireServer then
                        R.RollDice:FireServer()
                    end
                end
            end)
            task.wait(1.8)
        else
            task.wait(1)
        end
    end
end)

task.spawn(function()
    local lastRebirth = 0
    while _G.__ANIMEDICE == generation do
        if F.collect and R.CollectBalance then
            pcall(function()
                for i = 1, 15 do
                    if R.CollectBalance.FireServer then
                        R.CollectBalance:FireServer(i)
                    elseif R.CollectBalance.InvokeServer then
                        R.CollectBalance:InvokeServer(i)
                    end
                end
            end)
        end

        if F.levelup and R.LevelUpSlot then
            pcall(function()
                local slotData = slots()
                local currentMoney = money()
                for i = 1, 15 do
                    local d = slotData[tostring(i)]
                    if d and d.unitId then
                        local entry = inventory()[d.unitId]
                        if entry and entry.attributes and (tonumber(entry.attributes.level) or 1) < F.maxLevel then
                            local price = 0
                            pcall(function()
                                if G.UnitUtil and G.UnitUtil.GetLevelPrice then
                                    price = G.UnitUtil.GetLevelPrice(entry.name, entry.attributes)
                                end
                            end)
                            if currentMoney >= price then
                                if R.LevelUpSlot.FireServer then
                                    R.LevelUpSlot:FireServer(i)
                                elseif R.LevelUpSlot.InvokeServer then
                                    R.LevelUpSlot:InvokeServer(i)
                                end
                                currentMoney = currentMoney - price
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end)
        end

        if F.rebirth and R.Rebirth and (os.clock() - lastRebirth > 5) then
            pcall(function()
                local nextRebirth = G.Rebirths and G.Rebirths.GetNext and G.Rebirths.GetNext(rebirthAmt())
                local price = nextRebirth and (nextRebirth.cost or 9e9) or 9e9
                if money() >= price then
                    if R.Rebirth.FireServer then
                        R.Rebirth:FireServer()
                    elseif R.Rebirth.InvokeServer then
                        R.Rebirth:InvokeServer()
                    end
                    lastRebirth = os.clock()
                end
            end)
        end

        task.wait(math.clamp(tonumber(F.collectDelay) or 2.0, 0.5, 60))
    end
end)

Window:Notify("MofenkHub", "Anime Dice berhasil dimuat menggunakan MofenkUI!", 4)

return true
