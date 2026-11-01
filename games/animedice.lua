-- ===================================================================== --
-- 👑 MOFENKHUB V104.2 — FULL AI SMART PLANNER & RESOURCE THRESHOLD EDITION
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

-- 1. Load MofenkUI Library dari GitHub
local MofenkUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/MofenkUI.lua"))()

if not MofenkUI then
	warn("[MofenkHub] MofenkUI tidak berhasil dimuat!")
	return
end

-- ===================================================================== --
-- 1. CONFIGURATION & STATE MANAGER
-- ===================================================================== --
_G.__ANIMEDICE = (_G.__ANIMEDICE or 0) + 1
local generation = _G.__ANIMEDICE

local F = {
	cfgName = "MofenkConfig1", autoLoadEnabled = false,
	-- Farm & Plot
	collect = false, collectDelay = 2.0, levelup = false, maxLevel = 40, smartLevel = false,
	rebirth = false, upgrades = false, buyDice = true, equipDice = true, autoRoll = false,
	autoBestPlaceBase = false, smartPlace = true,
	-- Inventory & Dynamic Rarity Multi-Select Auto Sell / Lock
	sellAuto = false, sellMaxInvent = false, keepBest = 0, autoFuse = false,
	keepRarities = {"Mythic", "Secret", "Divine", "Godly"},
	autoLockRarity = true,
	specificSellUnits = {},
	-- Potions
	potionAuto = false, potionBest = true, potionSpecific = {},
	-- AI Master Smart Planner & Thresholds
	aiSmartPlanner = true,
	aiPriorityGoal = "Inisialisasi Scan Akun & Keamanan Limit...",
	aiResourceThreshold = true,
	aiJitterDelay = 1.8,
	-- Quirk, Grade & Trait Management
	autoLockTarget = true,
	quirkAuto = false, quirkTargets = {}, quirkUnits = {}, quirkReserve = 10,
	gradeAuto = false, gradeAll = false, gradePlacedOnly = false, gradeTargets = {}, gradeUnits = {}, gemReserve = 100,
	traitAuto = false, traitAll = false, traitPlacedOnly = false, traitTargets = {}, traitUnits = {}, rerollReserve = 50,
	-- Main Tower Setup
	tower = false, towerMix = false, towerList = {"Dragon Tower", "Demon Tower"}, towerEquipBest = true, towerExitOn = false, towerExitFloor = 50,
	-- Halloween & Haunted Tower
	halloweenTeleport = false, halloweenQuest = false, halloweenPath = false, halloweenOffer = false, trickOrTreat = false,
	pumpkinRollQty = 1, pumpkinAutoRoll = false, pumpkinAutoSell = false,
	hauntedTower = false, hauntedMix = false, hauntedList = {"Haunted Front Yard", "Haunted Crypt", "Haunted Attic", "Haunted Bell Tower"}, hauntedEquipBest = true, hauntedExitOn = false, hauntedExitFloor = 50,
	-- Client & Misc
	wsOn = false, wsValue = 16, noclip = false, afk = true, fpsOn = false,
	codesAuto = false, claimQuests = false,
	-- Webhook
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

local CFG_FOLDER = "MofenkHub_Configs"
if makefolder and not isfolder(CFG_FOLDER) then pcall(function() makefolder(CFG_FOLDER) end) end

local function getCfgPath(name) return CFG_FOLDER .. "/" .. (name or F.cfgName or "DefaultConfig") .. ".json" end

local function saveConfig(name)
	if writefile then
		pcall(function() 
			writefile(getCfgPath(name), HttpService:JSONEncode(F)) 
			local pointerPath = CFG_FOLDER .. "/autoload_pointer.txt"
			if F.autoLoadEnabled then
				writefile(pointerPath, name or F.cfgName or "DefaultConfig")
			else
				if isfile and isfile(pointerPath) then delfile(pointerPath) end
			end
			MofenkUI:Notify({ Title = "Config System", Content = "Berhasil menyimpan config: " .. tostring(name), Duration = 3 })
		end)
	end
end

local function loadConfig(name)
	local path = getCfgPath(name)
	if readfile and isfile and isfile(path) then
		pcall(function() 
			local d = HttpService:JSONDecode(readfile(path))
			for k,v in pairs(d) do F[k]=v end 
			MofenkUI:Notify({ Title = "Config System", Content = "Berhasil memuat config: " .. tostring(name), Duration = 3 })
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

-- ===================================================================== --
-- 2. FRAMEWORK & MODULE SERVICES BINDINGS
-- ===================================================================== --
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
	G.RollController = require(Framework.Features.Rolling.RollController)
	G.SellController = require(Framework.Features.Sell.SellController)
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

local function GetOpts(mode)
	local t = {}; 
	if mode == "rarity" then
		local foundRarities = {}
		pcall(function()
			if G.EntryRegistry and G.EntryRegistry.getEntries then
				for _, entry in pairs(G.EntryRegistry.getEntries()) do
					if entry and entry.rarity and not foundRarities[entry.rarity] then
						foundRarities[entry.rarity] = true
						table.insert(t, {label = tostring(entry.rarity), val = tostring(entry.rarity)})
					end
				end
			end
		end)
		local defaultRarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Divine", "Godly"}
		for _, rName in ipairs(defaultRarities) do
			if not foundRarities[rName] then
				table.insert(t, {label = rName, val = rName})
			end
		end
		table.sort(t, function(a,b) return a.label < b.label end)
	elseif mode == "grade" and G.GradesMod then for n, g in pairs(G.GradesMod) do if type(g)=="table" and g.order then table.insert(t, {label=n, val=n, order=g.order}) end end; table.sort(t, function(a,b) return a.order<b.order end)
	elseif mode == "trait" and G.TraitsMod then for n, g in pairs(G.TraitsMod) do if type(g)=="table" and g.order then table.insert(t, {label=n, val=n, order=g.order}) end end; table.sort(t, function(a,b) return a.order<b.order end)
	elseif mode == "quirk" and G.QuirksMod then for n, q in pairs(G.QuirksMod) do if type(q)=="table" then table.insert(t, {label=n, val=n}) end end; table.sort(t, function(a,b) return a.label<b.label end)
	elseif mode == "pot" and G.BoostConfig then for n, e in pairs(G.BoostConfig.entries or {}) do table.insert(t, {label=n.." [T"..tostring(e.tier)..']', val=n}) end; table.sort(t, function(a,b) return a.label<b.label end)
	elseif mode == "unit" then
		local placed = {}; pcall(function() for _, d in pairs(slots()) do if d.unitId then placed[d.unitId]=true end end end)
		for k, e in pairs(inventory()) do
			if isUnitEntry(e) then
				local lvl = (e.attributes and tonumber(e.attributes.level)) or 1
				local inc = FormatMoney(baseIncome(e))
				local labelStr = string.format("%s [Lv.%d | 💰$%s/s]%s", tostring(e.name), lvl, inc, placed[k] and " ★" or "")
				table.insert(t, {label=labelStr, val=k, inc=baseIncome(e)})
			end
		end
		table.sort(t, function(a,b) return a.inc > b.inc end)
	elseif mode == "unit_name" then
		local addedNames = {}
		for _, e in pairs(inventory()) do
			if isUnitEntry(e) and e.name and not addedNames[e.name] then
				addedNames[e.name] = true
				table.insert(t, {label = e.name, val = e.name})
			end
		end
		table.sort(t, function(a,b) return a.label < b.label end)
	elseif mode == "towers" then
		local addedTowers = {}
		pcall(function()
			local all = G.TowersConfig and G.TowersConfig.GetAll and G.TowersConfig.GetAll()
			if type(all) == "table" then
				for name in pairs(all) do
					addedTowers[name] = true
					table.insert(t, {label=name, val=name})
				end
			end
		end)
		local defaultTowers = {"Dragon Tower", "Demon Tower", "Ninja Tower", "Pirate Tower", "Hunter Tower", "Cursed Tower", "Halloween Tower", "Haunted Front Yard", "Haunted Crypt", "Haunted Attic", "Haunted Bell Tower"}
		for _, name in ipairs(defaultTowers) do
			if not addedTowers[name] then
				table.insert(t, {label=name, val=name})
			end
		end
		table.sort(t, function(a,b) return a.label < b.label end)
	end
	return t
end

-- ===================================================================== --
-- 3. BUILD WINDOW & TABS USING MOFENKUI
-- ===================================================================== --
local Window = MofenkUI:CreateWindow({
	Name = "MOFENK HUB | Anime Dice AI Smart Planner"
})

-- 1. Dashboard Tab
Window:CreateProfileTab()

local T_Dash = Window:CreateTab("Dashboard")
local G_TrackerMon = T_Dash:CreateGroup("DYNAMIC TASK & REAL-TIME MONEY TRACKER")
local TrackerLbl = Instance.new("TextLabel"); TrackerLbl.Parent = G_TrackerMon; TrackerLbl.Size = UDim2.new(1, 0, 0, 75); TrackerLbl.BackgroundTransparency = 1; TrackerLbl.TextColor3 = MofenkUI.Theme.Text; TrackerLbl.TextSize = 12; TrackerLbl.Font = Enum.Font.GothamMedium; TrackerLbl.TextXAlignment = Enum.TextXAlignment.Left; TrackerLbl.TextYAlignment = Enum.TextYAlignment.Top

local TaskTrackerState = {
	SessionStartTime = os.clock(),
	StartingMoney = 0,
	CurrentMoneyRate = 0,
	LastMoneyCheck = 0,
	LastMoneyValue = 0,
	TargetMoneyMilestone = 1e6
}

task.spawn(function()
	task.wait(1)
	pcall(function()
		TaskTrackerState.StartingMoney = money()
		TaskTrackerState.LastMoneyValue = TaskTrackerState.StartingMoney
		TaskTrackerState.LastMoneyCheck = os.clock()
	end)
end)

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		pcall(function()
			local currentMoney = money()
			local currentTime = os.clock()
			local timeElapsed = currentTime - TaskTrackerState.LastMoneyCheck
			
			if timeElapsed >= 1 then
				local moneyGained = currentMoney - TaskTrackerState.LastMoneyValue
				TaskTrackerState.CurrentMoneyRate = math.floor(moneyGained / timeElapsed)
				TaskTrackerState.LastMoneyValue = currentMoney
				TaskTrackerState.LastMoneyCheck = currentTime
			end
			
			if currentMoney >= TaskTrackerState.TargetMoneyMilestone then
				SendWebhook("🎯 Task Target Reached!", "Akun bot berhasil mencapai milestone money sebesar **" .. FormatMoney(TaskTrackerState.TargetMoneyMilestone) .. "**", 3066993)
				TaskTrackerState.TargetMoneyMilestone = TaskTrackerState.TargetMoneyMilestone * 2.5
			end
		end)
		task.wait(1)
	end
end)

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		pcall(function()
			local sessionDuration = math.floor(os.clock() - TaskTrackerState.SessionStartTime)
			local hours = math.floor(sessionDuration / 3600)
			local minutes = math.floor((sessionDuration % 3600) / 60)
			local seconds = sessionDuration % 60
			local timeString = string.format("%02d:%02d:%02d", hours, minutes, seconds)
			
			local currentMoney = money()
			local totalEarned = currentMoney - TaskTrackerState.StartingMoney
			if totalEarned < 0 then totalEarned = 0 end

			TrackerLbl.Text = string.format(
				"⏱️ Durasi Sesi: %s\n💰 Pendapatan Sesi Ini: +$%s (%s/detik)\n🎯 Target Money Berikutnya: %s\n📊 Status Target: Berjalan Aktif",
				timeString,
				FormatMoney(totalEarned),
				FormatMoney(TaskTrackerState.CurrentMoneyRate),
				FormatMoney(TaskTrackerState.TargetMoneyMilestone)
			)
		end)
		task.wait(0.8)
	end
end)

local G_Stats = T_Dash:CreateGroup("SYSTEM PERFORMANCE")
local SLbl = Instance.new("TextLabel"); SLbl.Parent = G_Stats; SLbl.Size = UDim2.new(1, 0, 0, 95); SLbl.BackgroundTransparency = 1; SLbl.TextColor3 = MofenkUI.Theme.Text; SLbl.TextSize = 12; SLbl.Font = Enum.Font.GothamMedium; SLbl.TextXAlignment = Enum.TextXAlignment.Left; SLbl.TextYAlignment = Enum.TextYAlignment.Top

task.spawn(function()
	while task.wait(0.8) do pcall(function()
		local qrk, trt, grd, tot = 0,0,0,0
		for _, e in pairs(inventory()) do
			if isUnitEntry(e) then
				tot += 1
				if e.attributes then
					if e.attributes.quirk or e.attributes.mutation then qrk+=1 end
					if e.attributes.trait then trt+=1 end
					if e.attributes.grade then grd+=1 end
				end
			end
		end
		
		local buffs = ""; if G.BuffController and G.BuffController.ActiveBuffs then for k,v in pairs(G.BuffController.ActiveBuffs) do buffs = buffs..k..", " end end; if buffs=="" then buffs="Tidak ada" end; STATE.activeBuffs = buffs
		SLbl.Text = string.format("💎 Gems: %s | 🧬 Trait Rerolls: %s\n⚔️ Total Units: %d/100\n⚡ Quirks: %d | 🧬 Traits: %d | ⭐ Grades: %d\n🧪 Active Buffs: %s", FormatMoney(currencyAmount("Gems")), FormatMoney(currencyAmount("Trait Reroll")), tot, qrk, trt, grd, STATE.activeBuffs)
	end) end
end)

-- 2. Farming Tab
local T_Farm = Window:CreateTab("Farming")
local G_Farm1 = T_Farm:CreateGroup("AI PLOT, ROLL & SMART PLACEMENT")
G_Farm1:AddToggle("Auto Collect Plot Balance", F, "collect")
G_Farm1:AddSlider("Delay Collect Plot (Detik)", 0.5, 10.0, F.collectDelay, function(val) F.collectDelay = val end)
G_Farm1:AddToggle("Auto Roll Dadu (Otomatis)", F, "autoRoll")
G_Farm1:AddToggle("AI Smart Place Unit Terbaik", F, "autoBestPlaceBase")
G_Farm1:AddToggle("Auto Rebirth", F, "rebirth")
G_Farm1:AddToggle("Auto Buy & Equip Best Dice Shop", F, "buyDice")

local G_Farm2 = T_Farm:CreateGroup("LEVELING & SKILL TREE UPGRADES")
G_Farm2:AddToggle("Auto Level Up Unit Plot", F, "levelup")
G_Farm2:AddInput("Max Level Unit Batas:", F, "maxLevel", true)
G_Farm2:AddToggle("Auto Upgrade Skill Tree Pad", F, "upgrades")

-- 3. Halloween Tab
local T_Hlw = Window:CreateTab("Halloween")
local G_HlwTeleport = T_Hlw:CreateGroup("HALLOWEEN WORLD & INTRO")
G_HlwTeleport:AddToggle("Auto Teleport Ke Halloween World", F, "halloweenTeleport")

local G_HlwRoll = T_Hlw:CreateGroup("PUMPKIN DICE & SPECIFIC AUTO SELL")
G_HlwRoll:AddDropdown("Kuantitas Pumpkin Roll:", {{label="Roll 1x", val=1}, {label="Roll 5x", val=5}}, F, "pumpkinRollQty", false)
G_HlwRoll:AddToggle("Auto Roll Pumpkin Dice", F, "pumpkinAutoRoll")
G_HlwRoll:AddToggle("Auto Sell Pumpkin Units (Server)", F, "pumpkinAutoSell")
G_HlwRoll:AddDropdown("Nama Unit Spesifik Auto Sell:", GetOpts("unit_name"), F, "specificSellUnits", true)

local G_HlwQuests = T_Hlw:CreateGroup("HALLOWEEN REWARDS & EVENT")
G_HlwQuests:AddToggle("Auto Claim Halloween Quests", F, "halloweenQuest")
G_HlwQuests:AddToggle("Auto Claim Halloween Path Rewards", F, "halloweenPath")
G_HlwQuests:AddToggle("Auto Buy Halloween Special Offers", F, "halloweenOffer")
G_HlwQuests:AddToggle("Auto Trick or Treat", F, "trickOrTreat")

local G_HauntedTwr = T_Hlw:CreateGroup("HAUNTED TOWER FARMING")
G_HauntedTwr:AddToggle("Auto Haunted Tower Farming", F, "hauntedTower")
G_HauntedTwr:AddToggle("Mode MIX / Random Haunted Tower", F, "hauntedMix")
G_HauntedTwr:AddDropdown("Pilih Haunted Tower:", {
	{label="Haunted Front Yard", val="Haunted Front Yard"},
	{label="Haunted Crypt", val="Haunted Crypt"},
	{label="Haunted Attic", val="Haunted Attic"},
	{label="Haunted Bell Tower", val="Haunted Bell Tower"}
}, F, "hauntedList", true)
G_HauntedTwr:AddToggle("Auto Equip Best Team Tower", F, "hauntedEquipBest")
G_HauntedTwr:AddToggle("Keluar di Lantai Tertentu", F, "hauntedExitOn")
G_HauntedTwr:AddInput("Batas Lantai Exit Haunted:", F, "hauntedExitFloor", true)

local G_HauntedMon = T_Hlw:CreateGroup("LIVE MONITORING HAUNTED TOWER")
local HauntedLbl = Instance.new("TextLabel"); HauntedLbl.Parent = G_HauntedMon; HauntedLbl.Size = UDim2.new(1,0,0,60); HauntedLbl.BackgroundTransparency = 1; HauntedLbl.TextColor3 = MofenkUI.Theme.Text; HauntedLbl.TextSize = 12; HauntedLbl.Font = Enum.Font.GothamMedium; HauntedLbl.TextXAlignment = Enum.TextXAlignment.Left; HauntedLbl.TextYAlignment = Enum.TextYAlignment.Top
task.spawn(function() while task.wait(0.5) do pcall(function() HauntedLbl.Text = string.format("🎃 Status: %s\n🏢 Lantai: %d | 🍬 Total Drops: %d", STATE.hauntedLive, STATE.hauntedFloor, STATE.hauntedDrops) end) end end)

-- 4. Inventory Tab
local T_Inv = Window:CreateTab("Inventory")
local G_Inv = T_Inv:CreateGroup("MANAGEMENT, RARITY KEEP & AUTO LOCK")
G_Inv:AddToggle("Auto Sell General", F, "sellAuto")
G_Inv:AddToggle("Auto Sell Saat Inventory Penuh", F, "sellMaxInvent")
G_Inv:AddInput("Simpan Unit Terbaik (Keep Best):", F, "keepBest", true)
G_Inv:AddDropdown("Pilih Rarity yang Disimpan:", GetOpts("rarity"), F, "keepRarities", true)
G_Inv:AddToggle("Auto Lock Unit Rarity Terpilih", F, "autoLockRarity")
G_Inv:AddToggle("Auto Fusion Unit", F, "autoFuse")

-- 5. Potions Tab
local T_Pot = Window:CreateTab("Potions")
local G_Pot = T_Pot:CreateGroup("AI THRESHOLD POTION MANAGER")
G_Pot:AddToggle("Auto Gunakan Potion", F, "potionAuto")
G_Pot:AddDropdown("Pilih Potion Spesifik:", GetOpts("pot"), F, "potionSpecific", true)

-- 6. Quirk Tab
local T_Qrk = Window:CreateTab("Quirk")
local G_QrkCtrl = T_Qrk:CreateGroup("AI THRESHOLD & QUIRK REROLL CONFIG")
G_QrkCtrl:AddToggle("Auto Lock Unit jika Quirk Target", F, "autoLockTarget")
G_QrkCtrl:AddToggle("Aktifkan Auto Quirk Reroll", F, "quirkAuto")
G_QrkCtrl:AddDropdown("Target Quirk:", GetOpts("quirk"), F, "quirkTargets", true)
G_QrkCtrl:AddDropdown("Pilih Unit Reroll Quirk:", GetOpts("unit"), F, "quirkUnits", true)
G_QrkCtrl:AddInput("Sisakan Quirk Reserve Minimum:", F, "quirkReserve", true)

local G_QrkMon = T_Qrk:CreateGroup("REALTIME MONITORING QUIRK")
local QrkLbl = Instance.new("TextLabel"); QrkLbl.Parent = G_QrkMon; QrkLbl.Size = UDim2.new(1,0,0,75); QrkLbl.BackgroundTransparency = 1; QrkLbl.TextColor3 = MofenkUI.Theme.Text; QrkLbl.TextSize = 12; QrkLbl.Font = Enum.Font.GothamMedium; QrkLbl.TextXAlignment = Enum.TextXAlignment.Left; QrkLbl.TextYAlignment = Enum.TextYAlignment.Top
task.spawn(function() while task.wait(0.3) do pcall(function() QrkLbl.Text = string.format("🎯 Unit Aktif: %s\n⚡ Quirk Saat Ini: %s\n📊 Log Roll: %s", STATE.quirkActiveUnit, STATE.quirkCurrentVal, STATE.quirkStatus) end) end end)

-- 7. Grade Tab
local T_Grd = Window:CreateTab("Grade")
local G_GrdCtrl = T_Grd:CreateGroup("AI THRESHOLD & GRADE REROLL CONFIG")
G_GrdCtrl:AddToggle("Aktifkan Auto Grade Reroll", F, "gradeAuto")
G_GrdCtrl:AddToggle("Hanya Unit di Base (Placed)", F, "gradePlacedOnly")
G_GrdCtrl:AddDropdown("Target Grade:", GetOpts("grade"), F, "gradeTargets", true)
G_GrdCtrl:AddDropdown("Pilih Unit Reroll Grade:", GetOpts("unit"), F, "gradeUnits", true)
G_GrdCtrl:AddInput("Sisakan Gems Minimum:", F, "gemReserve", true)

local G_GrdMon = T_Grd:CreateGroup("REALTIME MONITORING GRADE")
local GrdLbl = Instance.new("TextLabel"); GrdLbl.Parent = G_GrdMon; GrdLbl.Size = UDim2.new(1,0,0,75); GrdLbl.BackgroundTransparency = 1; GrdLbl.TextColor3 = MofenkUI.Theme.Text; GrdLbl.TextSize = 12; GrdLbl.Font = Enum.Font.GothamMedium; GrdLbl.TextXAlignment = Enum.TextXAlignment.Left; GrdLbl.TextYAlignment = Enum.TextYAlignment.Top
task.spawn(function() while task.wait(0.3) do pcall(function() GrdLbl.Text = string.format("🎯 Unit Aktif: %s\n🌟 Grade Saat Ini: %s\n📊 Log Roll: %s", STATE.gradeActiveUnit, STATE.gradeCurrentVal, STATE.gradeStatus) end) end end)

-- 8. Trait Tab
local T_Trt = Window:CreateTab("Trait")
local G_TrtCtrl = T_Trt:CreateGroup("AI THRESHOLD & TRAIT REROLL CONFIG")
G_TrtCtrl:AddToggle("Aktifkan Auto Trait Reroll", F, "traitAuto")
G_TrtCtrl:AddToggle("Hanya Unit di Base (Placed)", F, "traitPlacedOnly")
G_TrtCtrl:AddDropdown("Target Trait:", GetOpts("trait"), F, "traitTargets", true)
G_TrtCtrl:AddDropdown("Pilih Unit Reroll Trait:", GetOpts("unit"), F, "traitUnits", true)
G_TrtCtrl:AddInput("Sisakan Trait Reroll Minimum:", F, "rerollReserve", true)

local G_TrtMon = T_Trt:CreateGroup("REALTIME MONITORING TRAIT")
local TrtLbl = Instance.new("TextLabel"); TrtLbl.Parent = G_TrtMon; TrtLbl.Size = UDim2.new(1,0,0,75); TrtLbl.BackgroundTransparency = 1; TrtLbl.TextColor3 = MofenkUI.Theme.Text; TrtLbl.TextSize = 12; TrtLbl.Font = Enum.Font.GothamMedium; TrtLbl.TextXAlignment = Enum.TextXAlignment.Left; TrtLbl.TextYAlignment = Enum.TextYAlignment.Top
task.spawn(function() while task.wait(0.3) do pcall(function() TrtLbl.Text = string.format("🎯 Unit Aktif: %s\n🧬 Trait Saat Ini: %s\n📊 Log Roll: %s", STATE.traitActiveUnit, STATE.traitCurrentVal, STATE.traitStatus) end) end end)

-- 9. Tower Tab
local T_Twr = Window:CreateTab("Tower")
local G_Twr = T_Twr:CreateGroup("MAIN TOWER FARMING SETUP")
G_Twr:AddToggle("Auto Main Tower Farming", F, "tower")
G_Twr:AddToggle("Mode MIX / Random Tower", F, "towerMix")
G_Twr:AddDropdown("Pilih Main Tower:", GetOpts("towers"), F, "towerList", true)
G_Twr:AddToggle("Auto Equip Best Team Tower", F, "towerEquipBest")
G_Twr:AddToggle("Keluar di Lantai Tertentu", F, "towerExitOn")
G_Twr:AddInput("Batas Lantai Exit Tower:", F, "towerExitFloor", true)

local G_TwrMon = T_Twr:CreateGroup("LIVE TOWER MONITORING & DROPS")
local TwrLbl = Instance.new("TextLabel"); TwrLbl.Parent = G_TwrMon; TwrLbl.Size = UDim2.new(1,0,0,60); TwrLbl.BackgroundTransparency = 1; TwrLbl.TextColor3 = MofenkUI.Theme.Text; TwrLbl.TextSize = 12; TwrLbl.Font = Enum.Font.GothamMedium; TwrLbl.TextXAlignment = Enum.TextXAlignment.Left; TwrLbl.TextYAlignment = Enum.TextYAlignment.Top
task.spawn(function() while task.wait(0.5) do pcall(function() TwrLbl.Text = string.format("🎮 Status: %s\n🏢 Lantai: %d | 💎 Gems: %d\n🧬 Trait Drops: %s", STATE.towerLive, STATE.towerFloor, STATE.towerDrops, tostring(STATE.towerTraitsGot)) end) end end)

-- 10. Settings Tab
local T_Set = Window:CreateTab("Settings")
local G_SetConfig = T_Set:CreateGroup("FILE CONFIGURATION MANAGEMENT")
G_SetConfig:AddToggle("Auto Load Config Saat Nyala", F, "autoLoadEnabled")
G_SetConfig:AddInput("Nama File Config:", F, "cfgName", false)

G_SetConfig:AddButton("💾 SAVE CONFIG SEKARANG", function() saveConfig(F.cfgName) end)
G_SetConfig:AddButton("📂 LOAD CONFIG PILIHAN", function() loadConfig(F.cfgName) end)
G_SetConfig:AddButton("🗑️ DELETE CONFIG PILIHAN", function()
	pcall(function()
		local path = getCfgPath(F.cfgName)
		if delfile and isfile and isfile(path) then delfile(path) end
	end)
end)

local G_Web = T_Set:CreateGroup("DISCORD WEBHOOK NOTIFIER")
G_Web:AddToggle("Aktifkan Webhook Discord", F, "webhookEnabled")
G_Web:AddInput("Webhook URL:", F, "webhookUrl", false)
G_Web:AddButton("🔔 TEST KIRIM WEBHOOK", function() SendWebhook("✅ Webhook Connected!", "AI Smart Planner tersambung sukses.", 3447003) end)

local G_Set2 = T_Set:CreateGroup("OPTIMALISASI & SERVER UTILITY")
G_Set2:AddToggle("Anti-AFK Protection", F, "afk")
G_Set2:AddToggle("FPS Boost (Optimasi Partikel)", F, "fpsOn", function(v) if v then pcall(function() game:GetService("Lighting").GlobalShadows = false; for _,e in ipairs(workspace:GetDescendants()) do if e:IsA("BasePart") then e.Material = Enum.Material.SmoothPlastic end end end) end end)
G_Set2:AddToggle("Auto Claim Quests & Daily Rewards", F, "claimQuests")
G_Set2:AddToggle("Auto Redeem Codes", F, "codesAuto")

G_Set2:AddButton("🌐 SERVER HOP (PINDAH SERVER)", function()
	pcall(function()
		local cursor = ""; local servers = {}
		repeat
			local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
			local success, result = pcall(function() return HttpService:JSONEncode(game:HttpGet(url)) end)
			if success and result and result.data then
				for _, s in ipairs(result.data) do
					if type(s) == "table" and s.playing and s.maxPlayers and s.playing < s.maxPlayers and s.id ~= game.JobId then
						table.insert(servers, s.id)
					end
				end
				cursor = result.nextPageCursor or ""
			else break end
		until #servers > 10 or cursor == ""

		if #servers > 0 then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
		else
			TeleportService:Teleport(game.PlaceId, LocalPlayer)
		end
	end)
end)

-- ===================================================================== --
-- 4. BACKEND AUTOMATION LOOPS
-- ===================================================================== --
local vu = game:GetService("VirtualUser")
pcall(function()
	local PromptOverlay = CoreGui:FindFirstChild("PromptOverlay", true) or LocalPlayer.PlayerGui:FindFirstChild("PromptOverlay", true)
	if PromptOverlay then
		PromptOverlay.ChildAdded:Connect(function(child)
			if F.afk and (child.Name == "ErrorPrompt" or child.Name == "DisconnectPrompt") then
				local qot = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
				if qot then
					qot([[
						task.wait(3)
						loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/games/animedice.lua"))()
					]])
				end
				task.wait(2)
				pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
			end
		end)
	end
end)

LocalPlayer.Idled:Connect(function()
	if F.afk then
		pcall(function()
			vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			task.wait(1)
			vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
		end)
	end
end)

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		if F.autoLockRarity and R.LockUnit then
			pcall(function()
				for id, u in pairs(inventory()) do
					if isUnitEntry(u) and not isBeingRolled(id) then
						local rarity = getUnitRarity(u)
						local isSelectedRarity = false
						for _, rName in ipairs(F.keepRarities or {}) do
							if string.lower(tostring(rarity)) == string.lower(tostring(rName)) then
								isSelectedRarity = true
								break
							end
						end
						local isLocked = u.attributes and u.attributes.locked
						if isSelectedRarity and not isLocked then
							R.LockUnit:FireServer(id, true)
						elseif not isSelectedRarity and isLocked then
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
		if (F.sellAuto or F.sellMaxInvent) and R.SellInventory then
			pcall(function()
				local d = data()
				local cap = 100
				pcall(function()
					local buff = tonumber(select(2, pcall(G.BuffController.GetBuff, "Unit Storage")))
					if buff and buff > 0 then cap = buff end
				end)

				local totalOwned = 0
				local placed = {}
				for _, slot in pairs(d.Slots or {}) do if slot.unitId then placed[slot.unitId] = true end end
				for _, id in pairs(d.TowerTeam or {}) do placed[id] = true end

				local sellCandidates = {}
				for id, u in pairs(d.Inventory or {}) do
					if isUnitEntry(u) then
						totalOwned += 1
						local rarity = getUnitRarity(u)
						local isKeepRarity = false
						for _, rName in ipairs(F.keepRarities or {}) do
							if string.lower(tostring(rarity)) == string.lower(tostring(rName)) then
								isKeepRarity = true
								break
							end
						end

						if not isKeepRarity and not placed[id] and not isBeingRolled(id) then
							if u.attributes and u.attributes.locked and R.LockUnit then
								R.LockUnit:FireServer(id, false)
								task.wait(0.05)
							end
							table.insert(sellCandidates, { id = id, value = baseIncome(u) })
						end
					end
				end

				local isFull = totalOwned >= (cap - 3)
				if F.sellAuto or (F.sellMaxInvent and isFull) then
					table.sort(sellCandidates, function(a, b) return a.value < b.value end)
					local keepQty = tonumber(F.keepBest) or 0
					local sellCount = math.max(0, #sellCandidates - keepQty)
					
					local list = {}
					for i = 1, sellCount do
						table.insert(list, sellCandidates[i].id)
						if #list >= 150 then break end
					end
					
					if #list > 0 then
						pcall(function()
							if R.SellInventory:IsA("RemoteFunction") then
								R.SellInventory:InvokeServer(list)
							elseif R.SellInventory:IsA("RemoteEvent") then
								R.SellInventory:FireServer(list)
							end
						end)
					end
				end
			end)
		end
		task.wait(3.5)
	end
end)

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		if F.quirkAuto and R.QuirkRoll and #F.quirkUnits > 0 then
			pcall(function()
				local inv = inventory()
				for _, unitId in ipairs(F.quirkUnits) do
					local u = inv[unitId]
					if u and u.attributes then
						if R.LockUnit and not u.attributes.locked then R.LockUnit:FireServer(unitId, true) end
						STATE.quirkActiveUnit = tostring(u.name)
						local curQuirk = u.attributes.quirk or u.attributes.mutation or "None"
						STATE.quirkCurrentVal = tostring(curQuirk)
						
						local isMatch = false
						for _, target in ipairs(F.quirkTargets) do 
							if string.lower(tostring(curQuirk)) == string.lower(tostring(target)) then isMatch = true; break end 
						end

						if isMatch then
							STATE.quirkStatus = "✅ Berhasil: " .. tostring(curQuirk)
							SendWebhook("⚡ Quirk Matched!", "Berhasil mendapatkan Quirk **" .. tostring(curQuirk) .. "**", 65280)
						else
							STATE.quirkStatus = "AI Rolling..."
							R.QuirkRoll:FireServer(unitId)
							task.wait(F.aiJitterDelay + math.random(0,5)*0.1)
						end
					end
				end
			end)
		else STATE.quirkStatus = "Standby" end
		task.wait(1.0)
	end
end)

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		if F.gradeAuto and R.GradeRoll and #F.gradeUnits > 0 then
			pcall(function()
				local gemsAvailable = currencyAmount("Gems")
				local reserve = tonumber(F.gemReserve) or 100
				if gemsAvailable <= reserve then
					STATE.gradeStatus = "⚠️ Threshold Kritis: Gems di bawah cadangan"
				else
					local inv = inventory()
					for _, unitId in ipairs(F.gradeUnits) do
						local u = inv[unitId]
						if u and u.attributes then
							if R.LockUnit and not u.attributes.locked then R.LockUnit:FireServer(unitId, true) end
							STATE.gradeActiveUnit = tostring(u.name)
							local curGrade = u.attributes.grade or "None"
							STATE.gradeCurrentVal = tostring(curGrade)

							local isMatch = false
							for _, target in ipairs(F.gradeTargets) do 
								if string.lower(tostring(curGrade)) == string.lower(tostring(target)) then isMatch = true; break end 
							end

							if isMatch then
								STATE.gradeStatus = "✅ Berhasil: " .. tostring(curGrade)
								SendWebhook("⭐ Grade Matched!", "Berhasil mendapatkan Grade **" .. tostring(curGrade) .. "**", 65280)
							else
								STATE.gradeStatus = "AI Rolling Grade..."
								R.GradeRoll:FireServer(unitId)
								task.wait(F.aiJitterDelay + math.random(0,5)*0.1)
							end
						end
					end
				end
			end)
		else STATE.gradeStatus = "Standby" end
		task.wait(1.0)
	end
end)

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		if F.traitAuto and R.TraitRoll and #F.traitUnits > 0 then
			pcall(function()
				local scrollsAvailable = currencyAmount("Trait Reroll")
				local reserve = tonumber(F.rerollReserve) or 50
				if scrollsAvailable <= reserve then
					STATE.traitStatus = "⚠️ Threshold Kritis: Scroll di bawah cadangan"
				else
					local inv = inventory()
					for _, unitId in ipairs(F.traitUnits) do
						local u = inv[unitId]
						if u and u.attributes then
							if R.LockUnit and not u.attributes.locked then R.LockUnit:FireServer(unitId, true) end
							STATE.traitActiveUnit = tostring(u.name)
							local curTrait = u.attributes.trait or "None"
							STATE.traitCurrentVal = tostring(curTrait)

							local isMatch = false
							for _, target in ipairs(F.traitTargets) do 
								if string.lower(tostring(curTrait)) == string.lower(tostring(target)) then isMatch = true; break end 
							end

							if isMatch then
								STATE.traitStatus = "✅ Berhasil: " .. tostring(curTrait)
								SendWebhook("🧬 Trait Matched!", "Berhasil mendapatkan Trait **" .. tostring(curTrait) .. "**", 65280)
							else
								STATE.traitStatus = "AI Rolling Trait..."
								R.TraitRoll:FireServer(unitId)
								task.wait(F.aiJitterDelay + math.random(0,5)*0.1)
							end
						end
					end
				end
			end)
		else STATE.traitStatus = "Standby" end
		task.wait(1.0)
	end
end)

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		if F.halloweenTeleport and R.HWTeleport then
			pcall(function() R.HWTeleport:InvokeServer(); if R.HWSeenIntro then R.HWSeenIntro:FireServer() end end)
		end
		if F.halloweenQuest and R.HWQuestClaim then pcall(function() R.HWQuestClaim:FireServer() end) end
		if F.halloweenPath and R.HWClaimPath then pcall(function() R.HWClaimPath:FireServer() end) end
		if F.halloweenOffer and R.HWBuyOffer then pcall(function() R.HWBuyOffer:FireServer() end) end
		if F.trickOrTreat and R.TrickOrTreat then pcall(function() R.TrickOrTreat:FireServer() end) end
		task.wait(5)
	end
end)

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		if F.pumpkinAutoRoll and R.PumpkinRoll then
			pcall(function()
				local qty = tonumber(F.pumpkinRollQty) or 1
				for i = 1, qty do
					if not F.pumpkinAutoRoll then break end
					if R.PumpkinRoll:IsA("RemoteFunction") then R.PumpkinRoll:InvokeServer()
					elseif R.PumpkinRoll:IsA("RemoteEvent") then R.PumpkinRoll:FireServer() end
					task.wait(0.3)
				end
			end)
		end
		if R.PumpkinAutoSell then pcall(function() R.PumpkinAutoSell:FireServer(F.pumpkinAutoSell) end) end
		task.wait(3)
	end
end)

local function unlockedSlots() local arr={}; local rb = rebirthAmt(); pcall(function() for i=1, (G.PlotConfig.GetMaxSlots(rb) or 15) do if rb >= (G.PlotConfig.GetSlotRebirthRequirement(i) or 0) then table.insert(arr, i) end end end); return arr end

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		if F.autoRoll then
			pcall(function() if R.RollDice then R.RollDice:InvokeServer() end end)
			task.wait(F.aiJitterDelay + math.random(0, 4) * 0.1)
		else task.wait(1) end
	end
end)

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		if F.autoBestPlaceBase and R.EquipUnit and R.InteractSlot then
			pcall(function()
				local d = data()
				local n = #unlockedSlots()
				local ranked = {}
				for id, u in pairs(d.Inventory or {}) do
					if isUnitEntry(u) then
						local score = baseIncome(u)
						if u.attributes then
							if u.attributes.grade then score = score * 1.2 end
							if u.attributes.trait then score = score * 1.5 end
						end
						ranked[#ranked + 1] = { id = id, v = score }
					end
				end
				table.sort(ranked, function(a, b) return a.v > b.v end)

				local want, placed = {}, {}
				for i = 1, math.min(n, #ranked) do want[ranked[i].id] = ranked[i].v end
				for _, slot in pairs(d.Slots or {}) do if slot.unitId then placed[slot.unitId] = true end end

				local bench = {}
				for i = 1, math.min(n, #ranked) do if not placed[ranked[i].id] then bench[#bench + 1] = ranked[i] end end

				if #bench > 0 then
					local slotsArr = {}
					for i = 1, n do
						local s = d.Slots and d.Slots[tostring(i)]
						local u = s and s.unitId and d.Inventory[s.unitId]
						slotsArr[#slotsArr + 1] = { i = i, v = u and baseIncome(u) or 0, id = s and s.unitId }
					end
					table.sort(slotsArr, function(a, b) return a.v < b.v end)

					for k, cand in ipairs(bench) do
						local slot = slotsArr[k]
						if slot and (slot.id == nil or not want[slot.id]) and cand.v > slot.v * 1.1 then
							local ok, equipped = pcall(function() return R.EquipUnit:InvokeServer(cand.id) end)
							if ok and equipped == true then task.wait(0.4); R.InteractSlot:FireServer(slot.i); task.wait(0.4) end
						end
					end
				end
			end)
		end
		task.wait(8)
	end
end)

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		if F.buyDice and G.DiceModule and R.BuyDice and R.EquipDice then
			pcall(function()
				local d = data()
				local allDice = {}
				local ok, all = pcall(G.DiceModule.GetAll)
				if ok and type(all) == "table" then
					for key, def in pairs(all) do table.insert(allDice, { key = key, luck = tonumber(def.luck) or 0, price = tonumber(def.price) }) end
					table.sort(allDice, function(a, b) return a.luck < b.luck end)
				end

				local owned = d.OwnedDice or {}
				local bestOwnedName, bestOwnedLuck = "-", 0
				for _, die in ipairs(allDice) do
					if owned[die.key] and die.luck > bestOwnedLuck then bestOwnedLuck = die.luck; bestOwnedName = die.key end
				end

				local spendable = money()
				for _, die in ipairs(allDice) do
					if die.price and not owned[die.key] and spendable >= die.price and die.luck > bestOwnedLuck then
						R.BuyDice:FireServer(die.key); task.wait(0.3); owned[die.key] = true
					end
				end

				if bestOwnedName ~= "-" and d.Dice ~= bestOwnedName then R.EquipDice:FireServer(bestOwnedName) end
			end)
		end
		task.wait(5)
	end
end)

task.spawn(function()
	local lastRebirth = 0
	while _G.__ANIMEDICE == generation do
		if F.collect and R.CollectBalance then 
			pcall(function() 
				for _, slot in ipairs(unlockedSlots()) do 
					R.CollectBalance:FireServer(slot) 
				end 
			end) 
		end
		
		if F.levelup and R.LevelUpSlot then
			pcall(function()
				local s = slots(); local m = money()
				for _, slot in ipairs(unlockedSlots()) do
					local d = s[tostring(slot)]
					if d and d.unitId then
						local e = inventory()[d.unitId]
						if e and e.attributes and (tonumber(e.attributes.level) or 1) < F.maxLevel then
							local price = 0; pcall(function() price = G.UnitUtil.GetLevelPrice(e.name, e.attributes) end)
							if m >= price then R.LevelUpSlot:FireServer(tonumber(slot)); m = m - price; task.wait(0.1) end
						end
					end
				end
			end)
		end
		
		if F.rebirth and R.Rebirth and (os.clock() - lastRebirth > 5) then
			pcall(function() local nr = G.Rebirths.GetNext(rebirthAmt()); if nr and money() >= (nr.cost or 9e9) then R.Rebirth:FireServer(); lastRebirth = os.clock() end end)
		end
		
		if F.upgrades and R.BuyUpgrade and G.Upgrades then
			pcall(function()
				local owned = G.DC.Upgrades() or {}; local list = {}
				for n, u in pairs(G.Upgrades) do if type(u)=="table" and u.price and not owned[n] then table.insert(list, {name=n, price=u.price}) end end
				table.sort(list, function(a,b) return a.price < b.price end)
				for _, u in ipairs(list) do if money() >= u.price then R.BuyUpgrade:FireServer(u.name); break end end
			end)
		end
		
		task.wait(math.clamp(tonumber(F.collectDelay) or 2.0, 0.5, 60))
	end
end)

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		if F.potionAuto and R.BoostUse then
			pcall(function()
				local active = G.BuffController and G.BuffController.ActiveBuffs or {}
				for key, e in pairs(inventory()) do
					if e.name and e.amount and e.amount > 0 and G.BoostConfig and G.BoostConfig.entries[e.name] then
						local shouldUse = (#F.potionSpecific == 0)
						for _, sn in ipairs(F.potionSpecific) do if e.name == sn then shouldUse = true; break end end
						if shouldUse and not active[e.name] and (e.amount > 2) then
							R.BoostUse:FireServer(key); task.wait(1)
						end
					end
				end
			end)
		end
		task.wait(5)
	end
end)

local function drainTower()
	if not R.CancelTower then return end
	pcall(function()
		if R.CancelTower:IsA("RemoteFunction") then R.CancelTower:InvokeServer()
		elseif R.CancelTower:IsA("RemoteEvent") then R.CancelTower:FireServer() end
	end)
	for _ = 1, 20 do
		local ok, seq = pcall(function() if R.CompleteFloor:IsA("RemoteFunction") then return R.CompleteFloor:InvokeServer() end end)
		if ok and type(seq) == "table" then for _, ev in ipairs(seq) do if ev.action == "ended" then return end end end
		task.wait(0.2)
	end
end

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		if F.tower and R.PlayTower and R.CompleteFloor then
			drainTower(); task.wait(0.4)
			if F.towerEquipBest and R.BestTowerTeam then pcall(function() R.BestTowerTeam:FireServer() end) end
			task.wait(0.4)

			local pickTower = "Dragon Tower"
			local choices = (F.towerList and #F.towerList > 0) and F.towerList or {"Dragon Tower", "Demon Tower"}
			pickTower = F.towerMix and choices[math.random(1, #choices)] or choices[1]

			STATE.towerLive = "Jalan: " .. tostring(pickTower); STATE.towerDrops = 0; STATE.towerTraitsGot = "Mencari..."
			pcall(function()
				if R.PlayTower:IsA("RemoteFunction") then R.PlayTower:InvokeServer(pickTower)
				else R.PlayTower:FireServer(pickTower) end
			end)

			local done, fails = false, 0
			while F.tower and not done do
				local okP, seq = pcall(function() if R.CompleteFloor:IsA("RemoteFunction") then return R.CompleteFloor:InvokeServer() end end)
				if okP and type(seq) == "table" and #seq > 0 then
					fails = 0
					for _, act in ipairs(seq) do
						if act.action == "floorStarted" then 
							STATE.towerFloor = tonumber(act.floor) or 1
						elseif act.action == "floorCompleted" then
							if act.rewards and act.rewards.Gems then STATE.towerDrops += act.rewards.Gems end
							if act.rewards and (act.rewards.Trait or act.trait) then STATE.towerTraitsGot = tostring(act.rewards.Trait or act.trait) end
						elseif act.action == "ended" then done = true; break end
					end
					if not done and F.towerExitOn and F.towerExitFloor > 0 and STATE.towerFloor >= F.towerExitFloor then
						done = true; drainTower()
					end
				else fails += 1; if fails > 8 then done = true end; task.wait(1) end
			end
			drainTower(); task.wait(1.5)
		else STATE.towerLive = "Standby"; STATE.towerTraitsGot = "Belum Ada"; task.wait(2) end
	end
end)

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		if F.hauntedTower and R.PlayTower and R.CompleteFloor then
			drainTower(); task.wait(0.4)
			if F.hauntedEquipBest and R.BestTowerTeam then pcall(function() R.BestTowerTeam:FireServer() end) end
			task.wait(0.4)
			
			local pickHaunted = "Haunted Front Yard"
			local choices = (F.hauntedList and #F.hauntedList > 0) and F.hauntedList or {"Haunted Front Yard"}
			pickHaunted = F.hauntedMix and choices[math.random(1, #choices)] or choices[1]

			STATE.hauntedLive = "Jalan: " .. tostring(pickHaunted); STATE.hauntedDrops = 0
			pcall(function()
				if R.PlayTower:IsA("RemoteFunction") then R.PlayTower:InvokeServer(pickHaunted)
				else R.PlayTower:FireServer(pickHaunted) end
			end)

			local done, fails = false, 0
			while F.hauntedTower and not done do
				local okP, seq = pcall(function() if R.CompleteFloor:IsA("RemoteFunction") then return R.CompleteFloor:InvokeServer() end end)
				if okP and type(seq) == "table" and #seq > 0 then
					fails = 0
					for _, act in ipairs(seq) do
						if act.action == "floorStarted" then STATE.hauntedFloor = tonumber(act.floor) or 1
						elseif act.action == "floorCompleted" then
							if act.rewards then for _, amt in pairs(act.rewards) do if type(amt) == "number" then STATE.hauntedDrops += amt end end end
						elseif act.action == "ended" then done = true; break end
					end
					if not done and F.hauntedExitOn and F.hauntedExitFloor > 0 and STATE.hauntedFloor >= F.hauntedExitFloor then
						done = true; drainTower()
					end
				else fails += 1; if fails > 8 then done = true end; task.wait(1) end
			end
			drainTower(); task.wait(1.5)
		else STATE.hauntedLive = "Standby"; task.wait(2) end
	end
end)

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		if F.claimQuests then
			pcall(function()
				if R.ClaimDaily then R.ClaimDaily:FireServer() end; if R.ClaimOffline then R.ClaimOffline:FireServer() end; if R.ClaimGroup then R.ClaimGroup:FireServer() end
				if R.QuestClaim and G.DC and G.DC.Quests and G.QuestConfig then
					local now = workspace:GetServerTimeNow()
					for _, p in ipairs({"Daily", "Weekly"}) do
						local q = G.DC.Quests[p]()
						if q and (tonumber(q.expiresAt) or 0) > math.floor(now) then
							for _, def in ipairs(G.QuestConfig.Periods[p].quests) do
								if not (q.claimed and q.claimed[def.id]) and (tonumber(q.progress[def.id]) or 0) >= (tonumber(def.target) or 9e9) then R.QuestClaim:FireServer(p, def.id, q.expiresAt); task.wait(0.5) end
							end
						end
					end
				end
			end)
		end
		if F.codesAuto and R.RedeemCode then
			pcall(function()
				local defaultCodes = { "RELEASE", "UPDATE1", "UPDATE2", "UPDATE3", "UPDATE4", "1KCCU", "5KCCU", "10KCCU", "20KCCU", "30KCCU", "40KCCU", "100KLIKES" }
				local redeemed = G.DC.RedeemedCodes() or {}
				for _, c in ipairs(defaultCodes) do if not redeemed[c] then R.RedeemCode:FireServer(c); task.wait(0.5) end end
			end)
		end
		task.wait(60)
	end
end)
