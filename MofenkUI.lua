--[====================================================================]
-- MofenkUI - Ultimate Pro Universal Edition (All Elements Included)
--[====================================================================]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local MofenkUI = {}

MofenkUI.Themes = {
	DarkGlass = {
		Bg      = Color3.fromRGB(13, 13, 13),
		Card    = Color3.fromRGB(22, 22, 22),
		Header  = Color3.fromRGB(18, 18, 18),
		Accent  = Color3.fromRGB(255, 255, 255),
		Text    = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(140, 140, 140),
		Green   = Color3.fromRGB(46, 204, 113),
		Red     = Color3.fromRGB(231, 76, 60),
		Hover   = Color3.fromRGB(32, 32, 32)
	},
	PurpleNeon = {
		Bg      = Color3.fromRGB(12, 10, 18),
		Card    = Color3.fromRGB(20, 16, 30),
		Header  = Color3.fromRGB(16, 13, 24),
		Accent  = Color3.fromRGB(168, 85, 247),
		Text    = Color3.fromRGB(240, 240, 250),
		SubText = Color3.fromRGB(150, 140, 170),
		Green   = Color3.fromRGB(46, 204, 113),
		Red     = Color3.fromRGB(231, 76, 60),
		Hover   = Color3.fromRGB(30, 24, 45)
	},
	CyberBlue = {
		Bg      = Color3.fromRGB(10, 15, 20),
		Card    = Color3.fromRGB(18, 26, 35),
		Header  = Color3.fromRGB(14, 20, 28),
		Accent  = Color3.fromRGB(56, 189, 248),
		Text    = Color3.fromRGB(240, 245, 250),
		SubText = Color3.fromRGB(130, 150, 170),
		Green   = Color3.fromRGB(46, 204, 113),
		Red     = Color3.fromRGB(231, 76, 60),
		Hover   = Color3.fromRGB(25, 36, 48)
	}
}

function MofenkUI.CreateWindow(config)
	config = config or {}
	local titleText = config.Name or "MofenkHub | Universal"
	local currentTheme = MofenkUI.Themes[config.Theme] or MofenkUI.Themes.DarkGlass

	pcall(function()
		for _, v in pairs(PlayerGui:GetChildren()) do
			if string.find(v.Name, "Mofenk") then v:Destroy() end
		end
		for _, v in pairs(CoreGui:GetChildren()) do
			if string.find(v.Name, "Mofenk") then v:Destroy() end
		end
	end)

	-- Notification GUI
	local NotifGui = Instance.new("ScreenGui")
	NotifGui.Name = "MofenkNotifications"
	NotifGui.Parent = PlayerGui
	NotifGui.ResetOnSpawn = false
	NotifGui.DisplayOrder = 1000000

	local NotifHolder = Instance.new("Frame")
	NotifHolder.Parent = NotifGui
	NotifHolder.AnchorPoint = Vector2.new(1, 1)
	NotifHolder.Position = UDim2.new(1, -20, 1, -20)
	NotifHolder.Size = UDim2.new(0, 280, 0, 400)
	NotifHolder.BackgroundTransparency = 1

	local NotifLayout = Instance.new("UIListLayout")
	NotifLayout.Parent = NotifHolder
	NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	NotifLayout.Padding = UDim.new(0, 8)

	-- Toggle Button
	local ToggleGui = Instance.new("ScreenGui")
	ToggleGui.Name = "MofenkToggleFront"
	ToggleGui.Parent = PlayerGui
	ToggleGui.ResetOnSpawn = false
	ToggleGui.DisplayOrder = 999999

	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Parent = ToggleGui
	ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
	ToggleBtn.Position = UDim2.new(0.03, 0, 0.35, 0)
	ToggleBtn.BackgroundColor3 = currentTheme.Card
	ToggleBtn.Text = "👑"
	ToggleBtn.Font = Enum.Font.GothamBlack
	ToggleBtn.TextSize = 20
	ToggleBtn.TextColor3 = currentTheme.Accent
	ToggleBtn.ZIndex = 999999
	
	local TC = Instance.new("UICorner")
	TC.CornerRadius = UDim.new(0, 12)
	TC.Parent = ToggleBtn
	
	local TS = Instance.new("UIStroke")
	TS.Thickness = 1.5
	TS.Color = currentTheme.Accent
	TS.Parent = ToggleBtn

	local dragging, dragInput, dragStart, startPos
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
			local viewport = workspace.CurrentCamera.ViewportSize
			ToggleBtn.Position = UDim2.new(0, math.clamp(startPos.X.Offset + delta.X, 10, viewport.X - 60), 0, math.clamp(startPos.Y.Offset + delta.Y, 10, viewport.Y - 60))
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	-- Main Window
	local MainGui = Instance.new("ScreenGui")
	MainGui.Name = "MofenkUltraHubV110"
	MainGui.Parent = PlayerGui
	MainGui.ResetOnSpawn = false
	MainGui.DisplayOrder = 999998

	local MainFrame = Instance.new("Frame")
	MainFrame.Parent = MainGui
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.Size = UDim2.new(0, 520, 0, 310)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.Visible = true
	MainFrame.BackgroundColor3 = currentTheme.Bg
	MainFrame.BackgroundTransparency = 0.05

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 10)
	MainCorner.Parent = MainFrame

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Thickness = 1.5
	MainStroke.Color = currentTheme.Accent
	MainStroke.Parent = MainFrame

	ToggleBtn.MouseButton1Click:Connect(function() 
		MainFrame.Visible = not MainFrame.Visible 
	end)

	-- Top Bar
	local TopBar = Instance.new("Frame")
	TopBar.Parent = MainFrame
	TopBar.Size = UDim2.new(1, 0, 0, 40)
	TopBar.BackgroundColor3 = currentTheme.Header
	TopBar.BackgroundTransparency = 0.1

	local TopCorner = Instance.new("UICorner")
	TopCorner.CornerRadius = UDim.new(0, 10)
	TopCorner.Parent = TopBar

	local Title = Instance.new("TextLabel")
	Title.Parent = TopBar
	Title.Position = UDim2.new(0, 14, 0, 0)
	Title.Size = UDim2.new(0, 300, 1, 0)
	Title.Text = "⚡  " .. titleText
	Title.TextColor3 = currentTheme.Accent
	Title.TextSize = 13
	Title.Font = Enum.Font.GothamBold
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.BackgroundTransparency = 1

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Parent = TopBar
	CloseBtn.Position = UDim2.new(1, -36, 0, 6)
	CloseBtn.Size = UDim2.new(0, 28, 0, 28)
	CloseBtn.Text = "✕"
	CloseBtn.TextColor3 = currentTheme.Text
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 13
	CloseBtn.BackgroundColor3 = currentTheme.Card
	CloseBtn.BackgroundTransparency = 0.2
	
	local CC = Instance.new("UICorner")
	CC.CornerRadius = UDim.new(0, 6)
	CC.Parent = CloseBtn
	CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

	local minimized = false
	local origHeight = 310
	local MinimizeBtn = Instance.new("TextButton")
	MinimizeBtn.Parent = TopBar
	MinimizeBtn.Position = UDim2.new(1, -68, 0, 6)
	MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
	MinimizeBtn.Text = "—"
	MinimizeBtn.TextColor3 = currentTheme.Text
	MinimizeBtn.Font = Enum.Font.GothamBold
	MinimizeBtn.TextSize = 13
	MinimizeBtn.BackgroundColor3 = currentTheme.Card
	MinimizeBtn.BackgroundTransparency = 0.2
	
	local MC = Instance.new("UICorner")
	MC.CornerRadius = UDim.new(0, 6)
	MC.Parent = MinimizeBtn

	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Parent = MainFrame
	Sidebar.Position = UDim2.new(0, 8, 0, 48)
	Sidebar.Size = UDim2.new(0, 140, 1, -56)
	Sidebar.BackgroundTransparency = 1
	Sidebar.ScrollBarThickness = 2
	Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	
	local SideLayout = Instance.new("UIListLayout")
	SideLayout.Parent = Sidebar
	SideLayout.Padding = UDim.new(0, 4)

	local ContentArea = Instance.new("Frame")
	ContentArea.Parent = MainFrame
	ContentArea.Position = UDim2.new(0, 154, 0, 48)
	ContentArea.Size = UDim2.new(1, -162, 1, -56)
	ContentArea.BackgroundColor3 = currentTheme.Header
	ContentArea.BackgroundTransparency = 0.2
	
	local ContentCorner = Instance.new("UICorner")
	ContentCorner.CornerRadius = UDim.new(0, 8)
	ContentCorner.Parent = ContentArea

	MinimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			origHeight = MainFrame.AbsoluteSize.Y
			Sidebar.Visible = false
			ContentArea.Visible = false
			TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, MainFrame.AbsoluteSize.X, 0, 40)}):Play()
			MinimizeBtn.Text = "+"
		else
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
	ResizeBtn.TextColor3 = currentTheme.SubText
	ResizeBtn.TextSize = 10
	ResizeBtn.ZIndex = 10

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
			local newWidth = math.clamp(startSize.X + delta.X, 450, 750)
			local newHeight = math.clamp(startSize.Y + delta.Y, 260, 550)
			MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
			origHeight = newHeight
		end
	end)

	local WindowObj = {
		TabFrames = {},
		TabButtons = {},
		FirstTabSet = false,
		Theme = currentTheme
	}

	function WindowObj:Notify(title, text, duration)
		duration = duration or 3
		local NotifCard = Instance.new("Frame")
		NotifCard.Parent = NotifHolder
		NotifCard.Size = UDim2.new(1, 0, 0, 60)
		NotifCard.BackgroundColor3 = currentTheme.Card
		NotifCard.BackgroundTransparency = 0.1

		local NC = Instance.new("UICorner")
		NC.CornerRadius = UDim.new(0, 8)
		NC.Parent = NotifCard

		local NS = Instance.new("UIStroke")
		NS.Thickness = 1
		NS.Color = currentTheme.Accent
		NS.Parent = NotifCard

		local NTitle = Instance.new("TextLabel")
		NTitle.Parent = NotifCard
		NTitle.Position = UDim2.new(0, 10, 0, 6)
		NTitle.Size = UDim2.new(1, -20, 0, 20)
		NTitle.BackgroundTransparency = 1
		NTitle.Text = title
		NTitle.TextColor3 = currentTheme.Accent
		NTitle.Font = Enum.Font.GothamBold
		NTitle.TextSize = 12
		NTitle.TextXAlignment = Enum.TextXAlignment.Left

		local NDesc = Instance.new("TextLabel")
		NDesc.Parent = NotifCard
		NDesc.Position = UDim2.new(0, 10, 0, 26)
		NDesc.Size = UDim2.new(1, -20, 0, 24)
		NDesc.BackgroundTransparency = 1
		NDesc.Text = text
		NDesc.TextColor3 = currentTheme.Text
		NDesc.Font = Enum.Font.Gotham
		NDesc.TextSize = 11
		NDesc.TextXAlignment = Enum.TextXAlignment.Left

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
		Btn.Size = UDim2.new(1, -4, 0, 32)
		Btn.Text = "  " .. icon .. "  " .. name
		Btn.TextColor3 = currentTheme.SubText
		Btn.TextSize = 11
		Btn.Font = Enum.Font.GothamBold
		Btn.TextXAlignment = Enum.TextXAlignment.Left
		Btn.BackgroundColor3 = currentTheme.Card
		Btn.BackgroundTransparency = 0.3
		
		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 6)
		Corner.Parent = Btn
		
		local Scroll = Instance.new("ScrollingFrame")
		Scroll.Parent = ContentArea
		Scroll.Size = UDim2.new(1, -10, 1, -10)
		Scroll.Position = UDim2.new(0, 5, 0, 5)
		Scroll.BackgroundTransparency = 1
		Scroll.ScrollBarThickness = 3
		Scroll.Visible = false
		Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
		
		local Lay = Instance.new("UIListLayout")
		Lay.Parent = Scroll
		Lay.Padding = UDim.new(0, 6)
		
		self.TabFrames[name] = Scroll
		self.TabButtons[name] = Btn
		
		if not self.FirstTabSet then
			Scroll.Visible = true
			Btn.BackgroundTransparency = 0.05
			Btn.TextColor3 = currentTheme.Accent
			self.FirstTabSet = true
		end
		
		Btn.MouseButton1Click:Connect(function()
			for n, f in pairs(self.TabFrames) do f.Visible = (n == name) end
			for _, b in pairs(self.TabButtons) do b.BackgroundTransparency = 0.3; b.TextColor3 = currentTheme.SubText end
			Btn.BackgroundTransparency = 0.05
			Btn.TextColor3 = currentTheme.Accent
		end)
		
		local TabObj = { Container = Scroll }

		-- 1. AddSection (Pembagi Seksi)
		function TabObj:AddSection(text)
			local Sec = Instance.new("TextLabel")
			Sec.Parent = Scroll
			Sec.Size = UDim2.new(1, 0, 0, 26)
			Sec.BackgroundTransparency = 1
			Sec.Text = "── " .. text .. " ──"
			Sec.TextColor3 = currentTheme.Accent
			Sec.Font = Enum.Font.GothamBlack
			Sec.TextSize = 11
			Sec.TextXAlignment = Enum.TextXAlignment.Center
			return Sec
		end

		function TabObj:AddLabel(text)
			local Lbl = Instance.new("TextLabel")
			Lbl.Parent = Scroll
			Lbl.Size = UDim2.new(1, 0, 0, 22)
			Lbl.BackgroundTransparency = 1
			Lbl.Text = "  " .. text
			Lbl.TextColor3 = currentTheme.SubText
			Lbl.Font = Enum.Font.GothamBold
			Lbl.TextSize = 11
			Lbl.TextXAlignment = Enum.TextXAlignment.Left
			return Lbl
		end

		function TabObj:AddButton(text, callback)
			local BtnComp = Instance.new("TextButton")
			BtnComp.Parent = Scroll
			BtnComp.Size = UDim2.new(1, 0, 0, 34)
			BtnComp.BackgroundColor3 = currentTheme.Card
			BtnComp.BackgroundTransparency = 0.2
			BtnComp.Text = "  " .. text
			BtnComp.TextColor3 = currentTheme.Text
			BtnComp.Font = Enum.Font.GothamBold
			BtnComp.TextSize = 11
			BtnComp.TextXAlignment = Enum.TextXAlignment.Left

			local BC = Instance.new("UICorner")
			BC.CornerRadius = UDim.new(0, 6)
			BC.Parent = BtnComp

			BtnComp.MouseButton1Click:Connect(function()
				TweenService:Create(BtnComp, TweenInfo.new(0.1), {BackgroundColor3 = currentTheme.Hover}):Play()
				task.wait(0.1)
				TweenService:Create(BtnComp, TweenInfo.new(0.1), {BackgroundColor3 = currentTheme.Card}):Play()
				pcall(callback)
			end)
		end

		function TabObj:AddToggle(text, defaultState, callback)
			local state = defaultState or false
			local TglBtn = Instance.new("TextButton")
			TglBtn.Parent = Scroll
			TglBtn.Size = UDim2.new(1, 0, 0, 34)
			TglBtn.BackgroundColor3 = currentTheme.Card
			TglBtn.BackgroundTransparency = 0.2
			TglBtn.Text = "  " .. text
			TglBtn.TextColor3 = currentTheme.Text
			TglBtn.Font = Enum.Font.GothamBold
			TglBtn.TextSize = 11
			TglBtn.TextXAlignment = Enum.TextXAlignment.Left

			local TC = Instance.new("UICorner")
			TC.CornerRadius = UDim.new(0, 6)
			TC.Parent = TglBtn

			local StatusIndicator = Instance.new("Frame")
			StatusIndicator.Parent = TglBtn
			StatusIndicator.AnchorPoint = Vector2.new(1, 0.5)
			StatusIndicator.Position = UDim2.new(1, -10, 0.5, 0)
			StatusIndicator.Size = UDim2.new(0, 12, 0, 12)
			StatusIndicator.BackgroundColor3 = state and currentTheme.Green or currentTheme.Red

			local SIC = Instance.new("UICorner")
			SIC.CornerRadius = UDim.new(1, 0)
			SIC.Parent = StatusIndicator

			TglBtn.MouseButton1Click:Connect(function()
				state = not state
				StatusIndicator.BackgroundColor3 = state and currentTheme.Green or currentTheme.Red
				pcall(callback, state)
			end)
		end

		function TabObj:AddTextBox(placeholder, defaultText, callback)
			local TBox = Instance.new("TextBox")
			TBox.Parent = Scroll
			TBox.Size = UDim2.new(1, 0, 0, 34)
			TBox.BackgroundColor3 = currentTheme.Card
			TBox.BackgroundTransparency = 0.2
			TBox.PlaceholderText = placeholder
			TBox.PlaceholderColor3 = currentTheme.SubText
			TBox.Text = defaultText or ""
			TBox.TextColor3 = currentTheme.Accent
			TBox.Font = Enum.Font.Gotham
			TBox.TextSize = 11
			TBox.TextXAlignment = Enum.TextXAlignment.Left

			local TBC = Instance.new("UICorner")
			TBC.CornerRadius = UDim.new(0, 6)
			TBC.Parent = TBox

			local UIP = Instance.new("UIPadding")
			UIP.PaddingLeft = UDim.new(0, 10)
			UIP.Parent = TBox

			TBox.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					pcall(callback, TBox.Text)
				end
			end)
		end

		function TabObj:AddSlider(text, min, max, current, callback)
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Parent = Scroll
			SliderFrame.Size = UDim2.new(1, 0, 0, 48)
			SliderFrame.BackgroundColor3 = currentTheme.Card
			SliderFrame.BackgroundTransparency = 0.2

			local SFC = Instance.new("UICorner")
			SFC.CornerRadius = UDim.new(0, 6)
			SFC.Parent = SliderFrame

			local SliderLabel = Instance.new("TextLabel")
			SliderLabel.Parent = SliderFrame
			SliderLabel.Position = UDim2.new(0, 10, 0, 4)
			SliderLabel.Size = UDim2.new(1, -20, 0, 18)
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.Text = "  " .. text .. ": " .. tostring(current)
			SliderLabel.TextColor3 = currentTheme.Text
			SliderLabel.Font = Enum.Font.GothamBold
			SliderLabel.TextSize = 11
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

			local Bar = Instance.new("Frame")
			Bar.Parent = SliderFrame
			Bar.Position = UDim2.new(0, 10, 0, 28)
			Bar.Size = UDim2.new(1, -20, 0, 6)
			Bar.BackgroundColor3 = currentTheme.Header

			local BC = Instance.new("UICorner")
			BC.CornerRadius = UDim.new(1, 0)
			BC.Parent = Bar

			local Fill = Instance.new("Frame")
			Fill.Parent = Bar
			Fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
			Fill.BackgroundColor3 = currentTheme.Accent

			local FC = Instance.new("UICorner")
			FC.CornerRadius = UDim.new(1, 0)
			FC.Parent = Fill

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
			local dropHeight = 34 + (#options * 30)

			local DropFrame = Instance.new("Frame")
			DropFrame.Parent = Scroll
			DropFrame.Size = UDim2.new(1, 0, 0, 34)
			DropFrame.BackgroundColor3 = currentTheme.Card
			DropFrame.BackgroundTransparency = 0.2
			DropFrame.ClipsDescendants = true

			local DFC = Instance.new("UICorner")
			DFC.CornerRadius = UDim.new(0, 6)
			DFC.Parent = DropFrame

			local DropBtn = Instance.new("TextButton")
			DropBtn.Parent = DropFrame
			DropBtn.Size = UDim2.new(1, 0, 0, 34)
			DropBtn.BackgroundTransparency = 1
			DropBtn.Text = "  " .. text .. " : Select..."
			DropBtn.TextColor3 = currentTheme.Text
			DropBtn.Font = Enum.Font.GothamBold
			DropBtn.TextSize = 11
			DropBtn.TextXAlignment = Enum.TextXAlignment.Left

			local ListContainer = Instance.new("Frame")
			ListContainer.Parent = DropFrame
			ListContainer.Position = UDim2.new(0, 0, 0, 34)
			ListContainer.Size = UDim2.new(1, 0, 0, #options * 30)
			ListContainer.BackgroundTransparency = 1

			local LLayout = Instance.new("UIListLayout")
			LLayout.Parent = ListContainer
			LLayout.Padding = UDim.new(0, 2)

			for _, opt in ipairs(options) do
				local OptBtn = Instance.new("TextButton")
				OptBtn.Parent = ListContainer
				OptBtn.Size = UDim2.new(1, 0, 0, 28)
				OptBtn.BackgroundColor3 = currentTheme.Header
				OptBtn.BackgroundTransparency = 0.3
				OptBtn.Text = "    • " .. tostring(opt)
				OptBtn.TextColor3 = currentTheme.SubText
				OptBtn.Font = Enum.Font.Gotham
				OptBtn.TextSize = 11
				OptBtn.TextXAlignment = Enum.TextXAlignment.Left

				local OBC = Instance.new("UICorner")
				OBC.CornerRadius = UDim.new(0, 4)
				OBC.Parent = OptBtn

				OptBtn.MouseButton1Click:Connect(function()
					dropdownOpen = false
					DropBtn.Text = "  " .. text .. " : " .. tostring(opt)
					TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 34)}):Play()
					pcall(callback, opt)
				end)
			end

			DropBtn.MouseButton1Click:Connect(function()
				dropdownOpen = not dropdownOpen
				local targetH = dropdownOpen and dropHeight or 34
				TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetH)}):Play()
			end)
		end

		-- 2. AddKeybind (Tombol Pintasan)
		function TabObj:AddKeybind(text, defaultKey, callback)
			local selectedKey = defaultKey or Enum.KeyCode.RightShift
			local binding = false

			local KBBtn = Instance.new("TextButton")
			KBBtn.Parent = Scroll
			KBBtn.Size = UDim2.new(1, 0, 0, 34)
			KBBtn.BackgroundColor3 = currentTheme.Card
			KBBtn.BackgroundTransparency = 0.2
			KBBtn.Text = "  " .. text
			KBBtn.TextColor3 = currentTheme.Text
			KBBtn.Font = Enum.Font.GothamBold
			KBBtn.TextSize = 11
			KBBtn.TextXAlignment = Enum.TextXAlignment.Left

			local KBC = Instance.new("UICorner")
			KBC.CornerRadius = UDim.new(0, 6)
			KBC.Parent = KBBtn

			local ValLabel = Instance.new("TextLabel")
			ValLabel.Parent = KBBtn
			ValLabel.AnchorPoint = Vector2.new(1, 0.5)
			ValLabel.Position = UDim2.new(1, -10, 0.5, 0)
			ValLabel.Size = UDim2.new(0, 100, 0, 20)
			ValLabel.BackgroundTransparency = 1
			ValLabel.Text = "[" .. selectedKey.Name .. "]"
			ValLabel.TextColor3 = currentTheme.Accent
			ValLabel.Font = Enum.Font.GothamBold
			ValLabel.TextSize = 11
			ValLabel.TextXAlignment = Enum.TextXAlignment.Right

			KBBtn.MouseButton1Click:Connect(function()
				binding = true
				ValLabel.Text = "[...]"
			end)

			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if binding then
					if input.UserInputType == Enum.UserInputType.Keyboard then
						selectedKey = input.KeyCode
						ValLabel.Text = "[" .. selectedKey.Name .. "]"
						binding = false
						pcall(callback, selectedKey)
					end
				elseif input.KeyCode == selectedKey and not gameProcessed then
					pcall(callback, selectedKey)
				end
			end)
		end

		-- 3. AddColorPicker (Pemilih Warna Sederhana)
		function TabObj:AddColorPicker(text, defaultColor, callback)
			local currentColor = defaultColor or Color3.fromRGB(255, 255, 255)

			local CPFrame = Instance.new("Frame")
			CPFrame.Parent = Scroll
			CPFrame.Size = UDim2.new(1, 0, 0, 34)
			CPFrame.BackgroundColor3 = currentTheme.Card
			CPFrame.BackgroundTransparency = 0.2

			local CPC = Instance.new("UICorner")
			CPC.CornerRadius = UDim.new(0, 6)
			CPC.Parent = CPFrame

			local CPLabel = Instance.new("TextLabel")
			CPLabel.Parent = CPFrame
			CPLabel.Position = UDim2.new(0, 10, 0, 0)
			CPLabel.Size = UDim2.new(1, -50, 1, 0)
			CPLabel.BackgroundTransparency = 1
			CPLabel.Text = "  " .. text
			CPLabel.TextColor3 = currentTheme.Text
			CPLabel.Font = Enum.Font.GothamBold
			CPLabel.TextSize = 11
			CPLabel.TextXAlignment = Enum.TextXAlignment.Left

			local ColorPreview = Instance.new("Frame")
			ColorPreview.Parent = CPFrame
			ColorPreview.AnchorPoint = Vector2.new(1, 0.5)
			ColorPreview.Position = UDim2.new(1, -10, 0.5, 0)
			ColorPreview.Size = UDim2.new(0, 24, 0, 18)
			ColorPreview.BackgroundColor3 = currentColor

			local CPCircle = Instance.new("UICorner")
			CPCircle.CornerRadius = UDim.new(0, 4)
			CPCircle.Parent = ColorPreview

			-- Klik untuk uji ganti warna acak / preset
			local CPBtn = Instance.new("TextButton")
			CPBtn.Parent = CPFrame
			CPBtn.Size = UDim2.new(1, 0, 1, 0)
			CPBtn.BackgroundTransparency = 1
			CPBtn.Text = ""

			CPBtn.MouseButton1Click:Connect(function()
				-- Siklus warna sederhana untuk testing
				if currentColor == Color3.fromRGB(255, 255, 255) then
					currentColor = Color3.fromRGB(255, 0, 0)
				elseif currentColor == Color3.fromRGB(255, 0, 0) then
					currentColor = Color3.fromRGB(0, 255, 0)
				elseif currentColor == Color3.fromRGB(0, 255, 0) then
					currentColor = Color3.fromRGB(0, 0, 255)
				else
					currentColor = Color3.fromRGB(255, 255, 255)
				end
				ColorPreview.BackgroundColor3 = currentColor
				pcall(callback, currentColor)
			end)
		end

		return TabObj
	end

	return WindowObj
end

return MofenkUI
