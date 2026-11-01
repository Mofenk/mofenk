--[====================================================================]
-- Mofenk UI Library - Mobile & Cloud Phone Optimized (Compact Edition)
--[====================================================================]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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

	-- Bersihkan GUI lama yang tersisa
	pcall(function()
		for _, v in pairs(PlayerGui:GetChildren()) do
			if string.find(v.Name, "Mofenk") then v:Destroy() end
		end
		for _, v in pairs(CoreGui:GetChildren()) do
			if string.find(v.Name, "Mofenk") then v:Destroy() end
		end
	end)

	-- ===================================================================== --
	-- FLOATING TOGGLE BUTTON (Tombol "AI" di layar)
	-- ===================================================================== --
	local ToggleGui = Instance.new("ScreenGui")
	ToggleGui.Name = "MofenkToggleFront"
	ToggleGui.Parent = PlayerGui
	ToggleGui.ResetOnSpawn = false
	ToggleGui.DisplayOrder = 999999

	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Parent = ToggleGui
	ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
	ToggleBtn.Position = UDim2.new(0.04, 0, 0.35, 0)
	ToggleBtn.BackgroundColor3 = GLASS_THEME.Card
	ToggleBtn.Text = "AI"
	ToggleBtn.Font = Enum.Font.GothamBlack
	ToggleBtn.TextSize = 18
	ToggleBtn.TextColor3 = GLASS_THEME.Acc1
	ToggleBtn.ZIndex = 999999
	
	local TC = Instance.new("UICorner")
	TC.CornerRadius = UDim.new(0, 12)
	TC.Parent = ToggleBtn
	
	local TS = Instance.new("UIStroke")
	TS.Thickness = 2
	TS.Color = GLASS_THEME.Acc1
	TS.Parent = ToggleBtn

	-- Sistem Geser Tombol (Draggable)
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

	-- ===================================================================== --
	-- MAIN UI WINDOW (Ukuran diperkecil & Teks diperbesar agar Mobile Friendly)
	-- ===================================================================== --
	local MainGui = Instance.new("ScreenGui")
	MainGui.Name = "MofenkUltraHubV104"
	MainGui.Parent = PlayerGui
	MainGui.ResetOnSpawn = false
	MainGui.DisplayOrder = 999998

	local MainFrame = Instance.new("Frame")
	MainFrame.Parent = MainGui
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.Size = UDim2.new(0, 480, 0, 275) -- Ukuran Compact / Tidak Terlalu Besar
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.Visible = true -- Langsung tampil saat pertama dibuka
	MainFrame.BackgroundColor3 = GLASS_THEME.Bg
	MainFrame.BackgroundTransparency = 0.05

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 12)
	MainCorner.Parent = MainFrame

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Thickness = 1.5
	MainStroke.Color = GLASS_THEME.Acc1
	MainStroke.Parent = MainFrame

	ToggleBtn.MouseButton1Click:Connect(function() 
		MainFrame.Visible = not MainFrame.Visible 
	end)

	local TopBar = Instance.new("Frame")
	TopBar.Parent = MainFrame
	TopBar.Size = UDim2.new(1, 0, 0, 40)
	TopBar.BackgroundColor3 = GLASS_THEME.Header
	TopBar.BackgroundTransparency = 0.1

	local TopCorner = Instance.new("UICorner")
	TopCorner.CornerRadius = UDim.new(0, 12)
	TopCorner.Parent = TopBar

	local Title = Instance.new("TextLabel")
	Title.Parent = TopBar
	Title.Position = UDim2.new(0, 14, 0, 0)
	Title.Size = UDim2.new(0, 250, 1, 0)
	Title.Text = titleText
	Title.TextColor3 = GLASS_THEME.Acc1
	Title.TextSize = 14 -- Teks Diperbesar
	Title.Font = Enum.Font.GothamBlack
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.BackgroundTransparency = 1

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Parent = TopBar
	CloseBtn.Position = UDim2.new(1, -36, 0, 6)
	CloseBtn.Size = UDim2.new(0, 28, 0, 28)
	CloseBtn.Text = "✕"
	CloseBtn.TextColor3 = GLASS_THEME.Text
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 14
	CloseBtn.BackgroundColor3 = GLASS_THEME.Card
	CloseBtn.BackgroundTransparency = 0.2
	
	local CC = Instance.new("UICorner")
	CC.CornerRadius = UDim.new(0, 6)
	CC.Parent = CloseBtn
	CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Parent = MainFrame
	Sidebar.Position = UDim2.new(0, 8, 0, 48)
	Sidebar.Size = UDim2.new(0, 130, 1, -56)
	Sidebar.BackgroundTransparency = 1
	Sidebar.ScrollBarThickness = 2
	Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	
	local SideLayout = Instance.new("UIListLayout")
	SideLayout.Parent = Sidebar
	SideLayout.Padding = UDim.new(0, 4)

	local ContentArea = Instance.new("Frame")
	ContentArea.Parent = MainFrame
	ContentArea.Position = UDim2.new(0, 144, 0, 48)
	ContentArea.Size = UDim2.new(1, -152, 1, -56)
	ContentArea.BackgroundColor3 = GLASS_THEME.Header
	ContentArea.BackgroundTransparency = 0.2
	
	local ContentCorner = Instance.new("UICorner")
	ContentCorner.CornerRadius = UDim.new(0, 10)
	ContentCorner.Parent = ContentArea

	local WindowObj = {
		TabFrames = {},
		TabButtons = {},
		FirstTabSet = false,
		MainFrame = MainFrame,
		Sidebar = Sidebar,
		Theme = GLASS_THEME
	}

	function WindowObj:CreateTab(name, icon)
		local Btn = Instance.new("TextButton")
		Btn.Parent = Sidebar
		Btn.Size = UDim2.new(1, -4, 0, 32)
		Btn.Text = " " .. icon .. " " .. name
		Btn.TextColor3 = GLASS_THEME.SubText
		Btn.TextSize = 12 -- Teks Tombol Tab Proporsional
		Btn.Font = Enum.Font.GothamBold
		Btn.TextXAlignment = Enum.TextXAlignment.Left
		Btn.BackgroundColor3 = GLASS_THEME.Card
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
		Lay.Padding = UDim.new(0, 8)
		
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
			for _, b in pairs(self.TabButtons) do b.BackgroundTransparency = 0.3; b.TextColor3 = GLASS_THEME.SubText end
			Btn.BackgroundTransparency = 0.05
			Btn.TextColor3 = GLASS_THEME.Acc1
		end)
		
		return Scroll
	end

	return WindowObj
end

return MofenkUI
