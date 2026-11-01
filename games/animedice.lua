-- ===================================================================== --
-- 👑 MOFENKHUB - ANIME DICE GAME SCRIPT
-- ===================================================================== --

local success, MofenkUI = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/Mofenk/mofenk/refs/heads/main/MofenkUI.lua"))()
end)

if not success or not MofenkUI then
	warn("[MofenkHub] Gagal memuat MofenkUI Library!")
	return
end

-- Buat Jendela Utama
local Window = MofenkUI.CreateWindow({
	Name = "MofenkHub | Anime Dice"
})

-- Buat Tab Menu
local MainTab = Window:CreateTab("Main Farm", "⚡")
local AutoTab = Window:CreateTab("Automation", "🤖")
local SettingsTab = Window:CreateTab("Settings", "⚙️")

-- Masukkan Fitur ke Tab Main Farm
pcall(function()
	local SectionLabel = Instance.new("TextLabel")
	SectionLabel.Parent = MainTab
	SectionLabel.Size = UDim2.new(1, 0, 0, 30)
	SectionLabel.BackgroundTransparency = 1
	SectionLabel.Text = "  Status: Siap Digunakan di Cloud Phone"
	SectionLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
	SectionLabel.Font = Enum.Font.GothamBold
	SectionLabel.TextSize = 13
	SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

	-- Tombol Auto Roll / Farm Contoh
	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Parent = MainTab
	ToggleBtn.Size = UDim2.new(1, 0, 0, 45)
	ToggleBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	ToggleBtn.Text = "  [OFF] Auto Roll Dice"
	ToggleBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
	ToggleBtn.Font = Enum.Font.GothamBold
	ToggleBtn.TextSize = 13
	ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

	local UIC = Instance.new("UICorner")
	UIC.CornerRadius = UDim.new(0, 8)
	UIC.Parent = ToggleBtn

	local toggled = false
	ToggleBtn.MouseButton1Click:Connect(function()
		toggled = not toggled
		if toggled then
			ToggleBtn.Text = "  [ON] Auto Roll Dice (Aktif)"
			ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
		else
			ToggleBtn.Text = "  [OFF] Auto Roll Dice"
			ToggleBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
		end
	end)
end)

-- Masukkan Fitur ke Tab Automation
pcall(function()
	local InfoLabel = Instance.new("TextLabel")
	InfoLabel.Parent = AutoTab
	InfoLabel.Size = UDim2.new(1, 0, 0, 30)
	InfoLabel.BackgroundTransparency = 1
	InfoLabel.Text = "  Fitur Multi-Account & Anti-AFK"
	InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	InfoLabel.Font = Enum.Font.GothamBold
	InfoLabel.TextSize = 12
	InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
end)

print("✨ Skrip Anime Dice Berhasil Dimuat Sepenuhnya!")
