--[]
-- MofenkUI - Premium Monochrome Glass Executor UI Library
-- Black/White Aesthetics, Responsive Auto-Scale, Smooth Tweens & Full API
--[]
​local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
​local MofenkUI = {}
​local MONO_THEME = {
Bg         = Color3.fromRGB(12, 12, 14),
Card       = Color3.fromRGB(24, 24, 28),
CardAlt    = Color3.fromRGB(34, 34, 40),
Header     = Color3.fromRGB(16, 16, 19),
Accent     = Color3.fromRGB(255, 255, 255),
Text       = Color3.fromRGB(245, 247, 250),
SubText    = Color3.fromRGB(160, 165, 175),
Success    = Color3.fromRGB(255, 255, 255),
Warning    = Color3.fromRGB(210, 210, 210),
Danger     = Color3.fromRGB(170, 170, 170),
Line       = Color3.fromRGB(255, 255, 255),
Shadow     = Color3.fromRGB(0, 0, 0)
}
​local function createCorner(instance, radius)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, radius)
corner.Parent = instance
return corner
end
​local function createStroke(instance, color, thickness, transparency)
local stroke = Instance.new("UIStroke")
stroke.Color = color or Color3.new(1, 1, 1)
stroke.Thickness = thickness or 1
stroke.Transparency = transparency or 0.6
stroke.Parent = instance
return stroke
end
​local function clamp(val, min, max)
return math.max(min, math.min(val, max))
end
​local function createFrame(parent, props)
local f = Instance.new("Frame")
f.Name = props.Name or "Frame"
f.Size = props.Size or UDim2.new(0, 100, 0, 100)
f.Position = props.Position or UDim2.new()
f.BackgroundColor3 = props.BackgroundColor3 or Color3.new(1, 1, 1)
f.BackgroundTransparency = props.BackgroundTransparency or 0
f.BorderSizePixel = 0
f.Parent = parent
if props.AnchorPoint then f.AnchorPoint = props.AnchorPoint end
if props.ClipsDescendants ~= nil then f.ClipsDescendants = props.ClipsDescendants end
if props.ZIndex then f.ZIndex = props.ZIndex end
return f
end
​local function createTextLabel(parent, props)
local label = Instance.new("TextLabel")
label.Name = props.Name or "Label"
label.Size = props.Size or UDim2.new(0, 120, 0, 20)
label.Position = props.Position or UDim2.new()
label.BackgroundTransparency = props.BackgroundTransparency or 1
label.BorderSizePixel = 0
label.Font = props.Font or Enum.Font.GothamSemibold
label.Text = props.Text or ""
label.TextColor3 = props.TextColor3 or Color3.new(1, 1, 1)
label.TextSize = props.TextSize or 12
label.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
label.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
label.Parent = parent
if props.AnchorPoint then label.AnchorPoint = props.AnchorPoint end
if props.TextWrapped ~= nil then label.TextWrapped = props.TextWrapped end
if props.TextScaled ~= nil then label.TextScaled = props.TextScaled end
if props.ZIndex then label.ZIndex = props.ZIndex end
return label
end
​local function createTextButton(parent, props)
local btn = Instance.new("TextButton")
btn.Name = props.Name or "Button"
btn.Size = props.Size or UDim2.new(0, 120, 0, 24)
btn.Position = props.Position or UDim2.new()
btn.BackgroundColor3 = props.BackgroundColor3 or Color3.new(1, 1, 1)
btn.BackgroundTransparency = props.BackgroundTransparency or 0
btn.BorderSizePixel = 0
btn.Font = props.Font or Enum.Font.GothamSemibold
btn.Text = props.Text or ""
btn.TextColor3 = props.TextColor3 or Color3.new(1, 1, 1)
btn.TextSize = props.TextSize or 12
btn.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center
btn.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
btn.AutoButtonColor = false
btn.Parent = parent
if props.AnchorPoint then btn.AnchorPoint = props.AnchorPoint end
if props.ZIndex then btn.ZIndex = props.ZIndex end
return btn
end
​local function createTextBox(parent, props)
local box = Instance.new("TextBox")
box.Name = props.Name or "TextBox"
box.Size = props.Size or UDim2.new(0, 120, 0, 24)
box.Position = props.Position or UDim2.new()
box.BackgroundColor3 = props.BackgroundColor3 or Color3.new(1, 1, 1)
box.BackgroundTransparency = props.BackgroundTransparency or 0
box.BorderSizePixel = 0
box.Font = props.Font or Enum.Font.Gotham
box.Text = props.Text or ""
box.TextColor3 = props.TextColor3 or Color3.new(1, 1, 1)
box.TextSize = props.TextSize or 12
box.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
box.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
box.Parent = parent
if props.PlaceholderText then box.PlaceholderText = props.PlaceholderText end
if props.PlaceholderColor3 then box.PlaceholderColor3 = props.PlaceholderColor3 end
if props.ClearTextOnFocus ~= nil then box.ClearTextOnFocus = props.ClearTextOnFocus end
if props.ZIndex then box.ZIndex = props.ZIndex end
return box
end
​local function createImageLabel(parent, props)
local img = Instance.new("ImageLabel")
img.Name = props.Name or "ImageLabel"
img.Size = props.Size or UDim2.new(0, 100, 0, 100)
img.Position = props.Position or UDim2.new()
img.BackgroundTransparency = props.BackgroundTransparency or 1
img.BorderSizePixel = 0
img.Parent = parent
if props.Image then img.Image = props.Image end
if props.ScaleType then img.ScaleType = props.ScaleType end
if props.AnchorPoint then img.AnchorPoint = props.AnchorPoint end
return img
end
​local function setHover(button, baseColor, hoverColor, baseAlpha, hoverAlpha)
button.MouseEnter:Connect(function()
TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
BackgroundColor3 = hoverColor or baseColor,
BackgroundTransparency = hoverAlpha or baseAlpha or 0.05,
}):Play()
end)
button.MouseLeave:Connect(function()
TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
BackgroundColor3 = baseColor or button.BackgroundColor3,
BackgroundTransparency = baseAlpha or 0.12,
}):Play()
end)
end
​function MofenkUI.CreateWindow(config)
config = config or {}
local titleText = config.Name or "MofenkHub"
local profileTitle = config.ProfileTitle or "Executor Premium"
local theme = MONO_THEME
​pcall(function()
for _, v in ipairs(PlayerGui:GetChildren()) do if string.find(v.Name, "Mofenk") then v:Destroy() end end
for _, v in ipairs(CoreGui:GetChildren()) do if string.find(v.Name, "Mofenk") then v:Destroy() end end
end)
​-- Notifications GUI
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "MofenkNotifications"
NotifGui.ResetOnSpawn = false
NotifGui.Parent = PlayerGui
NotifGui.DisplayOrder = 1000000
​local NotifHolder = createFrame(NotifGui, {
Name = "NotifHolder",
Size = UDim2.new(0, 310, 0, 450),
Position = UDim2.new(1, -20, 1, -20),
AnchorPoint = Vector2.new(1, 1),
BackgroundTransparency = 1,
})
local NotifLayout = Instance.new("UIListLayout")
NotifLayout.Parent = NotifHolder
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 8)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
​-- Toggle Floating Button (Interactive Logo with Pulse)
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "MofenkToggleFront"
ToggleGui.ResetOnSpawn = false
ToggleGui.Parent = PlayerGui
ToggleGui.DisplayOrder = 999999
​local ToggleBtn = createTextButton(ToggleGui, {
Name = "ToggleBtn",
Text = "⚡",
TextColor3 = theme.Accent,
TextSize = 22,
Font = Enum.Font.GothamBlack,
BackgroundColor3 = theme.Card,
BackgroundTransparency = 0.1,
Size = UDim2.new(0, 52, 0, 52),
Position = UDim2.new(0.02, 0, 0.38, 0),
})
createCorner(ToggleBtn, 16)
createStroke(ToggleBtn, theme.Line, 1.2, 0.4)
​task.spawn(function()
while ToggleBtn and ToggleBtn.Parent do
TweenService:Create(ToggleBtn, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
Size = UDim2.new(0, 56, 0, 56)
}):Play()
task.wait(1.2)
TweenService:Create(ToggleBtn, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
Size = UDim2.new(0, 52, 0, 52)
}):Play()
task.wait(1.2)
end
end)
​local dragState = { dragging = false, startPos = Vector2.new(), startBtnPos = UDim2.new() }
ToggleBtn.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragState.dragging = true
dragState.startPos = input.Position
dragState.startBtnPos = ToggleBtn.Position
end
end)
UserInputService.InputChanged:Connect(function(input)
if dragState.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - dragState.startPos
local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
local x = clamp(dragState.startBtnPos.X.Offset + delta.X, 10, viewport.X - 70)
local y = clamp(dragState.startBtnPos.Y.Offset + delta.Y, 10, viewport.Y - 70)
ToggleBtn.Position = UDim2.new(0, x, 0, y)
end
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragState.dragging = false
end
end)
​-- Main Hub GUI & Auto Scale Viewport
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "MofenkPremiumHub"
MainGui.ResetOnSpawn = false
MainGui.Parent = PlayerGui
MainGui.DisplayOrder = 999998
​local UIScale = Instance.new("UIScale")
UIScale.Parent = MainGui
​local function updateScale()
local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
local scale = clamp(vp.X / 1150, 0.7, 1.15)
UIScale.Scale = scale
end
updateScale()
if workspace.CurrentCamera then
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end
​local MainFrame = createFrame(MainGui, {
Name = "MainFrame",
Size = UDim2.new(0, 700, 0, 480),
Position = UDim2.new(0.5, 0, 0.5, 0),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundColor3 = theme.Bg,
BackgroundTransparency = 0.04,
})
createCorner(MainFrame, 18)
createStroke(MainFrame, theme.Line, 1.2, 0.3)
​-- Top Bar
local TopBar = createFrame(MainFrame, {
Name = "TopBar",
Size = UDim2.new(1, 0, 0, 46),
BackgroundColor3 = theme.Header,
BackgroundTransparency = 0.08,
})
createCorner(TopBar, 18)
​local LogoDot = createFrame(TopBar, {
Name = "LogoDot",
Size = UDim2.new(0, 16, 0, 16),
Position = UDim2.new(0, 16, 0, 15),
BackgroundColor3 = theme.Accent,
})
createCorner(LogoDot, 999)
​local TitleLabel = createTextLabel(TopBar, {
Name = "TitleLabel",
Text = titleText,
TextColor3 = theme.Accent,
TextSize = 13,
Font = Enum.Font.GothamBlack,
Position = UDim2.new(0, 44, 0, 0),
Size = UDim2.new(0, 300, 1, 0),
})
​local ClockLabel = createTextLabel(TopBar, {
Name = "ClockLabel",
Text = "00:00:00",
TextColor3 = theme.SubText,
TextSize = 11,
Font = Enum.Font.GothamMedium,
Position = UDim2.new(1, -210, 0, 0),
Size = UDim2.new(0, 80, 1, 0),
TextXAlignment = Enum.TextXAlignment.Right,
})
​task.spawn(function()
while task.wait(1) do
pcall(function()
ClockLabel.Text = os.date("%H:%M:%S")
end)
end
end)
​local MinimizeBtn = createTextButton(TopBar, {
Name = "MinimizeBtn",
Text = "—",
TextColor3 = theme.Text,
TextSize = 14,
Font = Enum.Font.GothamBold,
Size = UDim2.new(0, 28, 0, 28),
Position = UDim2.new(1, -74, 0, 9),
BackgroundColor3 = theme.Card,
BackgroundTransparency = 0.15,
})
createCorner(MinimizeBtn, 8)
setHover(MinimizeBtn, theme.Card, theme.CardAlt, 0.15, 0.05)
​local CloseBtn = createTextButton(TopBar, {
Name = "CloseBtn",
Text = "✕",
TextColor3 = theme.Text,
TextSize = 12,
Font = Enum.Font.GothamBold,
Size = UDim2.new(0, 28, 0, 28),
Position = UDim2.new(1, -38, 0, 9),
BackgroundColor3 = theme.Card,
BackgroundTransparency = 0.15,
})
createCorner(CloseBtn, 8)
setHover(CloseBtn, theme.Card, theme.CardAlt, 0.15, 0.05)
​local minimized = false
local origHeight = 480
​MinimizeBtn.MouseButton1Click:Connect(function()
minimized = not minimized
if minimized then
origHeight = MainFrame.AbsoluteSize.Y
Sidebar.Visible = false
ContentArea.Visible = false
ProfileCard.Visible = false
TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, 46)
}):Play()
MinimizeBtn.Text = "+"
else
Sidebar.Visible = true
ContentArea.Visible = true
ProfileCard.Visible = true
TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, origHeight)
}):Play()
MinimizeBtn.Text = "—"
end
end)
​CloseBtn.MouseButton1Click:Connect(function()
MainFrame.Visible = false
end)
​-- Profile Card / Avatar Unique Panel
local ProfileCard = createFrame(MainFrame, {
Name = "ProfileCard",
Size = UDim2.new(1, -20, 0, 74),
Position = UDim2.new(0, 10, 0, 54),
BackgroundColor3 = theme.Card,
BackgroundTransparency = 0.12,
})
createCorner(ProfileCard, 12)
createStroke(ProfileCard, theme.Line, 1, 0.5)
​local Avatar = createImageLabel(ProfileCard, {
Name = "Avatar",
Size = UDim2.new(0, 52, 0, 52),
Position = UDim2.new(0, 11, 0, 11),
Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
})
createCorner(Avatar, 999)
createStroke(Avatar, theme.Line, 1.2, 0.3)
​local NameLabel = createTextLabel(ProfileCard, {
Name = "NameLabel",
Text = "👑 " .. LocalPlayer.Name,
TextColor3 = theme.Accent,
TextSize = 13,
Font = Enum.Font.GothamBlack,
Position = UDim2.new(0, 76, 0, 14),
Size = UDim2.new(1, -190, 0, 20),
})
​local IdentityBadge = createTextLabel(ProfileCard, {
Name = "IdentityBadge",
Text = profileTitle,
TextColor3 = theme.SubText,
TextSize = 10,
Font = Enum.Font.GothamMedium,
Position = UDim2.new(0, 76, 0, 36),
Size = UDim2.new(1, -190, 0, 18),
})
​local StatusPill = createTextLabel(ProfileCard, {
Name = "StatusPill",
Text = "● ONLINE",
TextColor3 = theme.Success,
TextSize = 10,
Font = Enum.Font.GothamBold,
Position = UDim2.new(1, -100, 0, 24),
Size = UDim2.new(0, 88, 0, 24),
BackgroundColor3 = theme.Header,
TextXAlignment = Enum.TextXAlignment.Center,
})
createCorner(StatusPill, 999)
createStroke(StatusPill, theme.Success, 1, 0.4)
​-- Sidebar & Content Area
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.Position = UDim2.new(0, 10, 0, 136)
Sidebar.Size = UDim2.new(0, 170, 1, -146)
Sidebar.BackgroundTransparency = 1
Sidebar.ScrollBarThickness = 2
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
​local SideLayout = Instance.new("UIListLayout")
SideLayout.Parent = Sidebar
SideLayout.Padding = UDim.new(0, 6)
​local ContentArea = createFrame(MainFrame, {
Name = "ContentArea",
Size = UDim2.new(1, -192, 1, -136),
Position = UDim2.new(0, 186, 0, 136),
BackgroundColor3 = theme.Card,
BackgroundTransparency = 0.16,
})
createCorner(ContentArea, 14)
createStroke(ContentArea, theme.Line, 1, 0.4)
​local WindowObj = {
Theme = theme,
TabFrames = {},
TabButtons = {},
FirstTabSet = false,
NotifHolder = NotifHolder,
}
​function WindowObj:Notify(arg1, arg2, arg3, arg4)
local kind = "Info"
local title = "Info"
local text = ""
local duration = 3
​if arg4 ~= nil then
kind = tostring(arg1); title = tostring(arg2); text = tostring(arg3); duration = tonumber(arg4) or 3
elseif arg3 ~= nil and type(arg3) == "number" then
title = tostring(arg1); text = tostring(arg2); duration = tonumber(arg3) or 3
elseif arg2 ~= nil then
title = tostring(arg1); text = tostring(arg2)
end
​if tostring(arg1) == "Info" or tostring(arg1) == "Success" or tostring(arg1) == "Warning" or tostring(arg1) == "Error" then
kind = tostring(arg1)
if arg2 ~= nil and arg3 ~= nil then title = tostring(arg2); text = tostring(arg3) end
end
​local toast = createFrame(self.NotifHolder, {
Name = "Toast",
Size = UDim2.new(1, 0, 0, 64),
BackgroundColor3 = self.Theme.Card,
BackgroundTransparency = 0.05,
})
createCorner(toast, 10)
createStroke(toast, self.Theme.Line, 1.1, 0.3)
​createTextLabel(toast, {
Name = "T1",
Text = title,
TextColor3 = self.Theme.Text,
TextSize = 12,
Font = Enum.Font.GothamBlack,
Position = UDim2.new(0, 12, 0, 8),
Size = UDim2.new(1, -24, 0, 18),
})
​createTextLabel(toast, {
Name = "T2",
Text = text,
TextColor3 = self.Theme.SubText,
TextSize = 10,
Font = Enum.Font.Gotham,
Position = UDim2.new(0, 12, 0, 26),
Size = UDim2.new(1, -24, 0, 26),
TextWrapped = true,
})
​task.delay(duration, function()
pcall(function()
TweenService:Create(toast, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
BackgroundTransparency = 1
}):Play()
task.wait(0.2)
toast:Destroy()
end)
end)
end
​function WindowObj:CreateTab(name, icon)
local tabBtn = createTextButton(Sidebar, {
Name = "Tab_" .. name,
Text = "  " .. icon .. "  " .. name,
TextColor3 = self.Theme.SubText,
TextSize = 12,
Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
BackgroundColor3 = self.Theme.Card,
BackgroundTransparency = 0.2,
Size = UDim2.new(1, -4, 0, 36),
})
createCorner(tabBtn, 8)
setHover(tabBtn, self.Theme.Card, self.Theme.CardAlt, 0.2, 0.08)
​local scroll = Instance.new("ScrollingFrame")
scroll.Name = "TabScroll_" .. name
scroll.Parent = ContentArea
scroll.Size = UDim2.new(1, -12, 1, -12)
scroll.Position = UDim2.new(0, 6, 0, 6)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Visible = false
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
​local list = Instance.new("UIListLayout")
list.Parent = scroll
list.Padding = UDim.new(0, 8)
​self.TabFrames[name] = scroll
self.TabButtons[name] = tabBtn
​if not self.FirstTabSet then
scroll.Visible = true
tabBtn.BackgroundTransparency = 0.05
tabBtn.TextColor3 = self.Theme.Accent
self.FirstTabSet = true
end
​tabBtn.MouseButton1Click:Connect(function()
for tabName, frame in pairs(self.TabFrames) do frame.Visible = (tabName == name) end
for _, btn in pairs(self.TabButtons) do
btn.BackgroundTransparency = 0.2
btn.TextColor3 = self.Theme.SubText
end
tabBtn.BackgroundTransparency = 0.05
tabBtn.TextColor3 = self.Theme.Accent
end)
​local TabObj = { Container = scroll }
​function TabObj:AddSection(text)
createTextLabel(scroll, {
Name = "Section",
Text = "— " .. text .. " —",
TextColor3 = self.Theme.SubText,
TextSize = 10,
Font = Enum.Font.GothamBold,
Size = UDim2.new(1, 0, 0, 22),
TextXAlignment = Enum.TextXAlignment.Center,
})
end
​function TabObj:AddLabel(text)
createTextLabel(scroll, {
Name = "Label",
Text = "  " .. text,
TextColor3 = self.Theme.SubText,
TextSize = 11,
Font = Enum.Font.GothamBold,
Size = UDim2.new(1, 0, 0, 22),
TextXAlignment = Enum.TextXAlignment.Left,
})
end
​function TabObj:AddInfoCard(title, value)
local card = createFrame(scroll, {
Name = "InfoCard",
Size = UDim2.new(1, 0, 0, 58),
BackgroundColor3 = self.Theme.Card,
BackgroundTransparency = 0.1,
})
createCorner(card, 10)
createStroke(card, self.Theme.Line, 1, 0.4)
​createTextLabel(card, {
Name = "Title",
Text = title,
TextColor3 = self.Theme.SubText,
TextSize = 10,
Font = Enum.Font.GothamBold,
Position = UDim2.new(0, 12, 0, 8),
Size = UDim2.new(1, -24, 0, 16),
})
​createTextLabel(card, {
Name = "Value",
Text = value,
TextColor3 = self.Theme.Accent,
TextSize = 14,
Font = Enum.Font.GothamBlack,
Position = UDim2.new(0, 12, 0, 24),
Size = UDim2.new(1, -24, 0, 20),
})
return card
end
​function TabObj:AddButton(text, callback)
local btn = createTextButton(scroll, {
Name = "ActionButton",
Text = "  " .. text,
TextColor3 = self.Theme.Text,
TextSize = 12,
Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
BackgroundColor3 = self.Theme.Card,
BackgroundTransparency = 0.12,
Size = UDim2.new(1, 0, 0, 36),
})
createCorner(btn, 8)
setHover(btn, self.Theme.Card, self.Theme.CardAlt, 0.12, 0.04)
​btn.MouseButton1Click:Connect(function() pcall(callback) end)
return btn
end
​function TabObj:AddToggle(text, defaultState, callback)
local state = defaultState or false
local btn = createTextButton(scroll, {
Name = "ToggleBtn",
Text = "  " .. text,
TextColor3 = self.Theme.Text,
TextSize = 12,
Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
BackgroundColor3 = self.Theme.Card,
BackgroundTransparency = 0.12,
Size = UDim2.new(1, 0, 0, 38),
})
createCorner(btn, 8)
setHover(btn, self.Theme.Card, self.Theme.CardAlt, 0.12, 0.04)
​local toggleBg = createFrame(btn, {
Name = "ToggleBg",
Size = UDim2.new(0, 42, 0, 22),
Position = UDim2.new(1, -50, 0.5, -11),
BackgroundColor3 = state and self.Theme.Accent or Color3.fromRGB(45, 45, 50),
})
createCorner(toggleBg, 999)
​local knob = createFrame(toggleBg, {
Name = "ToggleKnob",
Size = UDim2.new(0, 16, 0, 16),
Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
BackgroundColor3 = state and Color3.fromRGB(12, 12, 14) or Color3.fromRGB(200, 200, 200),
})
createCorner(knob, 999)
​btn.MouseButton1Click:Connect(function()
state = not state
TweenService:Create(toggleBg, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
BackgroundColor3 = state and self.Theme.Accent or Color3.fromRGB(45, 45, 50)
}):Play()
TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
BackgroundColor3 = state and Color3.fromRGB(12, 12, 14) or Color3.fromRGB(200, 200, 200)
}):Play()
pcall(callback, state)
end)
return btn
end
​function TabObj:AddTextBox(placeholder, defaultText, callback)
local box = createTextBox(scroll, {
Name = "InputBox",
Text = defaultText or "",
TextColor3 = self.Theme.Text,
TextSize = 12,
Font = Enum.Font.Gotham,
BackgroundColor3 = self.Theme.Card,
BackgroundTransparency = 0.1,
Size = UDim2.new(1, 0, 0, 36),
PlaceholderText = placeholder,
PlaceholderColor3 = self.Theme.SubText,
ClearTextOnFocus = false,
})
createCorner(box, 8)
box.FocusLost:Connect(function(enterPressed)
if enterPressed then pcall(callback, box.Text) end
end)
return box
end
​function TabObj:AddSlider(text, minValue, maxValue, currentValue, callback)
currentValue = clamp(currentValue or minValue, minValue, maxValue)
local frame = createFrame(scroll, {
Name = "SliderFrame",
Size = UDim2.new(1, 0, 0, 52),
BackgroundColor3 = self.Theme.Card,
BackgroundTransparency = 0.12,
})
createCorner(frame, 10)
​local label = createTextLabel(frame, {
Name = "SliderLabel",
Text = "  " .. text .. ": " .. tostring(currentValue),
TextColor3 = self.Theme.Text,
TextSize = 11,
Font = Enum.Font.GothamBold,
Position = UDim2.new(0, 10, 0, 6),
Size = UDim2.new(1, -20, 0, 18),
})
​local bar = createFrame(frame, {
Name = "SliderBar",
Size = UDim2.new(1, -20, 0, 6),
Position = UDim2.new(0, 10, 0, 32),
BackgroundColor3 = self.Theme.Header,
})
createCorner(bar, 999)
​local fill = createFrame(bar, {
Name = "FillBar",
Size = UDim2.new((currentValue - minValue) / (maxValue - minValue), 0, 1, 0),
BackgroundColor3 = self.Theme.Accent,
})
createCorner(fill, 999)
​local dragging = false
bar.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local pos = clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
fill.Size = UDim2.new(pos, 0, 1, 0)
local val = math.floor(minValue + ((maxValue - minValue) * pos))
label.Text = "  " .. text .. ": " .. tostring(val)
pcall(callback, val)
end
end)
return frame
end
​function TabObj:AddDropdown(text, options, callback)
options = options or {}
local open = false
local drop = createFrame(scroll, {
Name = "DropdownFrame",
Size = UDim2.new(1, 0, 0, 36),
BackgroundColor3 = self.Theme.Card,
BackgroundTransparency = 0.12,
})
createCorner(drop, 10)
​local mainBtn = createTextButton(drop, {
Name = "DropdownToggle",
Text = "  " .. text .. ": Select...",
TextColor3 = self.Theme.Text,
TextSize = 12,
Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 36),
})
​local listFrame = createFrame(drop, {
Name = "DropdownList",
Size = UDim2.new(1, 0, 0, #options * 30),
Position = UDim2.new(0, 0, 0, 36),
BackgroundTransparency = 1,
})
local listLayout = Instance.new("UIListLayout")
listLayout.Parent = listFrame
listLayout.Padding = UDim.new(0, 2)
​for _, opt in ipairs(options) do
local optionBtn = createTextButton(listFrame, {
Name = "Option",
Text = "    • " .. tostring(opt),
TextColor3 = self.Theme.SubText,
TextSize = 11,
Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left,
BackgroundColor3 = self.Theme.Header,
BackgroundTransparency = 0.2,
Size = UDim2.new(1, 0, 0, 28),
})
createCorner(optionBtn, 6)
optionBtn.MouseButton1Click:Connect(function()
open = false
mainBtn.Text = "  " .. text .. ": " .. tostring(opt)
TweenService:Create(drop, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Size = UDim2.new(1, 0, 0, 36)
}):Play()
pcall(callback, opt)
end)
end
​mainBtn.MouseButton1Click:Connect(function()
open = not open
local targetHeight = open and (36 + (#options * 30)) or 36
TweenService:Create(drop, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Size = UDim2.new(1, 0, 0, targetHeight)
}):Play()
end)
return drop
end
​return TabObj
end
​ToggleBtn.MouseButton1Click:Connect(function()
MainFrame.Visible = not MainFrame.Visible
end)
​return WindowObj
end
​return MofenkUI
