--!nocheck

task.wait(0.2)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function queueTeleport(code)
	local qot = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
	if qot then
		pcall(function()
			qot(code)
		end)
	end
end

local function safeLoadRemote(path)
	local url = "https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/" .. path
	local ok, result = pcall(function()
		return game:HttpGet(url)
	end)
	if not ok or type(result) ~= "string" or result == "" then
		warn("[MofenkHub] Failed to load remote: " .. path)
		return nil
	end
	local fn, err = loadstring(result)
	if not fn then
		warn("[MofenkHub] Load error for " .. path .. ": " .. tostring(err))
		return nil
	end
	return fn
end

queueTeleport([[
	task.wait(3)
	local ok, err = pcall(function()
		local script = game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/games/animedice.lua")
		loadstring(script)()
	end)
	if not ok then warn(err) end
]])

pcall(function()
	for _, child in ipairs(CoreGui:GetChildren()) do
		if tostring(child.Name):match("Mofenk") then
			child:Destroy()
		end
	end
	for _, child in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
		if tostring(child.Name):match("Mofenk") then
			child:Destroy()
		end
	end
end)

local uiScript = safeLoadRemote("MofenkUI.lua")
if not uiScript then
	return
end

local okUI, MofenkUI = pcall(function()
	return uiScript()
end)
if not okUI or not MofenkUI then
	warn("[MofenkHub] MofenkUI runtime error.")
	return
end

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
	potionSpecific = {},
	aiSmartPlanner = true,
	aiPriorityGoal = "Initialization...",
	aiResourceThreshold = true,
	aiJitterDelay = 1.8,
	quirkAuto = false,
	quirkTargets = {},
	quirkUnits = {},
	quirkReserve = 10,
	gradeAuto = false,
	gradePlacedOnly = false,
	gradeTargets = {},
	gradeUnits = {},
	gemReserve = 100,
	traitAuto = false,
	traitPlacedOnly = false,
	traitTargets = {},
	traitUnits = {},
	rerollReserve = 50,
	tower = false,
	towerMix = false,
	towerList = {"Dragon Tower", "Demon Tower"},
	towerEquipBest = true,
	towerExitOn = false,
	towerExitFloor = 50,
	halloweenTeleport = false,
	halloweenQuest = false,
	halloweenPath = false,
	halloweenOffer = false,
	trickOrTreat = false,
	pumpkinRollQty = 1,
	pumpkinAutoRoll = false,
	pumpkinAutoSell = false,
	hauntedTower = false,
	hauntedMix = false,
	hauntedList = {"Haunted Front Yard", "Haunted Crypt", "Haunted Attic", "Haunted Bell Tower"},
	hauntedEquipBest = true,
	hauntedExitOn = false,
	hauntedExitFloor = 50,
	wsOn = false,
	wsValue = 16,
	noclip = false,
	afk = true,
	fpsOn = false,
	claimQuests = false,
	codesAuto = false,
	webhookEnabled = false,
	webhookUrl = "",
}

local STATE = {
	pingMs = 0,
	fpsCurrent = 60,
	money = 0,
	rebirth = 0,
	rolls = 0,
	statusText = "Waiting for runtime data...",
	activeBuffs = "None",
}

local function formatMoney(value)
	value = tonumber(value) or 0
	if value >= 1e12 then
		return string.format("%.2fT", value / 1e12)
	elseif value >= 1e9 then
		return string.format("%.2fB", value / 1e9)
	elseif value >= 1e6 then
		return string.format("%.2fM", value / 1e6)
	elseif value >= 1e3 then
		return string.format("%.2fK", value / 1e3)
	else
		return tostring(math.floor(value))
	end
end

local Network = ReplicatedStorage:WaitForChild("Network", 15)
local Framework = ReplicatedStorage:WaitForChild("Framework", 15)

local function svc(path)
	local target = Network
	for part in string.gmatch(path, "[^%.]+") do
		if target then
			target = target:FindFirstChild(part)
		end
	end
	return target
end

local R = {
	RollDice = svc("RollService.RF.RollDice"),
	CollectBalance = svc("PlotService.RE.CollectBalance"),
	LevelUpSlot = svc("PlotService.RE.LevelUpSlot"),
	BuyDice = svc("DiceShopService.RE.BuyDice"),
	EquipDice = svc("DiceShopService.RE.EquipDice"),
	Rebirth = svc("RebirthService.RE.Rebirth"),
	BuyUpgrade = svc("RE.BuyUpgrade") or svc("PlotService.RE.BuyPadUpgrade"),
	QuirkRoll = svc("QuirkService.RE.Roll") or svc("Quirks.RE.Roll"),
	GradeRoll = svc("GradeService.RE.Roll") or svc("Grades.RE.Roll"),
	TraitRoll = svc("TraitService.RE.Roll") or svc("Traits.RE.Roll"),
	BoostUse = svc("BoostService.RE.Use"),
	PlayTower = svc("Towers.RF.PlayTower") or svc("TowerService.RF.PlayTower"),
	CompleteFloor = svc("Towers.RF.CompleteTowerFloor") or svc("TowerService.RF.CompleteTowerFloor"),
	CancelTower = svc("Towers.RF.CancelTower") or svc("TowerService.RF.CancelTower"),
	BestTowerTeam = svc("Towers.RE.EquipBestTowerTeam") or svc("TowerService.RE.EquipBestTowerTeam"),
	RedeemCode = svc("CodesService.RE.RedeemCode") or svc("MonetizationService.RE.RedeemCode"),
	QuestClaim = svc("QuestService.RE.Claim"),
	ClaimDaily = svc("DailyRewardService.RE.Claim"),
	ClaimOffline = svc("OfflineEarningsService.RE.Claim"),
	ClaimGroup = svc("GroupRewardService.RE.Claim"),
	SellInventory = svc("SellService.RF.SellInventory") or svc("SellService.RE.SellInventory"),
	UpdateAutoSell = svc("SellService.RE.UpdateAutoSell"),
	EquipUnit = svc("UnitService.RF.Equip") or svc("UnitService.RE.Equip"),
	UnequipUnit = svc("UnitService.RF.Unequip") or svc("UnitService.RE.Unequip"),
	LockUnit = svc("UnitService.RE.SetLock") or svc("InventoryService.RE.Lock"),
	HWTeleport = svc("HalloweenService.RF.Teleport"),
	HWSeenIntro = svc("HalloweenService.RE.SeenIntro"),
	HWQuestClaim = svc("HalloweenQuestService.RE.Claim"),
	HWClaimPath = svc("HalloweenService.RE.ClaimAllPath"),
	HWBuyOffer = svc("HalloweenService.RE.BuyOffer"),
	TrickOrTreat = svc("TrickOrTreatService.RE.Knocked"),
	PumpkinRoll = svc("PumpkinDiceService.RF.Roll") or svc("PumpkinDiceService.RE.Roll"),
	PumpkinAutoSell = svc("PumpkinDiceService.RF.SetAutoSell"),
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

local function getData()
	return (G.DC and G.DC.___X) or {}
end

local function getMoney()
	pcall(function()
		if G.DC and G.DC.Money then
			return G.DC.Money()
		end
	end)
	return (getData().Money or 0)
end

local function getRebirthAmount()
	pcall(function()
		if G.DC and G.DC.Rebirth then
			return G.DC.Rebirth()
		end
	end)
	return (getData().Rebirth or 0)
end

local function getInventory()
	return (getData().Inventory or {})
end

local function getSlots()
	return (getData().Slots or {})
end

local function isUnitEntry(entry)
	if not entry or type(entry) ~= "table" or not entry.name then return false end
	if G.EntryRegistry and G.EntryRegistry.getEntryConfig then
		local ok, result = pcall(function()
			return G.EntryRegistry.getEntryConfig(entry.name).kind == "Unit"
		end)
		if ok then return result end
	end
	return false
end

local function getCurrencyAmount(name)
	local total = 0
	for _, entry in pairs(getInventory()) do
		if type(entry) == "table" and entry.name == name then
			total = total + (tonumber(entry.amount) or 0)
		end
	end
	return total
end

local function getUnitRarity(unit)
	local rarity = "Common"
	if unit and unit.name then
		pcall(function()
			if G.EntryRegistry and G.EntryRegistry.getEntryConfig then
				local cfg = G.EntryRegistry.getEntryConfig(unit.name)
				if cfg and cfg.rarity then
					rarity = cfg.rarity
				end
			elseif G.UnitConfig and G.UnitConfig.entries then
				local cfg = G.UnitConfig.entries[unit.name]
				if cfg and cfg.rarity then
					rarity = cfg.rarity
				end
			end
		end)
	end
	return tostring(rarity)
end

local function getBaseIncome(unit)
	if not unit then return 0 end
	local cfg = G.UnitConfig and G.UnitConfig.entries and G.UnitConfig.entries[unit.name]
	if not cfg then return 0 end
	local attrs = unit.attributes or {}
	local lvl = tonumber(attrs.level) or 1
	local inc = 0
	pcall(function()
		if cfg.income then
			inc = cfg.income({ mutation = attrs.mutation or attrs.quirk, grade = attrs.grade, trait = attrs.trait, level = lvl }) or 0
		end
	end)
	return tonumber(inc) or 0
end

local window = MofenkUI.CreateWindow({
	Name = "MofenkHub | Anime Dice Pro",
	Theme = "Midnight",
	ToggleStyle = "Icon",
	ProfileTitle = "AI Smart Planner",
})

local Dash = window:CreateTab("Dashboard", "📊")
local Farm = window:CreateTab("Farming", "⛏️")
local Inv = window:CreateTab("Inventory", "🎒")
local Reroll = window:CreateTab("Reroll", "⚡")
local Tower = window:CreateTab("Tower", "🏰")
local Settings = window:CreateTab("Settings", "⚙️")

local function createMetricGroup(parent, title)
	local group = parent:AddGroup(title)
	return group
end

local dashGroup = createMetricGroup(Dash, "Profile & Live Stats")
local avatarCard = Dash:AddInfoCard("Player", LocalPlayer.Name)
local moneyCard = Dash:AddInfoCard("Money", formatMoney(getMoney()))
local rebirthCard = Dash:AddInfoCard("Rebirth", tostring(getRebirthAmount()))
local pingCard = Dash:AddInfoCard("Ping", "0 ms")

local statusGroup = createMetricGroup(Dash, "Automation Status")
local statusText = Dash:AddLabel("Status: Idle")
statusGroup.Parent = statusGroup

Dash:AddButton("Refresh Runtime Data", function()
	window:Notify("Success", "Runtime data refreshed", 2)
end)

Farm:AddSection("Core Automation")
Farm:AddToggle("Auto Collect Balance", F.collect, function(v) F.collect = v end)
Farm:AddSlider("Collect Delay (sec)", 1, 30, F.collectDelay, function(v) F.collectDelay = v end)
Farm:AddToggle("Auto Roll Dice", F.autoRoll, function(v) F.autoRoll = v end)
Farm:AddToggle("Auto Rebirth", F.rebirth, function(v) F.rebirth = v end)
Farm:AddToggle("Auto Upgrade Pad", F.upgrades, function(v) F.upgrades = v end)
Farm:AddToggle("Auto Buy & Equip Best Dice", F.buyDice, function(v) F.buyDice = v end)
Farm:AddToggle("Best Unit Auto Placement", F.autoBestPlaceBase, function(v) F.autoBestPlaceBase = v end)

Inv:AddSection("Inventory Control")
Inv:AddToggle("Auto Sell General", F.sellAuto, function(v) F.sellAuto = v end)
Inv:AddToggle("Auto Sell When Full", F.sellMaxInvent, function(v) F.sellMaxInvent = v end)
Inv:AddSlider("Keep Best Units", 0, 50, F.keepBest, function(v) F.keepBest = v end)
Inv:AddToggle("Auto Lock Target Rarities", F.autoLockRarity, function(v) F.autoLockRarity = v end)
Inv:AddMultiDropdown("Save Rarities", {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Divine", "Godly"}, function(v) F.keepRarities = v end, F.keepRarities)
Inv:AddToggle("Auto Potion Use", F.potionAuto, function(v) F.potionAuto = v end)

Reroll:AddSection("Roll Targets")
Reroll:AddToggle("Auto Quirk Reroll", F.quirkAuto, function(v) F.quirkAuto = v end)
Reroll:AddToggle("Auto Grade Reroll", F.gradeAuto, function(v) F.gradeAuto = v end)
Reroll:AddToggle("Auto Trait Reroll", F.traitAuto, function(v) F.traitAuto = v end)
Reroll:AddSlider("Quirk Reserve", 0, 100, F.quirkReserve, function(v) F.quirkReserve = v end)
Reroll:AddSlider("Gem Reserve", 0, 500, F.gemReserve, function(v) F.gemReserve = v end)
Reroll:AddSlider("Trait Reserve", 0, 200, F.rerollReserve, function(v) F.rerollReserve = v end)

Tower:AddSection("Main Tower")
Tower:AddToggle("Auto Main Tower", F.tower, function(v) F.tower = v end)
Tower:AddToggle("Random Tower Mix", F.towerMix, function(v) F.towerMix = v end)
Tower:AddMultiDropdown("Target Towers", {"Dragon Tower", "Demon Tower", "Ninja Tower", "Pirate Tower", "Hunter Tower", "Cursed Tower", "Halloween Tower"}, function(v) F.towerList = v end, F.towerList)
Tower:AddToggle("Auto Equip Best Team", F.towerEquipBest, function(v) F.towerEquipBest = v end)
Tower:AddToggle("Stop at Floor", F.towerExitOn, function(v) F.towerExitOn = v end)
Tower:AddSlider("Exit Floor", 1, 100, F.towerExitFloor, function(v) F.towerExitFloor = v end)

Settings:AddSection("System")
Settings:AddTextBox("Webhook URL", F.webhookUrl, function(v) F.webhookUrl = v end)
Settings:AddToggle("Discord Webhook", F.webhookEnabled, function(v) F.webhookEnabled = v end)
Settings:AddToggle("Anti-AFK", F.afk, function(v) F.afk = v end)
Settings:AddToggle("FPS Boost", F.fpsOn, function(v) F.fpsOn = v end)
Settings:AddToggle("Auto Claim Quests", F.claimQuests, function(v) F.claimQuests = v end)
Settings:AddToggle("Auto Redeem Codes", F.codesAuto, function(v) F.codesAuto = v end)
Settings:AddButton("Server Hop", function()
	pcall(function()
		local url = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
		local ok, result = pcall(function()
			return HttpService:JSONDecode(game:HttpGet(url))
		end)
		if ok and result and result.data and #result.data > 0 then
			local servers = {}
			for _, server in ipairs(result.data) do
				if server and server.id and server.playing and server.maxPlayers and server.playing < server.maxPlayers and server.id ~= game.JobId then
					table.insert(servers, server.id)
				end
			end
			if #servers > 0 then
				TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
				return
			end
		end
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end)
end)

window:Notify("MofenkHub", "All systems are loaded and ready.", 4)

local function updateRuntimeHud()
	local moneyValue = getMoney()
	local rebirthValue = getRebirthAmount()
	local pingValue = 0
	pcall(function()
		local stats = Stats.Network.ServerStatsItem
		if stats and stats["Data Ping"] then
			pingValue = math.floor(stats["Data Ping"]:GetValue() or 0)
		end
	end)
	moneyCard.Value.Text = formatMoney(moneyValue)
	rebirthCard.Value.Text = tostring(rebirthValue)
	pingCard.Value.Text = tostring(pingValue) .. " ms"
	STATE.pingMs = pingValue
	STATE.money = moneyValue
	STATE.rebirth = rebirthValue
	statusText.Text = "Status: " .. (F.aiSmartPlanner and "Planner Active" or "Manual")
end

task.spawn(function()
	while task.wait(1) do
		pcall(updateRuntimeHud)
	end
end)

local function doFarmingLoop()
	while task.wait(tonumber(F.collectDelay) or 2) do
		if F.collect and R.CollectBalance then
			pcall(function()
				for slot = 1, 15 do
					R.CollectBalance:FireServer(slot)
				end
			end)
		end
		if F.autoRoll and R.RollDice then
			pcall(function()
				R.RollDice:InvokeServer()
			end)
		end
		if F.rebirth and R.Rebirth then
			pcall(function()
				local moneyValue = getMoney()
				if G.Rebirths and G.Rebirths.GetNext then
					local nextRebirth = G.Rebirths.GetNext(getRebirthAmount())
					if nextRebirth and moneyValue >= (nextRebirth.cost or 0) then
						R.Rebirth:FireServer()
					end
				end
			end)
		end
		if F.upgrades and R.BuyUpgrade and G.Upgrades then
			pcall(function()
				local owned = G.DC and G.DC.Upgrades and G.DC.Upgrades() or {}
				local list = {}
				for name, upgrade in pairs(G.Upgrades) do
					if type(upgrade) == "table" and upgrade.price and not owned[name] then
						table.insert(list, {name = name, price = upgrade.price})
					end
				end
				table.sort(list, function(a, b) return a.price < b.price end)
				for _, item in ipairs(list) do
					if getMoney() >= item.price then
						R.BuyUpgrade:FireServer(item.name)
						break
					end
				end
			end)
		end
		if F.buyDice and R.BuyDice and R.EquipDice and G.DiceModule then
			pcall(function()
				local d = getData()
				local allDice = {}
				local ok, all = pcall(function()
					return G.DiceModule.GetAll()
				end)
				if ok and type(all) == "table" then
					for key, def in pairs(all) do
						table.insert(allDice, { key = key, luck = tonumber(def.luck) or 0, price = tonumber(def.price) or 0 })
					end
					table.sort(allDice, function(a, b) return a.luck < b.luck end)
				end
				local owned = d.OwnedDice or {}
				local bestOwnedName, bestOwnedLuck = "-", 0
				for _, die in ipairs(allDice) do
					if owned[die.key] and die.luck > bestOwnedLuck then
						bestOwnedLuck = die.luck
						bestOwnedName = die.key
					end
				end
				for _, die in ipairs(allDice) do
					if die.price and not owned[die.key] and getMoney() >= die.price and die.luck > bestOwnedLuck then
						R.BuyDice:FireServer(die.key)
						task.wait(0.3)
						owned[die.key] = true
					end
				end
				if bestOwnedName ~= "-" and d.Dice ~= bestOwnedName then
					R.EquipDice:FireServer(bestOwnedName)
				end
			end)
		end
	end
end

task.spawn(doFarmingLoop)

local vu = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
	if F.afk then
		pcall(function()
			vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
			task.wait(0.3)
			vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		end)
	end
end)

if F.fpsOn then
	pcall(function()
		local lighting = game:GetService("Lighting")
		lighting.GlobalShadows = false
		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.Material = Enum.Material.SmoothPlastic
			end
		end
	end)
end

window:Notify("Ready", "Anime Dice automation is online.", 3)

return window
