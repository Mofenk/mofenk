-- ===================================================================== --
-- 👑 MOFENKHUB V106.8 — FULL AI SMART PLANNER & ANIME DICE AUTOMATION
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
	collect = false, collectDelay = 2.0, levelup = false, maxLevel = 40,
	rebirth = false, upgrades = false, buyDice = true, equipDice = true, autoRoll = false,
	autoBestPlaceBase = false, sellAuto = false, sellMaxInvent = false, keepBest = 0, autoFuse = false,
	keepRarities = {"Mythic", "Secret", "Divine", "Godly"}, autoLockRarity = true,
	potionAuto = false, potionSpecific = {},
	aiSmartPlanner = true, aiJitterDelay = 1.8,
	quirkAuto = false, quirkTargets = {}, quirkUnits = {},
	gradeAuto = false, gradeTargets = {}, gradeUnits = {}, gemReserve = 100,
	traitAuto = false, traitTargets = {}, traitUnits = {}, rerollReserve = 50,
	tower = false, towerMix = false, towerList = {"Dragon Tower", "Demon Tower"}, towerEquipBest = true, towerExitOn = false, towerExitFloor = 50,
	wsOn = false, wsValue = 16, afk = true, fpsOn = false,
	codesAuto = false, claimQuests = false,
	webhookEnabled = false, webhookUrl = ""
}

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
	CollectBalance  = svc("PlotService.RE.CollectBalance"), 
	LevelUpSlot     = svc("PlotService.RE.LevelUpSlot"),
	BuyDice         = svc("DiceShopService.RF.BuyDice") or svc("DiceShopService.RE.BuyDice"), 
	EquipDice       = svc("DiceShopService.RE.EquipDice"),
	Rebirth         = svc("RebirthService.RE.Rebirth"), 
	BuyUpgrade      = svc("RE.BuyUpgrade") or svc("PlotService.RE.BuyPadUpgrade"),
	PlayTower       = svc("Towers.RF.PlayTower") or svc("TowerService.RF.PlayTower"), 
	CompleteFloor   = svc("Towers.RF.CompleteTowerFloor") or svc("TowerService.RF.CompleteTowerFloor"),
	CancelTower     = svc("Towers.RF.CancelTower") or svc("TowerService.RF.CancelTower"), 
	BestTowerTeam   = svc("Towers.RE.EquipBestTowerTeam") or svc("TowerService.RE.EquipBestTowerTeam"),
	RedeemCode      = svc("CodesService.RE.RedeemCode"),
	QuestClaim      = svc("QuestService.RE.Claim"), 
	ClaimDaily      = svc("DailyRewardService.RE.Claim"),
	ClaimOffline    = svc("OfflineEarningsService.RE.Claim"), 
	SellInventory   = svc("SellService.RF.SellInventory") or svc("SellService.RE.SellInventory"),
	EquipUnit       = svc("UnitService.RF.Equip") or svc("UnitService.RE.Equip"),
	LockUnit        = svc("UnitService.RE.SetLock") or svc("InventoryService.RE.Lock"),
}

local G = {}
pcall(function()
	G.DC = require(Framework.Features.Data.DataController)
	G.PlotConfig = require(Framework.Features.Plot.PlotConfig)
	G.Rebirths = require(Framework.Features.Rebirth.Rebirths)
	G.DiceModule = require(Framework.Features.Rolling.Dice)
	G.TowersConfig = require(Framework.Features.Towers.Towers)
end)

local function data() return G.DC and G.DC.___X or {} end
local function money() pcall(function() return G.DC.Money() end); return data().Money or 0 end
local function rebirthAmt() pcall(function() return G.DC.Rebirth() end); return data().Rebirth or 0 end

-- Load UI dari file MofenkUI.lua utama
local MofenkUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/MofenkUI.lua"))()
local Window = MofenkUI.CreateWindow({
	Name = "MofenkHub | Anime Dice Pro",
	Theme = "Midnight",
	ToggleStyle = "Bar",
	ProfileTitle = "AI Smart Planner"
})

-- PEMBUATAN TAB
local FarmTab  = Window:CreateTab("Auto Farm", "⛏️")
local RollTab  = Window:CreateTab("Rolling", "🎲")
local InvTab   = Window:CreateTab("Inventory", "🎒")
local TowerTab = Window:CreateTab("Tower", "🏰")
local SetTab   = Window:CreateTab("Settings", "⚙️")

-- ==================== 1. TAB AUTO FARM ====================
FarmTab:AddSection("Plot & Balance Management")
FarmTab:AddToggle("Auto Collect Balance", F.collect, function(v) F.collect = v end)
FarmTab:AddSlider("Collect Delay (Detik)", 1, 30, F.collectDelay, function(v) F.collectDelay = v end)
FarmTab:AddToggle("Auto Rebirth", F.rebirth, function(v) F.rebirth = v end)

FarmTab:AddSection("Upgrade & Leveling")
FarmTab:AddToggle("Auto Level Up Units", F.levelup, function(v) F.levelup = v end)
FarmTab:AddSlider("Max Level Batas", 1, 100, F.maxLevel, function(v) F.maxLevel = v end)
FarmTab:AddToggle("Auto Upgrade Skill Tree Pad", F.upgrades, function(v) F.upgrades = v end)

-- ==================== 2. TAB ROLLING ====================
RollTab:AddSection("Dice Automation")
RollTab:AddToggle("Auto Roll Dadu", F.autoRoll, function(v) F.autoRoll = v end)
RollTab:AddToggle("Auto Buy & Equip Best Dice", F.buyDice, function(v) F.buyDice = v end)
RollTab:AddToggle("AI Smart Place Unit Terbaik", F.autoBestPlaceBase, function(v) F.autoBestPlaceBase = v end)

-- ==================== 3. TAB INVENTORY ====================
InvTab:AddSection("Inventory Management")
InvTab:AddToggle("Auto Sell General", F.sellAuto, function(v) F.sellAuto = v end)
InvTab:AddToggle("Auto Sell Saat Inventory Penuh", F.sellMaxInvent, function(v) F.sellMaxInvent = v end)
InvTab:AddSlider("Simpan Unit Terbaik (Keep Best)", 0, 50, F.keepBest, function(v) F.keepBest = v end)
InvTab:AddToggle("Auto Lock Unit Rarity Terpilih", F.autoLockRarity, function(v) F.autoLockRarity = v end)

-- ==================== 4. TAB TOWER ====================
TowerTab:AddSection("Dungeon & Tower Farming")
TowerTab:AddToggle("Auto Main Tower Farming", F.tower, function(v) F.tower = v end)
TowerTab:AddToggle("Mode MIX / Random Tower", F.towerMix, function(v) F.towerMix = v end)
TowerTab:AddToggle("Auto Equip Best Team Tower", F.towerEquipBest, function(v) F.towerEquipBest = v end)
TowerTab:AddSlider("Batas Lantai Exit Tower", 1, 100, F.towerExitFloor, function(v) F.towerExitFloor = v end)

-- ==================== 5. TAB SETTINGS ====================
SetTab:AddSection("System Optimization & Webhook")
SetTab:AddTextBox("Discord Webhook URL", F.webhookUrl, function(v) F.webhookUrl = v end)
SetTab:AddToggle("Aktifkan Webhook Discord", F.webhookEnabled, function(v) F.webhookEnabled = v end)
SetTab:AddToggle("Anti-AFK Protection", F.afk, function(v) F.afk = v end)
SetTab:AddToggle("FPS Boost (Optimasi Partikel)", F.fpsOn, function(v) 
	F.fpsOn = v
	if v then pcall(function() game:GetService("Lighting").GlobalShadows = false end) end
end)
SetTab:AddButton("Server Hop (Pindah Server)", function()
	pcall(function()
		local servers = {}
		local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
		local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
		if success and result and result.data then
			for _, s in ipairs(result.data) do
				if type(s) == "table" and s.playing and s.maxPlayers and s.playing < s.maxPlayers and s.id ~= game.JobId then
					table.insert(servers, s.id)
				end
			end
		end
		if #servers > 0 then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
		else
			TeleportService:Teleport(game.PlaceId, LocalPlayer)
		end
	end)
end)

Window:Notify("MofenkHub", "Semua fitur berhasil dimuat tanpa kendala!", 4)

-- BACKGROUND LOOPS AUTOMATION
task.spawn(function()
	while _G.__ANIMEDICE == generation do
		if F.autoRoll and R.RollDice then
			pcall(function() R.RollDice:InvokeServer() end)
			task.wait(F.aiJitterDelay)
		else
			task.wait(1)
		end
	end
end)

task.spawn(function()
	while _G.__ANIMEDICE == generation do
		if F.collect and R.CollectBalance then
			pcall(function()
				for i = 1, 15 do R.CollectBalance:FireServer(i) end
			end)
		end
		task.wait(tonumber(F.collectDelay) or 2.0)
	end
end)
