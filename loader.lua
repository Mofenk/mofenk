-- ===================================================================== --
-- 👑 MOFENKHUB V107.0 — MODERN UNIVERSAL LOADER
-- ===================================================================== --
--!nocheck

task.wait(0.2)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function queueTeleport(code)
	local qot = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
	if qot then
		pcall(function()
			qot(code)
		end)
	end
end

local function loadRemote(path)
	local url = "https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/" .. path
	local ok, result = pcall(function()
		return game:HttpGet(url)
	end)
	if not ok or type(result) ~= "string" or result == "" then
		warn("[MofenkHub] Failed to load: " .. path)
		return nil
	end
	local fn, err = loadstring(result)
	if not fn then
		warn("[MofenkHub] Script compile failed: " .. path .. " | " .. tostring(err))
		return nil
	end
	return fn
end

queueTeleport([[
	task.wait(3)
	local ok, err = pcall(function()
		local script = game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/loader.lua")
		loadstring(script)()
	end)
	if not ok then warn(err) end
]])

print("[MofenkHub] Initializing modern loader...")

local uiScript = loadRemote("MofenkUI.lua")
if not uiScript then
	warn("[MofenkHub] CRITICAL: Unable to load MofenkUI.lua")
	return
end

local okUI, MofenkUI = pcall(function()
	return uiScript()
end)
if not okUI or not MofenkUI then
	warn("[MofenkHub] CRITICAL: MofenkUI runtime error")
	return
end

print("[MofenkHub] MofenkUI loaded successfully.")

local gameScript = loadRemote("games/animedice.lua")
if not gameScript then
	warn("[MofenkHub] Unable to load default automation script.")
	return
end

local okRun, errRun = pcall(function()
	return gameScript()
end)
if not okRun then
	warn("[MofenkHub] Error executing game script: " .. tostring(errRun))
end

print("[MofenkHub] Loader finished successfully.")
