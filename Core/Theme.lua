--[====================================================================]
-- Mofenk UI - Core/Theme.lua
-- @description Dynamic theme engine with real-time palette updates.
--[====================================================================]

local Theme = {}
Theme.__index = Theme

Theme.Palettes = {
    Dark = {
        Background = Color3.fromRGB(15, 17, 23),
        Surface = Color3.fromRGB(22, 25, 35),
        SurfaceHover = Color3.fromRGB(30, 35, 48),
        Primary = Color3.fromRGB(99, 102, 241), -- Indigo 500
        TextPrimary = Color3.fromRGB(248, 250, 252),
        TextSecondary = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(51, 65, 85),
    },
    Light = {
        Background = Color3.fromRGB(248, 250, 252),
        Surface = Color3.fromRGB(255, 255, 255),
        SurfaceHover = Color3.fromRGB(241, 245, 249),
        Primary = Color3.fromRGB(79, 70, 229),
        TextPrimary = Color3.fromRGB(15, 23, 42),
        TextSecondary = Color3.fromRGB(100, 116, 139),
        Border = Color3.fromRGB(226, 232, 240),
    }
}

function Theme.new(mode)
    local self = setmetatable({}, Theme)
    self.CurrentMode = mode or "Dark"
    self.Palette = Theme.Palettes[self.CurrentMode]
    self.Listeners = {}
    return self
end

function Theme:SetMode(mode)
    if Theme.Palettes[mode] then
        self.CurrentMode = mode
        self.Palette = Theme.Palettes[mode]
        for _, callback in ipairs(self.Listeners) do
            task.spawn(callback, self.Palette)
        end
    end
end

function Theme:OnThemeChanged(callback)
    table.insert(self.Listeners, callback)
end

return Theme
