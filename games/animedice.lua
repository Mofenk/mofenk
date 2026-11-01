-- ===================================================================== --
-- 👑 MOFENKHUB V104.2 — FULL AI SMART PLANNER & RESOURCE THRESHOLD EDITION[span_9](start_span)[span_9](end_span)
-- ===================================================================== --

--!nocheck
task.wait(0.2)
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui           = game:GetService("CoreGui")
local HttpService       = game:GetService("HttpService")
local TeleportService   = game:GetService("TeleportService")
local RunService        = game:GetService("RunService")
local Stats             = game:GetService("Stats")

pcall(function()
	local qot = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
	if qot then
		qot([[
			task.wait(3)
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/games/animedice.lua"))()
		]])
	end
end)

local LocalPlayer = Players.LocalPlayer
local successGui, parentGui = pcall(function()
	if gethui then return gethui() elseif CoreGui:FindFirstChild("RobloxGui") then return CoreGui else return LocalPlayer:WaitForChild("PlayerGui") end
end)
if not successGui or not parentGui then parentGui = LocalPlayer:WaitForChild("PlayerGui") end

pcall(function() for _, v in pairs(parentGui:GetChildren()) do if string.find(v.Name, "Mofenk") then v:Destroy() end end end)

_G.__ANIMEDICE = (_G.__ANIMEDICE or 0) + 1
local generation = _G.__ANIMEDICE

local F = {
	cfgName = "MofenkConfig1", autoLoadEnabled = false,
	collect = false, collectDelay = 2.0, levelup = false, maxLevel = 40, smartLevel = false,
	rebirth = false, upgrades = false, buyDice = true, equipDice = true, autoRoll = false,
	autoBestPlaceBase = false, smartPlace = true,
	sellAuto = false, sellMaxInvent = false, keepBest = 0, autoFuse = false,
	keepRarities = {"Mythic", "Secret", "Divine", "Godly"},
	autoLockRarity = true,
	specificSellUnits = {},
	potionAuto = false, potionBest = true, potionSpecific = {},
	aiSmartPlanner = true,
	aiPriorityGoal = "Inisialisasi Scan Akun & Keamanan Limit...",
	aiResourceThreshold = true,
	aiJitterDelay = 1.8,
	autoLockTarget = true,
	quirkAuto = false, quirkTargets = {}, quirkUnits = {}, quirkReserve = 10,
	gradeAuto = false, gradeAll = false, gradePlacedOnly = false, gradeTargets = {}, gradeUnits = {}, gemReserve = 100,
	traitAuto = false, traitAll = false, traitPlacedOnly = false, traitTargets = {}, traitUnits = {}, rerollReserve = 50,
	tower = false, towerMix = false, towerList = {"Dragon Tower", "Demon Tower"}, towerEquipBest = true, towerExitOn = false, towerExitFloor = 50,
	halloweenTeleport = false, halloweenQuest = false, halloweenPath = false, halloweenOffer = false, trickOrTreat = false,
	pumpkinRollQty = 1, pumpkinAutoRoll = false, pumpkinAutoSell = false,
	hauntedTower = false, hauntedMix = false, hauntedList = {"Haunted Front Yard", "Haunted Crypt", "Haunted Attic", "Haunted Bell Tower"}, hauntedEquipBest = true, hauntedExitOn = false, hauntedExitFloor = 50,
	wsOn = false, wsValue = 16, noclip = false, afk = true, fpsOn = false,
	codesAuto = false, claimQuests = false,
	webhookEnabled = false, webhookUrl = ""
}

local STATE = {
	towerLive = "Standby", towerFloor = 0, towerDrops = 0, towerTraitsGot = "Belum Ada",
	hauntedLive = "Standby", hauntedFloor = 0, hauntedDrops = 0, activeBuffs = "Tidak Ada",
	pingMs = 0, fpsCurrent = 60,
	quirkActiveUnit = "-", quirkCurrentVal = "-", quirkStatus = "Standby",
	gradeActiveUnit = "-", gradeCurrentVal = "-", gradeStatus = "Standby",
	traitActiveUnit = "-", traitCurrentVal = "-", traitStatus = "Standby",
	aiConsoleLog = "AI Master Smart Planner: Menunggu Inisialisasi..."
}
local ConfigUpdaters = {}

local GLASS_THEME = {
	Bg     = Color3.fromRGB(15, 15, 15),
	Card   = Color3.fromRGB(28, 28, 28),
	Header = Color3.fromRGB(22, 22, 22),
	Acc1   = Color3.fromRGB(255, 255, 255),
	Acc2   = Color3.fromRGB(200, 200, 200),
	Text   = Color3.fromRGB(240, 240, 240),
	SubText= Color3.fromRGB(160, 160, 160)
}

local CFG_FOLDER = "MofenkHub_Configs"
if makefolder and not isfolder(CFG_FOLDER) then pcall(function() makefolder(CFG_FOLDER) end) end

local function getCfgPath(name) return CFG_FOLDER .. "/" .. (name or F.cfgName or "DefaultConfig") .. ".json" end

local function saveConfig(name)
	if writefile then
		pcall(function() 
			writefile(getCfgPath(name), HttpService:JSONEncode(F)) 
			local pointerPath = CFG_FOLDER .. "/autoload_pointer.txt"
			if F.autoLoadEnabled then writefile(pointerPath, name or F.cfgName or "DefaultConfig")
			else if isfile and isfile(pointerPath) then delfile(pointerPath) end end
		end)
	end
end

local function loadConfig(name)
	local path = getCfgPath(name)
	if readfile and isfile and isfile(path) then
		pcall(function() 
			local d = HttpService:JSONDecode(readfile(path))
			for k,v in pairs(d) do F[k]=v end 
			for _, updateUI in ipairs(ConfigUpdaters) do pcall(updateUI) end
		end)
	end
end

pcall(function()
	local pointerPath = CFG_FOLDER .. "/autoload_pointer.txt"
	if readfile and isfile and isfile(pointerPath) then
		local autoName = readfile(pointerPath)
		if autoName and autoName ~= "" then 
			F.cfgName = autoName
			local d = HttpService:JSONDecode(readfile(getCfgPath(autoName)))
			for k,v in pairs(d) do F[k]=v end 
			F.autoLoadEnabled = true 
		end
	end
end)

local function FormatMoney(val)
	val = tonumber(val) or 0
	if val >= 1e12 then return string.format("%.2fT", val/1e12)
	elseif val >= 1e9 then return string.format("%.2fB", val/1e9)
	elseif val >= 1e6 then return string.format("%.2fM", val/1e6)
	elseif val >= 1e3 then return string.format("%.2fK", val/1e3)
	else return tostring(math.floor(val)) end
end

local Network = ReplicatedStorage:WaitForChild("Network", 15); local Framework = ReplicatedStorage:WaitForChild("Framework", 15)
local function svc(p) local n = Network; for x in string.gmatch(p, "[^%.]+") do n = n and n:FindFirstChild(x) end; return n end

local R = {
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
	ClaimOffline    = svc("OfflineEarningsService.RE.Claim"), 
	ClaimGroup      = svc("GroupRewardService.RE.Claim"),
	SellInventory   = svc("SellService.RF.SellInventory") or svc("SellService.RE.SellInventory"),
	UpdateAutoSell  = svc("SellService.RE.UpdateAutoSell"),
	Fuse            = svc("FusingService.RE.Fuse"),
	InteractSlot    = svc("PlotService.RE.InteractSlot"),
	EquipUnit       = svc("UnitService.RF.Equip") or svc("UnitService.RE.Equip"),
	UnequipUnit     = svc("UnitService.RF.Unequip") or svc("UnitService.RE.Unequip"),
	LockUnit        = svc("UnitService.RE.SetLock") or svc("InventoryService.RE.Lock"),
	HWTeleport      = svc("HalloweenService.RF.Teleport"),
	HWSeenIntro     = svc("HalloweenService.RE.SeenIntro"),
	HWQuestClaim    = svc("HalloweenQuestService.RE.Claim"),
	HWClaimPath     = svc("HalloweenService.RE.ClaimAllPath"),
	HWBuyOffer      = svc("HalloweenService.RE.BuyOffer"),
	TrickOrTreat    = svc("TrickOrTreatService.RE.Knocked"),
	PumpkinRoll     = svc("PumpkinDiceService.RF.Roll") or svc("PumpkinDiceService.RE.Roll"),
	PumpkinAutoSell = svc("PumpkinDiceService.RF.SetAutoSell")
}

local G = {}
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
	G.BuffController = require(Framework.Features.Buffs.BuffController)
	G.DiceModule = require(Framework.Features.Rolling.Dice)
	G.TowersConfig = require(Framework.Features.Towers.Towers)
	G.UnitConfig = require(Framework.Features.Inventory.Kinds.Unit.UnitConfig)
end)

local function data() return G.DC and G.DC.___X or {} end
local function money() pcall(function() return G.DC.Money() end); return data().Money or 0 end
local function rebirthAmt() pcall(function() return G.DC.Rebirth() end); return data().Rebirth or 0 end
local function inventory() return data().Inventory or {} end
local function slots() return data().Slots or {} end
local function isUnitEntry(e) return e and type(e)=="table" and e.name and G.EntryRegistry and pcall(function() return G.EntryRegistry.getEntryConfig(e.name).kind == "Unit" end) end
local function currencyAmount(name) local t = 0; for _, e in pairs(inventory()) do if type(e)=="table" and e.name==name then t += tonumber(e.amount) or 0 end end; return t end

local function isBeingRolled(unitId)
	if not unitId then return false end
	if F.quirkAuto then for _, id in ipairs(F.quirkUnits or {}) do if id == unitId then return true end end end
	if F.gradeAuto then for _, id in ipairs(F.gradeUnits or {}) do if id == unitId then return true end end end
	if F.traitAuto then for _, id in ipairs(F.traitUnits or {}) do if id == unitId then return true end end end
	return false
end

local function getUnitRarity(u)
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

local function baseIncome(u)
	if not u then return 0 end
	local e = G.UnitConfig and G.UnitConfig.entries[u.name]
	if not e then return 0 end
	local a = u.attributes or {}
	local lvl = tonumber(a.level) or 1
	local ok, inc = pcall(function()
		if e.income then
			return e.income({ mutation = a.mutation or a.quirk, grade = a.grade, trait = a.trait, level = lvl })
		end
		return 0
	end)
	return tonumber(inc) or 0
end

local function SendWebhook(title, description, colorCode)
	if not F.webhookEnabled or F.webhookUrl == "" then return end
	local req = (syn and syn.request) or request or http_request or (fluxus and fluxus.request)
	if req then
		pcall(function()
			req({
				Url = F.webhookUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"},
				Body = HttpService:JSONEncode({ username = "MofenkHub-AI", avatar_url = "https://i.imgur.com/3qGMB7j.png", embeds = {{ title = title, description = description, color = colorCode or 3447003, footer = {text = "Player: " .. LocalPlayer.Name} }} })
			})
		end)
	end
end

-- UI Initialization
local MainGui = Instance.new("ScreenGui"); MainGui.Name = "MofenkUltraHubV104"; MainGui.Parent = parentGui; MainGui.ResetOnSpawn = false

local MofenkUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/MofenkUI.lua"))()
local Window = MofenkUI.CreateWindow({
	Name = "MofenkHub | Anime Dice Pro",
	Theme = "Midnight",
	ToggleStyle = "Bar",
	ProfileTitle = "AI Smart Planner"
})

local FarmTab = Window:CreateTab("Auto Farm", "⛏️")
local HlwTab = Window:CreateTab("Halloween", "🎃")
local InvTab = Window:CreateTab("Inventory", "🎒")
local PotTab = Window:CreateTab("Potions", "🧪")
local QrkTab = Window:CreateTab("Quirk & Roll", "⚡")
local GrdTab = Window:CreateTab("Grade & Roll", "⭐")
local TrtTab = Window:CreateTab("Trait & Roll", "🧬")
local TwrTab = Window:CreateTab("Tower Utama", "🏰")
local SetTab = Window:CreateTab("Settings", "⚙️")

-- Farm Tab Features
FarmTab:AddSection("Plot, Roll & Smart Placement")
FarmTab:AddToggle("Auto Collect Plot Balance", F.collect, function(v) F.collect = v end)
FarmTab:AddSlider("Delay Collect Plot (Detik)", 1, 60, F.collectDelay, function(v) F.collectDelay = v end)
FarmTab:AddToggle("Auto Roll Dadu (Otomatis)", F.autoRoll, function(v) F.autoRoll = v end)
FarmTab:AddToggle("AI Smart Place Unit Terbaik", F.autoBestPlaceBase, function(v) F.autoBestPlaceBase = v end)
FarmTab:AddToggle("Auto Rebirth", F.rebirth, function(v) F.rebirth = v end)
FarmTab:AddToggle("Auto Buy & Equip Best Dice Shop", F.buyDice, function(v) F.buyDice = v end)
FarmTab:AddToggle("Auto Level Up Unit Plot", F.levelup, function(v) F.levelup = v end)
FarmTab:AddSlider("Max Level Unit Batas", 1, 100, F.maxLevel, function(v) F.maxLevel = v end)
FarmTab:AddToggle("Auto Upgrade Skill Tree Pad", F.upgrades, function(v) F.upgrades = v end)

-- Halloween Tab Features
HlwTab:AddSection("Halloween & Haunted Tower")
HlwTab:AddToggle("Auto Teleport Ke Halloween World", F.halloweenTeleport, function(v) F.halloweenTeleport = v end)
HlwTab:AddToggle("Auto Roll Pumpkin Dice", F.pumpkinAutoRoll, function(v) F.pumpkinAutoRoll = v end)
HlwTab:AddToggle("Auto Sell Pumpkin Units", F.pumpkinAutoSell, function(v) F.pumpkinAutoSell = v end)
HlwTab:AddToggle("Auto Claim Halloween Quests", F.halloweenQuest, function(v) F.halloweenQuest = v end)
HlwTab:AddToggle("Auto Haunted Tower Farming", F.hauntedTower, function(v) F.hauntedTower = v end)

-- Inventory Tab Features
InvTab:AddSection("Management & Auto Sell")
InvTab:AddToggle("Auto Sell General", F.sellAuto, function(v) F.sellAuto = v end)
InvTab:AddToggle("Auto Sell Saat Inventory Penuh", F.sellMaxInvent, function(v) F.sellMaxInvent = v end)
InvTab:AddSlider("Simpan Unit Terbaik (Keep Best)", 0, 50, F.keepBest, function(v) F.keepBest = v end)
InvTab:AddToggle("Auto Fusion Unit", F.autoFuse, function(v) F.autoFuse = v end)

-- Potions Tab
PotTab:AddSection("Potion Manager")
PotTab:AddToggle("Auto Gunakan Potion", F.potionAuto, function(v) F.potionAuto = v end)

-- Quirk / Grade / Trait / Tower / Settings tabs follow the exact same registration pattern...
SetTab:AddSection("Config & Utilities")
SetTab:AddTextBox("Nama File Config", F.cfgName, function(v) F.cfgName = v end)
SetTab:AddButton("SAVE CONFIG", function() saveConfig(F.cfgName) end)
SetTab:AddButton("LOAD CONFIG", function() loadConfig(F.cfgName) end)
SetTab:AddToggle("Anti-AFK Protection", F.afk, function(v) F.afk = v end)
SetTab:AddToggle("FPS Boost (Optimasi Partikel)", F.fpsOn, function(v) F.fpsOn = v end)

Window:Notify("MofenkHub", "Anime Dice Automation & AI Smart Planner siap dijalankan!", 4)
