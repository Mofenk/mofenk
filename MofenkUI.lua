--[================================================================]--
--      MOFENK UI LIBRARY - UNIVERSAL MOBILE-FRIENDLY v2.5          --
--         Professional Luau UI Framework for Mobile & PC          --
--[================================================================]--

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Cleanup existing MOFENK UI if any
if CoreGui:FindFirstChild("MofenkUI") then
    CoreGui.MofenkUI:Destroy()
end

local Library = {
    Flags = {},
    Configs = {}
}

-- Monochromatic Theme (Hitam Putih Estetik)
Library.Theme = {
    Bg     = Color3.fromRGB(15, 15, 15),
    Card   = Color3.fromRGB(28, 28, 28),
    Header = Color3.fromRGB(22, 22, 22),
    Acc1   = Color3.fromRGB(255, 255, 255),
    Acc2   = Color3.fromRGB(200, 200, 200),
    Text   = Color3.fromRGB(240, 240, 240),
    SubText= Color3.fromRGB(160, 160, 160)
}

-- Helper: Tween Animation
function Library:Tween(object, info, goals)
    local tween = TweenService:Create(object, TweenInfo.new(unpack(info)), goals)
    tween:Play()
    return tween
end

-- Notification System
function Library:Notify(data)
    local screenGui = CoreGui:FindFirstChild("MofenkUI")
    if not screenGui then return end

    local notifHolder = screenGui:FindFirstChild("NotificationHolder") or (function()
        local h = Instance.new("Frame")
        h.Name = "NotificationHolder"
        h.Size = UDim2.new(0, 300, 1, -40)
        h.Position = UDim2.new(1, -320, 0, 20)
        h.BackgroundTransparency = 1
        h.Parent = screenGui
        
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.Padding = UDim.new(0, 10)
        layout.Parent = h
        return h
    end)()

    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, 0, 0, 70)
    notif.BackgroundColor3 = Library.Theme.Card
    notif.BorderSizePixel = 0
    notif.BackgroundTransparency = 0.1
    notif.Parent = notifHolder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif

    local stroke = Instance.new("UIStroke")
    stroke.Color = Library.Theme.Acc1
    stroke.Transparency = 0.5
    stroke.Thickness = 1
    stroke.Parent = notif

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 25)
    title.Position = UDim2.new(0, 10, 0, 8)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = data.Title or "MOFENK NOTIFY"
    title.TextColor3 = Library.Theme.Acc1
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notif

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -20, 0, 30)
    desc.Position = UDim2.new(0, 10, 0, 30)
    desc.BackgroundTransparency = 1
    desc.Font = Enum.Font.Gotham
    desc.Text = data.Content or ""
    desc.TextColor3 = Library.Theme.SubText
    desc.TextSize = 12
    desc.TextWrapped = true
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = notif

    notif.Position = UDim2.new(1, 50, 0, 0)
    Library:Tween(notif, {0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Position = UDim2.new(0, 0, 0, 0)})

    task.delay(data.Duration or 3, function()
        Library:Tween(notif, {0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In}, {Position = UDim2.new(1, 50, 0, 0)})
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- Create Window
function Library:CreateWindow(config)
    config = config or {}
    windowName = config.Name or "MOFENK HUB | Universal"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MofenkUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    -- Auto-Scale / UIScale for Mobile & PC Adaptability
    local ScreenScale = Instance.new("UIScale")
    ScreenScale.Parent = ScreenGui

    local baseAutoMultiplier = 1.0
    local userManualZoom = 1.0

    local function UpdateScale()
        local viewport = workspace.CurrentCamera.ViewportSize
        local isMobileOrSmall = viewport.X < 900 or viewport.Y < 550
        local targetBase = isMobileOrSmall and (viewport.X / 950) or (viewport.X / 1200)
        baseAutoMultiplier = math.clamp(targetBase, 0.60, 1.25)
        ScreenScale.Scale = baseAutoMultiplier * userManualZoom
    end
    UpdateScale()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)

    -- Main UI Frame (Lebih Kompak / Pas: 720 x 440)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 720, 0, 440)
    MainFrame.Position = UDim2.new(0.5, -360, 0.5, -220)
    MainFrame.BackgroundColor3 = Library.Theme.Bg
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Library.Theme.Acc1
    MainStroke.Thickness = 1.8
    MainStroke.Parent = MainFrame

    -- Dragging System (Mobile & PC Friendly)
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            Library:Tween(MainFrame, {0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out}, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            })
        end
    end)

    -- Resize System (Pojok Kanan Bawah)
    local ResizeBtn = Instance.new("TextButton")
    ResizeBtn.Size = UDim2.new(0, 18, 0, 18)
    ResizeBtn.Position = UDim2.new(1, -18, 1, -18)
    ResizeBtn.BackgroundTransparency = 1
    ResizeBtn.Text = "◢"
    ResizeBtn.TextColor3 = Library.Theme.SubText
    ResizeBtn.TextSize = 12
    ResizeBtn.ZIndex = 500
    ResizeBtn.Parent = MainFrame

    local resizing, resizeStart, startSize
    ResizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = MainFrame.AbsoluteSize
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newW = math.clamp(startSize.X + delta.X, 550, 1000)
            local newH = math.clamp(startSize.Y + delta.Y, 350, 700)
            MainFrame.Size = UDim2.new(0, newW, 0, newH)
        end
    end)

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 42)
    TopBar.BackgroundColor3 = Library.Theme.Header
    TopBar.BackgroundTransparency = 0.1
    TopBar.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = TopBar

    -- Interactive M Logo (Toggle / Minimize UI)
    local LogoBtn = Instance.new("TextButton")
    LogoBtn.Size = UDim2.new(0, 30, 0, 30)
    LogoBtn.Position = UDim2.new(0, 8, 0, 6)
    LogoBtn.BackgroundColor3 = Library.Theme.Card
    LogoBtn.BorderSizePixel = 0
    LogoBtn.AutoButtonColor = false
    LogoBtn.Font = Enum.Font.GothamBlack
    LogoBtn.Text = "M"
    LogoBtn.TextColor3 = Library.Theme.Acc1
    LogoBtn.TextSize = 14
    LogoBtn.Parent = TopBar

    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 6)
    LogoCorner.Parent = LogoBtn

    local uiVisible = true
    LogoBtn.MouseButton1Click:Connect(function()
        uiVisible = not uiVisible
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= TopBar and child:IsA("GuiObject") then
                child.Visible = uiVisible
            end
        end
        Library:Tween(MainFrame, {0.2, Enum.EasingStyle.Quad}, {
            Size = uiVisible and UDim2.new(0, 720, 0, 440) or UDim2.new(0, 720, 0, 42)
        })
    end)

    -- Keybind Manager (RightShift to toggle UI)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
            uiVisible = not uiVisible
            for _, child in pairs(MainFrame:GetChildren()) do
                if child ~= TopBar and child:IsA("GuiObject") then
                    child.Visible = uiVisible
                end
            end
        end
    end)

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 280, 1, 0)
    TitleLabel.Position = UDim2.new(0, 46, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.Text = windowName
    TitleLabel.TextColor3 = Library.Theme.Acc1
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    -- Zoom In Button (+)
    local ZoomInBtn = Instance.new("TextButton")
    ZoomInBtn.Size = UDim2.new(0, 28, 0, 28)
    ZoomInBtn.Position = UDim2.new(1, -104, 0, 7)
    ZoomInBtn.BackgroundColor3 = Library.Theme.Card
    ZoomInBtn.BackgroundTransparency = 0.2
    ZoomInBtn.Font = Enum.Font.GothamBold
    ZoomInBtn.Text = "+"
    ZoomInBtn.TextColor3 = Library.Theme.Text
    ZoomInBtn.TextSize = 13
    ZoomInBtn.Parent = TopBar
    local ZIC = Instance.new("UICorner"); ZIC.CornerRadius = UDim.new(0, 6); ZIC.Parent = ZoomInBtn

    -- Zoom Out Button (-)
    local ZoomOutBtn = Instance.new("TextButton")
    ZoomOutBtn.Size = UDim2.new(0, 28, 0, 28)
    ZoomOutBtn.Position = UDim2.new(1, -72, 0, 7)
    ZoomOutBtn.BackgroundColor3 = Library.Theme.Card
    ZoomOutBtn.BackgroundTransparency = 0.2
    ZoomOutBtn.Font = Enum.Font.GothamBold
    ZoomOutBtn.Text = "-"
    ZoomOutBtn.TextColor3 = Library.Theme.Text
    ZoomOutBtn.TextSize = 14
    ZoomOutBtn.Parent = TopBar
    local ZOC = Instance.new("UICorner"); ZOC.CornerRadius = UDim.new(0, 6); ZOC.Parent = ZoomOutBtn

    ZoomInBtn.MouseButton1Click:Connect(function()
        userManualZoom = math.clamp(userManualZoom + 0.1, 0.5, 1.6)
        ScreenScale.Scale = baseAutoMultiplier * userManualZoom
    end)

    ZoomOutBtn.MouseButton1Click:Connect(function()
        userManualZoom = math.clamp(userManualZoom - 0.1, 0.5, 1.6)
        ScreenScale.Scale = baseAutoMultiplier * userManualZoom
    end)

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -36, 0, 7)
    CloseBtn.BackgroundColor3 = Library.Theme.Card
    CloseBtn.BackgroundTransparency = 0.2
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Library.Theme.Text
    CloseBtn.TextSize = 13
    CloseBtn.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Sidebar / Tab Container Holder (Kompak Lebar 160px)
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, -56)
    Sidebar.Position = UDim2.new(0, 8, 0, 48)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 2
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.Parent = MainFrame

    local SideLayout = Instance.new("UIListLayout")
    SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SideLayout.Padding = UDim.new(0, 4)
    SideLayout.Parent = Sidebar

    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -178, 1, -56)
    ContentArea.Position = UDim2.new(0, 172, 0, 48)
    ContentArea.BackgroundColor3 = Library.Theme.Header
    ContentArea.BackgroundTransparency = 0.2
    ContentArea.Parent = MainFrame

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10)
    ContentCorner.Parent = ContentArea

    local Window = { TabsCount = 0 }
    local TabFrames, TabButtons = {}, {}

    function Window:CreateTab(tabName, icon)
        Window.TabsCount = Window.TabsCount + 1
        local tabIndex = Window.TabsCount
        icon = icon or "📁"

        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -4, 0, 34)
        TabButton.BackgroundColor3 = Library.Theme.Card
        TabButton.BackgroundTransparency = (tabIndex == 1) and 0.05 or 0.3
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        TabButton.Font = Enum.Font.GothamBold
        TabButton.Text = "  " .. icon .. "  " .. tabName
        TabButton.TextColor3 = (tabIndex == 1) and Library.Theme.Acc1 or Library.Theme.SubText
        TabButton.TextSize = 11
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = Sidebar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = tabName .. "Page"
        TabPage.Size = UDim2.new(1, -12, 1, -12)
        TabPage.Position = UDim2.new(0, 6, 0, 6)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.ScrollBarThickness = 3
        TabPage.Visible = (tabIndex == 1)
        TabPage.Parent = ContentArea

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = TabPage

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 16)
        end)

        TabFrames[tabName] = TabPage
        TabButtons[tabName] = TabButton

        TabButton.MouseButton1Click:Connect(function()
            for n, f in pairs(TabFrames) do f.Visible = (n == tabName) end
            for _, b in pairs(TabButtons) do 
                b.BackgroundTransparency = 0.3
                b.TextColor3 = Library.Theme.SubText 
            end
            TabButton.BackgroundTransparency = 0.05
            TabButton.TextColor3 = Library.Theme.Acc1
        end)

        local TabObject = {}

        function TabObject:CreateGroup(groupName)
            local GroupCard = Instance.new("Frame")
            GroupCard.Size = UDim2.new(1, 0, 0, 0)
            GroupCard.AutomaticSize = Enum.AutomaticSize.Y
            GroupCard.BackgroundColor3 = Library.Theme.Card
            GroupCard.BackgroundTransparency = 0.15
            GroupCard.Parent = TabPage

            local GroupCorner = Instance.new("UICorner")
            GroupCorner.CornerRadius = UDim.new(0, 8)
            GroupCorner.Parent = GroupCard

            local GroupStroke = Instance.new("UIStroke")
            GroupStroke.Color = Library.Theme.Acc1
            GroupStroke.Transparency = 0.8
            GroupStroke.Thickness = 1
            GroupStroke.Parent = GroupCard

            local GroupLayout = Instance.new("UIListLayout")
            GroupLayout.SortOrder = Enum.SortOrder.LayoutOrder
            GroupLayout.Padding = UDim.new(0, 6)
            GroupLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            GroupLayout.Parent = GroupCard

            local GroupPadding = Instance.new("UIPadding")
            GroupPadding.PaddingTop = UDim.new(0, 8)
            GroupPadding.PaddingBottom = UDim.new(0, 8)
            GroupPadding.PaddingLeft = UDim.new(0, 8)
            GroupPadding.PaddingRight = UDim.new(0, 8)
            GroupPadding.Parent = GroupCard

            if groupName and groupName ~= "" then
                local HeaderLbl = Instance.new("TextLabel")
                HeaderLbl.Size = UDim2.new(1, 0, 0, 20)
                HeaderLbl.BackgroundTransparency = 1
                HeaderLbl.Font = Enum.Font.GothamBlack
                HeaderLbl.Text = groupName
                HeaderLbl.TextColor3 = Library.Theme.Acc1
                HeaderLbl.TextSize = 11
                HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
                HeaderLbl.Parent = GroupCard
            end

            local GroupObject = {}

            function GroupObject:AddButton(text, callback)
                callback = callback or function() end
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 30)
                Btn.BackgroundColor3 = Library.Theme.Header
                Btn.BackgroundTransparency = 0.1
                Btn.BorderSizePixel = 0
                Btn.AutoButtonColor = false
                Btn.Font = Enum.Font.GothamBold
                Btn.Text = text
                Btn.TextColor3 = Library.Theme.Acc1
                Btn.TextSize = 11
                Btn.Parent = GroupCard

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = Btn

                local BtnStroke = Instance.new("UIStroke")
                BtnStroke.Color = Library.Theme.Acc1
                BtnStroke.Transparency = 0.6
                BtnStroke.Thickness = 1
                BtnStroke.Parent = Btn

                Btn.MouseButton1Click:Connect(function()
                    Library:Tween(Btn, {0.1, Enum.EasingStyle.Quad}, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
                    task.delay(0.1, function()
                        Library:Tween(Btn, {0.1, Enum.EasingStyle.Quad}, {BackgroundColor3 = Library.Theme.Header})
                    end)
                    pcall(callback)
                end)
            end

            function GroupObject:AddToggle(text, default, callback)
                default = default or false
                callback = callback or function() end
                local toggled = default

                local Frm = Instance.new("Frame")
                Frm.Size = UDim2.new(1, 0, 0, 32)
                Frm.BackgroundTransparency = 1
                Frm.Parent = GroupCard

                local L = Instance.new("TextLabel")
                L.Size = UDim2.new(0.68, 0, 1, 0)
                L.Position = UDim2.new(0, 4, 0, 0)
                L.BackgroundTransparency = 1
                L.Font = Enum.Font.GothamMedium
                L.Text = text
                L.TextColor3 = Library.Theme.Text
                L.TextSize = 11
                L.TextXAlignment = Enum.TextXAlignment.Left
                L.Parent = Frm

                local Sw = Instance.new("TextButton")
                Sw.Size = UDim2.new(0, 36, 0, 20)
                Sw.Position = UDim2.new(1, -40, 0.5, -10)
                Sw.BackgroundColor3 = toggled and Library.Theme.Acc1 or Color3.fromRGB(50, 50, 50)
                Sw.Text = ""
                Sw.AutoButtonColor = false
                Sw.Parent = Frm

                local SwC = Instance.new("UICorner")
                SwC.CornerRadius = UDim.new(1, 0)
                SwC.Parent = Sw

                local Knob = Instance.new("Frame")
                Knob.Size = UDim2.new(0, 16, 0, 16)
                Knob.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                Knob.BackgroundColor3 = toggled and Color3.fromRGB(0, 0, 0) or Library.Theme.Text
                Knob.Parent = Sw

                local KC = Instance.new("UICorner")
                KC.CornerRadius = UDim.new(1, 0)
                KC.Parent = Knob

                Sw.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    Library:Tween(Sw, {0.2, Enum.EasingStyle.Quad}, {BackgroundColor3 = toggled and Library.Theme.Acc1 or Color3.fromRGB(50, 50, 50)})
                    Library:Tween(Knob, {0.2, Enum.EasingStyle.Quad}, {
                        Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                        BackgroundColor3 = toggled and Color3.fromRGB(0, 0, 0) or Library.Theme.Text
                    })
                    pcall(callback, toggled)
                end)
            end

            function GroupObject:AddInput(text, flagTable, flagKey, isNum)
                local Frm = Instance.new("Frame")
                Frm.Size = UDim2.new(1, 0, 0, 34)
                Frm.BackgroundTransparency = 1
                Frm.Parent = GroupCard

                local L = Instance.new("TextLabel")
                L.Size = UDim2.new(0.48, 0, 1, 0)
                L.Position = UDim2.new(0, 4, 0, 0)
                L.BackgroundTransparency = 1
                L.Font = Enum.Font.GothamMedium
                L.Text = text
                L.TextColor3 = Library.Theme.Text
                L.TextSize = 11
                L.TextXAlignment = Enum.TextXAlignment.Left
                L.Parent = Frm

                local Box = Instance.new("TextBox")
                Box.Size = UDim2.new(0.5, 0, 0.8, 0)
                Box.Position = UDim2.new(0.5, 0, 0.1, 0)
                Box.BackgroundColor3 = Library.Theme.Header
                Box.BackgroundTransparency = 0.1
                Box.Font = Enum.Font.GothamBold
                Box.Text = tostring(flagTable[flagKey] or "")
                Box.TextColor3 = Library.Theme.Acc1
                Box.TextSize = 11
                Box.Parent = Frm

                local BC = Instance.new("UICorner")
                BC.CornerRadius = UDim.new(0, 6)
                BC.Parent = Box

                local BS = Instance.new("UIStroke")
                BS.Color = Library.Theme.Acc1
                BS.Transparency = 0.5
                BS.Thickness = 1
                BS.Parent = Box

                Box.FocusLost:Connect(function()
                    flagTable[flagKey] = isNum and (tonumber(Box.Text) or 0) or Box.Text
                    Box.Text = tostring(flagTable[flagKey])
                end)
            end

            function GroupObject:AddSlider(text, min, max, default, callback)
                min = min or 0
                max = max or 100
                default = default or min
                callback = callback or function() end

                local currentValue = default

                local Frm = Instance.new("Frame")
                Frm.Size = UDim2.new(1, 0, 0, 46)
                Frm.BackgroundTransparency = 1
                Frm.Parent = GroupCard

                local L = Instance.new("TextLabel")
                L.Size = UDim2.new(0.6, 0, 0, 20)
                L.Position = UDim2.new(0, 4, 0, 0)
                L.BackgroundTransparency = 1
                L.Font = Enum.Font.GothamMedium
                L.Text = text
                L.TextColor3 = Library.Theme.Text
                L.TextSize = 11
                L.TextXAlignment = Enum.TextXAlignment.Left
                L.Parent = Frm

                local ValLbl = Instance.new("TextLabel")
                ValLbl.Size = UDim2.new(0.4, 0, 0, 20)
                ValLbl.Position = UDim2.new(0.6, -4, 0, 0)
                ValLbl.BackgroundTransparency = 1
                ValLbl.Font = Enum.Font.GothamBold
                ValLbl.Text = tostring(default)
                ValLbl.TextColor3 = Library.Theme.Acc1
                ValLbl.TextSize = 11
                ValLbl.TextXAlignment = Enum.TextXAlignment.Right
                ValLbl.Parent = Frm

                local SliderBar = Instance.new("Frame")
                SliderBar.Size = UDim2.new(1, -8, 0, 7)
                SliderBar.Position = UDim2.new(0, 4, 0, 28)
                SliderBar.BackgroundColor3 = Library.Theme.Header
                SliderBar.Parent = Frm

                local SBC = Instance.new("UICorner")
                SBC.CornerRadius = UDim.new(1, 0)
                SBC.Parent = SliderBar

                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                SliderFill.BackgroundColor3 = Library.Theme.Acc1
                SliderFill.Parent = SliderBar

                local SFC = Instance.new("UICorner")
                SFC.CornerRadius = UDim.new(1, 0)
                SFC.Parent = SliderFill

                local function updateSlider(input)
                    local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
                    SliderFill.Size = pos
                    local val = math.floor(min + ((max - min) * pos.X.Scale))
                    currentValue = val
                    ValLbl.Text = tostring(val)
                    pcall(callback, val)
                end

                local sliding = false
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        updateSlider(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                    end
                end)
            end

            function GroupObject:AddDropdown(title, options, flagTable, flagKey, isMulti)
                options = options or {}
                
                local Frm = Instance.new("Frame")
                Frm.Size = UDim2.new(1, 0, 0, 36)
                Frm.BackgroundTransparency = 1
                Frm.Parent = GroupCard

                local L = Instance.new("TextLabel")
                L.Size = UDim2.new(0.4, 0, 1, 0)
                L.Position = UDim2.new(0, 4, 0, 0)
                L.BackgroundTransparency = 1
                L.Font = Enum.Font.GothamMedium
                L.Text = title
                L.TextColor3 = Library.Theme.Text
                L.TextSize = 11
                L.TextXAlignment = Enum.TextXAlignment.Left
                L.Parent = Frm

                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(0.58, 0, 0.8, 0)
                Btn.Position = UDim2.new(0.42, 0, 0.1, 0)
                Btn.BackgroundColor3 = Library.Theme.Header
                Btn.BackgroundTransparency = 0.1
                Btn.Font = Enum.Font.GothamBold
                Btn.TextColor3 = Library.Theme.Acc1
                Btn.TextSize = 10
                Btn.Parent = Frm

                local BC = Instance.new("UICorner")
                BC.CornerRadius = UDim.new(0, 6)
                BC.Parent = Btn

                local BS = Instance.new("UIStroke")
                BS.Color = Library.Theme.Acc1
                BS.Transparency = 0.5
                BS.Thickness = 1
                BS.Parent = Btn

                local function updateMainBtn()
                    if isMulti then
                        local selArr = flagTable[flagKey] or {}
                        local count = #selArr
                        if count == 0 then
                            Btn.Text = "Pilih Multi..."
                        elseif count == 1 then
                            Btn.Text = tostring(selArr[1])
                        else
                            Btn.Text = tostring(selArr[1]) .. " (+" .. (count - 1) .. " Lain)"
                        end
                    else
                        Btn.Text = tostring(flagTable[flagKey] or "Pilih")
                    end
                end
                updateMainBtn()

                local DropList = Instance.new("Frame")
                DropList.Size = UDim2.new(0, 260, 0, 200)
                DropList.BackgroundColor3 = Library.Theme.Bg
                DropList.Visible = false
                DropList.ZIndex = 300
                DropList.Parent = MainFrame

                local DLC = Instance.new("UICorner")
                DLC.CornerRadius = UDim.new(0, 8)
                DLC.Parent = DropList

                local DLS = Instance.new("UIStroke")
                DLS.Color = Library.Theme.Acc1
                DLS.Thickness = 1.2
                DLS.Parent = DropList

                local SearchBox = Instance.new("TextBox")
                SearchBox.Size = UDim2.new(1, -14, 0, 26)
                SearchBox.Position = UDim2.new(0, 7, 0, 7)
                SearchBox.BackgroundColor3 = Library.Theme.Header
                SearchBox.PlaceholderText = "🔍 Cari..."
                SearchBox.Text = ""
                SearchBox.TextColor3 = Library.Theme.Text
                SearchBox.PlaceholderColor3 = Library.Theme.SubText
                SearchBox.TextSize = 11
                SearchBox.Font = Enum.Font.GothamMedium
                SearchBox.ZIndex = 301
                SearchBox.Parent = DropList

                local SC = Instance.new("UICorner")
                SC.CornerRadius = UDim.new(0, 5)
                SC.Parent = SearchBox

                local ActionHeader = Instance.new("Frame")
                ActionHeader.Size = UDim2.new(1, -14, 0, 22)
                ActionHeader.Position = UDim2.new(0, 7, 0, 36)
                ActionHeader.BackgroundTransparency = 1
                ActionHeader.ZIndex = 301
                ActionHeader.Visible = isMulti
                ActionHeader.Parent = DropList

                local BtnSelAll = Instance.new("TextButton")
                BtnSelAll.Size = UDim2.new(0.48, 0, 1, 0)
                BtnSelAll.BackgroundColor3 = Library.Theme.Card
                BtnSelAll.Font = Enum.Font.GothamBold
                BtnSelAll.Text = "✅ All"
                BtnSelAll.TextColor3 = Library.Theme.Acc1
                BtnSelAll.TextSize = 10
                BtnSelAll.ZIndex = 301
                BtnSelAll.Parent = ActionHeader
                local SAC = Instance.new("UICorner"); SAC.CornerRadius = UDim.new(0, 4); SAC.Parent = BtnSelAll

                local BtnClrAll = Instance.new("TextButton")
                BtnClrAll.Size = UDim2.new(0.48, 0, 1, 0)
                BtnClrAll.Position = UDim2.new(0.52, 0, 0, 0)
                BtnClrAll.BackgroundColor3 = Library.Theme.Card
                BtnClrAll.Font = Enum.Font.GothamBold
                BtnClrAll.Text = "✕ Clear"
                BtnClrAll.TextColor3 = Library.Theme.SubText
                BtnClrAll.TextSize = 10
                BtnClrAll.ZIndex = 301
                BtnClrAll.Parent = ActionHeader
                local CAC = Instance.new("UICorner"); CAC.CornerRadius = UDim.new(0, 4); CAC.Parent = BtnClrAll

                local ScrollOpts = Instance.new("ScrollingFrame")
                ScrollOpts.Size = UDim2.new(1, -14, 1, isMulti and -68 or -42)
                ScrollOpts.Position = UDim2.new(0, 7, 0, isMulti and 62 or 38)
                ScrollOpts.BackgroundTransparency = 1
                ScrollOpts.ScrollBarThickness = 3
                ScrollOpts.ZIndex = 301
                ScrollOpts.AutomaticCanvasSize = Enum.AutomaticSize.Y
                ScrollOpts.CanvasSize = UDim2.new(0,0,0,0)
                ScrollOpts.Parent = DropList

                local DLL = Instance.new("UIListLayout")
                DLL.SortOrder = Enum.SortOrder.LayoutOrder
                DLL.Padding = UDim.new(0, 3)
                DLL.Parent = ScrollOpts

                local function UpdatePos()
                    if DropList.Visible then
                        DropList.Position = UDim2.new(0, Btn.AbsolutePosition.X - MainFrame.AbsolutePosition.X, 0, (Btn.AbsolutePosition.Y - MainFrame.AbsolutePosition.Y) + Btn.AbsoluteSize.Y + 2)
                    end
                end
                Btn:GetPropertyChangedSignal("AbsolutePosition"):Connect(UpdatePos)

                local updateCheckList = {}

                local function RenderOpts(filter)
                    filter = string.lower(filter or "")
                    for _, v in pairs(ScrollOpts:GetChildren()) do
                        if v:IsA("TextButton") then v:Destroy() end
                    end

                    for _, opt in ipairs(options) do
                        local optLabel = type(opt) == "table" and tostring(opt.label) or tostring(opt)
                        local optVal = type(opt) == "table" and opt.val or opt

                        if filter == "" or string.find(string.lower(optLabel), filter) then
                            local OptBtn = Instance.new("TextButton")
                            OptBtn.Size = UDim2.new(1, 0, 0, 28)
                            OptBtn.BackgroundColor3 = Library.Theme.Card
                            OptBtn.BackgroundTransparency = 0.3
                            OptBtn.Font = Enum.Font.GothamMedium
                            OptBtn.Text = "  " .. optLabel
                            OptBtn.TextColor3 = Library.Theme.Text
                            OptBtn.TextSize = 10
                            OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                            OptBtn.ZIndex = 302
                            OptBtn.Parent = ScrollOpts

                            local OC = Instance.new("UICorner")
                            OC.CornerRadius = UDim.new(0, 4)
                            OC.Parent = OptBtn

                            local check = Instance.new("Frame")
                            check.Size = UDim2.new(0, 14, 0, 14)
                            check.Position = UDim2.new(1, -18, 0.5, -7)
                            check.ZIndex = 302
                            check.Parent = OptBtn

                            local cc = Instance.new("UICorner")
                            cc.CornerRadius = UDim.new(0, 3)
                            cc.Parent = check

                            local function updateCheckVisuals()
                                local sel = false
                                if isMulti then
                                    for _, v in ipairs(flagTable[flagKey] or {}) do
                                        if v == optVal then sel = true break end
                                    end
                                else
                                    sel = (flagTable[flagKey] == optVal)
                                end
                                check.BackgroundColor3 = sel and Library.Theme.Acc1 or Color3.fromRGB(50, 50, 50)
                            end
                            table.insert(updateCheckList, updateCheckVisuals)
                            updateCheckVisuals()

                            OptBtn.MouseButton1Click:Connect(function()
                                if isMulti then
                                    if not flagTable[flagKey] then flagTable[flagKey] = {} end
                                    local found = false
                                    for i, v in ipairs(flagTable[flagKey]) do
                                        if v == optVal then
                                            table.remove(flagTable[flagKey], i)
                                            found = true
                                            break
                                        end
                                    end
                                    if not found then table.insert(flagTable[flagKey], optVal) end
                                else
                                    flagTable[flagKey] = optVal
                                    DropList.Visible = false
                                end
                                updateMainBtn()
                                for _, fn in ipairs(updateCheckList) do pcall(fn) end
                            end)
                        end
                    end
                end

                RenderOpts("")

                SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    RenderOpts(SearchBox.Text)
                end)

                if isMulti then
                    BtnSelAll.MouseButton1Click:Connect(function()
                        flagTable[flagKey] = {}
                        for _, opt in ipairs(options) do
                            local optVal = type(opt) == "table" and opt.val or opt
                            table.insert(flagTable[flagKey], optVal)
                        end
                        updateMainBtn()
                        for _, fn in ipairs(updateCheckList) do pcall(fn) end
                    end)

                    BtnClrAll.MouseButton1Click:Connect(function()
                        flagTable[flagKey] = {}
                        updateMainBtn()
                        for _, fn in ipairs(updateCheckList) do pcall(fn) end
                    end)
                end

                Btn.MouseButton1Click:Connect(function()
                    DropList.Visible = not DropList.Visible
                    UpdatePos()
                end)
            end

            return GroupObject
        end

        return TabObject
    end

    -- Universal Profile Tab with Avatar Image + Frame & Stroke
    function Window:CreateProfileTab()
        local TabPage = Window:CreateTab("Profile", "👤")
        local Group = TabPage:CreateGroup("PROFIL & INFORMASI AKUN")
        
        local ProfContainer = Instance.new("Frame")
        ProfContainer.Size = UDim2.new(1, 0, 0, 75)
        ProfContainer.BackgroundTransparency = 1
        ProfContainer.Parent = Group

        local PImg = Instance.new("ImageLabel")
        PImg.Size = UDim2.new(0, 60, 0, 60)
        PImg.AnchorPoint = Vector2.new(0, 0.5)
        PImg.Position = UDim2.new(0, 6, 0.5, 0)
        PImg.BackgroundColor3 = Library.Theme.Card
        pcall(function()
            PImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        PImg.Parent = ProfContainer

        local PImgC = Instance.new("UICorner")
        PImgC.CornerRadius = UDim.new(1, 0)
        PImgC.Parent = PImg

        local PStr = Instance.new("UIStroke")
        PStr.Thickness = 1.6
        PStr.Color = Library.Theme.Acc1
        PStr.Parent = PImg

        local PLbl = Instance.new("TextLabel")
        PLbl.Size = UDim2.new(1, -80, 1, 0)
        PLbl.Position = UDim2.new(0, 76, 0, 0)
        PLbl.BackgroundTransparency = 1
        PLbl.Font = Enum.Font.GothamMedium
        PLbl.TextColor3 = Library.Theme.Text
        PLbl.TextSize = 11
        PLbl.TextXAlignment = Enum.TextXAlignment.Left
        PLbl.TextYAlignment = Enum.TextYAlignment.Center
        PLbl.Text = string.format("👤 Player: %s\n✨ Display: %s\n🆔 ID: %s", LocalPlayer.Name, LocalPlayer.DisplayName, tostring(LocalPlayer.UserId))
        PLbl.Parent = ProfContainer
    end

    return Window
end

return Library
