--[====================================================================]
-- Mofenk UI Library - Next-Gen Exploit Framework
-- Supports: Window, Tabs, Group Cards, Toggles, Inputs, Dropdowns, Notifications
--[====================================================================]

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local MofenkUI = {}

local GLASS_THEME = {
	Bg     = Color3.fromRGB(15, 15, 15),
	Card   = Color3.fromRGB(28, 28, 28),
	Header = Color3.fromRGB(22, 22, 22),
	Acc1   = Color3.fromRGB(255, 255, 255),
	Acc2   = Color3.fromRGB(200, 200, 200),
	Text   = Color3.fromRGB(240, 240, 240),
	SubText= Color3.fromRGB(160, 160, 160)
}

function MofenkUI.CreateWindow(config)
	config = config or {}
	local titleText = config.Name or "MofenkHub"
	local successGui, parentGui = pcall(function()
		if gethui then return gethui() elseif CoreGui:FindFirstChild("RobloxGui") then return CoreGui else return LocalPlayer:WaitForChild("PlayerGui") end
	end)
	if not successGui or not parentGui then parentGui = LocalPlayer:WaitForChild("PlayerGui") end

	-- Clear old GUI
	pcall(function()
		for _, v in pairs(parentGui:GetChildren()) do
			if string.find(v.Name, "Mofenk") then
				v:Destroy()
			end
		end
	end)

	-- Floating Toggle Button
	local ToggleGui = Instance.new("ScreenGui")
	ToggleGui.Name = "MofenkToggleFront"
	ToggleGui.Parent = parentGui
	ToggleGui.ResetOnSpawn = false
	ToggleGui.DisplayOrder = 99999

	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Parent = ToggleGui
	ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
	ToggleBtn.Position = UDim2.new(0.02, 0, 0.4, 0)
	ToggleBtn.BackgroundColor3 = GLASS_THEME.Card
	ToggleBtn.Text = "AI"
	ToggleBtn.Font = Enum.Font.GothamBlack
	ToggleBtn.TextSize = 22
	ToggleBtn.TextColor3 = GLASS_THEME.Acc1
	ToggleBtn.ZIndex = 99999
	
	local TC = Instance.new("UICorner")
	TC.CornerRadius = UDim.new(0, 14)
	TC.Parent = ToggleBtn
	
	local TS = Instance.new("UIStroke")
	TS.Thickness = 2
	TS.Color = GLASS_THEME.Acc1
	TS.Parent = ToggleBtn

	-- Draggable Toggle Button
	local dragging, dragInput, dragStart, startPos
	ToggleBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = ToggleBtn.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	ToggleBtn.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			local viewport = workspace.CurrentCamera.ViewportSize
			ToggleBtn.Position = UDim2.new(0, math.clamp(startPos.X.Offset + delta.X, 10, viewport.X - 60), 0, math.clamp(startPos.Y.Offset + delta.Y, 10, viewport.Y - 60))
		end
	end)

	-- Toast Notification GUI
	local NotifyGui = Instance.new("ScreenGui")
	NotifyGui.Name = "MofenkNotifyGui"
	NotifyGui.Parent = parentGui
	NotifyGui.ResetOnSpawn = false

	local NotifyHolder = Instance.new("Frame")
	NotifyHolder.Parent = NotifyGui
	NotifyHolder.Position = UDim2.new(1, -280, 0, 20)
	NotifyHolder.Size = UDim2.new(0, 260, 1, -40)
	NotifyHolder.BackgroundTransparency = 1

	local NotifyLayout = Instance.new("UIListLayout")
	NotifyLayout.Parent = NotifyHolder
	NotifyLayout.Padding = UDim.new(0, 8)
	NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Top

	local function Notify(title, msg, duration)
		duration = duration or 3.5
		local Card = Instance.new("Frame")
		Card.Parent = NotifyHolder
		Card.Size = UDim2.new(1, 0, 0, 56)
		Card.BackgroundColor3 = GLASS_THEME.Card
		Card.BackgroundTransparency = 0.15

		local CC = Instance.new("UICorner")
		CC.CornerRadius = UDim.new(0, 8)
		CC.Parent = Card

		local CS = Instance.new("UIStroke")
		CS.Thickness = 1.2
		CS.Color = GLASS_THEME.Acc1
		CS.Parent = Card

		local T = Instance.new("TextLabel")
		T.Parent = Card
		T.Position = UDim2.new(0, 10, 0, 5)
		T.Size = UDim2.new(1, -20, 0, 20)
		T.Text = title
		T.TextColor3 = GLASS_THEME.Acc1
		T.Font = Enum.Font.GothamBold
		T.TextSize = 13
		T.TextXAlignment = Enum.TextXAlignment.Left
		T.BackgroundTransparency = 1

		local M = Instance.new("TextLabel")
		M.Parent = Card
		M.Position = UDim2.new(0, 10, 0, 25)
		M.Size = UDim2.new(1, -20, 0, 26)
		M.Text = msg
		M.TextColor3 = GLASS_THEME.Text
		M.Font = Enum.Font.GothamMedium
		M.TextSize = 11
		M.TextXAlignment = Enum.TextXAlignment.Left
		M.TextWrapped = true
		M.BackgroundTransparency = 1

		Card.Position = UDim2.new(1, 40, 0, 0)
		TweenService:Create(Card, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

		task.delay(duration, function()
			if Card and Card.Parent then
				local tw = TweenService:Create(Card, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1, Position = UDim2.new(1, 40, 0, 0)})
				tw:Play()
				tw.Completed:Connect(function() Card:Destroy() end)
			end
		end)
	end

	-- Main UI Frame
	local MainGui = Instance.new("ScreenGui")
	MainGui.Name = "MofenkUltraHubV104"
	MainGui.Parent = parentGui
	MainGui.ResetOnSpawn = false

	local MainFrame = Instance.new("Frame")
	MainFrame.Parent = MainGui
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.Size = UDim2.new(0, 880, 0, 560)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.Visible = false
	MainFrame.BackgroundColor3 = GLASS_THEME.Bg
	MainFrame.BackgroundTransparency = 0.05

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 14)
	MainCorner.Parent = MainFrame

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Thickness = 1.8
	MainStroke.Color = GLASS_THEME.Acc1
	MainStroke.Parent = MainFrame

	local ScreenScale = Instance.new("UIScale")
	ScreenScale.Parent = MainGui
	local baseAutoMultiplier = 1.0
	local userManualZoom = 1.0

	local function UpdateScale()
		local viewport = workspace.CurrentCamera.ViewportSize
		local isMobileOrSmall = viewport.X < 900 or viewport.Y < 550
		local targetBase = isMobileOrSmall and (viewport.X / 1100) or (viewport.X / 1300)
		baseAutoMultiplier = math.clamp(targetBase, 0.55, 1.20)
		ScreenScale.Scale = baseAutoMultiplier * userManualZoom
	end
	UpdateScale()
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)

	ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

	-- Top Bar
	local TopBar = Instance.new("Frame")
	TopBar.Parent = MainFrame
	TopBar.Size = UDim2.new(1, 0, 0, 48)
	TopBar.BackgroundColor3 = GLASS_THEME.Header
	TopBar.BackgroundTransparency = 0.1

	local TopCorner = Instance.new("UICorner")
	TopCorner.CornerRadius = UDim.new(0, 14)
	TopCorner.Parent = TopBar

	local Title = Instance.new("TextLabel")
	Title.Parent = TopBar
	Title.Position = UDim2.new(0, 16, 0, 0)
	Title.Size = UDim2.new(0, 220, 1, 0)
	Title.Text = titleText
	Title.TextColor3 = GLASS_THEME.Acc1
	Title.TextSize = 13
	Title.Font = Enum.Font.GothamBlack
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.BackgroundTransparency = 1

	local StatusBar = Instance.new("TextLabel")
	StatusBar.Parent = TopBar
	StatusBar.Position = UDim2.new(0, 230, 0, 8)
	StatusBar.Size = UDim2.new(0, 490, 0, 32)
	StatusBar.BackgroundColor3 = GLASS_THEME.Card
	StatusBar.BackgroundTransparency = 0.2
	StatusBar.TextColor3 = GLASS_THEME.SubText
	StatusBar.TextSize = 10
	StatusBar.Font = Enum.Font.GothamMedium
	StatusBar.Text = "🤖 AI Status: Monochromatic & Secure Mode"
	
	local SBC = Instance.new("UICorner")
	SBC.CornerRadius = UDim.new(0, 6)
	SBC.Parent = StatusBar

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Parent = TopBar
	CloseBtn.Position = UDim2.new(1, -42, 0, 8)
	CloseBtn.Size = UDim2.new(0, 32, 0, 32)
	CloseBtn.Text = "✕"
	CloseBtn.TextColor3 = GLASS_THEME.Text
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 15
	CloseBtn.BackgroundColor3 = GLASS_THEME.Card
	CloseBtn.BackgroundTransparency = 0.2
	
	local CC = Instance.new("UICorner")
	CC.CornerRadius = UDim.new(0, 8)
	CC.Parent = CloseBtn
	CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

	local ZoomOutBtn = Instance.new("TextButton")
	ZoomOutBtn.Parent = TopBar
	ZoomOutBtn.Position = UDim2.new(1, -78, 0, 8)
	ZoomOutBtn.Size = UDim2.new(0, 32, 0, 32)
	ZoomOutBtn.Text = "-"
	ZoomOutBtn.TextColor3 = GLASS_THEME.Text
	ZoomOutBtn.Font = Enum.Font.GothamBold
	ZoomOutBtn.TextSize = 16
	ZoomOutBtn.BackgroundColor3 = GLASS_THEME.Card
	ZoomOutBtn.BackgroundTransparency = 0.2
	
	local ZOC = Instance.new("UICorner")
	ZOC.CornerRadius = UDim.new(0, 8)
	ZOC.Parent = ZoomOutBtn

	local ZoomInBtn = Instance.new("TextButton")
	ZoomInBtn.Parent = TopBar
	ZoomInBtn.Position = UDim2.new(1, -114, 0, 8)
	ZoomInBtn.Size = UDim2.new(0, 32, 0, 32)
	ZoomInBtn.Text = "+"
	ZoomInBtn.TextColor3 = GLASS_THEME.Text
	ZoomInBtn.Font = Enum.Font.GothamBold
	ZoomInBtn.TextSize = 15
	ZoomInBtn.BackgroundColor3 = GLASS_THEME.Card
	ZoomInBtn.BackgroundTransparency = 0.2
	
	local ZIC = Instance.new("UICorner")
	ZIC.CornerRadius = UDim.new(0, 8)
	ZIC.Parent = ZoomInBtn

	ZoomInBtn.MouseButton1Click:Connect(function()
		userManualZoom = math.clamp(userManualZoom + 0.1, 0.5, 1.8)
		ScreenScale.Scale = baseAutoMultiplier * userManualZoom
	end)

	ZoomOutBtn.MouseButton1Click:Connect(function`skipping`
		userManualZoom = math.clamp(userManualZoom - 0.1, 0.5, 1.8)
		ScreenScale.Scale = baseAutoMultiplier * userManualZoom
	end)

	-- Sidebar Navigation
	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Parent = MainFrame
	Sidebar.Position = UDim2.new(0, 10, 0, 56)
	Sidebar.Size = UDim2.new(0, 180, 1, -66)
	Sidebar.BackgroundTransparency = 1
	Sidebar.ScrollBarThickness = 2
	Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Sidebar.CanvasSize = UDim2.new(0,0,0,0)
	
	local SideLayout = Instance.new("UIListLayout")
	Sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
	SideLayout.Parent = Sidebar
	SideLayout.Padding = UDim.new(0, 5)

	-- Content Area
	local ContentArea = Instance.new("Frame")
	ContentArea.Parent = MainFrame
	ContentArea.Position = UDim2.new(0, 198, 0, 56)
	ContentArea.Size = UDim2.new(1, -208, 1, -66)
	ContentArea.BackgroundColor3 = GLASS_THEME.Header
	ContentArea.BackgroundTransparency = 0.2
	
	local ContentCorner = Instance.new("UICorner")
	ContentCorner.CornerRadius = UDim.new(0, 12)
	ContentCorner.Parent = ContentArea

	local WindowObj = {
		TabFrames = {},
		TabButtons = {},
		FirstTabSet = false,
		Notify = Notify,
		MainFrame = MainFrame,
		Sidebar = Sidebar,
		Theme = GLASS_THEME
	}

	function WindowObj:CreateTab(name, icon)
		local Btn = Instance.new("TextButton")
		Btn.Parent = Sidebar
		Btn.Size = UDim2.new(1, -4, 0, 38)
		Btn.Text = "  " .. icon .. "  " .. name
		Btn.TextColor3 = GLASS_THEME.SubText
		Btn.TextSize = 12
		Btn.Font = Enum.Font.GothamBold
		Btn.TextXAlignment = Enum.TextXAlignment.Left
		Btn.BackgroundColor3 = GLASS_THEME.Card
		Btn.BackgroundTransparency = 0.3
		
		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 8)
		Corner.Parent = Btn
		
		local Scroll = Instance.new("ScrollingFrame")
		Scroll.Parent = ContentArea
		Scroll.Size = UDim2.new(1, -14, 1, -14)
		Scroll.Position = UDim2.new(0, 7, 0, 7)
		Scroll.BackgroundTransparency = 1
		Scroll.ScrollBarThickness = 4
		Scroll.Visible = false
		Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Scroll.CanvasSize = UDim2.new(0,0,0,0)
		
		local Lay = Instance.new("UIListLayout")
		Lay.Parent = Scroll
		Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
		Lay.Padding = UDim.new(0, 10)
		
		self.TabFrames[name] = Scroll
		self.TabButtons[name] = Btn
		
		if not self.FirstTabSet then
			Scroll.Visible = true
			Btn.BackgroundTransparency = 0.05
			Btn.TextColor3 = GLASS_THEME.Acc1
			self.FirstTabSet = true
		end
		
		Btn.MouseButton1Click:Connect(function()
			for n, f in pairs(self.TabFrames) do f.Visible = (n == name) end
			for _, b in pairs(self.TabButtons) do b.BackgroundTransparency = 0.3; b.TextColor3 = GLASS_THEME.SubText; b.BackgroundColor3 = GLASS_THEME.Card end
			Btn.BackgroundTransparency = 0.05
			Btn.TextColor3 = GLASS_THEME.Acc1
			Btn.BackgroundColor3 = GLASS_THEME.Card
		end)
		
		return Scroll
	end

	return WindowObj
end

return MofenkUI
