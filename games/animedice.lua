-- ===================================================================== --
-- 👑 MOFENKHUB V107.0 — ANIMEDICE AUTOMATION SCRIPT (INTEGRATED WITH MOFENKUI)
-- ===================================================================== --
​--!nocheck
task.wait(0.2)
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui           = game:GetService("CoreGui")
local HttpService       = game:GetService("HttpService")
local TeleportService   = game:GetService("TeleportService")
local RunService        = game:GetService("RunService")
local Stats             = game:GetService("Stats")
​return function(MofenkUI)
if not MofenkUI then
warn("[MofenkHub] MofenkUI not found in animedice.lua")
return
end
​local LocalPlayer = Players.LocalPlayer
​pcall(function()
local qot = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
if qot then
qot([[
task.wait(3)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/loader.lua"))()
]])
end
end)
​_G.__ANIMEDICE = (_G.__ANIMEDICE or 0) + 1
local generation = _G.__ANIMEDICE
​local F = {
cfgName = "MofenkConfig1", autoLoadEnabled = false,
collect = false, collectDelay = 2.0, levelup = false, maxLevel = 40,
rebirth = false, upgrades = false, buyDice = true, equipDice = true, autoRoll = false,
autoBestPlaceBase = false,
sellAuto = false, sellMaxInvent = false, keepBest = 0, autoFuse = false,
keepRarities = {"Mythic", "Secret", "Divine", "Godly"},
autoLockRarity = true, specificSellUnits = {},
potionAuto = false, potionSpecific = {},
aiJitterDelay = 1.8,
quirkAuto = false, quirkTargets = {}, quirkUnits = {}, quirkReserve = 10,
gradeAuto = false, gradeTargets = {}, gradeUnits = {}, gemReserve = 100,
traitAuto = false, traitTargets = {}, traitUnits = {}, rerollReserve = 50,
tower = false, towerMix = false, towerList = {"Dragon Tower", "Demon Tower"}, towerEquipBest = true, towerExitOn = false, towerExitFloor = 50,
halloweenTeleport = false, halloweenQuest = false, halloweenPath = false, halloweenOffer = false, trickOrTreat = false,
pumpkinRollQty = 1, pumpkinAutoRoll = false, pumpkinAutoSell = false,
hauntedTower = false, hauntedMix = false, hauntedList = {"Haunted Front Yard", "Haunted Crypt"}, hauntedEquipBest = true, hauntedExitOn = false, hauntedExitFloor = 50,
afk = true, fpsOn = false, codesAuto = false, claimQuests = false,
webhookEnabled = false, webhookUrl = ""
}
​local Network = ReplicatedStorage:WaitForChild("Network", 15)
local Framework = ReplicatedStorage:WaitForChild("Framework", 15)
local function svc(p) local n = Network; for x in string.gmatch(p, "[^%.]+") do n = n and n:FindFirstChild(x) end; return n end
​local R = {
RollDice        = svc("RollService.RF.RollDice"),
SetAutoRoll     = svc("RollService.RE.SetAutoRoll"),
CollectBalance  = svc("PlotService.RE.CollectBalance"),
LevelUpSlot     = svc("PlotService.RE.LevelUpSlot"),
EquipBestPlot   = svc("PlotService.RE.EquipBest"),
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
SellInventory   = svc("SellService.RF.SellInventory") or svc("SellService.RE.SellInventory"),
LockUnit        = svc("UnitService.RE.SetLock") or svc("InventoryService.RE.Lock"),
HWTeleport      = svc("HalloweenService.RF.Teleport"),
HWSeenIntro     = svc("HalloweenService.RE.SeenIntro"),
HWQuestClaim    = svc("HalloweenQuestService.RE.Claim"),
HWClaimPath     = svc("HalloweenService.RE.ClaimAllPath"),
HWBuyOffer      = svc("HalloweenService.RE.BuyOffer"),
TrickOrTreat    = svc("TrickOrTreatService.RE.Knocked"),
PumpkinRoll     = svc("PumpkinDiceService.RF.Roll") or svc("PumpkinDiceService.RE.Roll")
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
G.QuirksMod = (Framework.Features:FindFirstChild("Quirks") and require(Framework.Features.Quirks.Quirks)) or nil
G.QuestConfig = require(Framework.Features.Quests.QuestConfig)
G.EntryRegistry = require(Framework.Features.Inventory.EntryRegistry)
G.BuffController = require(Framework.Features.Buffs.BuffController)
G.DiceModule = require(Framework.Features.Rolling.Dice)
G.UnitConfig = require(Framework.Features.Inventory.Kinds.Unit.UnitConfig)
end)
​local function data() return G.DC and G.DC.___X or {} end
local function money() pcall(function() return G.DC.Money() end); return data().Money or 0 end
local function rebirthAmt() pcall(function() return G.DC.Rebirth() end); return data().Rebirth or 0 end
local function inventory() return data().Inventory or {} end
local function slots() return data().Slots or {} end
local function isUnitEntry(e) return e and type(e)=="table" and e.name and G.EntryRegistry and pcall(function() return G.EntryRegistry.getEntryConfig(e.name).kind == "Unit" end) end
​local function GetOpts(mode)
local t = {}
if mode == "rarity" then
t = { {label="Common", val="Common"}, {label="Uncommon", val="Uncommon"}, {label="Rare", val="Rare"}, {label="Epic", val="Epic"}, {label="Legendary", val="Legendary"}, {label="Mythic", val="Mythic"}, {label="Secret", val="Secret"}, {label="Divine", val="Divine"}, {label="Godly", val="Godly"} }
elseif mode == "grade" and G.GradesMod then
for n, g in pairs(G.GradesMod) do if type(g)"table" then table.insert(t, {label=n, val=n}) end end
elseif mode == "trait" and G.TraitsMod then
for n, g in pairs(G.TraitsMod) do if type(g)"table" then table.insert(t, {label=n, val=n}) end end
elseif mode == "quirk" and G.QuirksMod then
for n, q in pairs(G.QuirksMod) do if type(q)=="table" then table.insert(t, {label=n, val=n}) end end
elseif mode == "pot" and G.BoostConfig then
for n, e in pairs(G.BoostConfig.entries or {}) do table.insert(t, {label=n, val=n}) end
elseif mode == "towers" then
t = { {label="Dragon Tower", val="Dragon Tower"}, {label="Demon Tower", val="Demon Tower"} }
end
return t
end
​local Window = MofenkUI:CreateWindow({ Name = "MOFENK HUB | Anime Dice Universal Edition" })
Window:CreateProfileTab()
​local T_Farm = Window:CreateTab("Farming")
local T_Inv  = Window:CreateTab("Inventory")
local T_Pot  = Window:CreateTab("Potions")
local T_Qrk  = Window:CreateTab("Quirk & Roll")
local T_Twr  = Window:CreateTab("Tower")
local T_Set  = Window:CreateTab("Settings")
​local G_Farm1 = T_Farm:CreateGroup("Automation Setup")
G_Farm1:AddToggle("Auto Collect Plot Balance", F.collect, function(v) F.collect = v end)
G_Farm1:AddInput("Delay Collect (s):", F.collectDelay, true, function(v) F.collectDelay = v end)
G_Farm1:AddToggle("Auto Roll Dadu", F.autoRoll, function(v) F.autoRoll = v end)
G_Farm1:AddToggle("AI Smart Place Best Units", F.autoBestPlaceBase, function(v) F.autoBestPlaceBase = v end)
G_Farm1:AddToggle("Auto Rebirth", F.rebirth, function(v) F.rebirth = v end)
​local G_Inv = T_Inv:CreateGroup("Inventory Management")
G_Inv:AddToggle("Auto Sell General", F.sellAuto, function(v) F.sellAuto = v end)
G_Inv:AddToggle("Auto Sell Max Inventory", F.sellMaxInvent, function(v) F.sellMaxInvent = v end)
G_Inv:AddInput("Keep Best Count:", F.keepBest, true, function(v) F.keepBest = v end)
G_Inv:AddDropdown("Keep Rarities:", GetOpts("rarity"), F.keepRarities, true, function(v) F.keepRarities = v end)
​local G_Pot = T_Pot:CreateGroup("Potion Manager")
G_Pot:AddToggle("Auto Use Potions", F.potionAuto, function(v) F.potionAuto = v end)
G_Pot:AddDropdown("Select Specific Potions:", GetOpts("pot"), F.potionSpecific, true, function(v) F.potionSpecific = v end)
​local G_Qrk = T_Qrk:CreateGroup("Quirk Reroll Setup")
G_Qrk:AddToggle("Auto Quirk Reroll", F.quirkAuto, function(v) F.quirkAuto = v end)
G_Qrk:AddDropdown("Target Quirks:", GetOpts("quirk"), F.quirkTargets, true, function(v) F.quirkTargets = v end)
​local G_Twr = T_Twr:CreateGroup("Tower Automation")
G_Twr:AddToggle("Auto Main Tower", F.tower, function(v) F.tower = v end)
G_Twr:AddDropdown("Select Towers:", GetOpts("towers"), F.towerList, true, function(v) F.towerList = v end)
​local G_Set = T_Set:CreateGroup("System Settings")
G_Set:AddToggle("Anti-AFK Protection", F.afk, function(v) F.afk = v end)
G_Set:AddToggle("FPS Boost", F.fpsOn, function(v) F.fpsOn = v end)
G_Set:AddButton("Server Hop", function()
TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)
​print("[MofenkHub] Anime Dice automation script initialized successfully via MofenkUI.")
end
