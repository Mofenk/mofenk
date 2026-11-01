--[]--
--                  MOFENK UI LIBRARY - UNIVERSAL                   --
--         Professional Luau UI Framework for Mobile & PC          --
--[]--
​local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
​local LocalPlayer = Players.LocalPlayer
​if CoreGui:FindFirstChild("MofenkUI") then
CoreGui.MofenkUI:Destroy()
end
​local Library = {
Flags = {},
Configs = {}
}
​function Library:Tween(object, info, goals)
local tween = TweenService:Create(object, TweenInfo.new(unpack(info)), goals)
tween:Play()
return tween
end
​function Library:Notify(data)
local screenGui = CoreGui:FindFirstChild("MofenkUI")
if not screenGui then return end
​local notifHolder = screenGui:FindFirstChild("NotificationHolder") or (function()
local h = Instance.new("Frame")
h.Name = "NotificationHolder"
h.Size = UDim2.new(0, 300, 1, -40)
h.Position = UDim2.new(1, -320, 0, 20)
h.BackgroundTransparency = 1
h.Parent = screenGui
​local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
layout.Padding = UDim.new(0, 10)
layout.Parent = h
return h
end)()
​local notif = Instance.new("Frame")
notif.Size = UDim2.new(1, 0, 0, 70)
notif.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
notif.BorderSizePixel = 0
notif.BackgroundTransparency = 0.1
notif.Parent = notifHolder
​local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = notif
​local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(50, 50, 50)
stroke.Thickness = 1
stroke.Parent = notif
​local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 25)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = data.Title or "MOFENK NOTIFY"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = notif
​local desc = Instance.new("TextLabel")
desc.Size = UDim2.new(1, -20, 0, 30)
desc.Position = UDim2.new(0, 10, 0, 30)
desc.BackgroundTransparency = 1
desc.Font = Enum.Font.Gotham
desc.Text = data.Content or ""
desc.TextColor3 = Color3.fromRGB(170, 170, 170)
desc.TextSize = 12
desc.TextWrapped = true
desc.TextXAlignment = Enum.TextXAlignment.Left
desc.Parent = notif
​notif.Position = UDim2.new(1, 50, 0, 0)
Library:Tween(notif, {0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Position = UDim2.new(0, 0, 0, 0)})
​task.delay(data.Duration or 3, function()
Library:Tween(notif, {0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In}, {Position = UDim2.new(1, 50, 0, 0)})
task.wait(0.3)
notif:Destroy()
end)
end
​function Library:CreateWindow(config)
config = config or {}
local windowName = config.Name or "MOFENK HUB | Universal"
​local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MofenkUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui
​local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 420)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BackgroundTransparency = 0.12
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
​local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame
​local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(50, 50, 50)
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame
​-- Dragging System (Mobile & PC Friendly)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = MainFrame.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
dragging = false
end
end)
end
end)
​UserInputService.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)
​RunService.RenderStepped:Connect(function()
if dragging and dragInput then
local delta = dragInput.Position - dragStart
Library:Tween(MainFrame, {0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out}, {
Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
})
end
end)
​-- Resize System
local ResizeBtn = Instance.new("TextButton")
ResizeBtn.Name = "ResizeHandle"
ResizeBtn.Size = UDim2.new(0, 16, 0, 16)
ResizeBtn.Position = UDim2.new(1, -16, 1, -16)
ResizeBtn.BackgroundTransparency = 1
ResizeBtn.Text = "◢"
ResizeBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
ResizeBtn.TextSize = 12
ResizeBtn.ZIndex = 500
ResizeBtn.Parent = MainFrame
​local resizing, resizeStart, startSize
ResizeBtn.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
resizing = true
resizeStart = input.Position
startSize = MainFrame.AbsoluteSize
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
resizing = false
end
end)
end
end)
​UserInputService.InputChanged:Connect(function(input)
if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - resizeStart
local newW = math.clamp(startSize.X + delta.X, 500, 1000)
local newH = math.clamp(startSize.Y + delta.Y, 350, 700)
MainFrame.Size = UDim2.new(0, newW, 0, newH)
end
end)
​-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame
​-- Interactive M Logo (Toggle / Minimize UI like Rayfield)
local LogoBtn = Instance.new("TextButton")
LogoBtn.Size = UDim2.new(0, 32, 0, 32)
LogoBtn.Position = UDim2.new(0, 10, 0, 5)
LogoBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
LogoBtn.BorderSizePixel = 0
LogoBtn.AutoButtonColor = false
LogoBtn.Font = Enum.Font.GothamBold
LogoBtn.Text = "M"
LogoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoBtn.TextSize = 16
LogoBtn.Parent = TopBar
​local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 6)
LogoCorner.Parent = LogoBtn
​local uiVisible = true
LogoBtn.MouseButton1Click:Connect(function()
uiVisible = not uiVisible
for _, child in pairs(MainFrame:GetChildren()) do
if child ~= TopBar and child ~= ResizeBtn then
child.Visible = uiVisible
end
end
Library:Tween(MainFrame, {0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {
Size = uiVisible and UDim2.new(0, 650, 0, 420) or UDim2.new(0, 650, 0, 42)
})
end)
​-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 400, 1, 0)
TitleLabel.Position = UDim2.new(0, 52, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = windowName
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar
​-- Divider Top
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -20, 0, 1)
Divider.Position = UDim2.new(0, 10, 0, 42)
Divider.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame
​-- Stats Bar (Ping & FPS) at Bottom
local BottomBar = Instance.new("Frame")
BottomBar.Size = UDim2.new(1, 0, 0, 26)
BottomBar.Position = UDim2.new(0, 0, 1, -26)
BottomBar.BackgroundTransparency = 1
BottomBar.Parent = MainFrame
​local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -20, 1, 0)
StatsLabel.Position = UDim2.new(0, 10, 0, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.Text = "MOFENK HUB | FPS: 60 | Ping: 0ms"
StatsLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
StatsLabel.TextSize = 10
StatsLabel.TextXAlignment = Enum.TextXAlignment.Right
StatsLabel.Parent = BottomBar
​task.spawn(function()
local fps, lastTick = 0, tick()
RunService.RenderStepped:Connect(function()
fps = fps + 1
if tick() - lastTick >= 1 then
local success, pingVal = pcall(function() return math.round(LocalPlayer:GetNetworkPing() * 1000) end)
local ping = success and pingVal or 0
StatsLabel.Text = string.format("MOFENK HUB | FPS: %d | Ping: %dms", fps, ping)
fps, lastTick = 0, tick()
end
end)
end)
​-- Tab Container Holder
local TabBar = Instance.new("ScrollingFrame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(0, 145, 1, -78)
TabBar.Position = UDim2.new(0, 0, 0, 46)
TabBar.BackgroundTransparency = 1
TabBar.BorderSizePixel = 0
TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
TabBar.ScrollBarThickness = 2
TabBar.Parent = MainFrame
​local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabBar
​local TabListPadding = Instance.new("UIPadding")
TabListPadding.PaddingTop = UDim.new(0, 5)
TabListPadding.PaddingLeft = UDim.new(0, 10)
TabListPadding.Parent = TabBar
​-- Pages Container
local PagesContainer = Instance.new("Folder")
PagesContainer.Name = "PagesContainer"
PagesContainer.Parent = MainFrame
​local Window = { TabsCount = 0 }
​function Window:CreateTab(tabName)
Window.TabsCount = Window.TabsCount + 1
local tabIndex = Window.TabsCount
​local TabButton = Instance.new("TextButton")
TabButton.Size = UDim2.new(1, 0, 0, 34)
TabButton.BackgroundColor3 = tabIndex == 1 and Color3.fromRGB(24, 24, 24) or Color3.fromRGB(16, 16, 16)
TabButton.BackgroundTransparency = tabIndex == 1 and 0 or 0.6
TabButton.BorderSizePixel = 0
TabButton.AutoButtonColor = false
TabButton.Font = Enum.Font.GothamMedium
TabButton.Text = "  " .. tabName
TabButton.TextColor3 = tabIndex == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 130, 130)
TabButton.TextSize = 12
TabButton.TextXAlignment = Enum.TextXAlignment.Left
TabButton.Parent = TabBar
​local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 6)
TabCorner.Parent = TabButton
​local TabPage = Instance.new("ScrollingFrame")
TabPage.Name = tabName .. "Page"
TabPage.Size = UDim2.new(1, -160, 1, -82)
TabPage.Position = UDim2.new(0, 150, 0, 48)
TabPage.BackgroundTransparency = 1
TabPage.BorderSizePixel = 0
TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
TabPage.ScrollBarThickness = 3
TabPage.Visible = tabIndex == 1
TabPage.Parent = PagesContainer
​local PageLayout = Instance.new("UIListLayout")
PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
PageLayout.Padding = UDim.new(0, 8)
PageLayout.Parent = TabPage
​local PagePadding = Instance.new("UIPadding")
PagePadding.PaddingTop = UDim.new(0, 5)
PagePadding.PaddingRight = UDim.new(0, 10)
PagePadding.Parent = TabPage
​PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
end)
​TabButton.MouseButton1Click:Connect(function()
for _, v in pairs(PagesContainer:GetChildren()) do v.Visible = false end
for _, v in pairs(TabBar:GetChildren()) do
if v:IsA("TextButton") then
Library:Tween(v, {0.2, Enum.EasingStyle.Quad}, {BackgroundColor3 = Color3.fromRGB(16, 16, 16), BackgroundTransparency = 0.6})
v.TextColor3 = Color3.fromRGB(130, 130, 130)
end
end
TabPage.Visible = true
Library:Tween(TabButton, {0.2, Enum.EasingStyle.Quad}, {BackgroundColor3 = Color3.fromRGB(24, 24, 24), BackgroundTransparency = 0})
TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)
​local TabObject = {}
​function TabObject:CreateGroup(groupName)
local GroupCard = Instance.new("Frame")
GroupCard.Size = UDim2.new(1, 0, 0, 40)
GroupCard.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
GroupCard.BackgroundTransparency = 0.3
GroupCard.BorderSizePixel = 0
GroupCard.Parent = TabPage
​local GroupCorner = Instance.new("UICorner")
GroupCorner.CornerRadius = UDim.new(0, 8)
GroupCorner.Parent = GroupCard
​local GroupStroke = Instance.new("UIStroke")
GroupStroke.Color = Color3.fromRGB(40, 40, 40)
GroupStroke.Thickness = 1
GroupStroke.Parent = GroupCard
​local GroupTitle = Instance.new("TextLabel")
GroupTitle.Size = UDim2.new(1, -20, 0, 30)
GroupTitle.Position = UDim2.new(0, 10, 0, 5)
GroupTitle.BackgroundTransparency = 1
GroupTitle.Font = Enum.Font.GothamBold
GroupTitle.Text = groupName
GroupTitle.TextColor3 = Color3.fromRGB(210, 210, 210)
GroupTitle.TextSize = 12
GroupTitle.TextXAlignment = Enum.TextXAlignment.Left
GroupTitle.Parent = GroupCard
​local GroupContainer = Instance.new("Frame")
GroupContainer.Size = UDim2.new(1, 0, 0, 0)
GroupContainer.Position = UDim2.new(0, 0, 0, 35)
GroupContainer.BackgroundTransparency = 1
GroupContainer.Parent = GroupCard
​local GroupLayout = Instance.new("UIListLayout")
GroupLayout.SortOrder = Enum.SortOrder.LayoutOrder
GroupLayout.Padding = UDim.new(0, 5)
GroupLayout.Parent = GroupContainer
​GroupLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
local h = GroupLayout.AbsoluteContentSize.Y + 45
GroupCard.Size = UDim2.new(1, 0, 0, h)
GroupContainer.Size = UDim2.new(1, 0, 0, GroupLayout.AbsoluteContentSize.Y + 10)
end)
​local GroupObject = {}
​function GroupObject:AddButton(text, callback)
callback = callback or function() end
local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(1, -20, 0, 32)
Btn.Position = UDim2.new(0, 10, 0, 0)
Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Btn.BorderSizePixel = 0
Btn.AutoButtonColor = false
Btn.Font = Enum.Font.GothamMedium
Btn.Text = text
Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
Btn.TextSize = 12
Btn.Parent = GroupContainer
​local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = Btn
​Btn.MouseButton1Click:Connect(function()
Library:Tween(Btn, {0.1, Enum.EasingStyle.Quad}, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
task.delay(0.1, function()
Library:Tween(Btn, {0.1, Enum.EasingStyle.Quad}, {BackgroundColor3 = Color3.fromRGB(22, 22, 22)})
end)
pcall(callback)
end)
end
​function GroupObject:AddToggle(text, default, callback)
default = default or false
callback = callback or function() end
local toggled = default
​local Tgl = Instance.new("TextButton")
Tgl.Size = UDim2.new(1, -20, 0, 32)
Tgl.Position = UDim2.new(0, 10, 0, 0)
Tgl.BackgroundTransparency = 1
Tgl.Text = ""
Tgl.AutoButtonColor = false
Tgl.Parent = GroupContainer
​local TglLabel = Instance.new("TextLabel")
TglLabel.Size = UDim2.new(1, -45, 1, 0)
TglLabel.BackgroundTransparency = 1
TglLabel.Font = Enum.Font.GothamMedium
TglLabel.Text = text
TglLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
TglLabel.TextSize = 12
TglLabel.TextXAlignment = Enum.TextXAlignment.Left
TglLabel.Parent = Tgl
​local ToggleBox = Instance.new("Frame")
ToggleBox.Size = UDim2.new(0, 36, 0, 20)
ToggleBox.Position = UDim2.new(1, -36, 0.5, -10)
ToggleBox.BackgroundColor3 = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(35, 35, 35)
ToggleBox.Parent = Tgl
​local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(1, 0)
BoxCorner.Parent = ToggleBox
​local Circle = Instance.new("Frame")
Circle.Size = UDim2.new(0, 16, 0, 16)
Circle.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
Circle.BackgroundColor3 = toggled and Color3.fromRGB(12, 12, 12) or Color3.fromRGB(150, 150, 150)
Circle.Parent = ToggleBox
​local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = Circle
​Tgl.MouseButton1Click:Connect(function()
toggled = not toggled
Library:Tween(ToggleBox, {0.2, Enum.EasingStyle.Quad}, {BackgroundColor3 = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(35, 35, 35)})
Library:Tween(Circle, {0.2, Enum.EasingStyle.Quad}, {
Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
BackgroundColor3 = toggled and Color3.fromRGB(12, 12, 12) or Color3.fromRGB(150, 150, 150)
})
pcall(callback, toggled)
end)
end
​function GroupObject:AddInput(text, default, isNum, callback)
default = default or ""
callback = callback or function() end
​local Frm = Instance.new("Frame")
Frm.Size = UDim2.new(1, -20, 0, 36)
Frm.Position = UDim2.new(0, 10, 0, 0)
Frm.BackgroundTransparency = 1
Frm.Parent = GroupContainer
​local L = Instance.new("TextLabel")
L.Size = UDim2.new(0.5, 0, 1, 0)
L.BackgroundTransparency = 1
L.Font = Enum.Font.GothamMedium
L.Text = text
L.TextColor3 = Color3.fromRGB(220, 220, 220)
L.TextSize = 12
L.TextXAlignment = Enum.TextXAlignment.Left
L.Parent = Frm
​local Box = Instance.new("TextBox")
Box.Size = UDim2.new(0.48, 0, 0.8, 0)
Box.Position = UDim2.new(0.52, 0, 0.1, 0)
Box.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Box.TextColor3 = Color3.fromRGB(255, 255, 255)
Box.TextSize = 12
Box.Font = Enum.Font.GothamBold
Box.Text = tostring(default)
Box.Parent = Frm
​local BC = Instance.new("UICorner")
BC.CornerRadius = UDim.new(0, 6)
BC.Parent = Box
​Box.FocusLost:Connect(function()
local val = isNum and (tonumber(Box.Text) or 0) or Box.Text
pcall(callback, val)
end)
end
​function GroupObject:AddDropdown(text, options, default, isMulti, callback)
options = options or {}
default = default or (isMulti and {} or options[1])
callback = callback or function() end
​local selected = default
local opened = false
​local DropFrame = Instance.new("Frame")
DropFrame.Size = UDim2.new(1, -20, 0, 35)
DropFrame.Position = UDim2.new(0, 10, 0, 0)
DropFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
DropFrame.BorderSizePixel = 0
DropFrame.ClipsDescendants = true
DropFrame.Parent = GroupContainer
​local DropCorner = Instance.new("UICorner")
DropCorner.CornerRadius = UDim.new(0, 6)
DropCorner.Parent = DropFrame
​local DropTitle = Instance.new("TextLabel")
DropTitle.Size = UDim2.new(1, -30, 0, 35)
DropTitle.Position = UDim2.new(0, 10, 0, 0)
DropTitle.BackgroundTransparency = 1
DropTitle.Font = Enum.Font.GothamMedium
DropTitle.Text = text
DropTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
DropTitle.TextSize = 12
DropTitle.TextXAlignment = Enum.TextXAlignment.Left
DropTitle.Parent = DropFrame
​local DropBtn = Instance.new("TextButton")
DropBtn.Size = UDim2.new(1, 0, 0, 35)
DropBtn.BackgroundTransparency = 1
DropBtn.Text = ""
DropBtn.Parent = DropFrame
​local ListHolder = Instance.new("ScrollingFrame")
ListHolder.Size = UDim2.new(1, -10, 0, 110)
ListHolder.Position = UDim2.new(0, 5, 0, 38)
ListHolder.BackgroundTransparency = 1
ListHolder.BorderSizePixel = 0
ListHolder.CanvasSize = UDim2.new(0, 0, 0, #options * 26)
ListHolder.ScrollBarThickness = 2
ListHolder.Parent = DropFrame
​local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 3)
ListLayout.Parent = ListHolder
​for _, opt in ipairs(options) do
local optLabel = type(opt) == "table" and (opt.label or tostring(opt.val)) or tostring(opt)
local optVal = type(opt) == "table" and opt.val or opt
​local OptBtn = Instance.new("TextButton")
OptBtn.Size = UDim2.new(1, 0, 0, 24)
OptBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
OptBtn.BorderSizePixel = 0
OptBtn.AutoButtonColor = false
OptBtn.Font = Enum.Font.Gotham
OptBtn.Text = "  " .. optLabel
OptBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
OptBtn.TextSize = 11
OptBtn.TextXAlignment = Enum.TextXAlignment.Left
OptBtn.Parent = ListHolder
​local OptCorner = Instance.new("UICorner")
OptCorner.CornerRadius = UDim.new(0, 4)
OptCorner.Parent = OptBtn
​OptBtn.MouseButton1Click:Connect(function()
if isMulti then
if type(selected) ~= "table" then selected = {} end
local found = false
for i, v in ipairs(selected) do
if v == optVal then
table.remove(selected, i)
found = true
break
end
end
if not found then table.insert(selected, optVal) end
OptBtn.TextColor3 = found and Color3.fromRGB(170, 170, 170) or Color3.fromRGB(255, 255, 255)
else
selected = optVal
opened = false
Library:Tween(DropFrame, {0.2, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, -20, 0, 35)})
end
pcall(callback, selected)
end)
end
​DropBtn.MouseButton1Click:Connect(function()
opened = not opened
local targetH = opened and 155 or 35
Library:Tween(DropFrame, {0.2, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, -20, 0, targetH)})
end)
end
​return GroupObject
end
​return TabObject
end
​function Window:CreateProfileTab()
local TabPage = Window:CreateTab("Profile")
local Group = TabPage:CreateGroup("User Information")
Group:AddButton("Username: " .. LocalPlayer.Name, function() end)
Group:AddButton("Display Name: " .. LocalPlayer.DisplayName, function() end)
Group:AddButton("User ID: " .. tostring(LocalPlayer.UserId), function() end)
end
​return Window
end
​return Library
