--[====================================================================]
-- MofenkUI - Premium Monochrome Dark Glass & Modern Theme Engine
-- Stable, Mobile Friendly, Fully Animated, Responsive Viewport
-- Fixed & production-ready for MofenkHub
--[====================================================================]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") or nil

local MofenkUI = {}

local THEMES = {
	Monochrome = {
		Bg = Color3.fromRGB(11, 11, 13),
		Bg2 = Color3.fromRGB(17, 18, 22),
		Card = Color3.fromRGB(24, 25, 31),
		CardAlt = Color3.fromRGB(34, 36, 43),
		Header = Color3.fromRGB(14, 15, 18),
		Accent = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(157, 162, 175),
		Text = Color3.fromRGB(243, 246, 255),
		Success = Color3.fromRGB(130, 255, 180),
		Warning = Color3.fromRGB(255, 195, 90),
		Danger = Color3.fromRGB(255, 112, 112),
		Line = Color3.fromRGB(255, 255, 255),
		Glow = Color3.fromRGB(70, 130, 255),
	},
	PureBlack = {
		Bg = Color3.fromRGB(5, 5, 5),
		Bg2 = Color3.fromRGB(12, 12, 12),
		Card = Color3.fromRGB(18, 18, 18),
		CardAlt = Color3.fromRGB(29, 29, 29),
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
		Bg = Color3.fromRGB(9, 13, 22),
		Bg2 = Color3.fromRGB(16, 22, 32),
		Card = Color3.fromRGB(22, 31, 44),
		CardAlt = Color3.fromRGB(32, 45, 61),
		Header = Color3.fromRGB(12, 17, 25),
		Accent = Color3.fromRGB(92, 184, 255),
		SubText = Color3.fromRGB(152, 168, 191),
		Text = Color3.fromRGB(235, 241, 255),
		Success = Color3.fromRGB(102, 255, 191),
		Warning = Color3.fromRGB(255, 201, 118),
		Danger = Color3.fromRGB(255, 110, 110),
		Line = Color3.fromRGB(110, 167, 255),
		Glow = Color3.fromRGB(92, 184, 255),
	},
}

local function clamp(value, minValue, maxValue)
	return math.max(minValue, math.min(value, maxValue))
end

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
	if button and button.MouseEnter and button.MouseLeave then
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
end

local function safeDestroy(obj)
	if obj and obj.Destroy then
		pcall(function() obj:Destroy() end)
	end
end

local function getPlayerGui()
	if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
		return LocalPlayer.PlayerGui
	end
	return nil
end

function MofenkUI.CreateWindow(config)
	config = config or {}

	local themeKey = config.Theme or "Monochrome"
	local theme = THEMES[themeKey] or THEMES.Monochrome
	local titleText = config.Name or "MofenkHub"
	local toggleStyle = config.ToggleStyle or "Icon"
	local profileTitle = config.ProfileTitle or "VIP Premium"
	local guiParent = getPlayerGui()

	if guiParent then
		pcall(function()
			for _, v in ipairs(guiParent:GetChildren()) do
				if v.Name and string.find(v.Name, "Mofenk") then
					safeDestroy(v)
				end
			end
			for _, v in ipairs(CoreGui:GetChildren()) do
				if v.Name and string.find(v.Name, "Mofenk") then
					safeDestroy(v)
				end
			end
		end)
	end

	local NotifGui = Instance.new("ScreenGui")
	NotifGui.Name = "MofenkNotifications"
	NotifGui.ResetOnSpawn = false
	NotifGui.Parent = guiParent or PlayerGui or CoreGui
	NotifGui.DisplayOrder = 1000000
	NotifGui.IgnoreGuiInset = true

	local NotifHolder = createFrame(NotifGui, {
		Name = "NotifHolder",
		Size = UDim2.new(0, 300, 0, 420),
		Position = UDim2.new(1, -22, 1, -22),
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
	ToggleGui.Parent = guiParent or PlayerGui or CoreGui
	ToggleGui.DisplayOrder = 999999
	ToggleGui.IgnoreGuiInset = true

	local ToggleBtn = createTextButton(ToggleGui, {
		Name = "ToggleBtn",
		Text = toggleStyle == "Bar" and "  ⚡ MofenkHub  " or "M",
		TextColor3 = theme.Accent,
		TextSize = toggleStyle == "Bar" and 12 or 20,
		Font = Enum.Font.GothamBlack,
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.08,
		Size = toggleStyle == "Bar" and UDim2.new(0, 130, 0, 38) or UDim2.new(0, 52, 0, 52),
		Position = toggleStyle == "Bar" and UDim2.new(0.5, -65, 0, 12) or UDim2.new(0.03, 0, 0.35, 0),
		TextXAlignment = toggleStyle == "Bar" and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
	})
	createCorner(ToggleBtn, toggleStyle == "Bar" and 10 or 16)
	createStroke(ToggleBtn, theme.Line, 1.2, 0.45)

	local MainGui = Instance.new("ScreenGui")
	MainGui.Name = "MofenkPremiumHub"
	MainGui.ResetOnSpawn = false
	MainGui.Parent = guiParent or PlayerGui or CoreGui
	MainGui.DisplayOrder = 999998
	MainGui.IgnoreGuiInset = true

	local MainFrame = createFrame(MainGui, {
		Name = "MainFrame",
		Size = UDim2.new(0, 820, 0, 500),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Bg,
		BackgroundTransparency = 0.04,
	})
	createCorner(MainFrame, 18)
	createStroke(MainFrame, theme.Line, 1.2, 0.3)

	local function updateScale()
		local cam = workspace.CurrentCamera
		if cam then
			local vp = cam.ViewportSize
			if vp.X < 760 then
				MainFrame.Size = UDim2.new(0, math.clamp(vp.X - 30, 340, 780), 0, math.clamp(vp.Y - 40, 300, 500))
			else
				MainFrame.Size = UDim2.new(0, 820, 0, 500)
			end
		end
	end
	pcall(function()
		if workspace.CurrentCamera then
			workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
		end
	end)
	updateScale()

	local TopBar = createFrame(MainFrame, {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 52),
		BackgroundColor3 = theme.Header,
		BackgroundTransparency = 0.08,
	})
	createCorner(TopBar, 18)

	local MainLogo = createFrame(TopBar, {
		Name = "MainLogo",
		Size = UDim2.new(0, 18, 0, 18),
		Position = UDim2.new(0, 18, 0, 17),
		BackgroundColor3 = theme.Accent,
	})
	createCorner(MainLogo, 999)
	createStroke(MainLogo, theme.Line, 1, 0.25)

	local TitleLabel = createTextLabel(TopBar, {
		Name = "TitleLabel",
		Text = "VIP-78 >",
		TextColor3 = theme.Accent,
		TextSize = 20,
		Font = Enum.Font.GothamBlack,
		Position = UDim2.new(0, 44, 0, 0),
		Size = UDim2.new(0, 200, 1, 0),
	})

	local AutoButton = createTextButton(TopBar, {
		Name = "AutoButton",
		Text = "Auto ▾",
		TextColor3 = theme.Text,
		TextSize = 13,
		Font = Enum.Font.GothamSemibold,
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.12,
		Size = UDim2.new(0, 122, 0, 30),
		Position = UDim2.new(1, -220, 0.5, -15),
	})
	createCorner(AutoButton, 8)
	createStroke(AutoButton, theme.Line, 1, 0.4)

	local WifiIcon = createTextButton(TopBar, {
		Name = "WifiIcon",
		Text = "◔",
		TextColor3 = theme.Accent,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 24, 0, 24),
		Position = UDim2.new(1, -78, 0.5, -12),
	})

	local SignalText = createTextLabel(TopBar, {
		Name = "SignalText",
		Text = "23ms",
		TextColor3 = theme.SubText,
		TextSize = 11,
		Font = Enum.Font.GothamSemibold,
		Position = UDim2.new(1, -132, 0.5, -10),
		Size = UDim2.new(0, 45, 0, 18),
		TextXAlignment = Enum.TextXAlignment.Right,
	})

	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Name = "Sidebar"
	Sidebar.Parent = MainFrame
	Sidebar.Position = UDim2.new(0, 14, 0, 72)
	Sidebar.Size = UDim2.new(0, 170, 1, -84)
	Sidebar.BackgroundColor3 = theme.Bg2
	Sidebar.BackgroundTransparency = 0.12
	Sidebar.BorderSizePixel = 0
	Sidebar.ScrollBarThickness = 0
	Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Sidebar.ScrollBarImageTransparency = 1

	createCorner(Sidebar, 12)
	createStroke(Sidebar, theme.Line, 1, 0.2)

	local SideLayout = Instance.new("UIListLayout")
	SideLayout.Parent = Sidebar
	SideLayout.Padding = UDim.new(0, 8)
	SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local ContentArea = createFrame(MainFrame, {
		Name = "ContentArea",
		Size = UDim2.new(1, -194, 1, -104),
		Position = UDim2.new(0, 192, 0, 72),
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.08,
	})
	createCorner(ContentArea, 16)
	createStroke(ContentArea, theme.Line, 1, 0.18)

	local RightRail = createFrame(MainFrame, {
		Name = "RightRail",
		Size = UDim2.new(0, 98, 1, -108),
		Position = UDim2.new(1, -100, 0, 72),
		BackgroundTransparency = 1,
	})

	local RailLayout = Instance.new("UIListLayout")
	RailLayout.Parent = RightRail
	RailLayout.Padding = UDim.new(0, 8)
	RailLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local function createRailButton(icon, label)
		local btn = createTextButton(RightRail, {
			Name = "RailButton",
			Text = icon,
			TextColor3 = theme.Text,
			TextSize = 24,
			Font = Enum.Font.GothamBold,
			BackgroundColor3 = theme.Card,
			BackgroundTransparency = 0.08,
			Size = UDim2.new(0, 68, 0, 68),
		})
		createCorner(btn, 18)
		createStroke(btn, theme.Line, 1, 0.28)
		setHover(btn, theme.Card, theme.CardAlt, 0.08, 0.02)

		local name = createTextLabel(btn, {
			Name = "RailLabel",
			Text = label,
			TextColor3 = theme.SubText,
			TextSize = 9,
			Font = Enum.Font.Gotham,
			Position = UDim2.new(0, 0, 1, -18),
			Size = UDim2.new(1, 0, 0, 18),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Center,
		})
		if label and label ~= "" then
			name.Visible = true
		else
			name.Visible = false
		end
		return btn
	end

	local UtilityButtons = {
		{ "◀", "Unggah" },
		{ "◍", "Jendela" },
		{ "◉", "Papan" },
		{ "◐", "Jika" },
		{ "◓", "Bantuan" },
		{ "◒", "Keluar" },
	}

	for _, item in ipairs(UtilityButtons) do
		local btn = createRailButton(item[1], item[2])
		btn.MouseButton1Click:Connect(function()
			WindowObj:Notify("Info", "System", item[2], 1.5)
		end)
	end

	local BottomBar = createFrame(MainFrame, {
		Name = "BottomBar",
		Size = UDim2.new(1, -40, 0, 56),
		Position = UDim2.new(0, 20, 1, -68),
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.10,
	})
	createCorner(BottomBar, 14)
	createStroke(BottomBar, theme.Line, 1, 0.25)

	local leftToggle = createTextButton(BottomBar, {
		Name = "LeftToggle",
		Text = "◀",
		TextColor3 = theme.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.10,
		Size = UDim2.new(0, 36, 0, 36),
		Position = UDim2.new(0, 16, 0.5, -18),
	})
	createCorner(leftToggle, 12)

	local centerGroup = createFrame(BottomBar, {
		Name = "CenterGroup",
		Size = UDim2.new(0, 240, 0, 36),
		Position = UDim2.new(0.5, -120, 0.5, -18),
		BackgroundTransparency = 1,
	})

	local small1 = createTextButton(centerGroup, {
		Name = "Action1",
		Text = "✦",
		TextColor3 = theme.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.10,
		Size = UDim2.new(0, 42, 0, 34),
		Position = UDim2.new(0, 0, 0, 1),
	})
	createCorner(small1, 10)
	local small2 = createTextButton(centerGroup, {
		Name = "Action2",
		Text = "◎",
		TextColor3 = theme.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.10,
		Size = UDim2.new(0, 42, 0, 34),
		Position = UDim2.new(0, 54, 0, 1),
	})
	createCorner(small2, 10)
	local small3 = createTextButton(centerGroup, {
		Name = "Action3",
		Text = "▣",
		TextColor3 = theme.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.10,
		Size = UDim2.new(0, 42, 0, 34),
		Position = UDim2.new(0, 108, 0, 1),
	})
	createCorner(small3, 10)
	local small4 = createTextButton(centerGroup, {
		Name = "Action4",
		Text = "◈",
		TextColor3 = theme.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.10,
		Size = UDim2.new(0, 42, 0, 34),
		Position = UDim2.new(0, 162, 0, 1),
	})
	createCorner(small4, 10)

	local rightToggle = createTextButton(BottomBar, {
		Name = "RightToggle",
		Text = "▶",
		TextColor3 = theme.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = theme.Bg2,
		BackgroundTransparency = 0.10,
		Size = UDim2.new(0, 36, 0, 36),
		Position = UDim2.new(1, -52, 0.5, -18),
	})
	createCorner(rightToggle, 12)

	local WindowObj = {
		Theme = theme,
		ThemeName = themeKey,
		TabFrames = {},
		TabButtons = {},
		FirstTabSet = false,
		NotifHolder = NotifHolder,
		MainFrame = MainFrame,
		Sidebar = Sidebar,
		ContentArea = ContentArea,
		ToggleBtn = ToggleBtn,
	}

	function WindowObj:ApplyTheme(newThemeKey)
		local selected = THEMES[newThemeKey] or THEMES.Monochrome
		self.Theme = selected
		self.ThemeName = newThemeKey
		if MainFrame then MainFrame.BackgroundColor3 = selected.Bg end
		if TopBar then TopBar.BackgroundColor3 = selected.Header end
		if ContentArea then ContentArea.BackgroundColor3 = selected.Bg2 end
		if BottomBar then BottomBar.BackgroundColor3 = selected.Card end
		if TitleLabel then TitleLabel.TextColor3 = selected.Accent end
		if SignalText then SignalText.TextColor3 = selected.SubText end
		for _, btn in pairs(self.TabButtons) do
			if btn then btn.TextColor3 = selected.SubText end
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
					BackgroundTransparency = 1,
				}):Play()
				task.wait(0.2)
				toast:Destroy()
			end)
		end)
	end

	function WindowObj:CreateTab(name, icon)
		local tabBtn = createTextButton(Sidebar, {
			Name = "Tab_" .. name,
			Text = "  " .. (icon or "•") .. "  " .. name,
			TextColor3 = self.Theme.SubText,
			TextSize = 11,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = self.Theme.Card,
			BackgroundTransparency = 0.12,
			Size = UDim2.new(1, -8, 0, 34),
		})
		createCorner(tabBtn, 10)
		setHover(tabBtn, self.Theme.Card, self.Theme.CardAlt, 0.12, 0.04)

		local scroll = Instance.new("ScrollingFrame")
		scroll.Name = "TabScroll_" .. name
		scroll.Parent = ContentArea
		scroll.Size = UDim2.new(1, -10, 1, -10)
		scroll.Position = UDim2.new(0, 5, 0, 5)
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
				btn.BackgroundTransparency = 0.12
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
				Size = UDim2.new(1, 0, 0, 58),
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.08,
			})
			createCorner(card, 10)
			createStroke(card, self.Theme.Line, 1, 0.28)

			createTextLabel(card, {
				Name = "Title",
				Text = title,
				TextColor3 = self.Theme.SubText,
				TextSize = 10,
				Font = Enum.Font.GothamBold,
				Position = UDim2.new(0, 12, 0, 8),
				Size = UDim2.new(1, -24, 0, 14),
			})

			createTextLabel(card, {
				Name = "Value",
				Text = value,
				TextColor3 = self.Theme.Accent,
				TextSize = 16,
				Font = Enum.Font.GothamBlack,
				Position = UDim2.new(0, 12, 0, 22),
				Size = UDim2.new(1, -24, 0, 20),
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
					BackgroundColor3 = state and self.Theme.Accent or self.Theme.CardAlt,
				}):Play()

				TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
					BackgroundColor3 = state and self.Theme.Bg or self.Theme.SubText,
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
				Size = UDim2.new(1, 0, 0, 52),
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
