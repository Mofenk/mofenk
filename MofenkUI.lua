--[====================================================================]
-- MofenkUI - Ultimate Monochrome (Permanent Top Profile Dashboard)
--[====================================================================]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local MofenkUI = {}

local MONO_THEME = {
	Bg         = Color3.fromRGB(12, 12, 12),
	Card       = Color3.fromRGB(20, 20, 20),
	Header     = Color3.fromRGB(16, 16, 16),
	Accent     = Color3.fromRGB(255, 255, 255),
	Text       = Color3.fromRGB(245, 245, 245),
	SubText    = Color3.fromRGB(160, 160, 160),
	Hover      = Color3.fromRGB(35, 35, 35),
	Soft       = Color3.fromRGB(28, 28, 28),
	Success    = Color3.fromRGB(140, 255, 180),
	Warning    = Color3.fromRGB(255, 210, 120),
	Shadow     = Color3.fromRGB(0, 0, 0),
	Line       = Color3.fromRGB(255, 255, 255)
}

local function createCorner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = instance
	return corner
end

local function createStroke(instance, color, thickness, transparency)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or MONO_THEME.Accent
	stroke.Thickness = thickness or 1
	stroke.Transparency = transparency or 0.4
	stroke.Parent = instance
	return stroke
end

local function setButtonHover(button, defaultColor, hoverColor, defaultTrans, hoverTrans)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = hoverColor or MONO_THEME.Hover,
			BackgroundTransparency = hoverTrans or 0.08,
		}):Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = defaultColor or MONO_THEME.Card,
			BackgroundTransparency = defaultTrans or 0.15,
		}):Play()
	end)
end

function MofenkUI.CreateWindow(config)
	config = config or {}
	local titleText = config.Name or "MofenkHub"
	local toggleStyle = config.ToggleStyle or "Icon"
	local profileTitle = config.ProfileTitle or "VIP Cloud User"

	pcall(function()
		for _, v in pairs(PlayerGui:GetChildren()) do
			if string.find(v.Name, "Mofenk") then v:Destroy() end
		end
		for _, v in pairs(CoreGui:GetChildren()) do
			if string.find(v.Name, "Mofenk") then v:Destroy() end
		end
	end)

	local NotifGui = Instance.new("ScreenGui")
	NotifGui.Name = "MofenkNotifications"
	NotifGui.Parent = PlayerGui
	NotifGui.ResetOnSpawn = false
	NotifGui.DisplayOrder = 1000000

	local NotifHolder = Instance.new("Frame")
	NotifHolder.Parent = NotifGui
	NotifHolder.AnchorPoint = Vector2.new(1, 1)
	NotifHolder.Position = UDim2.new(1, -20, 1, -20)
	NotifHolder.Size = UDim2.new(0, 300, 0, 400)
	NotifHolder.BackgroundTransparency = 1

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

	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Parent = ToggleGui
	ToggleBtn.BackgroundColor3 = MONO_THEME.Card
	ToggleBtn.BackgroundTransparency = 0.1
	ToggleBtn.Font = Enum.Font.GothamBlack
	ToggleBtn.TextScaled = false
	ToggleBtn.AutoButtonColor = false
	ToggleBtn.ZIndex = 999999
	ToggleBtn.BorderSizePixel = 0
	ToggleBtn.ClipsDescendants = true

	if toggleStyle == "Bar" then
		ToggleBtn.Size = UDim2.new(0, 128, 0, 38)
		ToggleBtn.Position = UDim2.new(0.5, -64, 0, 12)
		ToggleBtn.Text = "  ⚡ MofenkHub  "
		ToggleBtn.TextSize = 12
		ToggleBtn.TextColor3 = MONO_THEME.Accent
	else
		ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
		ToggleBtn.Position = UDim2.new(0.03, 0, 0.35, 0)
		ToggleBtn.Text = "M"
		ToggleBtn.TextSize = 22
		ToggleBtn.TextColor3 = MONO_THEME.Accent
	end

	createCorner(ToggleBtn, toggleStyle == "Bar" and 10 or 14)
	createStroke(ToggleBtn, MONO_THEME.Accent, 1.5, 0.25)

	local Glow = Instance.new("Frame")
	Glow.Parent = ToggleBtn
	Glow.BackgroundColor3 = MONO_THEME.Accent
	Glow.BackgroundTransparency = 0.92
	Glow.BorderSizePixel = 0
	Glow.Size = UDim2.new(1, 0, 1, 0)
	Glow.ZIndex = 0

	local btnGlow = Instance.new("UIGradient")
	btnGlow.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
	})
	btnGlow.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.75),
		NumberSequenceKeypoint.new(1, 1)
	})
	btnGlow.Rotation = 90
	btnGlow.Parent = Glow

	local dragging, dragStart, startPos
	ToggleBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = ToggleBtn.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
			ToggleBtn.Position = UDim2.new(
				0,
				math.clamp(startPos.X.Offset + delta.X, 10, viewport.X - 70),
				0,
				math.clamp(startPos.Y.Offset + delta.Y, 10, viewport.Y - 70)
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	local MainGui = Instance.new("ScreenGui")
	MainGui.Name = "MofenkUltraHubV116"
	MainGui.Parent = PlayerGui
	MainGui.ResetOnSpawn = false
	MainGui.DisplayOrder = 999998

	local MainFrame = Instance.new("Frame")
	MainFrame.Parent = MainGui
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.Size = UDim2.new(0, 580, 0, 370)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.Visible = true
	MainFrame.BackgroundColor3 = MONO_THEME.Bg
	MainFrame.BackgroundTransparency = 0.06
	MainFrame.BorderSizePixel = 0

	createCorner(MainFrame, 12)
	createStroke(MainFrame, MONO_THEME.Accent, 1.5, 0.3)

	local MainGloss = Instance.new("Frame")
	MainGloss.Parent = MainFrame
	MainGloss.Size = UDim2.new(1, 0, 1, 0)
	MainGloss.BackgroundColor3 = MONO_THEME.Accent
	MainGloss.BackgroundTransparency = 0.95
	MainGloss.BorderSizePixel = 0
	MainGloss.ZIndex = 0

	local MainGradient = Instance.new("UIGradient")
	MainGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
	})
	MainGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.9),
		NumberSequenceKeypoint.new(1, 1)
	})
	MainGradient.Rotation = 90
	MainGradient.Parent = MainGloss

	ToggleBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
	end)

	local TopBar = Instance.new("Frame")
	TopBar.Parent = MainFrame
	TopBar.Size = UDim2.new(1, 0, 0, 44)
	TopBar.BackgroundColor3 = MONO_THEME.Header
	TopBar.BackgroundTransparency = 0.2
	TopBar.BorderSizePixel = 0
	createCorner(TopBar, 12)

	local TopBarGlow = Instance.new("Frame")
	TopBarGlow.Parent = TopBar
	TopBarGlow.Size = UDim2.new(1, 0, 1, 0)
	TopBarGlow.BackgroundColor3 = MONO_THEME.Accent
	TopBarGlow.BackgroundTransparency = 0.97
	TopBarGlow.BorderSizePixel = 0
	TopBarGlow.ZIndex = 0

	local Title = Instance.new("TextLabel")
	Title.Parent = TopBar
	Title.Position = UDim2.new(0, 16, 0, 0)
	Title.Size = UDim2.new(0, 350, 1, 0)
	Title.Text = "⚡  " .. titleText
	Title.TextColor3 = MONO_THEME.Accent
	Title.TextSize = 14
	Title.Font = Enum.Font.GothamBold
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.BackgroundTransparency = 1

	local TitleDot = Instance.new("Frame")
	TitleDot.Parent = TopBar
	TitleDot.Position = UDim2.new(0, 9, 0, 17)
	TitleDot.Size = UDim2.new(0, 7, 0, 7)
	TitleDot.BackgroundColor3 = MONO_THEME.Success
	TitleDot.BorderSizePixel = 0
	createCorner(TitleDot, 999)

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Parent = TopBar
	CloseBtn.Position = UDim2.new(1, -38, 0, 8)
	CloseBtn.Size = UDim2.new(0, 28, 0, 28)
	CloseBtn.Text = "✕"
	CloseBtn.TextColor3 = MONO_THEME.Text
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 14
	CloseBtn.BackgroundColor3 = MONO_THEME.Card
	CloseBtn.BackgroundTransparency = 0.2
	CloseBtn.AutoButtonColor = false
	CloseBtn.BorderSizePixel = 0
	createCorner(CloseBtn, 6)
	setButtonHover(CloseBtn, MONO_THEME.Card, MONO_THEME.Hover, 0.2, 0.05)
	CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

	local minimized = false
	local origHeight = 370
	local MinimizeBtn = Instance.new("TextButton")
	MinimizeBtn.Parent = TopBar
	MinimizeBtn.Position = UDim2.new(1, -72, 0, 8)
	MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
	MinimizeBtn.Text = "—"
	MinimizeBtn.TextColor3 = MONO_THEME.Text
	MinimizeBtn.Font = Enum.Font.GothamBold
	MinimizeBtn.TextSize = 14
	MinimizeBtn.BackgroundColor3 = MONO_THEME.Card
	MinimizeBtn.BackgroundTransparency = 0.2
	MinimizeBtn.AutoButtonColor = false
	MinimizeBtn.BorderSizePixel = 0
	createCorner(MinimizeBtn, 6)
	setButtonHover(MinimizeBtn, MONO_THEME.Card, MONO_THEME.Hover, 0.2, 0.05)

	local ProfileCard = Instance.new("Frame")
	ProfileCard.Parent = MainFrame
	ProfileCard.Position = UDim2.new(0, 10, 0, 52)
	ProfileCard.Size = UDim2.new(1, -20, 0, 83)
	ProfileCard.BackgroundColor3 = MONO_THEME.Card
	ProfileCard.BackgroundTransparency = 0.12
	ProfileCard.BorderSizePixel = 0
	createCorner(ProfileCard, 10)
	createStroke(ProfileCard, MONO_THEME.Accent, 1.2, 0.5)

	local ProfileGlow = Instance.new("Frame")
	ProfileGlow.Parent = ProfileCard
	ProfileGlow.Size = UDim2.new(1, 0, 1, 0)
	ProfileGlow.BackgroundColor3 = MONO_THEME.Accent
	ProfileGlow.BackgroundTransparency = 0.96
	ProfileGlow.BorderSizePixel = 0

	local AvatarFrame = Instance.new("ImageLabel")
	AvatarFrame.Parent = ProfileCard
	AvatarFrame.Position = UDim2.new(0, 10, 0, 10)
	AvatarFrame.Size = UDim2.new(0, 55, 0, 55)
	AvatarFrame.BackgroundColor3 = MONO_THEME.Header
	AvatarFrame.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	AvatarFrame.BorderSizePixel = 0
	createCorner(AvatarFrame, 999)
	createStroke(AvatarFrame, MONO_THEME.Accent, 1.5, 0.2)

	local StatusDot = Instance.new("Frame")
	StatusDot.Parent = AvatarFrame
	StatusDot.AnchorPoint = Vector2.new(1, 1)
	StatusDot.Position = UDim2.new(1, -4, 1, -4)
	StatusDot.Size = UDim2.new(0, 12, 0, 12)
	StatusDot.BackgroundColor3 = MONO_THEME.Success
	StatusDot.BorderSizePixel = 0
	createCorner(StatusDot, 999)
	createStroke(StatusDot, MONO_THEME.Bg, 2, 0)

	local NameLabel = Instance.new("TextLabel")
	NameLabel.Parent = ProfileCard
	NameLabel.Position = UDim2.new(0, 78, 0, 12)
	NameLabel.Size = UDim2.new(1, -180, 0, 22)
	NameLabel.BackgroundTransparency = 1
	NameLabel.Text = "👑 " .. LocalPlayer.Name .. " (" .. profileTitle .. ")"
	NameLabel.TextColor3 = MONO_THEME.Accent
	NameLabel.Font = Enum.Font.GothamBlack
	NameLabel.TextSize = 12
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left

	local StatusBadge = Instance.new("TextLabel")
	StatusBadge.Parent = ProfileCard
	StatusBadge.AnchorPoint = Vector2.new(1, 0)
	StatusBadge.Position = UDim2.new(1, -12, 0, 12)
	StatusBadge.Size = UDim2.new(0, 92, 0, 20)
	StatusBadge.BackgroundColor3 = MONO_THEME.Header
	StatusBadge.BackgroundTransparency = 0.2
	StatusBadge.Text = "ONLINE"
	StatusBadge.TextColor3 = MONO_THEME.Success
	StatusBadge.Font = Enum.Font.GothamBold
	StatusBadge.TextSize = 9
	StatusBadge.TextXAlignment = Enum.TextXAlignment.Center
	StatusBadge.BorderSizePixel = 0
	createCorner(StatusBadge, 999)
	createStroke(StatusBadge, MONO_THEME.Success, 1, 0.5)

	local StatusLabel = Instance.new("TextLabel")
	StatusLabel.Parent = ProfileCard
	StatusLabel.Position = UDim2.new(0, 78, 0, 35)
	StatusLabel.Size = UDim2.new(1, -90, 0, 15)
	StatusLabel.BackgroundTransparency = 1
	StatusLabel.Text = "✨ Status: Secure & Connected"
	StatusLabel.TextColor3 = MONO_THEME.SubText
	StatusLabel.Font = Enum.Font.Gotham
	StatusLabel.TextSize = 10
	StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

	local PingBarBg = Instance.new("Frame")
	PingBarBg.Parent = ProfileCard
	PingBarBg.Position = UDim2.new(0, 78, 0, 58)
	PingBarBg.Size = UDim2.new(1, -90, 0, 8)
	PingBarBg.BackgroundColor3 = MONO_THEME.Header
	PingBarBg.BorderSizePixel = 0
	createCorner(PingBarBg, 999)

	local PingFill = Instance.new("Frame")
	PingFill.Parent = PingBarBg
	PingFill.Size = UDim2.new(0.5, 0, 1, 0)
	PingFill.BackgroundColor3 = MONO_THEME.Accent
	PingFill.BorderSizePixel = 0
	createCorner(PingFill, 999)

	local PingText = Instance.new("TextLabel")
	PingText.Parent = PingBarBg
	PingText.Size = UDim2.new(1, 0, 1, 0)
	PingText.BackgroundTransparency = 1
	PingText.Text = "Ping: calculating..."
	PingText.TextColor3 = MONO_THEME.Text
	PingText.Font = Enum.Font.GothamBold
	PingText.TextSize = 8
	PingText.TextXAlignment = Enum.TextXAlignment.Center
	PingText.ZIndex = 5

	task.spawn(function()
		while task.wait(1) do
			pcall(function()
				local pingVal = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
				PingText.Text = "Ping: " .. pingVal .. " ms"
				local alpha = math.clamp(pingVal / 300, 0.1, 1)
				PingFill.Size = UDim2.new(alpha, 0, 1, 0)
			end)
		end
	end)

	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Parent = MainFrame
	Sidebar.Position = UDim2.new(0, 10, 0, 145)
	Sidebar.Size = UDim2.new(0, 155, 1, -155)
	Sidebar.BackgroundTransparency = 1
	Sidebar.ScrollBarThickness = 2
	Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Sidebar.BorderSizePixel = 0

	local SideLayout = Instance.new("UIListLayout")
	SideLayout.Parent = Sidebar
	SideLayout.Padding = UDim.new(0, 6)

	local ContentArea = Instance.new("Frame")
	ContentArea.Parent = MainFrame
	ContentArea.Position = UDim2.new(0, 172, 0, 145)
	ContentArea.Size = UDim2.new(1, -182, 1, -155)
	ContentArea.BackgroundColor3 = MONO_THEME.Header
	ContentArea.BackgroundTransparency = 0.25
	ContentArea.BorderSizePixel = 0
	createCorner(ContentArea, 10)

	local ContentShade = Instance.new("Frame")
	ContentShade.Parent = ContentArea
	ContentShade.Size = UDim2.new(1, 0, 1, 0)
	ContentShade.BackgroundColor3 = MONO_THEME.Accent
	ContentShade.BackgroundTransparency = 0.97
	ContentShade.BorderSizePixel = 0
	ContentShade.ZIndex = 0

	MinimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			origHeight = MainFrame.AbsoluteSize.Y
			ProfileCard.Visible = false
			Sidebar.Visible = false
			ContentArea.Visible = false
			local W = MainFrame.AbsoluteSize.X
			TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, W, 0, 44)}):Play()
			MinimizeBtn.Text = "+"
		else
			ProfileCard.Visible = true
			Sidebar.Visible = true
			ContentArea.Visible = true
			TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, MainFrame.AbsoluteSize.X, 0, origHeight)}):Play()
			MinimizeBtn.Text = "—"
		end
	end)

	local ResizeBtn = Instance.new("TextButton")
	ResizeBtn.Parent = MainFrame
	ResizeBtn.AnchorPoint = Vector2.new(1, 1)
	ResizeBtn.Position = UDim2.new(1, -2, 1, -2)
	ResizeBtn.Size = UDim2.new(0, 18, 0, 18)
	ResizeBtn.BackgroundTransparency = 1
	ResizeBtn.Text = "◢"
	ResizeBtn.TextColor3 = MONO_THEME.SubText
	ResizeBtn.TextSize = 10
	ResizeBtn.ZIndex = 10
	ResizeBtn.BorderSizePixel = 0

	local resizing = false
	local resizeStart, startSize
	ResizeBtn.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not minimized then
			resizing = true
			resizeStart = input.Position
			startSize = MainFrame.AbsoluteSize
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - resizeStart
			local newWidth = math.clamp(startSize.X + delta.X, 480, 800)
			local newHeight = math.clamp(startSize.Y + delta.Y, 320, 600)
			MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
			origHeight = newHeight
		end
	end)

	local WindowObj = {
		TabFrames = {},
		TabButtons = {},
		FirstTabSet = false,
		Theme = MONO_THEME
	}

	function WindowObj:Notify(title, text, duration)
		duration = duration or 3
		local NotifCard = Instance.new("Frame")
		NotifCard.Parent = NotifHolder
		NotifCard.Size = UDim2.new(1, 0, 0, 65)
		NotifCard.BackgroundColor3 = MONO_THEME.Card
		NotifCard.BackgroundTransparency = 0.08
		NotifCard.BorderSizePixel = 0
		createCorner(NotifCard, 10)
		createStroke(NotifCard, MONO_THEME.Accent, 1.2, 0.4)

		local NTitle = Instance.new("TextLabel")
		NTitle.Parent = NotifCard
		NTitle.Position = UDim2.new(0, 12, 0, 6)
		NTitle.Size = UDim2.new(1, -24, 0, 22)
		NTitle.BackgroundTransparency = 1
		NTitle.Text = title
		NTitle.TextColor3 = MONO_THEME.Accent
		NTitle.Font = Enum.Font.GothamBold
		NTitle.TextSize = 13
		NTitle.TextXAlignment = Enum.TextXAlignment.Left

		local NDesc = Instance.new("TextLabel")
		NDesc.Parent = NotifCard
		NDesc.Position = UDim2.new(0, 12, 0, 28)
		NDesc.Size = UDim2.new(1, -24, 0, 26)
		NDesc.BackgroundTransparency = 1
		NDesc.Text = text
		NDesc.TextColor3 = MONO_THEME.Text
		NDesc.Font = Enum.Font.Gotham
		NDesc.TextSize = 11
		NDesc.TextXAlignment = Enum.TextXAlignment.Left

		local NGlow = Instance.new("Frame")
		NGlow.Parent = NotifCard
		NGlow.Size = UDim2.new(1, 0, 1, 0)
		NGlow.BackgroundColor3 = MONO_THEME.Accent
		NGlow.BackgroundTransparency = 0.98
		NGlow.BorderSizePixel = 0

		task.delay(duration, function()
			pcall(function()
				TweenService:Create(NotifCard, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
				task.wait(0.3)
				NotifCard:Destroy()
			end)
		end)
	end

	function WindowObj:CreateTab(name, icon)
		local Btn = Instance.new("TextButton")
		Btn.Parent = Sidebar
		Btn.Size = UDim2.new(1, -4, 0, 36)
		Btn.Text = "  " .. icon .. "  " .. name
		Btn.TextColor3 = MONO_THEME.SubText
		Btn.TextSize = 12
		Btn.Font = Enum.Font.GothamBold
		Btn.TextXAlignment = Enum.TextXAlignment.Left
		Btn.BackgroundColor3 = MONO_THEME.Card
		Btn.BackgroundTransparency = 0.4
		Btn.AutoButtonColor = false
		Btn.BorderSizePixel = 0
		createCorner(Btn, 8)
		setButtonHover(Btn, MONO_THEME.Card, MONO_THEME.Hover, 0.4, 0.08)

		local Scroll = Instance.new("ScrollingFrame")
		Scroll.Parent = ContentArea
		Scroll.Size = UDim2.new(1, -10, 1, -10)
		Scroll.Position = UDim2.new(0, 5, 0, 5)
		Scroll.BackgroundTransparency = 1
		Scroll.ScrollBarThickness = 3
		Scroll.Visible = false
		Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Scroll.BorderSizePixel = 0

		local Lay = Instance.new("UIListLayout")
		Lay.Parent = Scroll
		Lay.Padding = UDim.new(0, 8)

		self.TabFrames[name] = Scroll
		self.TabButtons[name] = Btn

		if not self.FirstTabSet then
			Scroll.Visible = true
			Btn.BackgroundTransparency = 0.05
			Btn.TextColor3 = MONO_THEME.Accent
			self.FirstTabSet = true
		end

		Btn.MouseButton1Click:Connect(function()
			for n, f in pairs(self.TabFrames) do f.Visible = (n == name) end
			for _, b in pairs(self.TabButtons) do
				b.BackgroundTransparency = 0.4
				b.TextColor3 = MONO_THEME.SubText
			end
			TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.05}):Play()
			Btn.TextColor3 = MONO_THEME.Accent
		end)

		local TabObj = { Container = Scroll }

		function TabObj:AddSection(text)
			local Sec = Instance.new("TextLabel")
			Sec.Parent = Scroll
			Sec.Size = UDim2.new(1, 0, 0, 26)
			Sec.BackgroundTransparency = 1
			Sec.Text = "── " .. text .. " ──"
			Sec.TextColor3 = MONO_THEME.SubText
			Sec.Font = Enum.Font.GothamBold
			Sec.TextSize = 11
			Sec.TextXAlignment = Enum.TextXAlignment.Center
			return Sec
		end

		function TabObj:AddLabel(text)
			local Lbl = Instance.new("TextLabel")
			Lbl.Parent = Scroll
			Lbl.Size = UDim2.new(1, 0, 0, 24)
			Lbl.BackgroundTransparency = 1
			Lbl.Text = "  " .. text
			Lbl.TextColor3 = MONO_THEME.SubText
			Lbl.Font = Enum.Font.GothamBold
			Lbl.TextSize = 11
			Lbl.TextXAlignment = Enum.TextXAlignment.Left
			return Lbl
		end

		function TabObj:AddInfoCard(title, value)
			local Card = Instance.new("Frame")
			Card.Parent = Scroll
			Card.Size = UDim2.new(1, 0, 0, 64)
			Card.BackgroundColor3 = MONO_THEME.Card
			Card.BackgroundTransparency = 0.15
			Card.BorderSizePixel = 0
			createCorner(Card, 10)
			createStroke(Card, MONO_THEME.Accent, 1, 0.5)

			local TitleLbl = Instance.new("TextLabel")
			TitleLbl.Parent = Card
			TitleLbl.Position = UDim2.new(0, 12, 0, 9)
			TitleLbl.Size = UDim2.new(1, -24, 0, 18)
			TitleLbl.BackgroundTransparency = 1
			TitleLbl.Text = title
			TitleLbl.TextColor3 = MONO_THEME.SubText
			TitleLbl.Font = Enum.Font.GothamBold
			TitleLbl.TextSize = 10
			TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

			local ValueLbl = Instance.new("TextLabel")
			ValueLbl.Parent = Card
			ValueLbl.Position = UDim2.new(0, 12, 0, 26)
			ValueLbl.Size = UDim2.new(1, -24, 0, 24)
			ValueLbl.BackgroundTransparency = 1
			ValueLbl.Text = value
			ValueLbl.TextColor3 = MONO_THEME.Accent
			ValueLbl.Font = Enum.Font.GothamBlack
			ValueLbl.TextSize = 15
			ValueLbl.TextXAlignment = Enum.TextXAlignment.Left

			return Card
		end

		function TabObj:AddButton(text, callback)
			local BtnComp = Instance.new("TextButton")
			BtnComp.Parent = Scroll
			BtnComp.Size = UDim2.new(1, 0, 0, 38)
			BtnComp.BackgroundColor3 = MONO_THEME.Card
			BtnComp.BackgroundTransparency = 0.15
			BtnComp.Text = "  " .. text
			BtnComp.TextColor3 = MONO_THEME.Text
			BtnComp.Font = Enum.Font.GothamBold
			BtnComp.TextSize = 12
			BtnComp.TextXAlignment = Enum.TextXAlignment.Left
			BtnComp.AutoButtonColor = false
			BtnComp.BorderSizePixel = 0
			createCorner(BtnComp, 8)
			setButtonHover(BtnComp, MONO_THEME.Card, MONO_THEME.Hover, 0.15, 0.05)

			BtnComp.MouseButton1Click:Connect(function()
				TweenService:Create(BtnComp, TweenInfo.new(0.08), {BackgroundColor3 = MONO_THEME.Hover, BackgroundTransparency = 0}):Play()
				task.wait(0.08)
				TweenService:Create(BtnComp, TweenInfo.new(0.12), {BackgroundColor3 = MONO_THEME.Card, BackgroundTransparency = 0.15}):Play()
				pcall(callback)
			end)
		end

		function TabObj:AddToggle(text, defaultState, callback)
			local state = defaultState or false

			local TglBtn = Instance.new("TextButton")
			TglBtn.Parent = Scroll
			TglBtn.Size = UDim2.new(1, 0, 0, 38)
			TglBtn.BackgroundColor3 = MONO_THEME.Card
			TglBtn.BackgroundTransparency = 0.15
			TglBtn.Text = "  " .. text
			TglBtn.TextColor3 = MONO_THEME.Text
			TglBtn.Font = Enum.Font.GothamBold
			TglBtn.TextSize = 12
			TglBtn.TextXAlignment = Enum.TextXAlignment.Left
			TglBtn.AutoButtonColor = false
			TglBtn.BorderSizePixel = 0
			createCorner(TglBtn, 8)
			setButtonHover(TglBtn, MONO_THEME.Card, MONO_THEME.Hover, 0.15, 0.05)

			local SwitchBg = Instance.new("Frame")
			SwitchBg.Parent = TglBtn
			SwitchBg.AnchorPoint = Vector2.new(1, 0.5)
			SwitchBg.Position = UDim2.new(1, -12, 0.5, 0)
			SwitchBg.Size = UDim2.new(0, 46, 0, 24)
			SwitchBg.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(45, 45, 45)
			SwitchBg.BorderSizePixel = 0
			createCorner(SwitchBg, 999)

			local SwitchKnob = Instance.new("Frame")
			SwitchKnob.Parent = SwitchBg
			SwitchKnob.AnchorPoint = Vector2.new(0, 0.5)
			SwitchKnob.Position = state and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
			SwitchKnob.Size = UDim2.new(0, 18, 0, 18)
			SwitchKnob.BackgroundColor3 = state and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(150, 150, 150)
			SwitchKnob.BorderSizePixel = 0
			createCorner(SwitchKnob, 999)

			TglBtn.MouseButton1Click:Connect(function()
				state = not state
				local targetPos = state and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
				local targetBgColor = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(45, 45, 45)
				local targetKnobColor = state and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(150, 150, 150)

				TweenService:Create(SwitchBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetBgColor}):Play()
				TweenService:Create(SwitchKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos, BackgroundColor3 = targetKnobColor}):Play()
				pcall(callback, state)
			end)
		end

		function TabObj:AddTextBox(placeholder, defaultText, callback)
			local TBox = Instance.new("TextBox")
			TBox.Parent = Scroll
			TBox.Size = UDim2.new(1, 0, 0, 38)
			TBox.BackgroundColor3 = MONO_THEME.Card
			TBox.BackgroundTransparency = 0.2
			TBox.PlaceholderText = placeholder
			TBox.PlaceholderColor3 = MONO_THEME.SubText
			TBox.Text = defaultText or ""
			TBox.TextColor3 = MONO_THEME.Accent
			TBox.Font = Enum.Font.Gotham
			TBox.TextSize = 12
			TBox.TextXAlignment = Enum.TextXAlignment.Left
			TBox.BorderSizePixel = 0
			createCorner(TBox, 8)

			local UIP = Instance.new("UIPadding")
			UIP.PaddingLeft = UDim.new(0, 12)
			UIP.Parent = TBox

			TBox.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					pcall(callback, TBox.Text)
				end
			end)
		end

		function TabObj:AddSlider(text, min, max, current, callback)
			current = math.clamp(current or min, min, max)
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Parent = Scroll
			SliderFrame.Size = UDim2.new(1, 0, 0, 52)
			SliderFrame.BackgroundColor3 = MONO_THEME.Card
			SliderFrame.BackgroundTransparency = 0.2
			SliderFrame.BorderSizePixel = 0
			createCorner(SliderFrame, 8)

			local SliderLabel = Instance.new("TextLabel")
			SliderLabel.Parent = SliderFrame
			SliderLabel.Position = UDim2.new(0, 12, 0, 6)
			SliderLabel.Size = UDim2.new(1, -24, 0, 18)
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.Text = "  " .. text .. ": " .. tostring(current)
			SliderLabel.TextColor3 = MONO_THEME.Text
			SliderLabel.Font = Enum.Font.GothamBold
			SliderLabel.TextSize = 11
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

			local Bar = Instance.new("Frame")
			Bar.Parent = SliderFrame
			Bar.Position = UDim2.new(0, 12, 0, 32)
			Bar.Size = UDim2.new(1, -24, 0, 6)
			Bar.BackgroundColor3 = MONO_THEME.Header
			Bar.BorderSizePixel = 0
			createCorner(Bar, 999)

			local Fill = Instance.new("Frame")
			Fill.Parent = Bar
			Fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
			Fill.BackgroundColor3 = MONO_THEME.Accent
			Fill.BorderSizePixel = 0
			createCorner(Fill, 999)

			local draggingSlider = false
			Bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = true
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = false
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
					Fill.Size = UDim2.new(pos, 0, 1, 0)
					local val = math.floor(min + ((max - min) * pos))
					SliderLabel.Text = "  " .. text .. ": " .. tostring(val)
					pcall(callback, val)
				end
			end)
		end

		function TabObj:AddDropdown(text, options, callback)
			options = options or {}
			local dropdownOpen = false
			local dropHeight = 38 + (#options * 32)

			local DropFrame = Instance.new("Frame")
			DropFrame.Parent = Scroll
			DropFrame.Size = UDim2.new(1, 0, 0, 38)
			DropFrame.BackgroundColor3 = MONO_THEME.Card
			DropFrame.BackgroundTransparency = 0.2
			DropFrame.ClipsDescendants = true
			DropFrame.BorderSizePixel = 0
			createCorner(DropFrame, 8)

			local DropBtn = Instance.new("TextButton")
			DropBtn.Parent = DropFrame
			DropBtn.Size = UDim2.new(1, 0, 0, 38)
			DropBtn.BackgroundTransparency = 1
			DropBtn.Text = "  " .. text .. " : Select..."
			DropBtn.TextColor3 = MONO_THEME.Text
			DropBtn.Font = Enum.Font.GothamBold
			DropBtn.TextSize = 12
			DropBtn.TextXAlignment = Enum.TextXAlignment.Left
			DropBtn.BorderSizePixel = 0

			local ListContainer = Instance.new("Frame")
			ListContainer.Parent = DropFrame
			ListContainer.Position = UDim2.new(0, 0, 0, 38)
			ListContainer.Size = UDim2.new(1, 0, 0, #options * 32)
			ListContainer.BackgroundTransparency = 1
			ListContainer.BorderSizePixel = 0

			local LLayout = Instance.new("UIListLayout")
			LLayout.Parent = ListContainer
			LLayout.Padding = UDim.new(0, 2)

			for _, opt in ipairs(options) do
				local OptBtn = Instance.new("TextButton")
				OptBtn.Parent = ListContainer
				OptBtn.Size = UDim2.new(1, 0, 0, 30)
				OptBtn.BackgroundColor3 = MONO_THEME.Header
				OptBtn.BackgroundTransparency = 0.3
				OptBtn.Text = "    • " .. tostring(opt)
				OptBtn.TextColor3 = MONO_THEME.SubText
				OptBtn.Font = Enum.Font.Gotham
				OptBtn.TextSize = 11
				OptBtn.TextXAlignment = Enum.TextXAlignment.Left
				OptBtn.BorderSizePixel = 0
				createCorner(OptBtn, 6)

				OptBtn.MouseButton1Click:Connect(function()
					dropdownOpen = false
					DropBtn.Text = "  " .. text .. " : " .. tostring(opt)
					TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 38)}):Play()
					pcall(callback, opt)
				end)
			end

			DropBtn.MouseButton1Click:Connect(function()
				dropdownOpen = not dropdownOpen
				local targetH = dropdownOpen and dropHeight or 38
				TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetH)}):Play()
			end)
		end

		return TabObj
	end

	return WindowObj
end

return MofenkUI
