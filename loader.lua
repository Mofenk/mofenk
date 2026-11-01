-- ===================================================================== --
-- 👑 MOFENKHUB V106.0 — UNIVERSAL LOADER & BOOTSTRAPPER
-- ===================================================================== --
​--!nocheck
task.wait(0.2)
​local Players   = game:GetService("Players")
local CoreGui   = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
​local LocalPlayer = Players.LocalPlayer
​print("[MofenkHub] Initializing Loader & Security Checks...")
​-- Setup Queue on Teleport for seamless script execution across servers
pcall(function()
local qot = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
if qot then
qot([[
task.wait(3)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/Loader.lua"))()
]])
end
end)
​-- Fetch and Load UI Library (MofenkUI Monochrome Edition)
local uiSuccess, MofenkUI = pcall(function()
return loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/MofenkUI.lua"))()
end)
​if not uiSuccess or not MofenkUI then
warn("[MofenkHub] CRITICAL: Failed to load MofenkUI library from repository!")
return
end
​print("[MofenkHub] UI Library loaded successfully. Detecting supported games...")
​-- Game Routing based on PlaceId or current environment
local placeId = game.PlaceId
print("[MofenkHub] Current Place ID: " .. tostring(placeId))
​-- Load Anime Dice automation script by default or match game ID
local gameSuccess, gameErr = pcall(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/animedice.lua"))()
end)
​if not gameSuccess then
warn("[MofenkHub] Error executing game script: " .. tostring(gameErr))
end
