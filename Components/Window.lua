--[====================================================================]
-- Mofenk UI - Components/Window.lua
-- @description Draggable window container with theme synchronization.
--[====================================================================]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Window = {}
Window.__index = Window

function Window.new(titleText, themeInstance, parent)
    local self = setmetatable({}, Window)
    self.Theme = themeInstance
    self.Parent = parent

    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "MofenkUI_Main"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = parent

    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainContainer"
    self.MainFrame.Size = UDim2.new(0, 480, 0, 360)
    self.MainFrame.Position = UDim2.new(0.5, -240, 0.5, -180)
    self.MainFrame.BackgroundColor3 = self.Theme.Palette.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.MainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = self.Theme.Palette.Border
    stroke.Thickness = 1.5
    stroke.Parent = self.MainFrame

    -- Title Label
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 45)
    title.Position = UDim2.new(0, 15, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = self.Theme.Palette.TextPrimary
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = self.MainFrame

    -- Scrolling Content Container
    self.ContentContainer = Instance.new("ScrollingFrame")
    self.ContentContainer.Size = UDim2.new(1, -20, 1, -65)
    self.ContentContainer.Position = UDim2.new(0, 10, 0, 55)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.ScrollBarThickness = 4
    self.ContentContainer.Parent = self.MainFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 10)
    listLayout.Parent = self.ContentContainer

    -- Theme listener for Window
    self.Theme:OnThemeChanged(function(palette)
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3), {
            BackgroundColor3 = palette.Background
        }):Play()
        stroke.Color = palette.Border
        title.TextColor3 = palette.TextPrimary
    end)

    self:MakeDraggable()
    return self
end

function Window:MakeDraggable()
    local dragging, dragStart, startPos
    self.MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

return Window
