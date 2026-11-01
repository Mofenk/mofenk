--[====================================================================]
-- MofenkUI - Premium Monochrome Dark Glass & Modern Theme Engine
-- Stable, Mobile Friendly, Fully Animated, Responsive Viewport
-- Full system element pack: tabs, cards, toggles, slider, dropdown,
-- multiselect, search, profile, utility rows, config rows, animation.
--[====================================================================]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:WaitForChild("PlayerGui", 5)

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
		Success = Color3.fromRGB(140, 255, 180),
		Warning = Color3.fromRGB(255, 210, 110),
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
	},
}

local function clamp(value, minValue, maxValue)
	return math.max(minValue, math.min(value, maxValue))
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
	if props.TextWrapped ~= nil then box.TextWrapped = props.TextWrapped end
	if props.AnchorPoint then box.AnchorPoint = props.AnchorPoint end
	if props.ZIndex ~= nil then box.ZIndex = props.ZIndex end
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

local function doClickPulse(obj, color)
	if not obj then return end
	local pulse = createFrame(obj.Parent, {
		Name = "PulseEffect",
		Size = obj.Size,
		Position = obj.Position,
		BackgroundColor3 = color or Color3.new(1, 1, 1),
		BackgroundTransparency = 0.8,
		AnchorPoint = obj.AnchorPoint,
	})
	createCorner(pulse, 12)
	pulse.Parent = obj.Parent
	pulse.ZIndex = (obj.ZIndex or 0) + 5
	TweenService:Create(pulse, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1,
		Size = obj.Size + UDim2.new(0.05, 0, 0.05, 0),
	}):Play()
	task.delay(0.22, function() if pulse and pulse.Parent then pulse:Destroy() end end)
end

function MofenkUI.CreateWindow(config)
	config = config or {}
	local themeKey = config.Theme or "Monochrome"
	local theme = THEMES[themeKey] or THEMES.Monochrome
	local titleText = config.Name or "MofenkHub"
	local toggleStyle = config.ToggleStyle or "Icon"
	local profileTitle = config.ProfileTitle or "Premium Access"

	local rootGuiParent = PlayerGui or CoreGui
	if not rootGuiParent then
		rootGuiParent = CoreGui
	end

	pcall(function()
		for _, child in ipairs(rootGuiParent:GetChildren()) do
			if child.Name:find("Mofenk") then
				child:Destroy()
			end
		end
	end)

	local notifGui = Instance.new("ScreenGui")
	notifGui.Name = "MofenkNotifications"
	notifGui.ResetOnSpawn = false
	notifGui.IgnoreGuiInset = true
	notifGui.Parent = rootGuiParent
	notifGui.DisplayOrder = 1000000

	local notifHolder = createFrame(notifGui, {
		Name = "NotifHolder",
		Size = UDim2.new(0, 300, 0, 420),
		Position = UDim2.new(1, -20, 1, -20),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
	})
	local notifLayout = Instance.new("UIListLayout")
	notifLayout.Parent = notifHolder
	notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
	notifLayout.Padding = UDim.new(0, 8)
	notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

	local toggleGui = Instance.new("ScreenGui")
	toggleGui.Name = "MofenkToggleFront"
	toggleGui.ResetOnSpawn = false
	toggleGui.IgnoreGuiInset = true
	toggleGui.Parent = rootGuiParent
	toggleGui.DisplayOrder = 999999

	local toggleBtn = createTextButton(toggleGui, {
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
	createCorner(toggleBtn, toggleStyle == "Bar" and 10 or 16)
	createStroke(toggleBtn, theme.Line, 1.2, 0.4)
	setHover(toggleBtn, theme.Card, theme.CardAlt, 0.08, 0.04)

	local dragState = { dragging = false, startPos = Vector2.new(), startBtnPos = UDim2.new() }
	local function beginDrag(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragState.dragging = true
			dragState.startPos = input.Position
			dragState.startBtnPos = toggleBtn.Position
		end
	end
	local function updateDrag(input)
		if dragState.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragState.startPos
			local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
			local x = clamp(dragState.startBtnPos.X.Offset + delta.X, 10, viewport.X - 70)
			local y = clamp(dragState.startBtnPos.Y.Offset + delta.Y, 10, viewport.Y - 70)
			toggleBtn.Position = UDim2.new(0, x, 0, y)
		end
	end
	toggleBtn.InputBegan:Connect(beginDrag)
	UserInputService.InputChanged:Connect(updateDrag)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragState.dragging = false
		end
	end)

	local mainGui = Instance.new("ScreenGui")
	mainGui.Name = "MofenkPremiumHub"
	mainGui.ResetOnSpawn = false
	mainGui.IgnoreGuiInset = true
	mainGui.Parent = rootGuiParent
	mainGui.DisplayOrder = 999998

	local mainFrame = createFrame(mainGui, {
		Name = "MainFrame",
		Size = UDim2.new(0, 600, 0, 410),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Bg,
		BackgroundTransparency = 0.04,
	})
	createCorner(mainFrame, 16)
	createStroke(mainFrame, theme.Line, 1.2, 0.3)

	local function resizeFrame()
		local cam = workspace.CurrentCamera
		if not cam then return end
		local vp = cam.ViewportSize
		if vp.X < 640 then
			mainFrame.Size = UDim2.new(0, clamp(vp.X - 40, 320, 580), 0, clamp(vp.Y - 60, 280, 390))
		else
			mainFrame.Size = UDim2.new(0, 600, 0, 410)
		end
	end
	if workspace.CurrentCamera then
		workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resizeFrame)
	end
	resizeFrame()

	local topBar = createFrame(mainFrame, {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = theme.Header,
		BackgroundTransparency = 0.1,
	})
	createCorner(topBar, 16)

	local logoDot = createFrame(topBar, {
		Name = "LogoDot",
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(0, 14, 0, 15),
		BackgroundColor3 = theme.Accent,
	})
	createCorner(logoDot, 999)

	local titleLabel = createTextLabel(topBar, {
		Name = "TitleLabel",
		Text = "⚡ " .. titleText,
		TextColor3 = theme.Accent,
		TextSize = 13,
		Font = Enum.Font.GothamBlack,
		Position = UDim2.new(0, 38, 0, 0),
		Size = UDim2.new(0, 260, 1, 0),
	})

	local minimizeBtn = createTextButton(topBar, {
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
	createCorner(minimizeBtn, 8)
	setHover(minimizeBtn, theme.Card, theme.CardAlt, 0.12, 0.05)

	local closeBtn = createTextButton(topBar, {
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
	createCorner(closeBtn, 8)
	setHover(closeBtn, theme.Card, theme.CardAlt, 0.12, 0.05)

	local profileCard = createFrame(mainFrame, {
		Name = "ProfileCard",
		Size = UDim2.new(1, -20, 0, 68),
		Position = UDim2.new(0, 10, 0, 52),
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.08,
	})
	createCorner(profileCard, 12)
	createStroke(profileCard, theme.Line, 1, 0.4)

	local avatar = createImageLabel(profileCard, {
		Name = "Avatar",
		Size = UDim2.new(0, 46, 0, 46),
		Position = UDim2.new(0, 10, 0, 11),
		Image = LocalPlayer and Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) or "",
	})
	createCorner(avatar, 999)
	createStroke(avatar, theme.Line, 1.2, 0.3)

	local nameLabel = createTextLabel(profileCard, {
		Name = "NameLabel",
		Text = "👑 " .. (LocalPlayer and LocalPlayer.Name or "Player"),
		TextColor3 = theme.Accent,
		TextSize = 12,
		Font = Enum.Font.GothamBlack,
		Position = UDim2.new(0, 66, 0, 12),
		Size = UDim2.new(1, -160, 0, 18),
	})
	local idLabel = createTextLabel(profileCard, {
		Name = "IDLabel",
		Text = "ID: " .. (LocalPlayer and LocalPlayer.UserId or 0) .. " | Role: " .. profileTitle,
		TextColor3 = theme.SubText,
		TextSize = 10,
		Font = Enum.Font.Gotham,
		Position = UDim2.new(0, 66, 0, 32),
		Size = UDim2.new(1, -160, 0, 16),
	})
	local statusBadge = createTextLabel(profileCard, {
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
	createCorner(statusBadge, 999)

	local sidebar = Instance.new("ScrollingFrame")
	sidebar.Name = "Sidebar"
	sidebar.Parent = mainFrame
	sidebar.Position = UDim2.new(0, 10, 0, 128)
	sidebar.Size = UDim2.new(0, 150, 1, -172)
	sidebar.BackgroundTransparency = 1
	sidebar.ScrollBarThickness = 2
	sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sidebar.BorderSizePixel = 0
	local sideLayout = Instance.new("UIListLayout")
	sideLayout.Parent = sidebar
	sideLayout.Padding = UDim.new(0, 6)

	local contentArea = createFrame(mainFrame, {
		Name = "ContentArea",
		Size = UDim2.new(1, -172, 1, -172),
		Position = UDim2.new(0, 166, 0, 128),
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.05,
	})
	createCorner(contentArea, 12)
	createStroke(contentArea, theme.Line, 1, 0.35)

	local statusBar = createFrame(mainFrame, {
		Name = "StatusBar",
		Size = UDim2.new(1, -20, 0, 32),
		Position = UDim2.new(0, 10, 1, -38),
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.08,
	})
	createCorner(statusBar, 10)
	createStroke(statusBar, theme.Line, 1, 0.4)
	local statusText = createTextLabel(statusBar, {
		Name = "StatusText",
		Text = "  Status: System Secure & Stable",
		TextColor3 = theme.SubText,
		TextSize = 10,
		Font = Enum.Font.GothamBold,
		Position = UDim2.new(0, 6, 0, 0),
		Size = UDim2.new(0, 240, 1, 0),
	})
	local clockText = createTextLabel(statusBar, {
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
				clockText.Text = os.date("%H:%M:%S") .. "  "
			end)
		end
	end)

	local Window = {
		Theme = theme,
		ThemeName = themeKey,
		TabFrames = {},
		TabButtons = {},
		FirstTabSet = false,
		NotifHolder = notifHolder,
		MainFrame = mainFrame,
		Sidebar = sidebar,
		ContentArea = contentArea,
		ProfileCard = profileCard,
	}

	function Window:ApplyTheme(newThemeKey)
		local selected = THEMES[newThemeKey] or THEMES.Monochrome
		self.Theme = selected
		self.ThemeName = newThemeKey
		mainFrame.BackgroundColor3 = selected.Bg
		topBar.BackgroundColor3 = selected.Header
		profileCard.BackgroundColor3 = selected.Card
		contentArea.BackgroundColor3 = selected.Bg2
		statusBar.BackgroundColor3 = selected.Card
		titleLabel.TextColor3 = selected.Accent
		nameLabel.TextColor3 = selected.Accent
		statusBadge.BackgroundColor3 = selected.Accent
		statusBadge.TextColor3 = selected.Bg
		idLabel.TextColor3 = selected.SubText
		clockText.TextColor3 = selected.Accent
		statusText.TextColor3 = selected.SubText
		for _, btn in pairs(self.TabButtons) do
			btn.TextColor3 = selected.SubText
		end
	end

	function Window:Notify(arg1, arg2, arg3, arg4)
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
					BackgroundTransparency = 1,
				}):Play()
				task.wait(0.2)
				if toast and toast.Parent then toast:Destroy() end
			end)
		end)
	end

	function Window:CreateTab(name, icon)
		local tabBtn = createTextButton(sidebar, {
			Name = "Tab_" .. name,
			Text = "  " .. (icon or "•") .. "  " .. name,
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
		scroll.Parent = contentArea
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
			doClickPulse(tabBtn, self.Theme.Accent)
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

		local Tab = { Container = scroll, Theme = self.Theme, Window = self }

		function Tab:AddSection(text)
			local label = createTextLabel(self.Container, {
				Name = "Section",
				Text = "— " .. tostring(text) .. " —",
				TextColor3 = self.Theme.SubText,
				TextSize = 10,
				Font = Enum.Font.GothamBold,
				Size = UDim2.new(1, 0, 0, 20),
				TextXAlignment = Enum.TextXAlignment.Center,
			})
			return label
		end

		function Tab:AddLabel(text)
			local label = createTextLabel(self.Container, {
				Name = "Label",
				Text = "  " .. tostring(text),
				TextColor3 = self.Theme.SubText,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				Size = UDim2.new(1, 0, 0, 20),
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			return label
		end

		function Tab:AddInfoCard(title, value)
			local card = createFrame(self.Container, {
				Name = "InfoCard",
				Size = UDim2.new(1, 0, 0, 56),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.1,
			})
			createCorner(card, 8)
			createStroke(card, self.Theme.Line, 1, 0.4)
			createTextLabel(card, {
				Name = "Title",
				Text = tostring(title),
				TextColor3 = self.Theme.SubText,
				TextSize = 10,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 10, 0, 8),
				Size = UDim2.new(1, -20, 0, 14),
			})
			createTextLabel(card, {
				Name = "Value",
				Text = tostring(value),
				TextColor3 = self.Theme.Accent,
				TextSize = 14,
				Font = Enum.Font.GothamBlack,
				Position = UDim2.new(0, 10, 0, 24),
				Size = UDim2.new(1, -20, 0, 18),
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
				BackgroundTransparency = 0.1,
				Size = UDim2.new(1, 0, 0, 36),
			})
			createCorner(btn, 8)
			setHover(btn, self.Theme.Card, self.Theme.CardAlt, 0.1, 0.04)
			btn.MouseButton1Click:Connect(function()
				doClickPulse(btn, self.Theme.Accent)
				if callback then pcall(callback) end
			end)
			return btn
		end

		function Tab:AddToggle(text, defaultState, callback)
			local state = defaultState == true
			local btn = createTextButton(self.Container, {
				Name = "ToggleBtn",
				Text = "  " .. tostring(text),
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
				doClickPulse(btn, self.Theme.Accent)
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
				BackgroundTransparency = 0.1,
				Size = UDim2.new(1, 0, 0, 36),
				PlaceholderText = placeholder or "",
				PlaceholderColor3 = self.Theme.SubText,
				ClearTextOnFocus = false,
			})
			createCorner(box, 8)
			createStroke(box, self.Theme.Line, 1, 0.25)
			box.FocusLost:Connect(function(enterPressed)
				if enterPressed and callback then
					pcall(callback, box.Text)
				end
			end)
			return box
		end

		function Tab:AddSearchBox(placeholder, callback)
			local box = self:AddTextBox(placeholder or "Search...", "", function(value)
				if callback then pcall(callback, value) end
			end)
			box.Name = "SearchBox"
			box.TextColor3 = self.Theme.Text
			return box
		end

		function Tab:AddSlider(text, minValue, maxValue, currentValue, callback)
			local minV = tonumber(minValue) or 0
			local maxV = tonumber(maxValue) or 100
			local curV = clamp(tonumber(currentValue) or minV, minV, maxV)
			local frame = createFrame(self.Container, {
				Name = "SliderFrame",
				Size = UDim2.new(1, 0, 0, 50),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.1,
			})
			createCorner(frame, 8)
			createStroke(frame, self.Theme.Line, 1, 0.25)
			local label = createTextLabel(frame, {
				Name = "SliderLabel",
				Text = "  " .. tostring(text) .. ": " .. tostring(curV),
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
				if not dragging then return end
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					local pos = clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					fill.Size = UDim2.new(pos, 0, 1, 0)
					local val = math.floor(minV + ((maxV - minV) * pos))
					label.Text = "  " .. tostring(text) .. ": " .. tostring(val)
					if callback then pcall(callback, val) end
				end
			end)
			return frame
		end

		function Tab:AddDropdown(text, options, callback)
			local optionList = options or {}
			local selected = optionList[1]
			local open = false
			local drop = createFrame(self.Container, {
				Name = "DropdownFrame",
				Size = UDim2.new(1, 0, 0, 36),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.1,
			})
			createCorner(drop, 8)
			createStroke(drop, self.Theme.Line, 1, 0.2)
			local mainBtn = createTextButton(drop, {
				Name = "DropdownToggle",
				Text = "  " .. tostring(text) .. ": " .. tostring(selected or "Select..."),
				TextColor3 = self.Theme.Text,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 36),
			})
			local listFrame = createFrame(drop, {
				Name = "DropdownList",
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 36),
				BackgroundColor3 = self.Theme.Bg2,
				BackgroundTransparency = 0.08,
			})
			createCorner(listFrame, 8)
			createStroke(listFrame, self.Theme.Line, 1, 0.2)
			local listLayout = Instance.new("UIListLayout")
			listLayout.Parent = listFrame
			listLayout.Padding = UDim.new(0, 2)
			listFrame.Visible = false
			local optionButtons = {}
			for _, opt in ipairs(optionList) do
				local optionBtn = createTextButton(listFrame, {
					Name = "Option",
					Text = "    • " .. tostring(opt),
					TextColor3 = self.Theme.SubText,
					TextSize = 10,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundColor3 = self.Theme.CardAlt,
					BackgroundTransparency = 0.2,
					Size = UDim2.new(1, -6, 0, 26),
					Position = UDim2.new(0, 3, 0, 0),
				})
				createCorner(optionBtn, 6)
				optionBtn.MouseButton1Click:Connect(function()
					selected = opt
					mainBtn.Text = "  " .. tostring(text) .. ": " .. tostring(opt)
					open = false
					listFrame.Visible = false
					if callback then pcall(callback, opt) end
				end)
				optionButtons[#optionButtons + 1] = optionBtn
			end
			mainBtn.MouseButton1Click:Connect(function()
				doClickPulse(mainBtn, self.Theme.Accent)
				open = not open
				listFrame.Visible = open
				local height = math.max(0, (#optionList * 28))
				listFrame.Size = UDim2.new(1, 0, 0, open and height or 0)
			end)
			return drop
		end

		function Tab:AddMultiSelectDropdown(text, options, callback)
			local selected = {}
			local optionList = options or {}
			local open = false
			local drop = createFrame(self.Container, {
				Name = "MultiDropdownFrame",
				Size = UDim2.new(1, 0, 0, 36),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.1,
			})
			createCorner(drop, 8)
			createStroke(drop, self.Theme.Line, 1, 0.2)
			local mainBtn = createTextButton(drop, {
				Name = "MultiDropdownToggle",
				Text = "  " .. tostring(text) .. ": " .. tostring(#selected) .. " selected",
				TextColor3 = self.Theme.Text,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 36),
			})
			local listFrame = createFrame(drop, {
				Name = "MultiDropdownList",
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 36),
				BackgroundColor3 = self.Theme.Bg2,
				BackgroundTransparency = 0.08,
			})
			createCorner(listFrame, 8)
			createStroke(listFrame, self.Theme.Line, 1, 0.2)
			local listLayout = Instance.new("UIListLayout")
			listLayout.Parent = listFrame
			listLayout.Padding = UDim.new(0, 2)
			listFrame.Visible = false
			local function refreshSelectedLabel()
				local labels = {}
				for _, v in ipairs(selected) do
					table.insert(labels, tostring(v))
				end
				mainBtn.Text = "  " .. tostring(text) .. ": " .. (#labels > 0 and table.concat(labels, ", ") or "None")
				if callback then pcall(callback, selected) end
			end
			for _, opt in ipairs(optionList) do
				local optionBtn = createTextButton(listFrame, {
					Name = "Option",
					Text = "    • " .. tostring(opt),
					TextColor3 = self.Theme.SubText,
					TextSize = 10,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundColor3 = self.Theme.CardAlt,
					BackgroundTransparency = 0.2,
					Size = UDim2.new(1, -6, 0, 26),
					Position = UDim2.new(0, 3, 0, 0),
				})
				createCorner(optionBtn, 6)
				optionBtn.MouseButton1Click:Connect(function()
					local found = false
					for index, value in ipairs(selected) do
						if value == opt then
							table.remove(selected, index)
							found = true
							break
						end
					end
					if not found then
						table.insert(selected, opt)
					end
					refreshSelectedLabel()
				end)
			end
			mainBtn.MouseButton1Click:Connect(function()
				doClickPulse(mainBtn, self.Theme.Accent)
				open = not open
				listFrame.Visible = open
				local height = math.max(0, (#optionList * 28))
				listFrame.Size = UDim2.new(1, 0, 0, open and height or 0)
			end)
			return drop
		end

		function Tab:AddGroupCard(title, callback)
			local group = createFrame(self.Container, {
				Name = "GroupCard",
				Size = UDim2.new(1, 0, 0, 120),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.1,
			})
			createCorner(group, 10)
			createStroke(group, self.Theme.Line, 1, 0.2)
			local head = createTextLabel(group, {
				Name = "GroupHeader",
				Text = "  " .. tostring(title),
				TextColor3 = self.Theme.Accent,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 8, 0, 8),
				Size = UDim2.new(1, -16, 0, 18),
			})
			local body = createFrame(group, {
				Name = "GroupBody",
				Size = UDim2.new(1, -16, 1, -36),
				Position = UDim2.new(0, 8, 0, 30),
				BackgroundTransparency = 1,
			})
			local list = Instance.new("UIListLayout")
			list.Parent = body
			list.Padding = UDim.new(0, 6)
			if callback then pcall(callback, body) end
			return body
		end

		function Tab:AddList(items)
			local listFrame = createFrame(self.Container, {
				Name = "ListFrame",
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
			})
			local layout = Instance.new("UIListLayout")
			layout.Parent = listFrame
			layout.Padding = UDim.new(0, 4)
			for _, item in ipairs(items or {}) do
				local row = createTextLabel(listFrame, {
					Name = "ListRow",
					Text = "• " .. tostring(item),
					TextColor3 = self.Theme.SubText,
					TextSize = 10,
					Font = Enum.Font.Gotham,
					Size = UDim2.new(1, 0, 0, 18),
				})
			end
			return listFrame
		end

		function Tab:AddConfigRow(label, valueText, accent)
			local row = createFrame(self.Container, {
				Name = "ConfigRow",
				Size = UDim2.new(1, 0, 0, 34),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.12,
			})
			createCorner(row, 8)
			local left = createTextLabel(row, {
				Name = "LeftText",
				Text = "  " .. tostring(label),
				TextColor3 = self.Theme.Text,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 8, 0, 0),
				Size = UDim2.new(1, -110, 1, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			local right = createTextLabel(row, {
				Name = "RightText",
				Text = tostring(valueText or "0"),
				TextColor3 = accent or self.Theme.Accent,
				TextSize = 10,
				Font = Enum.Font.GothamBlack,
				Position = UDim2.new(1, -90, 0, 0),
				Size = UDim2.new(0, 80, 1, 0),
				TextXAlignment = Enum.TextXAlignment.Right,
			})
			return row
		end

		function Tab:AddValueSet(label, value, callback)
			local frame = createFrame(self.Container, {
				Name = "ValueSetRow",
				Size = UDim2.new(1, 0, 0, 36),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.1,
			})
			createCorner(frame, 8)
			createTextLabel(frame, {
				Name = "Label",
				Text = "  " .. tostring(label),
				TextColor3 = self.Theme.Text,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 8, 0, 0),
				Size = UDim2.new(0.5, 0, 1, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			local box = createTextBox(frame, {
				Name = "ValueBox",
				Text = tostring(value or "0"),
				TextColor3 = self.Theme.Accent,
				TextSize = 11,
				Font = Enum.Font.GothamBold,
				BackgroundColor3 = self.Theme.Bg2,
				BackgroundTransparency = 0.15,
				Size = UDim2.new(0.38, -10, 0, 22),
				Position = UDim2.new(1, -120, 0.5, -11),
				TextXAlignment = Enum.TextXAlignment.Center,
			})
			createCorner(box, 6)
			box.FocusLost:Connect(function(enterPressed)
				if enterPressed and callback then pcall(callback, box.Text) end
			end)
			return frame
		end

		return Tab
	end

	closeBtn.MouseButton1Click:Connect(function()
		mainFrame.Visible = false
	end)
	minimizeBtn.MouseButton1Click:Connect(function()
		if mainFrame.Visible then
			mainFrame.Visible = false
		else
			mainFrame.Visible = true
		end
	end)
	toggleBtn.MouseButton1Click:Connect(function()
		mainFrame.Visible = not mainFrame.Visible
	end)

	Window:Notify("Success", "System", "MofenkUI Premium Monochrome active.", 3)
	return Window
end

return MofenkUI
