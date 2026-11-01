--[====================================================================]
-- MofenkUI - Ultimate Monochrome Dark Glass (Full Features Edition)
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
	SwitchOn   = Color3.fromRGB(255, 255, 255),
	SwitchOff  = Color3.fromRGB(40, 40, 40)
}

function MofenkUI.CreateWindow(config)
	config = config or {}
	local titleText = config.Name or "MofenkHub"
	local toggleStyle = config.ToggleStyle or "Icon" -- Pilihan: "Icon" (Huruf M) atau "Bar" (Panjang)

	pcall(function()
		for _, v in pairs(PlayerGui:GetChildren()) do
			if string.find(v.Name, "Mofenk") then v:Destroy() end
		end
		for _, v in pairs(CoreGui:GetChildren()) do
			if string.find(v.Name, "Mofenk") then v:Destroy() end
		end
	end)

	-- Notification Toast Container
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

	-- ===================================================================== --
	-- TOGGLE INTERAKTIF DI LAYAR (Dua Versi: Icon M / Bar Panjang)
	-- ===================================================================== --
	local ToggleGui = Instance.new("ScreenGui")
	ToggleGui.Name = "MofenkToggleFront"
	ToggleGui.Parent = PlayerGui
	ToggleGui.ResetOnSpawn = false
	ToggleGui.DisplayOrder = 999999

	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Parent = ToggleGui
	ToggleBtn.BackgroundColor3 = MONO_THEME.Card
	ToggleBtn.Font = Enum.Font.GothamBlack
	ToggleBtn.ZIndex = 999999

	if toggleStyle == "Bar" then
		ToggleBtn.Size = UDim2.new(0, 120, 0, 36)
		ToggleBtn.Position = UDim2.new(0.5, -60, 0, 10)
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

	local TC = Instance.new("UICorner")
	TC.CornerRadius = UDim.new(0, toggleStyle == "Bar" and 10 or 14)
	TC.Parent = ToggleBtn
	
	local TS = Instance.new("UIStroke")
	TS.Thickness = 1.5
	TS.Color = MONO_THEME.Accent
	TS.Transparency = 0.3
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
			ToggleBtn.Position = UDim2.new(0, math.clamp(startPos.X.Offset + delta.X, 10, viewport.X - 70), 0, math.clamp(startPos.Y.Offset + delta.Y, 10, viewport.Y - 70))
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	-- ===================================================================== --
	-- MAIN WINDOW UI (Diperbesar & Proporsional)
	-- ===================================================================== --
	local MainGui = Instance.new("ScreenGui")
	MainGui.Name = "MofenkUltraHubV114"
	MainGui.Parent = PlayerGui
	MainGui.ResetOnSpawn = false
	MainGui.DisplayOrder = 999998

	local MainFrame = Instance.new("Frame")
	MainFrame.Parent = MainGui
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.Size = UDim2.new(0, 580, 0, 350)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.Visible = true
	MainFrame.BackgroundColor3 = MONO_THEME.Bg
	MainFrame.BackgroundTransparency = 0.06

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 12)
	MainCorner.Parent = MainFrame

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Thickness = 1.5
	MainStroke.Color = MONO_THEME.Accent
	MainStroke.Transparency = 0.3
	MainStroke.Parent = MainFrame

	ToggleBtn.MouseButton1Click:Connect(function() 
		MainFrame.Visible = not MainFrame.Visible 
	end)

	-- Top Bar
	local TopBar = Instance.new("Frame")
	TopBar.Parent = MainFrame
	TopBar.Size = UDim2.new(1, 0, 0, 44)
	TopBar.BackgroundColor3 = MONO_THEME.Header
	TopBar.BackgroundTransparency = 0.2

	local TopCorner = Instance.new("UICorner")
	TopCorner.CornerRadius = UDim.new(0, 12)
	TopCorner.Parent = TopBar

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
	
	local CC = Instance.new("UICorner")
	CC.CornerRadius = UDim.new(0, 6)
	CC.Parent = CloseBtn
	CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

	local minimized = false
	local origHeight = 350
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
	
	local MC = Instance.new("UICorner")
	MC.CornerRadius = UDim.new(0, 6)
	MC.Parent = MinimizeBtn

	-- Sidebar Kiri
	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Parent = MainFrame
	Sidebar.Position = UDim2.new(0, 10, 0, 52)
	Sidebar.Size = UDim2.new(0, 155, 1, -62)
	Sidebar.BackgroundTransparency = 1
	Sidebar.ScrollBarThickness = 2
	Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	
	local SideLayout = Instance.new("UIListLayout")
	SideLayout.Parent = Sidebar
	SideLayout.Padding = UDim.new(0, 6)

	-- Content Area Kanan
	local ContentArea = Instance.new("Frame")
	ContentArea.Parent = MainFrame
	ContentArea.Position = UDim2.new(0, 172, 0, 52)
	ContentArea.Size = UDim2.new(1, -182, 1, -62)
	ContentArea.BackgroundColor3 = MONO_THEME.Header
	ContentArea.BackgroundTransparency = 0.3
	
	local ContentCorner = Instance.new("UICorner")
	ContentCorner.CornerRadius = UDim.new(0, 10)
	ContentCorner.Parent = ContentArea

	MinimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			origHeight = MainFrame.AbsoluteSize.Y
			Sidebar.Visible = false
			ContentArea.Visible = false
			TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, MainFrame.AbsoluteSize.X, 0, 44)}):Play()
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
	ResizeBtn.TextColor3 = MONO_THEME.SubText
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
			local newWidth = math.clamp(startSize.X + delta.X, 480, 800)
			local newHeight = math.clamp(startSize.Y + delta.Y, 300, 600)
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
		NotifCard.BackgroundTransparency = 0.1

		local NC = Instance.new("UICorner")
		NC.CornerRadius = UDim.new(0, 10)
		NC.Parent = NotifCard

		local NS = Instance.new("UIStroke")
		NS.Thickness = 1.2
		NS.Color = MONO_THEME.Accent
		NS.Transparency = 0.4
		NS.Parent = NotifCard

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
		
		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 8)
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
			for _, b in pairs(self.TabButtons) do b.BackgroundTransparency = 0.4; b.TextColor3 = MONO_THEME.SubText end
			TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.05}):Play()
			Btn.TextColor3 = MONO_THEME.Accent
		end)
		
		local TabObj = { Container = Scroll }

		-- 1. Dashboard Profil Pengguna (Avatar, Nama Aesthetic, & Ping Bar Real-time)
		function TabObj:AddUserProfileDashboard(customTitle)
			local ProfileCard = Instance.new("Frame")
			ProfileCard.Parent = Scroll
			ProfileCard.Size = UDim2.new(1, 0, 0, 95)
			ProfileCard.BackgroundColor3 = MONO_THEME.Card
			ProfileCard.BackgroundTransparency = 0.15

			local PCC = Instance.new("UICorner")
			PCC.CornerRadius = UDim.new(0, 10)
			PCC.Parent = ProfileCard

			local PCS = Instance.new("UIStroke")
			PCS.Thickness = 1.2
			PCS.Color = MONO_THEME.Accent
			PCS.Transparency = 0.5
			PCS.Parent = ProfileCard

			local AvatarFrame = Instance.new("ImageLabel")
			AvatarFrame.Parent = ProfileCard
			AvatarFrame.Position = UDim2.new(0, 12, 0, 12)
			AvatarFrame.Size = UDim2.new(0, 70, 0, 70)
			AvatarFrame.BackgroundColor3 = MONO_THEME.Header
			AvatarFrame.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

			local AFC = Instance.new("UICorner")
			AFC.CornerRadius = UDim.new(1, 0)
			AFC.Parent = AvatarFrame

			local AFS = Instance.new("UIStroke")
			AFS.Thickness = 2
			AFS.Color = MONO_THEME.Accent
			AFS.Parent = AvatarFrame

			local NameLabel = Instance.new("TextLabel")
			NameLabel.Parent = ProfileCard
			NameLabel.Position = UDim2.new(0, 95, 0, 16)
			NameLabel.Size = UDim2.new(1, -110, 0, 24)
			NameLabel.BackgroundTransparency = 1
			NameLabel.Text = "👑 " .. LocalPlayer.Name .. " (" .. (customTitle or "Mofenk User") .. ")"
			NameLabel.TextColor3 = MONO_THEME.Accent
			NameLabel.Font = Enum.Font.GothamBlack
			NameLabel.TextSize = 13
			NameLabel.TextXAlignment = Enum.TextXAlignment.Left

			local StatusLabel = Instance.new("TextLabel")
			StatusLabel.Parent = ProfileCard
			StatusLabel.Position = UDim2.new(0, 95, 0, 42)
			StatusLabel.Size = UDim2.new(1, -110, 0, 18)
			StatusLabel.BackgroundTransparency = 1
			StatusLabel.Text = "✨ Status: Secure & Connected"
			StatusLabel.TextColor3 = MONO_THEME.SubText
			StatusLabel.Font = Enum.Font.Gotham
			StatusLabel.TextSize = 11
			StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

			local PingBarBg = Instance.new("Frame")
			PingBarBg.Parent = ProfileCard
			PingBarBg.Position = UDim2.new(0, 95, 0, 66)
			PingBarBg.Size = UDim2.new(1, -110, 0, 10)
			PingBarBg.BackgroundColor3 = MONO_THEME.Header

			local PBBC = Instance.new("UICorner")
			PBBC.CornerRadius = UDim.new(1, 0)
			PBBC.Parent = PingBarBg

			local PingFill = Instance.new("Frame")
			PingFill.Parent = PingBarBg
			PingFill.Size = UDim2.new(0.5, 0, 1, 0)
			PingFill.BackgroundColor3 = MONO_THEME.Accent

			local PFC = Instance.new("UICorner")
			PFC.CornerRadius = UDim.new(1, 0)
			PFC.Parent = PingFill

			local PingText = Instance.new("TextLabel")
			PingText.Parent = PingBarBg
			PingText.Size = UDim2.new(1, 0, 1, 0)
			PingText.BackgroundTransparency = 1
			PingText.Text = "Ping: calculating..."
			PingText.TextColor3 = MONO_THEME.Text
			PingText.Font = Enum.Font.GothamBold
			PingText.TextSize = 9
			PingText.TextXAlignment = Enum.TextXAlignment.Center

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
		end

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

		function TabObj:AddButton(text, callback)
			local BtnComp = Instance.new("TextButton")
			BtnComp.Parent = Scroll
			BtnComp.Size = UDim2.new(1, 0, 0, 38)
			BtnComp.BackgroundColor3 = MONO_THEME.Card
			BtnComp.BackgroundTransparency = 0.2
			BtnComp.Text = "  " .. text
			BtnComp.TextColor3 = MONO_THEME.Text
			BtnComp.Font = Enum.Font.GothamBold
			BtnComp.TextSize = 12
			BtnComp.TextXAlignment = Enum.TextXAlignment.Left

			local BC = Instance.new("UICorner")
			BC.CornerRadius = UDim.new(0, 8)
			BC.Parent = BtnComp

			BtnComp.MouseButton1Click:Connect(function()
				TweenService:Create(BtnComp, TweenInfo.new(0.1), {BackgroundColor3 = MONO_THEME.Hover}):Play()
				task.wait(0.1)
				TweenService:Create(BtnComp, TweenInfo.new(0.1), {BackgroundColor3 = MONO_THEME.Card}):Play()
				pcall(callback)
			end)
		end

		function TabObj:AddToggle(text, defaultState, callback)
			local state = defaultState or false
			
			local TglBtn = Instance.new("TextButton")
			TglBtn.Parent = Scroll
			TglBtn.Size = UDim2.new(1, 0, 0, 38)
			TglBtn.BackgroundColor3 = MONO_THEME.Card
			TglBtn.BackgroundTransparency = 0.2
			TglBtn.Text = "  " .. text
			TglBtn.TextColor3 = MONO_THEME.Text
			TglBtn.Font = Enum.Font.GothamBold
			TglBtn.TextSize = 12
			TglBtn.TextXAlignment = Enum.TextXAlignment.Left

			local TC = Instance.new("UICorner")
			TC.CornerRadius = UDim.new(0, 8)
			TC.Parent = TglBtn

			local SwitchBg = Instance.new("Frame")
			SwitchBg.Parent = TglBtn
			SwitchBg.AnchorPoint = Vector2.new(1, 0.5)
			SwitchBg.Position = UDim2.new(1, -10, 0.5, 0)
			SwitchBg.Size = UDim2.new(0, 48, 0, 22)
			SwitchBg.BackgroundColor3 = state and MONO_THEME.SwitchOn or MONO_THEME.SwitchOff

			local SBC = Instance.new("UICorner")
			SBC.CornerRadius = UDim.new(1, 0)
			SBC.Parent = SwitchBg

			local SwitchLabel = Instance.new("TextLabel")
			SwitchLabel.Parent = SwitchBg
			SwitchLabel.Size = UDim2.new(1, 0, 1, 0)
			SwitchLabel.BackgroundTransparency = 1
			SwitchLabel.Text = state and "ON" or "OFF"
			SwitchLabel.TextColor3 = state and Color3.fromRGB(0, 0, 0) or MONO_THEME.SubText
			SwitchLabel.Font = Enum.Font.GothamBlack
			SwitchLabel.TextSize = 10
			SwitchLabel.TextXAlignment = Enum.TextXAlignment.Center

			TglBtn.MouseButton1Click:Connect(function()
				state = not state
				TweenService:Create(SwitchBg, TweenInfo.new(0.15), {BackgroundColor3 = state and MONO_THEME.SwitchOn or MONO_THEME.SwitchOff}):Play()
				SwitchLabel.Text = state and "ON" or "OFF"
				SwitchLabel.TextColor3 = state and Color3.fromRGB(0, 0, 0) or MONO_THEME.SubText
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

			local TBC = Instance.new("UICorner")
			TBC.CornerRadius = UDim.new(0, 8)
			TBC.Parent = TBox

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
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Parent = Scroll
			SliderFrame.Size = UDim2.new(1, 0, 0, 52)
			SliderFrame.BackgroundColor3 = MONO_THEME.Card
			SliderFrame.BackgroundTransparency = 0.2

			local SFC = Instance.new("UICorner")
			SFC.CornerRadius = UDim.new(0, 8)
			SFC.Parent = SliderFrame

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

			local BC = Instance.new("UICorner")
			BC.CornerRadius = UDim.new(1, 0)
			BC.Parent = Bar

			local Fill = Instance.new("Frame")
			Fill.Parent = Bar
			Fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
			Fill.BackgroundColor3 = MONO_THEME.Accent

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
			local dropHeight = 38 + (#options * 32)

			local DropFrame = Instance.new("Frame")
			DropFrame.Parent = Scroll
			DropFrame.Size = UDim2.new(1, 0, 0, 38)
			DropFrame.BackgroundColor3 = MONO_THEME.Card
			DropFrame.BackgroundTransparency = 0.2
			DropFrame.ClipsDescendants = true

			local DFC = Instance.new("UICorner")
			DFC.CornerRadius = UDim.new(0, 8)
			DFC.Parent = DropFrame

			local DropBtn = Instance.new("TextButton")
			DropBtn.Parent = DropFrame
			DropBtn.Size = UDim2.new(1, 0, 0, 38)
			DropBtn.BackgroundTransparency = 1
			DropBtn.Text = "  " .. text .. " : Select..."
			DropBtn.TextColor3 = MONO_THEME.Text
			DropBtn.Font = Enum.Font.GothamBold
			DropBtn.TextSize = 12
			DropBtn.TextXAlignment = Enum.TextXAlignment.Left

			local ListContainer = Instance.new("Frame")
			ListContainer.Parent = DropFrame
			ListContainer.Position = UDim2.new(0, 0, 0, 38)
			ListContainer.Size = UDim2.new(1, 0, 0, #options * 32)
			ListContainer.BackgroundTransparency = 1

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

				local OBC = Instance.new("UICorner")
				OBC.CornerRadius = UDim.new(0, 6)
				OBC.Parent = OptBtn

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
