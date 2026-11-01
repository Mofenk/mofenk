--[====================================================================]
-- MofenkUI - Premium Monochrome Dashboard UI
-- Fixed version: stable, mobile-friendly, responsive, no nil/runtime issues
--[====================================================================]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:WaitForChild("PlayerGui", 5)

local MofenkUI = {}

local THEMES = {
	Monochrome = {
		Bg = Color3.fromRGB(10, 10, 12),
		Bg2 = Color3.fromRGB(18, 19, 24),
		Card = Color3.fromRGB(24, 25, 31),
		CardAlt = Color3.fromRGB(34, 36, 44),
		Header = Color3.fromRGB(14, 15, 18),
		Accent = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(155, 161, 174),
		Text = Color3.fromRGB(245, 247, 255),
		Success = Color3.fromRGB(140, 255, 180),
		Warning = Color3.fromRGB(255, 210, 100),
		Danger = Color3.fromRGB(255, 110, 110),
		Line = Color3.fromRGB(255, 255, 255),
		Glow = Color3.fromRGB(110, 160, 255),
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
		Glow = Color3.fromRGB(255, 255, 255),
	},
	Midnight = {
		Bg = Color3.fromRGB(7, 12, 18),
		Bg2 = Color3.fromRGB(17, 24, 32),
		Card = Color3.fromRGB(23, 31, 42),
		CardAlt = Color3.fromRGB(33, 45, 60),
		Header = Color3.fromRGB(12, 15, 20),
		Accent = Color3.fromRGB(110, 180, 255),
		SubText = Color3.fromRGB(155, 170, 190),
		Text = Color3.fromRGB(240, 245, 255),
		Success = Color3.fromRGB(120, 255, 185),
		Warning = Color3.fromRGB(255, 205, 110),
		Danger = Color3.fromRGB(255, 120, 120),
		Line = Color3.fromRGB(120, 170, 255),
		Glow = Color3.fromRGB(110, 180, 255),
	},
}

local function clamp(value, minValue, maxValue)
	return math.max(minValue, math.min(value, maxValue))
end

local function safeDestroy(obj)
	if obj and obj.Destroy then
		pcall(function()
			obj:Destroy()
		end)
	end
end

local function createCorner(instance, radius)
	if not instance then return nil end
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = instance
	return corner
end

local function createStroke(instance, color, thickness, transparency)
	if not instance then return nil end
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Color3.new(1, 1, 1)
	stroke.Thickness = thickness or 1
	stroke.Transparency = transparency or 0.4
	stroke.Parent = instance
	return stroke
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
	if props.ZIndex ~= nil then f.ZIndex = props.ZIndex end
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
	if props.ZIndex ~= nil then label.ZIndex = props.ZIndex end
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
	if props.ZIndex ~= nil then btn.ZIndex = props.ZIndex end
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
	if props.AnchorPoint then box.AnchorPoint = props.AnchorPoint end
	if props.ZIndex ~= nil then box.ZIndex = props.ZIndex end
	return box
end

local function buildPingBar(parent, theme)
	local host = createFrame(parent, {
		Name = "PingBar",
		Size = UDim2.new(0, 90, 0, 12),
		BackgroundColor3 = theme.CardAlt,
		BackgroundTransparency = 0.15,
	})
	createCorner(host, 999)

	local fill = createFrame(host, {
		Name = "PingFill",
		Size = UDim2.new(0.72, 0, 1, 0),
		BackgroundColor3 = theme.Accent,
		BackgroundTransparency = 0.12,
	})
	createCorner(fill, 999)
	return fill
end

local function setHover(button, baseColor, hoverColor, baseAlpha, hoverAlpha)
	if not button then return end
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = hoverColor or baseColor,
			BackgroundTransparency = hoverAlpha or baseAlpha or 0.04,
		}):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = baseColor or button.BackgroundColor3,
			BackgroundTransparency = baseAlpha or 0.12,
		}):Play()
	end)
end

function MofenkUI.CreateWindow(config)
	config = config or {}
	local themeName = config.Theme or "Monochrome"
	local theme = THEMES[themeName] or THEMES.Monochrome
	local titleText = config.Name or "MofenkHub"
	local toggleStyle = config.ToggleStyle or "Icon"
	local profileTitle = config.ProfileTitle or "VIP Premium"

	local rootGuiParent = PlayerGui or CoreGui
	if not rootGuiParent then
		rootGuiParent = CoreGui
	end

	local windowGui = Instance.new("ScreenGui")
	windowGui.Name = "MofenkPremiumUI"
	windowGui.ResetOnSpawn = false
	windowGui.IgnoreGuiInset = true
	windowGui.Parent = rootGuiParent

	local overlay = createFrame(windowGui, {
		Name = "Overlay",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
	})

	local toggleGui = Instance.new("ScreenGui")
	toggleGui.Name = "MofenkToggle"
	toggleGui.ResetOnSpawn = false
	toggleGui.IgnoreGuiInset = true
	toggleGui.Parent = rootGuiParent

	local toggleButton = createTextButton(toggleGui, {
		Name = "ToggleButton",
		Text = toggleStyle == "Bar" and "  ⚡ Mofenk  " or "M",
		TextColor3 = theme.Accent,
		TextSize = toggleStyle == "Bar" and 12 or 20,
		Font = Enum.Font.GothamBlack,
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.08,
		Size = toggleStyle == "Bar" and UDim2.new(0, 130, 0, 38) or UDim2.new(0, 54, 0, 54),
		Position = toggleStyle == "Bar" and UDim2.new(0.5, -65, 0, 12) or UDim2.new(0.03, 0, 0.35, 0),
		TextXAlignment = toggleStyle == "Bar" and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
	})
	createCorner(toggleButton, toggleStyle == "Bar" and 10 or 16)
	createStroke(toggleButton, theme.Line, 1.1, 0.4)

	local dragState = {
		dragging = false,
		startPos = Vector2.new(),
		startButtonPos = UDim2.new(),
	}

	local function updateTogglePositionFromDrag(input)
		if not dragState.dragging then return end
		local delta = input.Position - dragState.startPos
		local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
		local x = clamp(dragState.startButtonPos.X.Offset + delta.X, 12, viewport.X - 70)
		local y = clamp(dragState.startButtonPos.Y.Offset + delta.Y, 12, viewport.Y - 90)
		toggleButton.Position = UDim2.new(0, x, 0, y)
	end

	toggleButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragState.dragging = true
			dragState.startPos = input.Position
			dragState.startButtonPos = toggleButton.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			updateTogglePositionFromDrag(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragState.dragging = false
		end
	end)

	local mainFrame = createFrame(windowGui, {
		Name = "MainFrame",
		Size = UDim2.new(0, 820, 0, 500),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Bg,
		BackgroundTransparency = 0.03,
	})
	createCorner(mainFrame, 18)
	createStroke(mainFrame, theme.Line, 1.2, 0.28)
	mainFrame.Visible = true

	local function updateScale()
		local cam = workspace.CurrentCamera
		if not cam then return end
		local viewport = cam.ViewportSize
		if viewport.X < 760 then
			mainFrame.Size = UDim2.new(0, clamp(viewport.X - 24, 340, 780), 0, clamp(viewport.Y - 26, 320, 500))
		else
			mainFrame.Size = UDim2.new(0, 820, 0, 500)
		end
	end

	if workspace.CurrentCamera then
		workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
	end
	updateScale()

	local topBar = createFrame(mainFrame, {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 52),
		BackgroundColor3 = theme.Header,
		BackgroundTransparency = 0.08,
	})
	createCorner(topBar, 18)

	local logoDot = createFrame(topBar, {
		Name = "LogoDot",
		Size = UDim2.new(0, 16, 0, 16),
		Position = UDim2.new(0, 14, 0, 18),
		BackgroundColor3 = theme.Accent,
	})
	createCorner(logoDot, 999)
	createStroke(logoDot, theme.Line, 1, 0.25)

	local titleLabel = createTextLabel(topBar, {
		Name = "TitleLabel",
		Text = titleText .. " >",
		TextColor3 = theme.Accent,
		TextSize = 19,
		Font = Enum.Font.GothamBlack,
		Position = UDim2.new(0, 38, 0, 0),
		Size = UDim2.new(0, 220, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local autoButton = createTextButton(topBar, {
		Name = "AutoButton",
		Text = "Auto ▾",
		TextColor3 = theme.Text,
		TextSize = 13,
		Font = Enum.Font.GothamSemibold,
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.12,
		Size = UDim2.new(0, 118, 0, 30),
		Position = UDim2.new(1, -218, 0.5, -15),
	})
	createCorner(autoButton, 8)
	createStroke(autoButton, theme.Line, 1, 0.35)
	setHover(autoButton, theme.Card, theme.CardAlt, 0.12, 0.04)

	local pingText = createTextLabel(topBar, {
		Name = "PingText",
		Text = "34ms",
		TextColor3 = theme.SubText,
		TextSize = 11,
		Font = Enum.Font.GothamSemibold,
		Position = UDim2.new(1, -100, 0.5, -9),
		Size = UDim2.new(0, 60, 0, 18),
		TextXAlignment = Enum.TextXAlignment.Right,
	})

	local pingBar = buildPingBar(topBar, theme)
	pingBar.Parent = topBar
	pingBar.Position = UDim2.new(1, -150, 0.5, -6)
	pingBar.Size = UDim2.new(0, 90, 0, 12)

	local profileCard = createFrame(mainFrame, {
		Name = "ProfileCard",
		Size = UDim2.new(1, -26, 0, 82),
		Position = UDim2.new(0, 13, 0, 64),
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.1,
	})
	createCorner(profileCard, 14)
	createStroke(profileCard, theme.Line, 1, 0.25)

	local avatarImage = Instance.new("ImageLabel")
	avatarImage.Name = "Avatar"
	avatarImage.Size = UDim2.new(0, 54, 0, 54)
	avatarImage.Position = UDim2.new(0, 12, 0.5, -27)
	avatarImage.BackgroundTransparency = 0
	avatarImage.BorderSizePixel = 0
	avatarImage.Parent = profileCard
	local userId = LocalPlayer and LocalPlayer.UserId or 0
	local thumb = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	avatarImage.Image = thumb
	createCorner(avatarImage, 999)
	createStroke(avatarImage, theme.Line, 1, 0.2)

	local nameLabel = createTextLabel(profileCard, {
		Name = "NameLabel",
		Text = "👑 " .. (LocalPlayer and LocalPlayer.Name or "Player"),
		TextColor3 = theme.Accent,
		TextSize = 14,
		Font = Enum.Font.GothamBlack,
		Position = UDim2.new(0, 80, 0, 18),
		Size = UDim2.new(1, -225, 0, 18),
	})

	local idLabel = createTextLabel(profileCard, {
		Name = "IDLabel",
		Text = "ID: " .. userId .. " | Role: " .. profileTitle,
		TextColor3 = theme.SubText,
		TextSize = 10,
		Font = Enum.Font.Gotham,
		Position = UDim2.new(0, 80, 0, 42),
		Size = UDim2.new(1, -230, 0, 14),
	})

	local badge = createTextLabel(profileCard, {
		Name = "Badge",
		Text = "ONLINE",
		BackgroundColor3 = theme.Accent,
		BackgroundTransparency = 0,
		TextColor3 = theme.Bg,
		TextSize = 9,
		Font = Enum.Font.GothamBlack,
		Position = UDim2.new(1, -112, 0.5, -12),
		Size = UDim2.new(0, 90, 0, 20),
		TextXAlignment = Enum.TextXAlignment.Center,
	})
	createCorner(badge, 999)

	local sidebar = Instance.new("ScrollingFrame")
	sidebar.Name = "Sidebar"
	sidebar.Parent = mainFrame
	sidebar.Position = UDim2.new(0, 14, 0, 156)
	sidebar.Size = UDim2.new(0, 168, 1, -200)
	sidebar.BackgroundColor3 = theme.Bg2
	sidebar.BackgroundTransparency = 0.12
	sidebar.BorderSizePixel = 0
	sidebar.ScrollBarThickness = 0
	sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
	createCorner(sidebar, 12)
	createStroke(sidebar, theme.Line, 1, 0.18)

	local sidebarList = Instance.new("UIListLayout")
	sidebarList.Padding = UDim.new(0, 8)
	sidebarList.Parent = sidebar

	local contentArea = createFrame(mainFrame, {
		Name = "ContentArea",
		Size = UDim2.new(1, -194, 1, -200),
		Position = UDim2.new(0, 194, 0, 156),
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.08,
	})
	createCorner(contentArea, 16)
	createStroke(contentArea, theme.Line, 1, 0.18)

	local rightRail = createFrame(mainFrame, {
		Name = "RightRail",
		Size = UDim2.new(0, 100, 1, -200),
		Position = UDim2.new(1, -98, 0, 156),
		BackgroundTransparency = 1,
	})
	local railLayout = Instance.new("UIListLayout")
	railLayout.Parent = rightRail
	railLayout.Padding = UDim.new(0, 8)
	railLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local function createRailIcon(iconText, labelText)
		local btn = createTextButton(rightRail, {
			Name = "RailButton",
			Text = iconText,
			TextColor3 = theme.Text,
			TextSize = 22,
			Font = Enum.Font.GothamBold,
			BackgroundColor3 = theme.Card,
			BackgroundTransparency = 0.08,
			Size = UDim2.new(0, 62, 0, 62),
		})
		createCorner(btn, 16)
		createStroke(btn, theme.Line, 1, 0.2)
		setHover(btn, theme.Card, theme.CardAlt, 0.08, 0.02)

		local label = createTextLabel(btn, {
			Name = "RailLabel",
			Text = labelText,
			TextColor3 = theme.SubText,
			TextSize = 8,
			Font = Enum.Font.Gotham,
			Position = UDim2.new(0, 0, 1, -16),
			Size = UDim2.new(1, 0, 0, 16),
			TextXAlignment = Enum.TextXAlignment.Center,
		})
		return btn
	end

	local bottomBar = createFrame(mainFrame, {
		Name = "BottomBar",
		Size = UDim2.new(1, -30, 0, 52),
		Position = UDim2.new(0, 15, 1, -62),
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.10,
	})
	createCorner(bottomBar, 14)
	createStroke(bottomBar, theme.Line, 1, 0.2)

	local leftArrow = createTextButton(bottomBar, {
		Name = "LeftArrow",
		Text = "◀",
		TextColor3 = theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.12,
		Size = UDim2.new(0, 36, 0, 36),
		Position = UDim2.new(0, 16, 0.5, -18),
	})
	createCorner(leftArrow, 12)

	local centerGroup = createFrame(bottomBar, {
		Name = "CenterGroup",
		Size = UDim2.new(0, 232, 0, 34),
		Position = UDim2.new(0.5, -116, 0.5, -17),
		BackgroundTransparency = 1,
	})

	local actionButton1 = createTextButton(centerGroup, {
		Name = "Action1",
		Text = "✦",
		TextColor3 = theme.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.12,
		Size = UDim2.new(0, 42, 0, 34),
		Position = UDim2.new(0, 0, 0, 0),
	})
	createCorner(actionButton1, 10)

	local actionButton2 = createTextButton(centerGroup, {
		Name = "Action2",
		Text = "◎",
		TextColor3 = theme.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.12,
		Size = UDim2.new(0, 42, 0, 34),
		Position = UDim2.new(0, 52, 0, 0),
	})
	createCorner(actionButton2, 10)

	local actionButton3 = createTextButton(centerGroup, {
		Name = "Action3",
		Text = "▣",
		TextColor3 = theme.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.12,
		Size = UDim2.new(0, 42, 0, 34),
		Position = UDim2.new(0, 104, 0, 0),
	})
	createCorner(actionButton3, 10)

	local actionButton4 = createTextButton(centerGroup, {
		Name = "Action4",
		Text = "◈",
		TextColor3 = theme.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.12,
		Size = UDim2.new(0, 42, 0, 34),
		Position = UDim2.new(0, 156, 0, 0),
	})
	createCorner(actionButton4, 10)

	local rightArrow = createTextButton(bottomBar, {
		Name = "RightArrow",
		Text = "▶",
		TextColor3 = theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.12,
		Size = UDim2.new(0, 36, 0, 36),
		Position = UDim2.new(1, -52, 0.5, -18),
	})
	createCorner(rightArrow, 12)

	local Window = {
		Gui = windowGui,
		MainFrame = mainFrame,
		Sidebar = sidebar,
		ContentArea = contentArea,
		RightRail = rightRail,
		Theme = theme,
		TabButtons = {},
		TabFrames = {},
		NotificationHolder = nil,
	}

	function Window:Notify(title, text, duration)
		if not self.NotificationHolder then
			local holder = createFrame(windowGui, {
				Name = "NotificationHolder",
				Size = UDim2.new(0, 280, 0, 200),
				Position = UDim2.new(1, -300, 1, -120),
				AnchorPoint = Vector2.new(1, 1),
				BackgroundTransparency = 1,
			})
			self.NotificationHolder = holder
		end

		local toast = createFrame(self.NotificationHolder, {
			Name = "Toast",
			Size = UDim2.new(1, 0, 0, 58),
			BackgroundColor3 = self.Theme.Card,
			BackgroundTransparency = 0.07,
		})
		createCorner(toast, 10)
		createStroke(toast, self.Theme.Accent, 1, 0.35)

		local side = createFrame(toast, {
			Name = "SideBar",
			Size = UDim2.new(0, 4, 1, 0),
			BackgroundColor3 = self.Theme.Accent,
		})
		createCorner(side, 10)

		createTextLabel(toast, {
			Name = "Title",
			Text = tostring(title),
			TextColor3 = self.Theme.Text,
			TextSize = 11,
			Font = Enum.Font.GothamBlack,
			Position = UDim2.new(0, 14, 0, 8),
			Size = UDim2.new(1, -28, 0, 16),
		})
		createTextLabel(toast, {
			Name = "Text",
			Text = tostring(text),
			TextColor3 = self.Theme.SubText,
			TextSize = 10,
			Font = Enum.Font.Gotham,
			Position = UDim2.new(0, 14, 0, 22),
			Size = UDim2.new(1, -28, 0, 22),
			TextWrapped = true,
		})

		local current = #self.NotificationHolder:GetChildren()
		if current > 0 then
			local prev = self.NotificationHolder:FindFirstChild("Toast")
			if prev then
				prev.Position = UDim2.new(0, 0, 0, 0)
			end
		end

		task.delay(duration or 3, function()
			if toast and toast.Parent then
				TweenService:Create(toast, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 1,
				}):Play()
				task.wait(0.2)
				safeDestroy(toast)
			end
		end)
	end

	function Window:CreateTab(name, icon)
		local button = createTextButton(self.Sidebar, {
			Name = "TabButton_" .. name,
			Text = "  " .. (icon or "•") .. "  " .. name,
			TextColor3 = self.Theme.SubText,
			TextSize = 11,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = self.Theme.Card,
			BackgroundTransparency = 0.12,
			Size = UDim2.new(1, -8, 0, 34),
		})
		createCorner(button, 10)
		setHover(button, self.Theme.Card, self.Theme.CardAlt, 0.12, 0.04)

		local container = createFrame(self.ContentArea, {
			Name = "TabContainer_" .. name,
			Size = UDim2.new(1, -10, 1, -10),
			Position = UDim2.new(0, 5, 0, 5),
			BackgroundTransparency = 1,
		})
		local list = Instance.new("UIListLayout")
		list.Parent = container
		list.Padding = UDim.new(0, 8)
		container.Visible = false

		self.TabButtons[name] = button
		self.TabFrames[name] = container

		local firstTab = next(self.TabFrames)
		if not firstTab then
			container.Visible = true
			button.BackgroundTransparency = 0.05
			button.TextColor3 = self.Theme.Accent
		end

		button.MouseButton1Click:Connect(function()
			for tabName, frame in pairs(self.TabFrames) do
				frame.Visible = (tabName == name)
			end
			for _, btn in pairs(self.TabButtons) do
				btn.BackgroundTransparency = 0.12
				btn.TextColor3 = self.Theme.SubText
			end
			button.BackgroundTransparency = 0.05
			button.TextColor3 = self.Theme.Accent
		end)

		local Tab = { Container = container, Theme = self.Theme }

		function Tab:AddSection(title)
			createTextLabel(self.Container, {
				Name = "Section",
				Text = "— " .. tostring(title) .. " —",
				TextColor3 = self.Theme.SubText,
				TextSize = 10,
				Font = Enum.Font.GothamBold,
				Size = UDim2.new(1, 0, 0, 20),
				TextXAlignment = Enum.TextXAlignment.Center,
			})
		end

		function Tab:AddInfoCard(title, value)
			local card = createFrame(self.Container, {
				Name = "InfoCard",
				Size = UDim2.new(1, 0, 0, 58),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.08,
			})
			createCorner(card, 10)
			createStroke(card, self.Theme.Line, 1, 0.22)

			createTextLabel(card, {
				Name = "Title",
				Text = tostring(title),
				TextColor3 = self.Theme.SubText,
				TextSize = 10,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 12, 0, 8),
				Size = UDim2.new(1, -24, 0, 14),
			})
			createTextLabel(card, {
				Name = "Value",
				Text = tostring(value),
				TextColor3 = self.Theme.Accent,
				TextSize = 15,
				Font = Enum.Font.GothamBlack,
				Position = UDim2.new(0, 12, 0, 24),
				Size = UDim2.new(1, -24, 0, 20),
			})
			return card
		end

		function Tab:AddButton(text, callback)
			local btn = createTextButton(self.Container, {
				Name = "ActionButton",
				Text = "  " .. tostring(text),
				TextColor3 = self.Theme.Text,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.10,
				Size = UDim2.new(1, 0, 0, 36),
			})
			createCorner(btn, 8)
			setHover(btn, self.Theme.Card, self.Theme.CardAlt, 0.10, 0.04)
			btn.MouseButton1Click:Connect(function()
				if callback then
					pcall(callback)
				end
			end)
			return btn
		end

		function Tab:AddToggle(text, defaultState, callback)
			local state = defaultState == true
			local btn = createTextButton(self.Container, {
				Name = "ToggleRow",
				Text = "  " .. tostring(text),
				TextColor3 = self.Theme.Text,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.10,
				Size = UDim2.new(1, 0, 0, 38),
			})
			createCorner(btn, 8)
			setHover(btn, self.Theme.Card, self.Theme.CardAlt, 0.10, 0.04)

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
					BackgroundColor3 = state and self.Theme.Accent or self.Theme.CardAlt,
				}):Play()
				TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
					BackgroundColor3 = state and self.Theme.Bg or self.Theme.SubText,
				}):Play()
				if callback then pcall(callback, state) end
			end)

			return btn
		end

		function Tab:AddTextBox(placeholder, defaultText, callback)
			local box = createTextBox(self.Container, {
				Name = "InputBox",
				Text = defaultText or "",
				TextColor3 = self.Theme.Text,
				TextSize = 11,
				Font = Enum.Font.Gotham,
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.10,
				Size = UDim2.new(1, 0, 0, 36),
				PlaceholderText = placeholder or "",
				PlaceholderColor3 = self.Theme.SubText,
				ClearTextOnFocus = false,
			})
			createCorner(box, 8)
			box.FocusLost:Connect(function(enterPressed)
				if enterPressed and callback then
					pcall(callback, box.Text)
				end
			end)
			return box
		end

		function Tab:AddSlider(label, minValue, maxValue, currentValue, callback)
			local minV = tonumber(minValue) or 0
			local maxV = tonumber(maxValue) or 100
			local curV = clamp(tonumber(currentValue) or minV, minV, maxV)

			local frame = createFrame(self.Container, {
				Name = "SliderRow",
				Size = UDim2.new(1, 0, 0, 54),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.10,
			})
			createCorner(frame, 8)

			local labelText = createTextLabel(frame, {
				Name = "SliderLabel",
				Text = "  " .. tostring(label) .. ": " .. tostring(curV),
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
				Name = "SliderFill",
				Size = UDim2.new((curV - minV) / (maxV - minV), 0, 1, 0),
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
					local value = math.floor(minV + ((maxV - minV) * pos))
					labelText.Text = "  " .. tostring(label) .. ": " .. tostring(value)
					if callback then pcall(callback, value) end
				end
			end)
			return frame
		end

		return Tab
	end

	toggleButton.MouseButton1Click:Connect(function()
		mainFrame.Visible = not mainFrame.Visible
	end)

	return Window
end

return MofenkUI
