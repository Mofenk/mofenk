--[====================================================================]
-- MofenkUI - Delta Safe Premium Executor UI[span_4](start_span)[span_4](end_span)
-- Stable, Mobile Friendly, Modern, Animated, Theme Switcher[span_5](start_span)[span_5](end_span)
--[====================================================================]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local MofenkUI = {}

local THEME_ALIASES = {
	CyberBlue = "Neon",
	DarkGlass = "Midnight",
	PurpleNeon = "Violet",
}

local THEMES = {
	Midnight = {
		Bg = Color3.fromRGB(9, 10, 15),
		Bg2 = Color3.fromRGB(18, 21, 29),
		Card = Color3.fromRGB(23, 27, 35),
		CardAlt = Color3.fromRGB(31, 36, 45),
		Header = Color3.fromRGB(14, 16, 22),
		Accent = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(172, 182, 205),
		Text = Color3.fromRGB(245, 247, 255),
		Success = Color3.fromRGB(117, 255, 169),
		Warning = Color3.fromRGB(255, 204, 110),
		Danger = Color3.fromRGB(255, 123, 123),
		Line = Color3.fromRGB(255, 255, 255),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Neon = {
		Bg = Color3.fromRGB(7, 13, 20),
		Bg2 = Color3.fromRGB(18, 28, 38),
		Card = Color3.fromRGB(18, 26, 32),
		CardAlt = Color3.fromRGB(24, 35, 44),
		Header = Color3.fromRGB(12, 18, 25),
		Accent = Color3.fromRGB(66, 255, 226),
		SubText = Color3.fromRGB(148, 214, 208),
		Text = Color3.fromRGB(234, 255, 252),
		Success = Color3.fromRGB(85, 255, 180),
		Warning = Color3.fromRGB(255, 210, 100),
		Danger = Color3.fromRGB(255, 122, 134),
		Line = Color3.fromRGB(66, 255, 226),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Sunset = {
		Bg = Color3.fromRGB(22, 15, 18),
		Bg2 = Color3.fromRGB(38, 24, 28),
		Card = Color3.fromRGB(42, 29, 29),
		CardAlt = Color3.fromRGB(54, 37, 34),
		Header = Color3.fromRGB(28, 18, 21),
		Accent = Color3.fromRGB(255, 165, 90),
		SubText = Color3.fromRGB(242, 177, 147),
		Text = Color3.fromRGB(255, 243, 232),
		Success = Color3.fromRGB(112, 255, 178),
		Warning = Color3.fromRGB(255, 208, 100),
		Danger = Color3.fromRGB(255, 124, 118),
		Line = Color3.fromRGB(255, 165, 90),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Violet = {
		Bg = Color3.fromRGB(13, 11, 24),
		Bg2 = Color3.fromRGB(24, 20, 37),
		Card = Color3.fromRGB(27, 22, 40),
		CardAlt = Color3.fromRGB(38, 31, 54),
		Header = Color3.fromRGB(18, 16, 29),
		Accent = Color3.fromRGB(190, 133, 255),
		SubText = Color3.fromRGB(195, 182, 220),
		Text = Color3.fromRGB(247, 240, 255),
		Success = Color3.fromRGB(92, 255, 175),
		Warning = Color3.fromRGB(255, 216, 108),
		Danger = Color3.fromRGB(255, 129, 129),
		Line = Color3.fromRGB(190, 133, 255),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
}

local function createCorner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = instance
	return corner
end

local function createStroke(instance, color, thickness, transparency)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Color3.new(1, 1, 1)
	stroke.Thickness = thickness or 1
	stroke.Transparency = transparency or 0.4
	stroke.Parent = instance
	return stroke
end

local function clamp(value, minValue, maxValue)
	return math.max(minValue, math.min(value, maxValue))
end

local function createFrame(parent, props)
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

local function createTextLabel(parent, props)
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

local function createTextButton(parent, props)
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
	if props.ClipsDescendants ~= nil then btn.ClipsDescendants = props.ClipsDescendants end
	if props.TextScaled ~= nil then btn.TextScaled = props.TextScaled end
	if props.ZIndex then btn.ZIndex = props.ZIndex end
	return btn
end

local function createTextBox(parent, props)
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
	if props.TextWrapped ~= nil then box.TextWrapped = props.TextWrapped end
	if props.AnchorPoint then box.AnchorPoint = props.AnchorPoint end
	if props.ZIndex then box.ZIndex = props.ZIndex end
	return box
end

local function createImageLabel(parent, props)
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

local function setHover(button, baseColor, hoverColor, baseAlpha, hoverAlpha)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = hoverColor or baseColor,
			BackgroundTransparency = hoverAlpha or baseAlpha or 0.1,
		}):Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = baseColor or button.BackgroundColor3,
			BackgroundTransparency = baseAlpha or 0.15,
		}):Play()
	end)
end

function MofenkUI.CreateWindow(config)
	config = config or {}

	local themeKey = (THEME_ALIASES[config.Theme] or config.Theme or "Midnight")
	local theme = THEMES[themeKey] or THEMES.Midnight
	local titleText = config.Name or "MofenkHub"
	local toggleStyle = config.ToggleStyle or "Icon"
	local profileTitle = config.ProfileTitle or "Executor Premium"

	pcall(function()
		for _, v in ipairs(PlayerGui:GetChildren()) do
			if string.find(v.Name, "Mofenk") then v:Destroy() end
		end
		for _, v in ipairs(CoreGui:GetChildren()) do
			if string.find(v.Name, "Mofenk") then v:Destroy() end
		end
	end)

	local NotifGui = Instance.new("ScreenGui")
	NotifGui.Name = "MofenkNotifications"
	NotifGui.ResetOnSpawn = false
	NotifGui.Parent = PlayerGui
	NotifGui.DisplayOrder = 1000000

	local NotifHolder = createFrame(NotifGui, {
		Name = "NotifHolder",
		Size = UDim2.new(0, 300, 0, 420),
		Position = UDim2.new(1, -320, 1, -40),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
	})
	local NotifLayout = Instance.new("UIListLayout")
	NotifLayout.Parent = NotifHolder
	NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NotifLayout.Padding = UDim.new(0, 8)
	NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

	local ToggleGui = Instance.new("ScreenGui")
	ToggleGui.Name = "MofenkToggleFront"
	ToggleGui.ResetOnSpawn = false
	ToggleGui.Parent = PlayerGui
	ToggleGui.DisplayOrder = 999999

	local ToggleBtn = createTextButton(ToggleGui, {
		Name = "ToggleBtn",
		Text = toggleStyle == "Bar" and "  ⚡ MofenkHub  " or "M",
		TextColor3 = theme.Accent,
		TextSize = toggleStyle == "Bar" and 12 or 22,
		Font = Enum.Font.GothamBlack,
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.08,
		Size = toggleStyle == "Bar" and UDim2.new(0, 140, 0, 38) or UDim2.new(0, 56, 0, 56),
		Position = toggleStyle == "Bar" and UDim2.new(0.5, -70, 0, 12) or UDim2.new(0.03, 0, 0.35, 0),
		TextXAlignment = toggleStyle == "Bar" and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
	})
	createCorner(ToggleBtn, 14)
	createStroke(ToggleBtn, theme.Line, 1.2, 0.3)

	local ToggleGlow = createFrame(ToggleBtn, {
		Name = "ToggleGlow",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = theme.Accent,
		BackgroundTransparency = 0.95,
	})
	local tg = Instance.new("UIGradient")
	tg.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, theme.Accent),
		ColorSequenceKeypoint.new(1, theme.Accent)
	})
	tg.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.8),
		NumberSequenceKeypoint.new(1, 1)
	})
	tg.Rotation = 90
	tg.Parent = ToggleGlow

	local dragState = { dragging = false, startPos = Vector2.new(), startBtnPos = UDim2.new() }

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
			local x = clamp(dragState.startBtnPos.X.Offset + delta.X, 10, viewport.X - 90)
			local y = clamp(dragState.startBtnPos.Y.Offset + delta.Y, 10, viewport.Y - 90)
			ToggleBtn.Position = UDim2.new(0, x, 0, y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragState.dragging = false
		end
	end)

	local MainGui = Instance.new("ScreenGui")
	MainGui.Name = "MofenkPremiumHub"
	MainGui.ResetOnSpawn = false
	MainGui.Parent = PlayerGui
	MainGui.DisplayOrder = 999998

	local MainFrame = createFrame(MainGui, {
		Name = "MainFrame",
		Size = UDim2.new(0, 620, 0, 430),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Bg,
		BackgroundTransparency = 0.02,
	})
	createCorner(MainFrame, 16)
	createStroke(MainFrame, theme.Line, 1.2, 0.25)

	local TopBar = createFrame(MainFrame, {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 48),
		BackgroundColor3 = theme.Header,
		BackgroundTransparency = 0.08,
	})
	createCorner(TopBar, 16)

	local LogoDot = createFrame(TopBar, {
		Name = "LogoDot",
		Size = UDim2.new(0, 18, 0, 18),
		Position = UDim2.new(0, 14, 0, 15),
		BackgroundColor3 = theme.Accent,
	})
	createCorner(LogoDot, 999)

	local TitleLabel = createTextLabel(TopBar, {
		Name = "TitleLabel",
		Text = "⚡ " .. titleText,
		TextColor3 = theme.Accent,
		TextSize = 14,
		Font = Enum.Font.GothamBlack,
		Position = UDim2.new(0, 42, 0, 0),
		Size = UDim2.new(0, 260, 1, 0),
	})

	local MinimizeBtn = createTextButton(TopBar, {
		Name = "MinimizeBtn",
		Text = "—",
		TextColor3 = theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamBold,
		Size = UDim2.new(0, 28, 0, 28),
		Position = UDim2.new(1, -72, 0, 10),
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.15,
	})
	createCorner(MinimizeBtn, 8)
	setHover(MinimizeBtn, theme.Card, theme.CardAlt, 0.15, 0.08)

	local CloseBtn = createTextButton(TopBar, {
		Name = "CloseBtn",
		Text = "✕",
		TextColor3 = theme.Text,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		Size = UDim2.new(0, 28, 0, 28),
		Position = UDim2.new(1, -36, 0, 10),
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.15,
	})
	createCorner(CloseBtn, 8)
	setHover(CloseBtn, theme.Card, theme.CardAlt, 0.15, 0.08)

	local minimized = false
	local origHeight = 430

	MinimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			origHeight = MainFrame.AbsoluteSize.Y
			ProfileCard.Visible = false
			Sidebar.Visible = false
			ContentArea.Visible = false
			MusicBar.Visible = false
			TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, 50)
			}):Play()
			MinimizeBtn.Text = "+"
		else
			ProfileCard.Visible = true
			Sidebar.Visible = true
			ContentArea.Visible = true
			MusicBar.Visible = true
			TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, origHeight)
			}):Play()
			MinimizeBtn.Text = "—"
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = false
	end)

	local ProfileCard = createFrame(MainFrame, {
		Name = "ProfileCard",
		Size = UDim2.new(1, -20, 0, 90),
		Position = UDim2.new(0, 10, 0, 56),
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.08,
	})
	createCorner(ProfileCard, 14)
	createStroke(ProfileCard, theme.Line, 1, 0.35)

	local Avatar = createImageLabel(ProfileCard, {
		Name = "Avatar",
		Size = UDim2.new(0, 58, 0, 58),
		Position = UDim2.new(0, 12, 0, 16),
		Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
		BackgroundTransparency = 0,
	})
	createCorner(Avatar, 999)
	createStroke(Avatar, theme.Line, 1.2, 0.2)

	local AvatarStatus = createFrame(Avatar, {
		Name = "AvatarStatus",
		Size = UDim2.new(0, 12, 0, 12),
		Position = UDim2.new(1, -5, 1, -5),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundColor3 = theme.Success,
	})
	createCorner(AvatarStatus, 999)

	local NameLabel = createTextLabel(ProfileCard, {
		Name = "NameLabel",
		Text = "👑 " .. LocalPlayer.Name .. " (" .. profileTitle .. ")",
		TextColor3 = theme.Accent,
		TextSize = 12,
		Font = Enum.Font.GothamBlack,
		Position = UDim2.new(0, 82, 0, 18),
		Size = UDim2.new(1, -110, 0, 18),
	})

	local StatusBadge = createTextLabel(ProfileCard, {
		Name = "StatusBadge",
		Text = "ONLINE",
		TextColor3 = theme.Success,
		TextSize = 9,
		Font = Enum.Font.GothamBold,
		Position = UDim2.new(1, -96, 0, 18),
		Size = UDim2.new(0, 84, 0, 18),
		BackgroundTransparency = 0,
		BackgroundColor3 = theme.Header,
		TextXAlignment = Enum.TextXAlignment.Center,
	})
	createCorner(StatusBadge, 999)
	createStroke(StatusBadge, theme.Success, 1, 0.4)

	local StatusText = createTextLabel(ProfileCard, {
		Name = "StatusText",
		Text = "✨ Status: Secure & Connected",
		TextColor3 = theme.SubText,
		TextSize = 10,
		Font = Enum.Font.Gotham,
		Position = UDim2.new(0, 82, 0, 42),
		Size = UDim2.new(1, -98, 0, 16),
	})

	local PingBarBg = createFrame(ProfileCard, {
		Name = "PingBarBg",
		Size = UDim2.new(1, -98, 0, 8),
		Position = UDim2.new(0, 82, 0, 66),
		BackgroundColor3 = theme.Header,
	})
	createCorner(PingBarBg, 999)

	local PingFill = createFrame(PingBarBg, {
		Name = "PingFill",
		Size = UDim2.new(0.5, 0, 1, 0),
		BackgroundColor3 = theme.Accent,
	})
	createCorner(PingFill, 999)

	local PingText = createTextLabel(PingBarBg, {
		Name = "PingText",
		Text = "Ping: calculating...",
		TextColor3 = theme.Text,
		TextSize = 8,
		Font = Enum.Font.GothamBold,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Center,
	})

	task.spawn(function()
		while task.wait(1) do
			pcall(function()
				local pingValue = 0
				local statItem = Stats.Network.ServerStatsItem
				if statItem and statItem["Data Ping"] then
					pingValue = statItem["Data Ping"]:GetValue() or 0
				end
				local p = clamp(tonumber(pingValue) or 0, 0, 300)
				local norm = clamp(p / 300, 0.08, 1)
				PingFill.Size = UDim2.new(norm, 0, 1, 0)
				PingText.Text = "Ping: " .. math.floor(p) .. " ms"
			end)
		end
	end)

	local ThemeRow = createFrame(ProfileCard, {
		Name = "ThemeRow",
		Size = UDim2.new(0, 120, 0, 18),
		Position = UDim2.new(1, -122, 0, 64),
		BackgroundTransparency = 1,
	})

	local themeOrder = {"Midnight", "Neon", "Sunset", "Violet"}

	local function addThemeSwatch(themeKey)
		local sw = createTextButton(ThemeRow, {
			Name = "Theme_" .. themeKey,
			Text = "",
			BackgroundColor3 = THEMES[themeKey].Accent,
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(0, (#ThemeRow:GetChildren() - 1) * 18, 0, 1),
		})
		createCorner(sw, 999)
		sw.MouseButton1Click:Connect(function()
			WindowObj:ApplyTheme(themeKey)
		end)
		return sw
	end

	for _, key in ipairs(themeOrder) do
		addThemeSwatch(key)
	end

	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Name = "Sidebar"
	Sidebar.Parent = MainFrame
	Sidebar.Position = UDim2.new(0, 10, 0, 154)
	Sidebar.Size = UDim2.new(0, 160, 1, -164)
	Sidebar.BackgroundTransparency = 1
	Sidebar.ScrollBarThickness = 2
	Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Sidebar.BorderSizePixel = 0
	Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)

	local SideLayout = Instance.new("UIListLayout")
	SideLayout.Parent = Sidebar
	SideLayout.Padding = UDim.new(0, 8)

	local ContentArea = createFrame(MainFrame, {
		Name = "ContentArea",
		Size = UDim2.new(1, -182, 1, -164),
		Position = UDim2.new(0, 176, 0, 154),
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.04,
	})
	createCorner(ContentArea, 14)
	createStroke(ContentArea, theme.Line, 1, 0.3)

	local MusicBar = createFrame(MainFrame, {
		Name = "MusicBar",
		Size = UDim2.new(1, -20, 0, 44),
		Position = UDim2.new(0, 10, 1, -54),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.06,
	})
	createCorner(MusicBar, 12)
	createStroke(MusicBar, theme.Line, 1, 0.35)

	local MusicText = createTextLabel(MusicBar, {
		Name = "MusicText",
		Text = "♫ Now Playing: Session Boost",
		TextColor3 = theme.Text,
		TextSize = 10,
		Font = Enum.Font.GothamBold,
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(0, 200, 1, 0),
	})

	local eqHolder = createFrame(MusicBar, {
		Name = "eqHolder",
		Size = UDim2.new(0, 120, 0, 18),
		Position = UDim2.new(1, -138, 0.5, -9),
		BackgroundTransparency = 1,
	})
	for i = 1, 10 do
		local bar = createFrame(eqHolder, {
			Name = "eq_" .. i,
			Size = UDim2.new(0, 8, 0, 10 + (i * 3) % 12),
			Position = UDim2.new(0, (i - 1) * 11, 1, -12),
			BackgroundColor3 = theme.Accent,
			BackgroundTransparency = 0.2,
		})
		createCorner(bar, 999)
		local tween = TweenService:Create(bar, TweenInfo.new(0.45 + i * 0.03, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Size = UDim2.new(0, 8, 0, 8 + (i * 2) % 15)
		})
		tween:Play()
	end

	local MusicToggle = createTextButton(MusicBar, {
		Name = "MusicToggle",
		Text = "■",
		TextColor3 = theme.Text,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = theme.Header,
		Size = UDim2.new(0, 28, 0, 28),
		Position = UDim2.new(1, -38, 0.5, -14),
	})
	createCorner(MusicToggle, 8)

	local WindowObj = {
		Theme = theme,
		ThemeName = themeKey,
		TabFrames = {},
		TabButtons = {},
		FirstTabSet = false,
		NotifHolder = NotifHolder,
	}

	function WindowObj:ApplyTheme(newThemeName)
		local selected = THEMES[(THEME_ALIASES[newThemeName] or newThemeName) or "Midnight"] or THEMES.Midnight
		self.Theme = selected
		self.ThemeName = newThemeName

		MainFrame.BackgroundColor3 = selected.Bg
		TopBar.BackgroundColor3 = selected.Header
		ProfileCard.BackgroundColor3 = selected.Card
		ContentArea.BackgroundColor3 = selected.Bg2
		MusicBar.BackgroundColor3 = selected.Card
		TitleLabel.TextColor3 = selected.Accent
		NameLabel.TextColor3 = selected.Accent
		StatusBadge.TextColor3 = selected.Success
		StatusText.TextColor3 = selected.SubText
		StatusBadge.BackgroundColor3 = selected.Header
		PingFill.BackgroundColor3 = selected.Accent
		MusicText.TextColor3 = selected.Text

		for _, btn in pairs(self.TabButtons) do
			btn.TextColor3 = selected.SubText
		end

		for _, frame in pairs(self.TabFrames) do
			frame.Visible = false
		end

		if self.TabButtons and next(self.TabButtons) then
			local firstKey = nil
			for k, _ in pairs(self.TabButtons) do
				firstKey = k
				break
			end
			if firstKey then
				self.TabButtons[firstKey].TextColor3 = selected.Accent
			end
		end
	end

	function WindowObj:Notify(arg1, arg2, arg3, arg4)
		local kind = "Info"
		local title = "Info"
		local text = ""
		local duration = 3

		if arg4 ~= nil then
			kind = tostring(arg1)
			title = tostring(arg2)
			text = tostring(arg3)
			duration = tonumber(arg4) or 3
		elseif arg3 ~= nil and type(arg3) == "number" then
			title = tostring(arg1)
			text = tostring(arg2)
			duration = tonumber(arg3) or 3
		elseif arg2 ~= nil and type(arg2) == "number" then
			title = tostring(arg1)
			text = tostring(arg2)
			duration = tonumber(arg2) or 3
		elseif arg2 ~= nil then
			title = tostring(arg1)
			text = tostring(arg2)
		end

		if tostring(arg1) == "Info" or tostring(arg1) == "Success" or tostring(arg1) == "Warning" or tostring(arg1) == "Error" then
			kind = tostring(arg1)
			if arg2 ~= nil and arg3 ~= nil and arg4 ~= nil then
				title = tostring(arg2)
				text = tostring(arg3)
				duration = tonumber(arg4) or 3
			elseif arg2 ~= nil and arg3 ~= nil then
				title = tostring(arg2)
				text = tostring(arg3)
				duration = 3
			end
		end

		local palette = {
			Info = self.Theme.Accent,
			Success = self.Theme.Success,
			Warning = self.Theme.Warning,
			Error = self.Theme.Danger,
		}

		local toast = createFrame(self.NotifHolder, {
			Name = "Toast",
			Size = UDim2.new(1, 0, 0, 70),
			BackgroundColor3 = self.Theme.Card,
			BackgroundTransparency = 0.08,
		})
		createCorner(toast, 12)
		createStroke(toast, palette[kind] or palette.Info, 1.1, 0.4)

		local accent = createFrame(toast, {
			Name = "AccentBar",
			Size = UDim2.new(0, 4, 1, 0),
			BackgroundColor3 = palette[kind] or palette.Info,
		})
		createCorner(accent, 12)

		createTextLabel(toast, {
			Name = "T1",
			Text = title,
			TextColor3 = self.Theme.Text,
			TextSize = 12,
			Font = Enum.Font.GothamBlack,
			Position = UDim2.new(0, 14, 0, 8),
			Size = UDim2.new(1, -28, 0, 18),
		})

		createTextLabel(toast, {
			Name = "T2",
			Text = text,
			TextColor3 = self.Theme.SubText,
			TextSize = 10,
			Font = Enum.Font.Gotham,
			Position = UDim2.new(0, 14, 0, 28),
			Size = UDim2.new(1, -28, 0, 26),
			TextWrapped = true,
		})

		task.delay(duration, function()
			pcall(function()
				TweenService:Create(toast, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 1
				}):Play()
				task.wait(0.25)
				toast:Destroy()
			end)
		end)
	end

	function WindowObj:CreateTab(name, icon)
		local tabBtn = createTextButton(Sidebar, {
			Name = "Tab_" .. name,
			Text = "  " .. icon .. "  " .. name,
			TextColor3 = self.Theme.SubText,
			TextSize = 12,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = self.Theme.Card,
			BackgroundTransparency = 0.15,
			Size = UDim2.new(1, -8, 0, 38),
		})
		createCorner(tabBtn, 10)
		setHover(tabBtn, self.Theme.Card, self.Theme.CardAlt, 0.15, 0.05)

		local scroll = Instance.new("ScrollingFrame")
		scroll.Name = "TabScroll_" .. name
		scroll.Parent = ContentArea
		scroll.Size = UDim2.new(1, -8, 1, -8)
		scroll.Position = UDim2.new(0, 4, 0, 4)
		scroll.BackgroundTransparency = 1
		scroll.BorderSizePixel = 0
		scroll.ScrollBarThickness = 3
		scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scroll.Visible = false
		scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

		local list = Instance.new("UIListLayout")
		list.Parent = scroll
		list.Padding = UDim.new(0, 8)

		self.TabFrames[name] = scroll
		self.TabButtons[name] = tabBtn

		if not self.FirstTabSet then
			scroll.Visible = true
			tabBtn.BackgroundTransparency = 0.05
			tabBtn.TextColor3 = self.Theme.Accent
			self.FirstTabSet = true
		end

		tabBtn.MouseButton1Click:Connect(function()
			for tabName, frame in pairs(self.TabFrames) do
				frame.Visible = (tabName == name)
			end

			for _, btn in pairs(self.TabButtons) do
				btn.BackgroundTransparency = 0.15
				btn.TextColor3 = self.Theme.SubText
			end

			tabBtn.BackgroundTransparency = 0.05
			tabBtn.TextColor3 = self.Theme.Accent
		end)

		local TabObj = { Container = scroll }

		function TabObj:AddSection(text)
			createTextLabel(scroll, {
				Name = "Section",
				Text = "— " .. text .. " —",
				TextColor3 = self.Theme.SubText,
				TextSize = 10,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 22),
				TextXAlignment = Enum.TextXAlignment.Center,
			})
		end

		function TabObj:AddLabel(text)
			createTextLabel(scroll, {
				Name = "Label",
				Text = "  " .. text,
				TextColor3 = self.Theme.SubText,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 22),
				TextXAlignment = Enum.TextXAlignment.Left,
			})
		end

		function TabObj:AddInfoCard(title, value)
			local card = createFrame(scroll, {
				Name = "InfoCard",
				Size = UDim2.new(1, 0, 0, 62),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.12,
			})
			createCorner(card, 10)
			createStroke(card, self.Theme.Line, 1, 0.35)

			createTextLabel(card, {
				Name = "Title",
				Text = title,
				TextColor3 = self.Theme.SubText,
				TextSize = 10,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 12, 0, 9),
				Size = UDim2.new(1, -24, 0, 16),
			})

			createTextLabel(card, {
				Name = "Value",
				Text = value,
				TextColor3 = self.Theme.Accent,
				TextSize = 15,
				Font = Enum.Font.GothamBlack,
				Position = UDim2.new(0, 12, 0, 26),
				Size = UDim2.new(1, -24, 0, 20),
			})

			return card
		end

		function TabObj:AddButton(text, callback)
			local btn = createTextButton(scroll, {
				Name = "ActionButton",
				Text = "  " .. text,
				TextColor3 = self.Theme.Text,
				TextSize = 12,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.12,
				Size = UDim2.new(1, 0, 0, 38),
			})
			createCorner(btn, 9)
			setHover(btn, self.Theme.Card, self.Theme.CardAlt, 0.12, 0.05)

			btn.MouseButton1Click:Connect(function()
				pcall(callback)
			end)

			return btn
		end

		function TabObj:AddToggle(text, defaultState, callback)
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
				Size = UDim2.new(1, 0, 0, 40),
			})
			createCorner(btn, 9)
			setHover(btn, self.Theme.Card, self.Theme.CardAlt, 0.12, 0.05)

			local toggleBg = createFrame(btn, {
				Name = "ToggleBg",
				Size = UDim2.new(0, 46, 0, 24),
				Position = UDim2.new(1, -54, 0.5, -12),
				BackgroundColor3 = state and self.Theme.Accent or Color3.fromRGB(42, 45, 54),
			})
			createCorner(toggleBg, 999)

			local knob = createFrame(toggleBg, {
				Name = "ToggleKnob",
				Size = UDim2.new(0, 18, 0, 18),
				Position = state and UDim2.new(1, -18, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
				BackgroundColor3 = state and Color3.fromRGB(14, 16, 22) or Color3.fromRGB(200, 200, 200),
			})
			createCorner(knob, 999)

			btn.MouseButton1Click:Connect(function()
				state = not state
				TweenService:Create(toggleBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = state and self.Theme.Accent or Color3.fromRGB(42, 45, 54)
				}):Play()

				TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = state and UDim2.new(1, -18, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
					BackgroundColor3 = state and Color3.fromRGB(14, 16, 22) or Color3.fromRGB(200, 200, 200)
				}):Play()

				pcall(callback, state)
			end)

			return btn
		end

		function TabObj:AddTextBox(placeholder, defaultText, callback)
			local box = createTextBox(scroll, {
				Name = "InputBox",
				Text = defaultText or "",
				TextColor3 = self.Theme.Text,
				TextSize = 12,
				Font = Enum.Font.Gotham,
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.1,
				Size = UDim2.new(1, 0, 0, 38),
				PlaceholderText = placeholder,
				PlaceholderColor3 = self.Theme.SubText,
				ClearTextOnFocus = false,
			})
			createCorner(box, 9)

			box.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					pcall(callback, box.Text)
				end
			end)

			return box
		end

		function TabObj:AddSlider(text, minValue, maxValue, currentValue, callback)
			currentValue = clamp(currentValue or minValue, minValue, maxValue)

			local frame = createFrame(scroll, {
				Name = "SliderFrame",
				Size = UDim2.new(1, 0, 0, 54),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.12,
			})
			createCorner(frame, 10)

			local label = createTextLabel(frame, {
				Name = "SliderLabel",
				Text = "  " .. text .. ": " .. tostring(currentValue),
				TextColor3 = self.Theme.Text,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 10, 0, 6),
				Size = UDim2.new(1, -20, 0, 18),
			})

			local bar = createFrame(frame, {
				Name = "SliderBar",
				Size = UDim2.new(1, -20, 0, 6),
				Position = UDim2.new(0, 10, 0, 32),
				BackgroundColor3 = self.Theme.Header,
			})
			createCorner(bar, 999)

			local fill = createFrame(bar, {
				Name = "FillBar",
				Size = UDim2.new((currentValue - minValue) / (maxValue - minValue), 0, 1, 0),
				BackgroundColor3 = self.Theme.Accent,
			})
			createCorner(fill, 999)

			local dragging = false
			bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
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

		function TabObj:AddDropdown(text, options, callback)
			options = options or {}
			local open = false

			local drop = createFrame(scroll, {
				Name = "DropdownFrame",
				Size = UDim2.new(1, 0, 0, 38),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.12,
			})
			createCorner(drop, 10)

			local mainBtn = createTextButton(drop, {
				Name = "DropdownToggle",
				Text = "  " .. text .. ": Select...",
				TextColor3 = self.Theme.Text,
				TextSize = 12,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 38),
			})

			local listFrame = createFrame(drop, {
				Name = "DropdownList",
				Size = UDim2.new(1, 0, 0, #options * 32),
				Position = UDim2.new(0, 0, 0, 38),
				BackgroundTransparency = 1,
			})
			local listLayout = Instance.new("UIListLayout")
			listLayout.Parent = listFrame
			listLayout.Padding = UDim.new(0, 2)

			for _, opt in ipairs(options) do
				local optionBtn = createTextButton(listFrame, {
					Name = "Option",
					Text = "    • " .. tostring(opt),
					TextColor3 = self.Theme.SubText,
					TextSize = 11,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundColor3 = self.Theme.Header,
					BackgroundTransparency = 0.2,
					Size = UDim2.new(1, 0, 0, 30),
				})
				createCorner(optionBtn, 6)

				optionBtn.MouseButton1Click:Connect(function()
					open = false
					mainBtn.Text = "  " .. text .. ": " .. tostring(opt)
					TweenService:Create(drop, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, 0, 0, 38)
					}):Play()
					pcall(callback, opt)
				end)
			end

			mainBtn.MouseButton1Click:Connect(function()
				open = not open
				local targetHeight = open and (38 + (#options * 32)) or 38
				TweenService:Create(drop, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(1, 0, 0, targetHeight)
				}):Play()
			end)

			return drop
		end

		function TabObj:AddStatusPill(text, color)
			local pill = createTextLabel(scroll, {
				Name = "StatusPill",
				Text = text,
				TextColor3 = color or self.Theme.Accent,
				TextSize = 9,
				Font = Enum.Font.GothamBold,
				BackgroundColor3 = color or self.Theme.Card,
				BackgroundTransparency = 0.08,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 72, 0, 22),
				TextXAlignment = Enum.TextXAlignment.Center,
			})
			createCorner(pill, 999)
			createStroke(pill, color or self.Theme.Line, 1, 0.3)
			return pill
		end

		function TabObj:AddKeybind(text, defaultKeyCode, callback)
			local selectedKey = defaultKeyCode or Enum.KeyCode.Insert
			local bindBtn = createTextButton(scroll, {
				Name = "KeybindButton",
				Text = "  " .. text .. ": " .. selectedKey.Name,
				TextColor3 = self.Theme.Text,
				TextSize = 12,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.12,
				Size = UDim2.new(1, 0, 0, 38),
			})
			createCorner(bindBtn, 9)
			setHover(bindBtn, self.Theme.Card, self.Theme.CardAlt, 0.12, 0.05)

			local listening = false
			local bindConnection

			bindBtn.MouseButton1Click:Connect(function()
				listening = true
				bindBtn.Text = "  " .. text .. ": Press any key..."
				if bindConnection then bindConnection:Disconnect() end

				bindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
					if gameProcessed or not listening then return end
					if input.KeyCode then
						selectedKey = input.KeyCode
						listening = false
						bindBtn.Text = "  " .. text .. ": " .. selectedKey.Name
						if callback then pcall(callback, selectedKey) end
						if bindConnection then bindConnection:Disconnect() end
					end
				end)
			end)

			return bindBtn
		end

		function TabObj:AddColorPicker(text, defaultColor, callback)
			local currentColor = defaultColor or Color3.fromRGB(255, 255, 255)
			local palette = {
				Color3.fromRGB(255, 255, 255),
				Color3.fromRGB(255, 100, 100),
				Color3.fromRGB(90, 255, 160),
				Color3.fromRGB(100, 180, 255),
				Color3.fromRGB(190, 120, 255),
				Color3.fromRGB(255, 200, 90),
			}
			local index = 1

			local btn = createTextButton(scroll, {
				Name = "ColorPicker",
				Text = "  " .. text .. ":",
				TextColor3 = self.Theme.Text,
				TextSize = 12,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.12,
				Size = UDim2.new(1, 0, 0, 38),
			})
			createCorner(btn, 9)
			setHover(btn, self.Theme.Card, self.Theme.CardAlt, 0.12, 0.05)

			local swatch = createFrame(btn, {
				Name = "Swatch",
				Size = UDim2.new(0, 22, 0, 22),
				Position = UDim2.new(1, -30, 0.5, -11),
				BackgroundColor3 = currentColor,
			})
			createCorner(swatch, 6)

			local function updateDisplay()
				swatch.BackgroundColor3 = currentColor
				btn.Text = "  " .. text .. ": " .. string.format("RGB(%d,%d,%d)", math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255))
			end
			updateDisplay()

			btn.MouseButton1Click:Connect(function()
				index = index % #palette + 1
				currentColor = palette[index]
				updateDisplay()
				pcall(callback, currentColor)
			end)

			return btn
		end

		return TabObj
	end

	ToggleBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
	end)

	MusicToggle.MouseButton1Click:Connect(function()
		MusicText.Text = MusicText.Text == "♫ Now Playing: Session Boost" and "♫ Now Playing: Focus Flow" or "♫ Now Playing: Session Boost"
	end)

	return WindowObj
end

return MofenkUI
