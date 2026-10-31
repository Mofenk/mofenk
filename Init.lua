--[====================================================================]
-- Mofenk UI - Init.lua (Entry Point)
-- @description Main loader for Mofenk UI library.
--[====================================================================]

local MofenkUI = {}
MofenkUI.__index = MofenkUI

-- Load Core modules
local CoreFolder = script:WaitForChild("Core")
local Theme = require(CoreFolder:WaitForChild("Theme"))

-- Load Components modules
local ComponentsFolder = script:WaitForChild("Components")
local Window = require(ComponentsFolder:WaitForChild("Window"))
local Button = require(ComponentsFolder:WaitForChild("Button"))

-- Export references
MofenkUI.Theme = Theme
MofenkUI.Window = Window
MofenkUI.Button = Button

-- Constructor Mofenk UI
function MofenkUI.new(config)
    config = config or {}
    local self = setmetatable({}, MofenkUI)
    
    self.DefaultTheme = config.Theme or "Dark"
    self.ThemeInstance = Theme.new(self.DefaultTheme)
    self.Parent = config.Parent or game:GetService("CoreGui")
    
    return self
end

-- Method untuk membuat Window baru
function MofenkUI:CreateWindow(title)
    return Window.new(title, self.ThemeInstance, self.Parent)
end

-- Method untuk mengganti tema secara global
function MofenkUI:SetTheme(mode)
    self.ThemeInstance:SetMode(mode)
end

return MofenkUI
