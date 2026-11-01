--[====================================================================]
-- MofenkUI - Premium Executor Dashboard (PC + Mobile Friendly)
-- Modern blackglass + neon theme + smooth motion + advanced integrated UI
--[====================================================================]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local MofenkUI = {}

local THEMES = {
	Midnight = {
		Bg = Color3.fromRGB(9, 10, 15),
		Bg2 = Color3.fromRGB(17, 19, 26),
		Card = Color3.fromRGB(22, 25, 33),
		CardAlt = Color3.fromRGB(28, 32, 40),
		Header = Color3.fromRGB(14, 16, 22),
		Accent = Color3.fromRGB(255, 255, 255),
		AccentSoft = Color3.fromRGB(174, 214, 255),
		Text = Color3.fromRGB(245, 247, 255),
		SubText = Color3.fromRGB(165, 176, 204),
		Muted = Color3.fromRGB(118, 128, 150),
		Success = Color3.fromRGB(118, 255, 166),
		Warning = Color3.fromRGB(255, 203, 110),
		Danger = Color3.fromRGB(255, 112, 112),
		Line = Color3.fromRGB(255, 255, 255),
		Glow = Color3.fromRGB(255, 255, 255),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Neon = {
		Bg = Color3.fromRGB(7, 12, 18),
		Bg2 = Color3.fromRGB(18, 28, 38),
		Card = Color3.fromRGB(18, 24, 31),
		CardAlt = Color3.fromRGB(24, 34, 42),
		Header = Color3.fromRGB(12, 17, 24),
		Accent = Color3.fromRGB(64, 255, 220),
		AccentSoft = Color3.fromRGB(120, 255, 219),
		Text = Color3.fromRGB(232, 255, 252),
		SubText = Color3.fromRGB(148, 217, 211),
		Muted = Color3.fromRGB(124, 172, 167),
		Success = Color3.fromRGB(70, 255, 170),
		Warning = Color3.fromRGB(255, 201, 95),
		Danger = Color3.fromRGB(255, 121, 134),
		Line = Color3.fromRGB(64, 255, 220),
		Glow = Color3.fromRGB(64, 255, 220),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Sunset = {
		Bg = Color3.fromRGB(23, 15, 18),
		Bg2 = Color3.fromRGB(38, 23, 27),
		Card = Color3.fromRGB(41, 28, 27),
		CardAlt = Color3.fromRGB(52, 35, 32),
		Header = Color3.fromRGB(26, 18, 21),
		Accent = Color3.fromRGB(255, 160, 90),
		AccentSoft = Color3.fromRGB(255, 196, 122),
		Text = Color3.fromRGB(255, 242, 230),
		SubText = Color3.fromRGB(244, 178, 148),
		Muted = Color3.fromRGB(179, 128, 104),
		Success = Color3.fromRGB(120, 255, 188),
		Warning = Color3.fromRGB(255, 208, 103),
		Danger = Color3.fromRGB(255, 123, 118),
		Line = Color3.fromRGB(255, 160, 90),
		Glow = Color3.fromRGB(255, 160, 90),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Violet = {
		Bg = Color3.fromRGB(13, 11, 22),
		Bg2 = Color3.fromRGB(24, 20, 36),
		Card = Color3.fromRGB(25, 22, 38),
		CardAlt = Color3.fromRGB(34, 28, 52),
		Header = Color3.fromRGB(18, 16, 28),
		Accent = Color3.fromRGB(180, 120, 255),
		AccentSoft = Color3.fromRGB(213, 177, 255),
		Text = Color3.fromRGB(245, 238, 255),
		SubText = Color3.fromRGB(190, 176, 218),
		Muted = Color3.fromRGB(146, 124, 184),
		Success = Color3.fromRGB(90, 255, 176),
		Warning = Color3.fromRGB(255, 214, 111),
		Danger = Color3.fromRGB(255, 128, 128),
		Line = Color3.fromRGB(180, 120, 255),
		Glow = Color3.fromRGB(180, 120, 255),
		Shadow = Color3.fromRGB(0, 0, 0),
	}
}

local function createCorner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = instance
	return corner
end

local function createStroke(instance, color, thickness, transparency)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Color3.fromRGB(255, 255, 255)
	stroke.Thickness = thickness or 1
	stroke.Transparency = transparency or 0.4
	stroke.Parent = instance
	return stroke
end

local function createGradient(parent, colorA, colorB, rotation)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, colorA),
		ColorSequenceKeypoint.new(1, colorB or colorA),
	})
	g.Rotation = rotation or 90
	g.Parent = parent
	return g
end

local function setHover(button, baseColor, hoverColor, baseAlpha, hoverAlpha)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = hoverColor or baseColor,
			BackgroundTransparency = hoverAlpha or 0.08,
		}):Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = baseColor or button.BackgroundColor3,
			BackgroundTransparency = baseAlpha or 0.15,
		}):Play()
	end)
end

local function clamp(value, minValue, maxValue)
	return math.max(minValue, math.min(value, maxValue))
end

local function applyAnimatedGlow(parent, color)
	local glow = Instance.new("Frame")
	glow.Name = "Glow"
	glow.Parent = parent
	glow.Size = UDim2.new(1, 0, 1, 0)
	glow.BackgroundColor3 = color
	glow.BackgroundTransparency = 0.96
	glow.BorderSizePixel = 0
	glow.ZIndex = 0
	createGradient(glow, color, color, 90)
	return glow
end

local function createTextLabel(parent, props)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = props.BackgroundTransparency or 1
	label.BorderSizePixel = 0
	label.Font = props.Font or Enum.Font.GothamSemibold
	label.Text = props.Text or ""
	label.TextColor3 = props.TextColor3 or Color3.new(1, 1, 1)
	label.TextSize = props.TextSize or 12
	label.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	label.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
	label.Size = props.Size or UDim2.new(0, 100, 0, 20)
	label.Position = props.Position or UDim2.new()
	label.Parent = parent
	if props.AnchorPoint then label.AnchorPoint = props.AnchorPoint end
	if props.AutomaticSize then label.AutomaticSize = props.AutomaticSize end
	if props.TextScaled ~= nil then label.TextScaled = props.TextScaled end
	if props.TextWrapped ~= nil then label.TextWrapped = props.TextWrapped end
	if props.ZIndex then label.ZIndex = props.ZIndex end
	if props.Name then label.Name = props.Name end
	return label
end

local function createTextButton(parent, props)
	local btn = Instance.new("TextButton")
	btn.BackgroundColor3 = props.BackgroundColor3 or Color3.new(1, 1, 1)
	btn.BackgroundTransparency = props.BackgroundTransparency or 0
	btn.BorderSizePixel = 0
	btn.Font = props.Font or Enum.Font.GothamSemibold
	btn.Text = props.Text or ""
	btn.TextColor3 = props.TextColor3 or Color3.new(1, 1, 1)
	btn.TextSize = props.TextSize or 12
	btn.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center
	btn.Size = props.Size or UDim2.new(0, 100, 0, 24)
	btn.Position = props.Position or UDim2.new()
	btn.AutoButtonColor = false
	btn.Parent = parent
	if props.AnchorPoint then btn.AnchorPoint = props.AnchorPoint end
	if props.ZIndex then btn.ZIndex = props.ZIndex end
	if props.Name then btn.Name = props.Name end
	if props.ClipsDescendants ~= nil then btn.ClipsDescendants = props.ClipsDescendants end
	if props.TextScaled ~= nil then btn.TextScaled = props.TextScaled end
	return btn
end

local function createFrame(parent, props)
	local f = Instance.new("Frame")
	f.BackgroundColor3 = props.BackgroundColor3 or Color3.new(1, 1, 1)
	f.BackgroundTransparency = props.BackgroundTransparency or 0
	f.BorderSizePixel = 0
	f.Size = props.Size or UDim2.new(0, 100, 0, 100)
	f.Position = props.Position or UDim2.new()
	f.Parent = parent
	if props.AnchorPoint then f.AnchorPoint = props.AnchorPoint end
	if props.ZIndex then f.ZIndex = props.ZIndex end
	if props.Name then f.Name = props.Name end
	if props.ClipsDescendants ~= nil then f.ClipsDescendants = props.ClipsDescendants end
	return f
end

local function createImageLabel(parent, props)
	local img = Instance.new("ImageLabel")
	img.BackgroundTransparency = props.BackgroundTransparency or 1
	img.BorderSizePixel = 0
	img.Size = props.Size or UDim2.new(0, 100, 0, 100)
	img.Position = props.Position or UDim2.new()
	img.Image = props.Image or ""
	img.Parent = parent
	if props.AnchorPoint then img.AnchorPoint = props.AnchorPoint end
	if props.Name then img.Name = props.Name end
	if props.ScaleType then img.ScaleType = props.ScaleType end
	return img
end

function MofenkUI.CreateWindow(config)
	config = config or {}
	local titleText = config.Name or "MofenkHub"
	local toggleStyle = config.ToggleStyle or "Icon"
	local profileTitle = config.ProfileTitle or "Executor Premium"
	local initialTheme = config.Theme or "Midnight"

	pcall(function()
		for _, v in ipairs(PlayerGui:GetChildren()) do
			if string.find(v.Name, "Mofenk") then
				v:Destroy()
			end
		end
		for _, v in ipairs(CoreGui:GetChildren()) do
			if string.find(v.Name, "Mofenk") then
				v:Destroy()
			end
		end
	end)

	local themeState = {
		current = THEMES[initialTheme] and initialTheme or "Midnight",
		refs = {},
	}

	local function tintSet(obj, propName, value)
		if obj and obj[propName] then
			obj[propName] = value
		end
	end

	local function registerThemeObj(obj, key)
		if obj then
			table.insert(themeState.refs, {obj = obj, key = key})
		end
	end

	local function applyTheme(themeName)
		local selected = THEMES[themeName] or THEMES.Midnight
		if not selected then return end
		themeState.current = themeName

		for _, entry in ipairs(themeState.refs) do
			local obj = entry.obj
			local key = entry.key
			if obj and obj.Parent then
				if key == "Bg" then obj.BackgroundColor3 = selected.Bg end
				if key == "Bg2" then obj.BackgroundColor3 = selected.Bg2 end
				if key == "Card" then obj.BackgroundColor3 = selected.Card end
				if key == "CardAlt" then obj.BackgroundColor3 = selected.CardAlt end
				if key == "Header" then obj.BackgroundColor3 = selected.Header end
				if key == "Accent" then obj.BackgroundColor3 = selected.Accent end
				if key == "Text" then obj.TextColor3 = selected.Text end
				if key == "SubText" then obj.TextColor3 = selected.SubText end
				if key == "Line" then obj.BackgroundColor3 = selected.Line end
				if key == "Success" then obj.BackgroundColor3 = selected.Success end
				if key == "Warning" then obj.BackgroundColor3 = selected.Warning end
				if key == "Danger" then obj.BackgroundColor3 = selected.Danger end
				if key == "Stroke" then
					if obj:IsA("UIStroke") then
						obj.Color = selected.Line
					end
				end
			end
		end
	end

		if ToggleBtn then ToggleBtn.BackgroundColor3 = selected.Card end
		if MainFrame then MainFrame.BackgroundColor3 = selected.Bg end
		if TopBar then TopBar.BackgroundColor3 = selected.Header end
		if ProfileCard then ProfileCard.BackgroundColor3 = selected.Card end
		if ContentArea then ContentArea.BackgroundColor3 = selected.Bg2 end
		if Sidebar then Sidebar.BackgroundColor3 = selected.Bg2 end
		if MinimizeBtn then MinimizeBtn.BackgroundColor3 = selected.Card end
		if CloseBtn then CloseBtn.BackgroundColor3 = selected.Card end
		if Title then Title.TextColor3 = selected.Accent end
		if StatusBadge then StatusBadge.BackgroundColor3 = selected.Header end
		if NotifHolder then NotifHolder.BackgroundColor3 = selected.Bg end
	end

	local NotifGui = Instance.new("ScreenGui")
	NotifGui.Name = "MofenkNotifications"
	NotifGui.Parent = PlayerGui
	NotifGui.ResetOnSpawn = false
	NotifGui.DisplayOrder = 1000000

	local NotifHolder = createFrame(NotifGui, {
		Size = UDim2.new(0, 310, 0, 420),
		Position = UDim2.new(1, -330, 1, -50),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
	})
	NotifHolder.Name = "ToastHolder"

	local NotifLayout = Instance.new("UIListLayout")
	NotifLayout.Parent = NotifHolder
	NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	NotifLayout.Padding = UDim.new(0, 8)

	local ToggleGui = Instance.new("ScreenGui")
	ToggleGui.Name = "MofenkToggleFront"
	ToggleGui.Parent = PlayerGui
	ToggleGui.ResetOnSpawn = false
	ToggleGui.DisplayOrder = 999999

	local ToggleBtn = createTextButton(ToggleGui, {
		Name = "ToggleBtn",
		Text = toggleStyle == "Bar" and "  ⚡ MofenkHub  " or "M",
		TextSize = toggleStyle == "Bar" and 12 or 22,
		TextColor3 = THEMES[initialTheme].Accent,
		BackgroundColor3 = THEMES[initialTheme].Card,
		BackgroundTransparency = 0.08,
		Size = toggleStyle == "Bar" and UDim2.new(0, 138, 0, 38) or UDim2.new(0, 54, 0, 54),
		Position = toggleStyle == "Bar" and UDim2.new(0.5, -69, 0, 12) or UDim2.new(0.03, 0, 0.35, 0),
		TextXAlignment = toggleStyle == "Bar" and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
		Font = Enum.Font.GothamBlack,
		ClipsDescendants = true,
	})
	createCorner(ToggleBtn, 14)
	createStroke(ToggleBtn, THEMES[initialTheme].Line, 1.2, 0.25)
	applyAnimatedGlow(ToggleBtn, THEMES[initialTheme].Accent)

	local dragState = {isDragging = false, startPosition = Vector2.zero, startBtnPos = UDim2.new()}
	ToggleBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragState.isDragging = true
			dragState.startPosition = input.Position
			dragState.startBtnPos = ToggleBtn.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragState.isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragState.startPosition
			local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
			ToggleBtn.Position = UDim2.new(
				0,
				clamp(dragState.startBtnPos.X.Offset + delta.X, 10, viewport.X - (toggleStyle == "Bar" and 170 or 80)),
				0,
				clamp(dragState.startBtnPos.Y.Offset + delta.Y, 10, viewport.Y - 90)
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragState.isDragging = false
		end
	end)

	local MainGui = Instance.new("ScreenGui")
	MainGui.Name = "MofenkUltraHubV2"
	MainGui.Parent = PlayerGui
	MainGui.ResetOnSpawn = false
	MainGui.DisplayOrder = 999998

	local MainFrame = createFrame(MainGui, {
		Name = "MainFrame",
		Size = UDim2.new(0, 620, 0, 430),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = THEMES[initialTheme].Bg,
		BackgroundTransparency = 0.02,
	})
	createCorner(MainFrame, 16)
	createStroke(MainFrame, THEMES[initialTheme].Line, 1.2, 0.28)

	local MainGloss = Instance.new("Frame")
	MainGloss.Parent = MainFrame
	MainGloss.Size = UDim2.new(1, 0, 1, 0)
	MainGloss.BackgroundTransparency = 1
	MainGloss.BorderSizePixel = 0
	MainGloss.ZIndex = 0
	createGradient(MainGloss, Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255), 0)
	local glossTween = Instance.new("UIGradient")
	glossTween.Parent = MainGloss
	glossTween.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
	})
	glossTween.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.9),
		NumberSequenceKeypoint.new(1, 1),
	})
	glossTween.Rotation = 90

	local TopBar = createFrame(MainFrame, {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 48),
		BackgroundColor3 = THEMES[initialTheme].Header,
		BackgroundTransparency = 0.12,
	})
	createCorner(TopBar, 16)
	applyAnimatedGlow(TopBar, THEMES[initialTheme].Accent)

	local logoOrb = createFrame(TopBar, {
		Name = "LogoOrb",
		Size = UDim2.new(0, 20, 0, 20),
		Position = UDim2.new(0, 14, 0, 14),
		BackgroundColor3 = THEMES[initialTheme].Accent,
	})
	createCorner(logoOrb, 10)
	createStroke(logoOrb, THEMES[initialTheme].Accent, 1, 0)

	local logoPulse = createFrame(logoOrb, {
		Size = UDim2.new(1, 10, 1, 10),
		Position = UDim2.new(0, -5, 0, -5),
		BackgroundColor3 = THEMES[initialTheme].Accent,
		BackgroundTransparency = 0.65,
	})
	createCorner(logoPulse, 999)

	local logoText = createTextLabel(TopBar, {
		Name = "LogoLabel",
		Size = UDim2.new(0, 250, 1, 0),
		Position = UDim2.new(0, 42, 0, 0),
		Text = "⚡ " .. titleText,
		TextColor3 = THEMES[initialTheme].Accent,
		TextSize = 14,
		Font = Enum.Font.GothamBlack,
	})

	local TitleDot = createFrame(TopBar, {
		Name = "TitleDot",
		Size = UDim2.new(0, 8, 0, 8),
		Position = UDim2.new(0, 16, 0, 20),
		BackgroundColor3 = THEMES[initialTheme].Success,
	})
	createCorner(TitleDot, 999)

	local MinimizeBtn = createTextButton(TopBar, {
		Name = "MinimizeBtn",
		Text = "—",
		TextColor3 = THEMES[initialTheme].Text,
		TextSize = 16,
		Size = UDim2.new(0, 28, 0, 28),
		Position = UDim2.new(1, -72, 0, 10),
		BackgroundColor3 = THEMES[initialTheme].Card,
		BackgroundTransparency = 0.18,
		Font = Enum.Font.GothamBold,
	})
	createCorner(MinimizeBtn, 8)
	setHover(MinimizeBtn, THEMES[initialTheme].Card, THEMES[initialTheme].CardAlt, 0.18, 0.08)

	local CloseBtn = createTextButton(TopBar, {
		Name = "CloseBtn",
		Text = "✕",
		TextColor3 = THEMES[initialTheme].Text,
		TextSize = 13,
		Size = UDim2.new(0, 28, 0, 28),
		Position = UDim2.new(1, -36, 0, 10),
		BackgroundColor3 = THEMES[initialTheme].Card,
		BackgroundTransparency = 0.18,
		Font = Enum.Font.GothamBold,
	})
	createCorner(CloseBtn, 8)
	setHover(CloseBtn, THEMES[initialTheme].Card, THEMES[initialTheme].CardAlt, 0.18, 0.08)

	local minimized = false
	local origHeight = 430
	local function collapseWindow()
		minimized = not minimized
		if minimized then
			origHeight = MainFrame.AbsoluteSize.Y
			ProfileCard.Visible = false
			Sidebar.Visible = false
			ContentArea.Visible = false
			MusicBar.Visible = false
			TweenService:Create(MainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, 50),
			}):Play()
			MinimizeBtn.Text = "+"
		else
			ProfileCard.Visible = true
			Sidebar.Visible = true
			ContentArea.Visible = true
			MusicBar.Visible = true
			TweenService:Create(MainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, origHeight),
			}):Play()
			MinimizeBtn.Text = "—"
		end
	end

	MinimizeBtn.MouseButton1Click:Connect(collapseWindow)

	local ProfileCard = createFrame(MainFrame, {
		Name = "ProfileCard",
		Size = UDim2.new(1, -20, 0, 90),
		Position = UDim2.new(0, 10, 0, 56),
		BackgroundColor3 = THEMES[initialTheme].Card,
		BackgroundTransparency = 0.08,
	})
	createCorner(ProfileCard, 14)
	createStroke(ProfileCard, THEMES[initialTheme].Line, 1.1, 0.45)
	applyAnimatedGlow(ProfileCard, THEMES[initialTheme].Accent)

	local AvatarFrame = createImageLabel(ProfileCard, {
		Name = "AvatarFrame",
		Size = UDim2.new(0, 58, 0, 58),
		Position = UDim2.new(0, 12, 0, 16),
		Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
		BackgroundTransparency = 0,
		ScaleType = Enum.ScaleType.Crop,
	})
	createCorner(AvatarFrame, 999)
	createStroke(AvatarFrame, THEMES[initialTheme].Line, 1.5, 0.2)

	local AvatarStatus = createFrame(AvatarFrame, {
		Name = "AvatarStatus",
		Size = UDim2.new(0, 12, 0, 12),
		Position = UDim2.new(1, -6, 1, -6),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundColor3 = THEMES[initialTheme].Success,
	})
	createCorner(AvatarStatus, 999)
	createStroke(AvatarStatus, THEMES[initialTheme].Bg, 2, 0)

	local NameLabel = createTextLabel(ProfileCard, {
		Name = "NameLabel",
		Text = "👑 " .. LocalPlayer.Name .. " (" .. profileTitle .. ")",
		TextColor3 = THEMES[initialTheme].Accent,
		TextSize = 12,
		Position = UDim2.new(0, 82, 0, 18),
		Size = UDim2.new(1, -210, 0, 18),
		Font = Enum.Font.GothamBlack,
	})

	local StatusBadge = createTextLabel(ProfileCard, {
		Name = "StatusBadge",
		Text = "ONLINE",
		TextColor3 = THEMES[initialTheme].Success,
		TextSize = 9,
		Position = UDim2.new(1, -96, 0, 18),
		Size = UDim2.new(0, 84, 0, 18),
		BackgroundTransparency = 0,
		BackgroundColor3 = THEMES[initialTheme].Header,
		TextXAlignment = Enum.TextXAlignment.Center,
		Font = Enum.Font.GothamBold,
	})
	createCorner(StatusBadge, 999)
	createStroke(StatusBadge, THEMES[initialTheme].Success, 1, 0.4)

	local StatusLabel = createTextLabel(ProfileCard, {
		Name = "StatusLabel",
		Text = "✨ Status: Secure & Connected",
		TextColor3 = THEMES[initialTheme].SubText,
		TextSize = 10,
		Position = UDim2.new(0, 82, 0, 42),
		Size = UDim2.new(1, -98, 0, 16),
		Font = Enum.Font.Gotham,
	})

	local PingBg = createFrame(ProfileCard, {
		Name = "PingBg",
		Size = UDim2.new(1, -98, 0, 8),
		Position = UDim2.new(0, 82, 0, 66),
		BackgroundColor3 = THEMES[initialTheme].Header,
	})
	createCorner(PingBg, 999)

	local PingFill = createFrame(PingBg, {
		Name = "PingFill",
		Size = UDim2.new(0.55, 0, 1, 0),
		BackgroundColor3 = THEMES[initialTheme].Accent,
	})
	createCorner(PingFill, 999)

	local PingText = createTextLabel(PingBg, {
		Name = "PingText",
		Text = "Ping: calculating...",
		TextColor3 = THEMES[initialTheme].Text,
		TextSize = 8,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Center,
		Font = Enum.Font.GothamBold,
		ZIndex = 10,
	})

	task.spawn(function()
		while task.wait(1) do
			pcall(function()
				local ping = tonumber(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) or 0
				local normalized = clamp(ping / 300, 0.08, 1)
				PingFill.Size = UDim2.new(normalized, 0, 1, 0)
				PingText.Text = "Ping: " .. math.floor(ping) .. " ms"
			end)
		end
	end)

	local ThemeSwatchRow = createFrame(ProfileCard, {
		Name = "ThemeSwatchRow",
		Size = UDim2.new(0, 120, 0, 20),
		Position = UDim2.new(1, -128, 0, 64),
		BackgroundTransparency = 1,
	})

	local function addSwatch(color, name)
		local sw = createTextButton(ThemeSwatchRow, {
			Name = "Swatch_" .. name,
			Text = "",
			BackgroundColor3 = color,
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(0, (#ThemeSwatchRow:GetChildren() - 1) * 18, 0, 2),
			BackgroundTransparency = 0,
		})
		createCorner(sw, 999)
		createStroke(sw, color, 1, 0.35)
		sw.MouseButton1Click:Connect(function()
			applyTheme(name)
		end)
		return sw
	end

	addSwatch(THEMES.Midnight.Accent, "Midnight")
	addSwatch(THEMES.Neon.Accent, "Neon")
	addSwatch(THEMES.Sunset.Accent, "Sunset")
	addSwatch(THEMES.Violet.Accent, "Violet")

	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Name = "Sidebar"
	Sidebar.Parent = MainFrame
	Sidebar.Position = UDim2.new(0, 10, 0, 154)
	Sidebar.Size = UDim2.new(0, 160, 1, -164)
	Sidebar.BackgroundTransparency = 1
	Sidebar.BorderSizePixel = 0
	Sidebar.ScrollBarThickness = 2
	Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Sidebar.ScrollBarImageColor3 = THEMES[initialTheme].SubText
	Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
	Sidebar.BackgroundColor3 = THEMES[initialTheme].Bg2

	local SideList = Instance.new("UIListLayout")
	SideList.Parent = Sidebar
	SideList.Padding = UDim.new(0, 8)
	SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local ContentArea = createFrame(MainFrame, {
		Name = "ContentArea",
		Size = UDim2.new(1, -182, 1, -164),
		Position = UDim2.new(0, 176, 0, 154),
		BackgroundColor3 = THEMES[initialTheme].Bg2,
		BackgroundTransparency = 0.04,
	})
	createCorner(ContentArea, 14)
	createStroke(ContentArea, THEMES[initialTheme].Line, 1, 0.38)

	local MusicBar = createFrame(MainFrame, {
		Name = "MusicBar",
		Size = UDim2.new(1, -20, 0, 44),
		Position = UDim2.new(0, 10, 1, -54),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = THEMES[initialTheme].Card,
		BackgroundTransparency = 0.06,
	})
	createCorner(MusicBar, 12)
	createStroke(MusicBar, THEMES[initialTheme].Line, 1, 0.35)

	local musicText = createTextLabel(MusicBar, {
		Text = "♫ Now Playing: Session Boost",
		TextColor3 = THEMES[initialTheme].Text,
		TextSize = 10,
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(0, 190, 1, 0),
		Font = Enum.Font.GothamBold,
	})

	local eqHolder = createFrame(MusicBar, {
		Size = UDim2.new(0, 122, 0, 18),
		Position = UDim2.new(1, -136, 0.5, -9),
		BackgroundTransparency = 1,
	})
	for i = 1, 10 do
		local bar = createFrame(eqHolder, {
			Size = UDim2.new(0, 8, 0, 10 + (i * 2) % 12),
			Position = UDim2.new(0, (i - 1) * 11, 1, -((10 + (i * 2) % 12))),
			BackgroundColor3 = THEMES[initialTheme].Accent,
			BackgroundTransparency = 0.2,
		})
		createCorner(bar, 999)
		local s = 0.5 + (i / 10)
		local pulse = TweenService:Create(bar, TweenInfo.new(0.45 + (i * 0.02), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Size = UDim2.new(0, 8, 0, (10 + (i * 3) % 15)),
		})
		pulse:Play()
	end

	local musicToggle = createTextButton(MusicBar, {
		Text = "■",
		TextColor3 = THEMES[initialTheme].Text,
		TextSize = 11,
		BackgroundColor3 = THEMES[initialTheme].Header,
		Size = UDim2.new(0, 28, 0, 28),
		Position = UDim2.new(1, -38, 0.5, -14),
		Font = Enum.Font.GothamBold,
	})
	createCorner(musicToggle, 8)
	musicToggle.MouseButton1Click:Connect(function()
		musicText.Text = musicText.Text == "♫ Now Playing: Session Boost" and "♫ Now Playing: Focus Flow" or "♫ Now Playing: Session Boost"
	end)

	local WindowObj = {
		TabFrames = {},
		TabButtons = {},
		Theme = THEMES[initialTheme],
		ThemeName = initialTheme,
		MainFrame = MainFrame,
		Sidebar = Sidebar,
		ContentArea = ContentArea,
		NotifHolder = NotifHolder,
	}

	function WindowObj:ApplyTheme(themeName)
		applyTheme(themeName)
		self.Theme = THEMES[themeName] or THEMES.Midnight
		self.ThemeName = themeName
	end

	function WindowObj:Notify(kind, title, text, duration)
		kind = kind or "Info"
		duration = duration or 3.2
		local colors = {
			Info = THEMES[themeState.current].Accent,
			Success = THEMES[themeState.current].Success,
			Warning = THEMES[themeState.current].Warning,
			Error = THEMES[themeState.current].Danger,
		}

		local toast = createFrame(NotifHolder, {
			Size = UDim2.new(1, 0, 0, 72),
			BackgroundColor3 = THEMES[themeState.current].Card,
			BackgroundTransparency = 0.06,
		})
		createCorner(toast, 12)
		createStroke(toast, colors[kind] or colors.Info, 1.1, 0.4)

		local accentBar = createFrame(toast, {
			Size = UDim2.new(0, 4, 1, 0),
			BackgroundColor3 = colors[kind] or colors.Info,
		})
		createCorner(accentBar, 12)

		local t1 = createTextLabel(toast, {
			Text = title,
			TextColor3 = THEMES[themeState.current].Text,
			TextSize = 12,
			Font = Enum.Font.GothamBlack,
			Position = UDim2.new(0, 14, 0, 8),
			Size = UDim2.new(1, -28, 0, 20),
		})

		local t2 = createTextLabel(toast, {
			Text = text,
			TextColor3 = THEMES[themeState.current].SubText,
			TextSize = 10,
			Font = Enum.Font.Gotham,
			Position = UDim2.new(0, 14, 0, 28),
			Size = UDim2.new(1, -28, 0, 28),
			TextWrapped = true,
		})

		local pulse = TweenService:Create(toast, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(toast.Position.X.Scale, toast.Position.X.Offset, toast.Position.Y.Scale, toast.Position.Y.Offset + 2),
		})
		pulse:Play()

		task.delay(duration, function()
			pcall(function()
				TweenService:Create(toast, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 1,
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
			TextColor3 = THEMES[themeState.current].SubText,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = THEMES[themeState.current].Card,
			BackgroundTransparency = 0.15,
			Size = UDim2.new(1, -8, 0, 38),
			Font = Enum.Font.GothamBold,
		})
		createCorner(tabBtn, 10)
		setHover(tabBtn, THEMES[themeState.current].Card, THEMES[themeState.current].CardAlt, 0.15, 0.05)

		local scroll = Instance.new("ScrollingFrame")
		scroll.Parent = ContentArea
		scroll.Name = "TabScroll_" .. name
		scroll.Size = UDim2.new(1, -8, 1, -8)
		scroll.Position = UDim2.new(0, 4, 0, 4)
		scroll.BackgroundTransparency = 1
		scroll.ScrollBarThickness = 3
		scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scroll.BorderSizePixel = 0
		scroll.Visible = false
		scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

		local list = Instance.new("UIListLayout")
		list.Parent = scroll
		list.Padding = UDim.new(0, 8)
		list.SortOrder = Enum.SortOrder.LayoutOrder

		self.TabFrames[name] = scroll
		self.TabButtons[name] = tabBtn

		if not self.FirstTabSet then
			scroll.Visible = true
			tabBtn.BackgroundTransparency = 0.05
			tabBtn.TextColor3 = THEMES[themeState.current].Accent
			self.FirstTabSet = true
		end

		tabBtn.MouseButton1Click:Connect(function()
			for tabName, frame in pairs(self.TabFrames) do
				frame.Visible = (tabName == name)
			end
			for _, btn in pairs(self.TabButtons) do
				btn.BackgroundTransparency = 0.15
				btn.TextColor3 = THEMES[themeState.current].SubText
			end
			tabBtn.BackgroundTransparency = 0.05
			tabBtn.TextColor3 = THEMES[themeState.current].Accent
		end)

		local TabObj = { Container = scroll }

		function TabObj:AddSection(text)
			local lbl = createTextLabel(scroll, {
				Text = "— " .. text .. " —",
				TextColor3 = THEMES[themeState.current].SubText,
				TextSize = 10,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 22),
				TextXAlignment = Enum.TextXAlignment.Center,
			})
			return lbl
		end

		function TabObj:AddLabel(text)
			local lbl = createTextLabel(scroll, {
				Text = "  " .. text,
				TextColor3 = THEMES[themeState.current].SubText,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 22),
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			return lbl
		end

		function TabObj:AddInfoCard(title, value)
			local card = createFrame(scroll, {
				Size = UDim2.new(1, 0, 0, 64),
				BackgroundColor3 = THEMES[themeState.current].Card,
				BackgroundTransparency = 0.12,
			})
			createCorner(card, 10)
			createStroke(card, THEMES[themeState.current].Line, 1, 0.4)

			createTextLabel(card, {
				Text = title,
				TextColor3 = THEMES[themeState.current].SubText,
				TextSize = 10,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 12, 0, 10),
				Size = UDim2.new(1, -24, 0, 16),
			})

			createTextLabel(card, {
				Text = value,
				TextColor3 = THEMES[themeState.current].Accent,
				TextSize = 15,
				Font = Enum.Font.GothamBlack,
				Position = UDim2.new(0, 12, 0, 26),
				Size = UDim2.new(1, -24, 0, 22),
			})
			return card
		end

		function TabObj:AddButton(text, callback)
			local btn = createTextButton(scroll, {
				Text = "  " .. text,
				TextColor3 = THEMES[themeState.current].Text,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = THEMES[themeState.current].Card,
				BackgroundTransparency = 0.12,
				Size = UDim2.new(1, 0, 0, 38),
				Font = Enum.Font.GothamBold,
			})
			createCorner(btn, 9)
			setHover(btn, THEMES[themeState.current].Card, THEMES[themeState.current].CardAlt, 0.12, 0.05)
			btn.MouseButton1Click:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Linear), {
					BackgroundTransparency = 0.04,
				}):Play()
				pcall(callback)
			end)
			return btn
		end

		function TabObj:AddToggle(text, defaultState, callback)
			local state = defaultState or false
			local btn = createTextButton(scroll, {
				Text = "  " .. text,
				TextColor3 = THEMES[themeState.current].Text,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = THEMES[themeState.current].Card,
				BackgroundTransparency = 0.12,
				Size = UDim2.new(1, 0, 0, 40),
				Font = Enum.Font.GothamBold,
			})
			createCorner(btn, 9)
			setHover(btn, THEMES[themeState.current].Card, THEMES[themeState.current].CardAlt, 0.12, 0.05)

			local toggleBg = createFrame(btn, {
				Size = UDim2.new(0, 46, 0, 24),
				Position = UDim2.new(1, -56, 0.5, -12),
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = state and THEMES[themeState.current].Accent or Color3.fromRGB(42, 45, 54),
			})
			createCorner(toggleBg, 999)

			local knob = createFrame(toggleBg, {
				Size = UDim2.new(0, 18, 0, 18),
				Position = state and UDim2.new(1, -18, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = state and Color3.fromRGB(14, 16, 22) or Color3.fromRGB(200, 200, 200),
			})
			createCorner(knob, 999)

			btn.MouseButton1Click:Connect(function()
				state = not state
				TweenService:Create(toggleBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = state and THEMES[themeState.current].Accent or Color3.fromRGB(42, 45, 54),
				}):Play()
				TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = state and UDim2.new(1, -18, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
					BackgroundColor3 = state and Color3.fromRGB(14, 16, 22) or Color3.fromRGB(200, 200, 200),
				}):Play()
				pcall(callback, state)
			end)

			return btn
		end

		function TabObj:AddTextBox(placeholder, defaultText, callback)
			local box = createTextButton(scroll, {
				Text = defaultText or "",
				TextColor3 = THEMES[themeState.current].Text,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = THEMES[themeState.current].Card,
				BackgroundTransparency = 0.10,
				Size = UDim2.new(1, 0, 0, 38),
				Font = Enum.Font.Gotham,
			})
			createCorner(box, 9)
			box.Text = defaultText or ""
			box.AutoButtonColor = false
			box.TextEditable = true
			box.TextWrapped = false
			box.ClearTextOnFocus = false
			box.PlaceholderText = placeholder
			box.PlaceholderColor3 = THEMES[themeState.current].SubText
			box.BorderSizePixel = 0
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
				Size = UDim2.new(1, 0, 0, 54),
				BackgroundColor3 = THEMES[themeState.current].Card,
				BackgroundTransparency = 0.12,
			})
			createCorner(frame, 10)

			local lbl = createTextLabel(frame, {
				Text = "  " .. text .. ": " .. tostring(currentValue),
				TextColor3 = THEMES[themeState.current].Text,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 10, 0, 6),
				Size = UDim2.new(1, -20, 0, 18),
			})

			local bar = createFrame(frame, {
				Size = UDim2.new(1, -20, 0, 6),
				Position = UDim2.new(0, 10, 0, 32),
				BackgroundColor3 = THEMES[themeState.current].Header,
			})
			createCorner(bar, 999)

			local fill = createFrame(bar, {
				Size = UDim2.new((currentValue - minValue) / (maxValue - minValue), 0, 1, 0),
				BackgroundColor3 = THEMES[themeState.current].Accent,
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
					lbl.Text = "  " .. text .. ": " .. tostring(val)
					pcall(callback, val)
				end
			end)

			return frame
		end

		function TabObj:AddDropdown(text, options, callback)
			options = options or {}
			local open = false
			local drop = createFrame(scroll, {
				Size = UDim2.new(1, 0, 0, 38),
				BackgroundColor3 = THEMES[themeState.current].Card,
				BackgroundTransparency = 0.12,
			})
			createCorner(drop, 10)

			local mainBtn = createTextButton(drop, {
				Text = "  " .. text .. ": Select...",
				TextColor3 = THEMES[themeState.current].Text,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 38),
				Font = Enum.Font.GothamBold,
			})

			local listFrame = createFrame(drop, {
				Size = UDim2.new(1, 0, 0, #options * 32),
				Position = UDim2.new(0, 0, 0, 38),
				BackgroundTransparency = 1,
			})
			local lay = Instance.new("UIListLayout")
			lay.Parent = listFrame
			lay.Padding = UDim.new(0, 2)

			for _, opt in ipairs(options) do
				local optBtn = createTextButton(listFrame, {
					Text = "    • " .. tostring(opt),
					TextColor3 = THEMES[themeState.current].SubText,
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundColor3 = THEMES[themeState.current].Header,
					BackgroundTransparency = 0.2,
					Size = UDim2.new(1, 0, 0, 30),
					Font = Enum.Font.Gotham,
				})
				createCorner(optBtn, 6)
				optBtn.MouseButton1Click:Connect(function()
					open = false
					mainBtn.Text = "  " .. text .. ": " .. tostring(opt)
					TweenService:Create(drop, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 38)}):Play()
					pcall(callback, opt)
				end)
			end

			mainBtn.MouseButton1Click:Connect(function()
				open = not open
				TweenService:Create(drop, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(1, 0, 0, open and (38 + (#options * 32)) or 38),
				}):Play()
			end)

			return drop
		end

		function TabObj:AddStatusPill(text, color)
			local pill = createTextLabel(scroll, {
				Text = text,
				TextColor3 = color or THEMES[themeState.current].Accent,
				TextSize = 9,
				Font = Enum.Font.GothamBold,
				Size = UDim2.new(0, 72, 0, 22),
				BackgroundColor3 = color or THEMES[themeState.current].Card,
				BackgroundTransparency = 0.08,
				TextXAlignment = Enum.TextXAlignment.Center,
			})
			createCorner(pill, 999)
			createStroke(pill, color or THEMES[themeState.current].Line, 1, 0.3)
			return pill
		end

		return TabObj
	end

	ToggleBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = false
	end)

	local homeTab = WindowObj:CreateTab("Home", "⌂")
	homeTab:AddSection("Overview")
	homeTab:AddInfoCard("Active Tasks", "84")
	homeTab:AddInfoCard("Pending", "12")
	homeTab:AddInfoCard("Executed", "68")
	homeTab:AddSection("Quick Control")
	homeTab:AddButton("Start Session", function() WindowObj:Notify("Success", "Session", "Executor session started successfully.", 3) end)
	homeTab:AddButton("Sync Data", function() WindowObj:Notify("Info", "Sync", "Data refreshed from server.", 2.5) end)
	homeTab:AddToggle("Auto refresh", true, function(v) end)

	local execTab = WindowObj:CreateTab("Executor", "⚙")
	execTab:AddSection("Executor Status")
	execTab:AddInfoCard("Boost", "92%")
	execTab:AddInfoCard("Speed", "321ms")
	execTab:AddInfoCard("Queue", "14")
	execTab:AddSlider("Priority", 1, 100, 72, function(val) end)
	execTab:AddDropdown("Mode", {"Auto", "Semi", "Manual", "Support"}, function(v) end)
	execTab:AddTextBox("Search executor", "Cloud-1", function(v) end)

	local systemTab = WindowObj:CreateTab("System", "▣")
	systemTab:AddSection("Performance")
	systemTab:AddStatusPill("Stable", THEMES[themeState.current].Success)
	systemTab:AddStatusPill("Secure", THEMES[themeState.current].Accent)
	systemTab:AddSlider("Render Quality", 1, 100, 90, function(v) end)
	systemTab:AddToggle("Motion Blur", false, function(v) end)
	systemTab:AddToggle("Low CPU Mode", true, function(v) end)
	systemTab:AddSection("Safety")
	systemTab:AddButton("Check Updates", function() WindowObj:Notify("Warning", "Update", "No new update available.", 2.5) end)
	systemTab:AddButton("Reset Session", function() WindowObj:Notify("Error", "Reset", "Session was reset by user.", 3.2) end)

	local settingsTab = WindowObj:CreateTab("Settings", "⚡")
	settingsTab:AddSection("Theme")
	settingsTab:AddButton("Apply Midnight", function() WindowObj:ApplyTheme("Midnight") end)
	settingsTab:AddButton("Apply Neon", function() WindowObj:ApplyTheme("Neon") end)
	settingsTab:AddButton("Apply Sunset", function() WindowObj:ApplyTheme("Sunset") end)
	settingsTab:AddButton("Apply Violet", function() WindowObj:ApplyTheme("Violet") end)
	settingsTab:AddSection("UI")
	settingsTab:AddToggle("Compact Mode", false, function(v) end)
	settingsTab:AddToggle("Hide Sidebar", false, function(v) end)
	settingsTab:AddTextBox("Player ID", tostring(LocalPlayer.UserId), function(v) end)

	WindowObj:Notify("Info", "ExecutorUI", "Mofenk premium UI ready.", 3)
	return WindowObj
end

return MofenkUI
