--[====================================================================]
-- MofenkUI - Premium Monochrome Dark Glass & Modern Theme Engine
-- Stable, Mobile Friendly, Fully Animated, Responsive Viewport
--[====================================================================]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local MofenkUI = {}

local THEMES = {
	Monochrome = {
		Bg = Color3.fromRGB(12, 12, 14),
		Bg2 = Color3.fromRGB(18, 18, 22),
		Card = Color3.fromRGB(24, 24, 30),
		CardAlt = Color3.fromRGB(34, 34, 42),
		Header = Color3.fromRGB(16, 16, 20),
		Accent = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(160, 165, 180),
		Text = Color3.fromRGB(245, 247, 255),
		Success = Color3.fromRGB(255, 255, 255),
		Warning = Color3.fromRGB(210, 210, 210),
		Danger = Color3.fromRGB(255, 120, 120),
		Line = Color3.fromRGB(255, 255, 255),
	},
	PureBlack = {
		Bg = Color3.fromRGB(5, 5, 5),
		Bg2 = Color3.fromRGB(12, 12, 12),
		Card = Color3.fromRGB(18, 18, 18),
		CardAlt = Color3.fromRGB(26, 26, 26),
		Header = Color3.fromRGB(10, 10, 10),
		Accent = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(140, 140, 140),
		Text = Color3.fromRGB(255, 255, 255),
		Success = Color3.fromRGB(255, 255, 255),
		Warning = Color3.fromRGB(200, 200, 200),
		Danger = Color3.fromRGB(255, 100, 100),
		Line = Color3.fromRGB(255, 255, 255),
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
	stroke.Transparency = transparency or 0.5
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

function MofenkUI.CreateWindow(config)
	config = config or {}

	local themeKey = config.Theme or "Monochrome"
	local theme = THEMES[themeKey] or THEMES.Monochrome
	local titleText = config.Name or "MofenkHub"
	local toggleStyle = config.ToggleStyle or "Icon"
	local profileTitle = config.ProfileTitle or "Premium Access"

	pcall(function()
		for _, v in ipairs(PlayerGui:GetChildren()) do
			if string.find(v.Name, "Mofenk") then v:Destroy() end
		end
		for _, v in ipairs(CoreGui:GetChildren()) do
			if string.find(v.Name, "Mofenk") then v:Destroy() end
		end
	end)

	-- Notification ScreenGui
	local NotifGui = Instance.new("ScreenGui")
	NotifGui.Name = "MofenkNotifications"
	NotifGui.ResetOnSpawn = false
	NotifGui.Parent = PlayerGui
	NotifGui.DisplayOrder = 1000000

	local NotifHolder = createFrame(NotifGui, {
		Name = "NotifHolder",
		Size = UDim2.new(0, 300, 0, 420),
		Position = UDim2.new(1, -20, 1, -20),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
	})
	local NotifLayout = Instance.new("UIListLayout")
	NotifLayout.Parent = NotifHolder
	NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NotifLayout.Padding = UDim.new(0, 8)
	NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

	-- Interactive Toggle / Floating Logo
	local ToggleGui = Instance.new("ScreenGui")
	ToggleGui.Name = "MofenkToggleFront"
	ToggleGui.ResetOnSpawn = false
	ToggleGui.Parent = PlayerGui
	ToggleGui.DisplayOrder = 999999

	local ToggleBtn = createTextButton(ToggleGui, {
		Name = "ToggleBtn",
		Text = toggleStyle == "Bar" and "  ⚡ MofenkHub  " or "M",
		TextColor3 = theme.Accent,
		TextSize = toggleStyle == "Bar" and 12 or 20,
		Font = Enum.Font.GothamBlack,
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.08,
		Size = toggleStyle == "Bar" and UDim2.new(0, 130, 0, 38) or UDim2.new(0, 52, 0, 52),
		Position = toggleStyle == "Bar" and UDim2.new(0.5, -65, 0, 10) or UDim2.new(0.03, 0, 0.35, 0),
		TextXAlignment = toggleStyle == "Bar" and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
	})
	createCorner(ToggleBtn, toggleStyle == "Bar" and 10 or 16)
	createStroke(ToggleBtn, theme.Line, 1.2, 0.4)

	-- Hover & Pulse Animation for Logo
	task.spawn(function()
		while ToggleBtn and ToggleBtn.Parent do
			TweenService:Create(ToggleBtn, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Size = toggleStyle == "Bar" and UDim2.new(0, 134, 0, 40) or UDim2.new(0, 55, 0, 55)
			}):Play()
			task.wait(1)
			TweenService:Create(ToggleBtn, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Size = toggleStyle == "Bar" and UDim2.new(0, 130, 0, 38) or UDim2.new(0, 52, 0, 52)
			}):Play()
			task.wait(1)
		end
	end)

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

	-- Main Window GUI
	local MainGui = Instance.new("ScreenGui")
	MainGui.Name = "MofenkPremiumHub"
	MainGui.ResetOnSpawn = false
	MainGui.Parent = PlayerGui
	MainGui.DisplayOrder = 999998

	local MainFrame = createFrame(MainGui, {
		Name = "MainFrame",
		Size = UDim2.new(0, 600, 0, 410),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Bg,
		BackgroundTransparency = 0.04,
	})
	createCorner(MainFrame, 16)
	createStroke(MainFrame, theme.Line, 1.2, 0.3)

	-- Auto Scale / Responsive Aspect Control
	local function updateScale()
		local cam = workspace.CurrentCamera
		if cam then
			local vp = cam.ViewportSize
			if vp.X < 640 then
				MainFrame.Size = UDim2.new(0, math.clamp(vp.X - 40, 320, 580), 0, math.clamp(vp.Y - 60, 280, 390))
			else
				MainFrame.Size = UDim2.new(0, 600, 0, 410)
			end
		end
	end
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
	updateScale()

	local TopBar = createFrame(MainFrame, {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = theme.Header,
		BackgroundTransparency = 0.1,
	})
	createCorner(TopBar, 16)

	local LogoDot = createFrame(TopBar, {
		Name = "LogoDot",
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(0, 14, 0, 15),
		BackgroundColor3 = theme.Accent,
	})
	createCorner(LogoDot, 999)

	local TitleLabel = createTextLabel(TopBar, {
		Name = "TitleLabel",
		Text = "⚡ " .. titleText,
		TextColor3 = theme.Accent,
		TextSize = 13,
		Font = Enum.Font.GothamBlack,
		Position = UDim2.new(0, 38, 0, 0),
		Size = UDim2.new(0, 260, 1, 0),
	})

	local MinimizeBtn = createTextButton(TopBar, {
		Name = "MinimizeBtn",
		Text = "—",
		TextColor3 = theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		Size = UDim2.new(0, 26, 0, 26),
		Position = UDim2.new(1, -68, 0, 9),
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.12,
	})
	createCorner(MinimizeBtn, 8)
	setHover(MinimizeBtn, theme.Card, theme.CardAlt, 0.12, 0.05)

	local CloseBtn = createTextButton(TopBar, {
		Name = "CloseBtn",
		Text = "✕",
		TextColor3 = theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		Size = UDim2.new(0, 26, 0, 26),
		Position = UDim2.new(1, -34, 0, 9),
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.12,
	})
	createCorner(CloseBtn, 8)
	setHover(CloseBtn, theme.Card, theme.CardAlt, 0.12, 0.05)

	local minimized = false
	local origHeight = 410

	MinimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			origHeight = MainFrame.AbsoluteSize.Y
			ProfileCard.Visible = false
			Sidebar.Visible = false
			ContentArea.Visible = false
			StatusBar.Visible = false
			TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, 44)
			}):Play()
			MinimizeBtn.Text = "+"
		else
			ProfileCard.Visible = true
			Sidebar.Visible = true
			ContentArea.Visible = true
			StatusBar.Visible = true
			TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, origHeight)
			}):Play()
			MinimizeBtn.Text = "—"
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = false
	end)

	-- Avatar Profile Panel (Unique Frame & Clear Identity)
	local ProfileCard = createFrame(MainFrame, {
		Name = "ProfileCard",
		Size = UDim2.new(1, -20, 0, 68),
		Position = UDim2.new(0, 10, 0, 52),
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.08,
	})
	createCorner(ProfileCard, 12)
	createStroke(ProfileCard, theme.Line, 1, 0.4)

	local Avatar = createImageLabel(ProfileCard, {
		Name = "Avatar",
		Size = UDim2.new(0, 46, 0, 46),
		Position = UDim2.new(0, 10, 0, 11),
		Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
	})
	createCorner(Avatar, 999)
	createStroke(Avatar, theme.Line, 1.2, 0.3)

	local NameLabel = createTextLabel(ProfileCard, {
		Name = "NameLabel",
		Text = "👑 " .. LocalPlayer.Name,
		TextColor3 = theme.Accent,
		TextSize = 12,
		Font = Enum.Font.GothamBlack,
		Position = UDim2.new(0, 66, 0, 12),
		Size = UDim2.new(1, -160, 0, 18),
	})

	local IDLabel = createTextLabel(ProfileCard, {
		Name = "IDLabel",
		Text = "ID: " .. LocalPlayer.UserId .. " | Role: " .. profileTitle,
		TextColor3 = theme.SubText,
		TextSize = 10,
		Font = Enum.Font.Gotham,
		Position = UDim2.new(0, 66, 0, 32),
		Size = UDim2.new(1, -160, 0, 16),
	})

	local StatusBadge = createTextLabel(ProfileCard, {
		Name = "StatusBadge",
		Text = "ONLINE",
		TextColor3 = theme.Bg,
		TextSize = 9,
		Font = Enum.Font.GothamBold,
		Position = UDim2.new(1, -86, 0, 23),
		Size = UDim2.new(0, 74, 0, 20),
		BackgroundTransparency = 0,
		BackgroundColor3 = theme.Accent,
		TextXAlignment = Enum.TextXAlignment.Center,
	})
	createCorner(StatusBadge, 999)

	-- Sidebar Tab Menu
	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Name = "Sidebar"
	Sidebar.Parent = MainFrame
	Sidebar.Position = UDim2.new(0, 10, 0, 128)
	Sidebar.Size = UDim2.new(0, 150, 1, -172)
	Sidebar.BackgroundTransparency = 1
	Sidebar.ScrollBarThickness = 2
	Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Sidebar.BorderSizePixel = 0

	local SideLayout = Instance.new("UIListLayout")
	SideLayout.Parent = Sidebar
	SideLayout.Padding = UDim.new(0, 6)

	-- Content Area
	local ContentArea = createFrame(MainFrame, {
		Name = "ContentArea",
		Size = UDim2.new(1, -172, 1, -172),
		Position = UDim2.new(0, 166, 0, 128),
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.05,
	})
	createCorner(ContentArea, 12)
	createStroke(ContentArea, theme.Line, 1, 0.35)

	-- Modern System Status Bar (Bottom)
	local StatusBar = createFrame(MainFrame, {
		Name = "StatusBar",
		Size = UDim2.new(1, -20, 0, 32),
		Position = UDim2.new(0, 10, 1, -38),
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.08,
	})
	createCorner(StatusBar, 10)
	createStroke(StatusBar, theme.Line, 1, 0.4)

	local StatusText = createTextLabel(StatusBar, {
		Name = "StatusText",
		Text = "  Status: System Secure & Stable",
		TextColor3 = theme.SubText,
		TextSize = 10,
		Font = Enum.Font.GothamBold,
		Position = UDim2.new(0, 6, 0, 0),
		Size = UDim2.new(0, 240, 1, 0),
	})

	local ClockText = createTextLabel(StatusBar, {
		Name = "ClockText",
		Text = "00:00:00  ",
		TextColor3 = theme.Accent,
		TextSize = 10,
		Font = Enum.Font.GothamBold,
		Position = UDim2.new(1, -100, 0, 0),
		Size = UDim2.new(0, 94, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Right,
	})

	task.spawn(function()
		while task.wait(1) do
			pcall(function()
				ClockText.Text = os.date("%H:%M:%S") .. "  "
			end)
		end
	end)

	local WindowObj = {
		Theme = theme,
		ThemeName = themeKey,
		TabFrames = {},
		TabButtons = {},
		FirstTabSet = false,
		NotifHolder = NotifHolder,
	}

	function WindowObj:ApplyTheme(newThemeKey)
		local selected = THEMES[newThemeKey] or THEMES.Monochrome
		self.Theme = selected
		self.ThemeName = newThemeKey

		MainFrame.BackgroundColor3 = selected.Bg
		TopBar.BackgroundColor3 = selected.Header
		ProfileCard.BackgroundColor3 = selected.Card
		ContentArea.BackgroundColor3 = selected.Bg2
		StatusBar.BackgroundColor3 = selected.Card
		TitleLabel.TextColor3 = selected.Accent
		NameLabel.TextColor3 = selected.Accent
		StatusBadge.BackgroundColor3 = selected.Accent
		StatusBadge.TextColor3 = selected.Bg
		IDLabel.TextColor3 = selected.SubText
		ClockText.TextColor3 = selected.Accent
		StatusText.TextColor3 = selected.SubText

		for _, btn in pairs(self.TabButtons) do
			btn.TextColor3 = selected.SubText
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

		local palette = {
			Info = self.Theme.Accent,
			Success = self.Theme.Success,
			Warning = self.Theme.Warning,
			Error = self.Theme.Danger,
		}

		local toast = createFrame(self.NotifHolder, {
			Name = "Toast",
			Size = UDim2.new(1, 0, 0, 64),
			BackgroundColor3 = self.Theme.Card,
			BackgroundTransparency = 0.05,
		})
		createCorner(toast, 10)
		createStroke(toast, palette[kind] or palette.Info, 1.2, 0.3)

		local bar = createFrame(toast, {
			Name = "Bar",
			Size = UDim2.new(0, 4, 1, 0),
			BackgroundColor3 = palette[kind] or palette.Info,
		})
		createCorner(bar, 10)

		createTextLabel(toast, {
			Name = "T1",
			Text = title,
			TextColor3 = self.Theme.Text,
			TextSize = 12,
			Font = Enum.Font.GothamBlack,
			Position = UDim2.new(0, 14, 0, 6),
			Size = UDim2.new(1, -24, 0, 18),
		})

		createTextLabel(toast, {
			Name = "T2",
			Text = text,
			TextColor3 = self.Theme.SubText,
			TextSize = 10,
			Font = Enum.Font.Gotham,
			Position = UDim2.new(0, 14, 0, 24),
			Size = UDim2.new(1, -24, 0, 32),
			TextWrapped = true,
		})

		task.delay(duration, function()
			pcall(function()
				TweenService:Create(toast, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 1
				}):Play()
				task.wait(0.2)
				toast:Destroy()
			end)
		end)
	end

	function WindowObj:CreateTab(name, icon)
		local tabBtn = createTextButton(Sidebar, {
			Name = "Tab_" .. name,
			Text = "  " .. icon .. "  " .. name,
			TextColor3 = self.Theme.SubText,
			TextSize = 11,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = self.Theme.Card,
			BackgroundTransparency = 0.15,
			Size = UDim2.new(1, -6, 0, 34),
		})
		createCorner(tabBtn, 8)
		setHover(tabBtn, self.Theme.Card, self.Theme.CardAlt, 0.15, 0.05)

		local scroll = Instance.new("ScrollingFrame")
		scroll.Name = "TabScroll_" .. name
		scroll.Parent = ContentArea
		scroll.Size = UDim2.new(1, -8, 1, -8)
		scroll.Position = UDim2.new(0, 4, 0, 4)
		scroll.BackgroundTransparency = 1
		scroll.BorderSizePixel = 0
		scroll.ScrollBarThickness = 2
		scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scroll.Visible = false

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
				Size = UDim2.new(1, 0, 0, 20),
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
				Size = UDim2.new(1, 0, 0, 20),
				TextXAlignment = Enum.TextXAlignment.Left,
			})
		end

		function TabObj:AddInfoCard(title, value)
			local card = createFrame(scroll, {
				Name = "InfoCard",
				Size = UDim2.new(1, 0, 0, 56),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.1,
			})
			createCorner(card, 8)
			createStroke(card, self.Theme.Line, 1, 0.4)

			createTextLabel(card, {
				Name = "Title",
				Text = title,
				TextColor3 = self.Theme.SubText,
				TextSize = 10,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 10, 0, 8),
				Size = UDim2.new(1, -20, 0, 14),
			})

			createTextLabel(card, {
				Name = "Value",
				Text = value,
				TextColor3 = self.Theme.Accent,
				TextSize = 14,
				Font = Enum.Font.GothamBlack,
				Position = UDim2.new(0, 10, 0, 24),
				Size = UDim2.new(1, -20, 0, 18),
			})

			return card
		end

		function TabObj:AddButton(text, callback)
			local btn = createTextButton(scroll, {
				Name = "ActionButton",
				Text = "  " .. text,
				TextColor3 = self.Theme.Text,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.1,
				Size = UDim2.new(1, 0, 0, 36),
			})
			createCorner(btn, 8)
			setHover(btn, self.Theme.Card, self.Theme.CardAlt, 0.1, 0.04)

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
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.1,
				Size = UDim2.new(1, 0, 0, 36),
			})
			createCorner(btn, 8)
			setHover(btn, self.Theme.Card, self.Theme.CardAlt, 0.1, 0.04)

			local toggleBg = createFrame(btn, {
				Name = "ToggleBg",
				Size = UDim2.new(0, 42, 0, 22),
				Position = UDim2.new(1, -50, 0.5, -11),
				BackgroundColor3 = state and self.Theme.Accent or self.Theme.CardAlt,
			})
			createCorner(toggleBg, 999)

			local knob = createFrame(toggleBg, {
				Name = "ToggleKnob",
				Size = UDim2.new(0, 16, 0, 16),
				Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
				BackgroundColor3 = state and self.Theme.Bg or self.Theme.SubText,
			})
			createCorner(knob, 999)

			btn.MouseButton1Click:Connect(function()
				state = not state
				TweenService:Create(toggleBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = state and self.Theme.Accent or self.Theme.CardAlt
				}):Play()

				TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
					BackgroundColor3 = state and self.Theme.Bg or self.Theme.SubText
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
				TextSize = 11,
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
				Size = UDim2.new(1, 0, 0, 50),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.1,
			})
			createCorner(frame, 8)

			local label = createTextLabel(frame, {
				Name = "SliderLabel",
				Text = "  " .. text .. ": " .. tostring(currentValue),
				TextColor3 = self.Theme.Text,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 8, 0, 6),
				Size = UDim2.new(1, -16, 0, 16),
			})

			local bar = createFrame(frame, {
				Name = "SliderBar",
				Size = UDim2.new(1, -16, 0, 6),
				Position = UDim2.new(0, 8, 0, 30),
				BackgroundColor3 = self.Theme.CardAlt,
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
				Size = UDim2.new(1, 0, 0, 36),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.1,
			})
			createCorner(drop, 8)

			local mainBtn = createTextButton(drop, {
				Name = "DropdownToggle",
				Text = "  " .. text .. ": Select...",
				TextColor3 = self.Theme.Text,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 36),
			})

			local listFrame = createFrame(drop, {
				Name = "DropdownList",
				Size = UDim2.new(1, 0, 0, #options * 28),
				Position = UDim2.new(0, 0, 0, 36),
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
					TextSize = 10,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundColor3 = self.Theme.CardAlt,
					BackgroundTransparency = 0.2,
					Size = UDim2.new(1, 0, 0, 26),
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

			mainBtn.MouseButton1Click:Connect(function()
				open = not open
				local targetHeight = open and (36 + (#options * 28)) or 36
				TweenService:Create(drop, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(1, 0, 0, targetHeight)
				}):Play()
			end)

			return drop
		end

		return TabObj
	end

	ToggleBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
	end)

	WindowObj:Notify("Success", "System", "MofenkUI Premium Monochrome active.", 3)
	return WindowObj
end

return MofenkUI
