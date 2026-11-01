-- ===================================================================== --
-- 👑 MOFENKHUB V106.0 — ANIME DICE (MofenkUI Monochrome Integration)
-- ===================================================================== --
​--!nocheck
task.wait(0.2)
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui           = game:GetService("CoreGui")
local HttpService       = game:GetService("HttpService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
​pcall(function()
local qot = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
if qot then
qot([[
task.wait(3)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/animedice.lua"))()
]])
end
end)
​local LocalPlayer = Players.LocalPlayer
​-- Load Library MofenkUI Terbaru (Monochrome Glass Edition)
local MofenkUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/MofenkUI.lua"))()
​-- Inisialisasi Window Utama Menggunakan API MofenkUI
local Window = MofenkUI.CreateWindow({
Name = "MofenkHub | Anime Dice",
ProfileTitle = "VIP Cloud Automation"
})
​-- ===================================================================== --
-- 1. CONFIGURATION & STATE MANAGER
-- ===================================================================== --
_G.__ANIMEDICE = (_G.__ANIMEDICE or 0) + 1
local generation = _G.__ANIMEDICE
​local F = {
cfgName = "MofenkConfig1", autoLoadEnabled = false,
-- Farm & Plot
collect = false, collectDelay = 2.0, levelup = false, maxLevel = 40,
rebirth = false, upgrades = false, buyDice = true, equipDice = true, autoRoll = false,
autoBestPlaceBase = false,
-- Inventory & Auto Sell / Lock
sellAuto = false, sellMaxInvent = false, keepBest = 0, autoFuse = false,
keepRarities = {"Mythic", "Secret", "Divine", "Godly"},
autoLockRarity = true,
-- Potions
potionAuto = false, potionBest = true, potionSpecific = {},
-- Quirk, Grade & Trait Management
autoLockTarget = true,
quirkAuto = false, quirkTargets = {}, quirkUnits = {}, quirkReserve = 10,
gradeAuto = false, gradeTargets = {}, gradeUnits = {}, gemReserve = 100,
traitAuto = false, traitTargets = {}, traitUnits = {}, rerollReserve = 50,
-- Main Tower Setup
tower = false, towerMix = false, towerList = {"Dragon Tower", "Demon Tower"}, towerEquipBest = true, towerExitOn = false, towerExitFloor = 50,
-- Client & Misc
afk = true, codesAuto = false, claimQuests = false,
-- Webhook
webhookEnabled = false, webhookUrl = ""
}
​local CFG_FOLDER = "MofenkHub_Configs"
if makefolder and not isfolder(CFG_FOLDER) then pcall(function() makefolder(CFG_FOLDER) end) end
​local function getCfgPath(name) return CFG_FOLDER .. "/" .. (name or F.cfgName or "DefaultConfig") .. ".json" end
​local function saveConfig(name)
if writefile then
pcall(function()
writefile(getCfgPath(name), HttpService:JSONEncode(F))
local pointerPath = CFG_FOLDER .. "/autoload_pointer.txt"
if F.autoLoadEnabled then writefile(pointerPath, name or F.cfgName or "DefaultConfig")
else if isfile and isfile(pointerPath) then delfile(pointerPath) end end
end)
end
end
​local function loadConfig(name)
local path = getCfgPath(name)
if readfile and isfile and isfile(path) then
pcall(function()
local d = HttpService:JSONDecode(readfile(path))
for k,v in pairs(d) do F[k]=v end
end)
end
end
​-- ===================================================================== --
-- 2. FRAMEWORK & MODULE SERVICES BINDINGS
-- ===================================================================== --
local Network = ReplicatedStorage:WaitForChild("Network", 15); local Framework = ReplicatedStorage:WaitForChild("Framework", 15)
local function svc(p) local n = Network; for x in string.gmatch(p, "[^%.]+") do n = n and n:FindFirstChild(x) end; return n end
​local R = {
RollDice        = svc("RollService.RF.RollDice"),
CollectBalance  = svc("PlotService.RE.CollectBalance"),
LevelUpSlot     = svc("PlotService.RE.LevelUpSlot"),
BuyDice         = svc("DiceShopService.RE.BuyDice"),
EquipDice       = svc("DiceShopService.RE.EquipDice"),
Rebirth         = svc("RebirthService.RE.Rebirth"),
BuyUpgrade      = svc("RE.BuyUpgrade") or svc("PlotService.RE.BuyPadUpgrade"),
QuirkRoll       = svc("QuirkService.RE.Roll") or svc("Quirks.RE.Roll") or svc("MutationService.RE.Roll"),
GradeRoll       = svc("GradeService.RE.Roll") or svc("Grades.RE.Roll"),
TraitRoll       = svc("TraitService.RE.Roll") or svc("Traits.RE.Roll"),
BoostUse        = svc("BoostService.RE.Use"),
PlayTower       = svc("Towers.RF.PlayTower") or svc("Towers.RE.PlayTower") or svc("TowerService.RF.PlayTower"),
CompleteFloor   = svc("Towers.RF.CompleteTowerFloor") or svc("TowerService.RF.CompleteTowerFloor"),
CancelTower     = svc("Towers.RF.CancelTower") or svc("TowerService.RF.CancelTower"),
BestTowerTeam   = svc("Towers.RE.EquipBestTowerTeam") or svc("TowerService.RE.EquipBestTowerTeam"),
RedeemCode      = svc("CodesService.RE.RedeemCode") or svc("MonetizationService.RE.RedeemCode"),
QuestClaim      = svc("QuestService.RE.Claim"),
ClaimDaily      = svc("DailyRewardService.RE.Claim"),
ClaimOffline    = svc("OfflineEarningsService.RE.Claim"),
ClaimGroup      = svc("GroupRewardService.RE.Claim"),
SellInventory   = svc("SellService.RF.SellInventory") or svc("SellService.RE.SellInventory"),
InteractSlot    = svc("PlotService.RE.InteractSlot"),
EquipUnit       = svc("UnitService.RF.Equip") or svc("UnitService.RE.Equip"),
LockUnit        = svc("UnitService.RE.SetLock") or svc("InventoryService.RE.Lock")
}
​local G = {}
pcall(function()
G.DC = require(Framework.Features.Data.DataController)
G.PlotConfig = require(Framework.Features.Plot.PlotConfig)
G.UnitUtil = require(Framework.Features.Inventory.Kinds.Unit.UnitUtil)
G.Upgrades = require(Framework.Features.Upgrades.Upgrades)
G.Rebirths = require(Framework.Features.Rebirth.Rebirths)
G.BoostConfig = require(Framework.Features.Inventory.Kinds.Boost.BoostConfig)
G.GradesMod = require(Framework.Features.Grades.Grades)
G.TraitsMod = require(Framework.Features.Traits.Traits)
G.QuirksMod = (Framework.Features:FindFirstChild("Quirks") and require(Framework.Features.Quirks.Quirks)) or (Framework.Features:FindFirstChild("Mutations") and require(Framework.Features.Mutations.Mutations))
G.QuestConfig = require(Framework.Features.Quests.QuestConfig)
G.EntryRegistry = require(Framework.Features.Inventory.EntryRegistry)
G.UnitConfig = require(Framework.Features.Inventory.Kinds.Unit.UnitConfig)
end)
​local function data() return G.DC and G.DC.___X or {} end
local function money() pcall(function() return G.DC.Money() end); return data().Money or 0 end
local function rebirthAmt() pcall(function() return G.DC.Rebirth() end); return data().Rebirth or 0 end
local function inventory() return data().Inventory or {} end
local function slots() return data().Slots or {} end
local function isUnitEntry(e) return e and type(e)=="table" and e.name and G.EntryRegistry and pcall(function() return G.EntryRegistry.getEntryConfig(e.name).kind == "Unit" end) end
​local function isBeingRolled(unitId)
if not unitId then return false end
if F.quirkAuto then for _, id in ipairs(F.quirkUnits or {}) do if id == unitId then return true end end end
if F.gradeAuto then for _, id in ipairs(F.gradeUnits or {}) do if id == unitId then return true end end end
if F.traitAuto then for _, id in ipairs(F.traitUnits or {}) do if id == unitId then return true end end end
return false
end
​local function getUnitRarity(u)
local rarity = "Common"
if u and u.name then
pcall(function()
if G.EntryRegistry and G.EntryRegistry.getEntryConfig then
local cfg = G.EntryRegistry.getEntryConfig(u.name)
if cfg and cfg.rarity then rarity = cfg.rarity end
elseif G.UnitConfig and G.UnitConfig.entries then
local cfg = G.UnitConfig.entries[u.name]
if cfg and cfg.rarity then rarity = cfg.rarity end
end
end)
end
return tostring(rarity)
end
​-- ===================================================================== --
-- 3. BUILD TABS & COMPONENTS VIA MOFENKUI LIBRARY
-- ===================================================================== --
local T_Dash = Window:CreateTab("Dashboard", "📊")
local T_Farm = Window:CreateTab("Farming", "⛏️")
local T_Inv  = Window:CreateTab("Inventory", "🎒")
local T_Pot  = Window:CreateTab("Potions", "🧪")
local T_Qrk  = Window:CreateTab("Quirk & Roll", "⚡")
local T_Grd  = Window:CreateTab("Grade & Roll", "⭐")
local T_Trt  = Window:CreateTab("Trait & Roll", "🧬")
local T_Twr  = Window:CreateTab("Tower Utama", "🏰")
local T_Set  = Window:CreateTab("Settings", "⚙️")
​-- Dashboard Tab
T_Dash:AddSection("Informasi Akun")
T_Dash:AddInfoCard("Status Akun", "Secure & Active")
T_Dash:AddInfoCard("Money", "Calculating...")
​-- Farming Tab
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
​-- Inventory Tab
T_Inv:AddSection("Manajemen Unit")
T_Inv:AddToggle("Auto Sell General", false, function(v) F.sellAuto = v end)
T_Inv:AddToggle("Auto Sell Penuh", false, function(v) F.sellMaxInvent = false end)
T_Inv:AddSlider("Simpan Unit Terbaik (Keep Best)", 0, 50, 0, function(v) F.keepBest = v end)
T_Inv:AddToggle("Auto Lock Rarity Pilihan", true, function(v) F.autoLockRarity = v end)
T_Inv:AddToggle("Auto Fusion Unit", false, function(v) F.autoFuse = v end)
​-- Potions Tab
T_Pot:AddSection("Potion Manager")
T_Pot:AddToggle("Auto Gunakan Potion", false, function(v) F.potionAuto = v end)
​-- Quirk Tab
T_Qrk:AddSection("Quirk Reroll Setup")
T_Qrk:AddToggle("Auto Lock Target Quirk", true, function(v) F.autoLockTarget = v end)
T_Qrk:AddToggle("Aktifkan Auto Quirk Reroll", false, function(v) F.quirkAuto = v end)
T_Qrk:AddSlider("Quirk Reserve Minimum", 0, 100, 10, function(v) F.quirkReserve = v end)
​-- Grade Tab
T_Grd:AddSection("Grade Reroll Setup")
T_Grd:AddToggle("Aktifkan Auto Grade Reroll", false, function(v) F.gradeAuto = v end)
T_Grd:AddSlider("Gems Reserve Minimum", 0, 500, 100, function(v) F.gemReserve = v end)
​-- Trait Tab
T_Trt:AddSection("Trait Reroll Setup")
T_Trt:AddToggle("Aktifkan Auto Trait Reroll", false, function(v) F.traitAuto = v end)
T_Trt:AddSlider("Reroll Scroll Reserve", 0, 200, 50, function(v) F.rerollReserve = v end)
​-- Tower Tab
T_Twr:AddSection("Main Tower Setup")
T_Twr:AddToggle("Auto Main Tower Farming", false, function(v) F.tower = v end)
T_Twr:AddToggle("Mode MIX / Random Tower", false, function(v) F.towerMix = v end)
T_Twr:AddToggle("Auto Equip Best Team Tower", true, function(v) F.towerEquipBest = v end)
T_Twr:AddToggle("Keluar di Lantai Tertentu", false, function(v) F.towerExitOn = v end)
T_Twr:AddSlider("Batas Lantai Exit Tower", 1, 100, 50, function(v) F.towerExitFloor = v end)
​-- Settings Tab
T_Set:AddSection("Konfigurasi & Sistem")
T_Set:AddToggle("Auto Load Config", false, function(v) F.autoLoadEnabled = v end)
T_Set:AddTextBox("Nama File Config", "MofenkConfig1", function(text) F.cfgName = text end)
T_Set:AddButton("Save Config Sekarang", function() saveConfig(F.cfgName); Window:Notify("Success", "Config Berhasil Disimpan", 2) end)
T_Set:AddButton("Load Config Pilihan", function() loadConfig(F.cfgName); Window:Notify("Info", "Config Berhasil Dimuat", 2) end)
T_Set:AddSection("Webhook & Utilities")
T_Set:AddToggle("Aktifkan Webhook Discord", false, function(v) F.webhookEnabled = v end)
T_Set:AddTextBox("Webhook URL", "", function(text) F.webhookUrl = text end)
T_Set:AddToggle("Anti-AFK Protection", true, function(v) F.afk = v end)
T_Set:AddToggle("Auto Claim Quests & Daily", false, function(v) F.claimQuests = v end)
T_Set:AddToggle("Auto Redeem Codes", false, function(v) F.codesAuto = v end)
​-- ===================================================================== --
-- 4. BACKEND AUTOMATION LOOPS
-- ===================================================================== --
local vu = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
if F.afk then
pcall(function()
vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
task.wait(1)
vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
end
end)
​task.spawn(function()
while _G.__ANIMEDICE == generation do
if F.autoLockRarity and R.LockUnit then
pcall(function()
for id, u in pairs(inventory()) do
if isUnitEntry(u) and not isBeingRolled(id) then
local rarity = getUnitRarity(u)
local isSelectedRarity = false
for _, rName in ipairs(F.keepRarities or {}) do
if string.lower(tostring(rarity)) == string.lower(tostring(rName)) then isSelectedRarity = true; break end
end
local isLocked = u.attributes and u.attributes.locked
if isSelectedRarity and not isLocked then R.LockUnit:FireServer(id, true)
elseif not isSelectedRarity and isLocked then R.LockUnit:FireServer(id, false) end
end
end
end)
end
task.wait(3)
end
end)
​task.spawn(function()
while _G.__ANIMEDICE == generation do
if F.autoRoll then
pcall(function() if R.RollDice then R.RollDice:InvokeServer() end end)
task.wait(1.8)
else task.wait(1) end
end
end)
​task.spawn(function()
local lastRebirth = 0
while _G.__ANIMEDICE == generation do
if F.collect and R.CollectBalance then
pcall(function()
for i=1, 15 do R.CollectBalance:FireServer(i) end
end)
end
​if F.levelup and R.LevelUpSlot then
pcall(function()
local s = slots(); local m = money()
for i=1, 15 do
local d = s[tostring(i)]
if d and d.unitId then
local e = inventory()[d.unitId]
if e and e.attributes and (tonumber(e.attributes.level) or 1) < F.maxLevel then
local price = 0; pcall(function() price = G.UnitUtil.GetLevelPrice(e.name, e.attributes) end)
if m >= price then R.LevelUpSlot:FireServer(i); m = m - price; task.wait(0.1) end
end
end
end
end)
end
​if F.rebirth and R.Rebirth and (os.clock() - lastRebirth > 5) then
pcall(function() local nr = G.Rebirths.GetNext(rebirthAmt()); if nr and money() >= (nr.cost or 9e9) then R.Rebirth:FireServer(); lastRebirth = os.clock() end end)
end
​task.wait(math.clamp(tonumber(F.collectDelay) or 2.0, 0.5, 60))
end
end)
​Window:Notify("Success", "MofenkHub", "Anime Dice berhasil dimuat dengan MofenkUI Monochrome!", 4)
