--[====================================================================]
-- Mofenk UI - Components/Button.lua
-- @description Interactive button component with smooth hover animations.
--[====================================================================]

local TweenService = game:GetService("TweenService")
local Button = {}
Button.__index = Button

function Button.new(windowInstance, text, callback)
    local self = setmetatable({}, Button)
    self.Theme = windowInstance.Theme
    self.Callback = callback or function() end

    self.Instance = Instance.new("TextButton")
    self.Instance.Size = UDim2.new(1, 0, 0, 40)
    self.Instance.BackgroundColor3 = self.Theme.Palette.Surface
    self.Instance.Text = text
    self.Instance.TextColor3 = self.Theme.Palette.TextPrimary
    self.Instance.Font = Enum.Font.GothamMedium
    self.Instance.TextSize = 14
    self.Instance.AutoButtonColor = false
    self.Instance.Parent = windowInstance.ContentContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.Instance

    local stroke = Instance.new("UIStroke")
    stroke.Color = self.Theme.Palette.Border
    stroke.Transparency = 0.5
    stroke.Parent = self.Instance

    -- Theme listener for Button
    self.Theme:OnThemeChanged(function(palette)
        self.Instance.BackgroundColor3 = palette.Surface
        self.Instance.TextColor3 = palette.TextPrimary
        stroke.Color = palette.Border
    end)

    -- Hover & Click effects
    self.Instance.MouseEnter:Connect(function()
        TweenService:Create(self.Instance, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.Palette.Primary
        }):Play()
    end)

    self.Instance.MouseLeave:Connect(function()
        TweenService:Create(self.Instance, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.Palette.Surface
        }):Play()
    end)

    self.Instance.MouseButton1Click:Connect(function()
        task.spawn(self.Callback)
    end)

    return self
end

return Button
