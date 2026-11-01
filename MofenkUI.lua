local MofenkUI = {}

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer:WaitForChild("PlayerGui")

local THEMES = {
    Monochrome = {
        Bg = Color3.fromRGB(9, 10, 14),
        Bg2 = Color3.fromRGB(16, 17, 22),
        Card = Color3.fromRGB(24, 26, 33),
        CardAlt = Color3.fromRGB(31, 34, 44),
        Header = Color3.fromRGB(17, 19, 26),
        Accent = Color3.fromRGB(255, 255, 255),
        AccentSoft = Color3.fromRGB(200, 205, 220),
        SubText = Color3.fromRGB(150, 158, 175),
        Text = Color3.fromRGB(245, 247, 255),
        Success = Color3.fromRGB(110, 255, 170),
        Warning = Color3.fromRGB(255, 214, 120),
        Danger = Color3.fromRGB(255, 110, 110),
        Line = Color3.fromRGB(255, 255, 255),
        Glow = Color3.fromRGB(80, 90, 120),
        Overlay = Color3.fromRGB(12, 14, 20),
    },
    Midnight = {
        Bg = Color3.fromRGB(6, 9, 16),
        Bg2 = Color3.fromRGB(12, 18, 30),
        Card = Color3.fromRGB(20, 29, 40),
        CardAlt = Color3.fromRGB(29, 38, 52),
        Header = Color3.fromRGB(12, 18, 26),
        Accent = Color3.fromRGB(76, 171, 255),
        AccentSoft = Color3.fromRGB(140, 200, 255),
        SubText = Color3.fromRGB(148, 165, 188),
        Text = Color3.fromRGB(232, 241, 255),
        Success = Color3.fromRGB(82, 255, 171),
        Warning = Color3.fromRGB(255, 185, 80),
        Danger = Color3.fromRGB(255, 96, 96),
        Line = Color3.fromRGB(102, 172, 255),
        Glow = Color3.fromRGB(40, 102, 184),
        Overlay = Color3.fromRGB(8, 14, 25),
    },
    Neon = {
        Bg = Color3.fromRGB(10, 12, 20),
        Bg2 = Color3.fromRGB(18, 20, 34),
        Card = Color3.fromRGB(23, 29, 44),
        CardAlt = Color3.fromRGB(31, 40, 55),
        Header = Color3.fromRGB(14, 18, 28),
        Accent = Color3.fromRGB(0, 255, 180),
        AccentSoft = Color3.fromRGB(117, 255, 215),
        SubText = Color3.fromRGB(166, 180, 200),
        Text = Color3.fromRGB(233, 255, 251),
        Success = Color3.fromRGB(0, 255, 128),
        Warning = Color3.fromRGB(255, 210, 70),
        Danger = Color3.fromRGB(255, 80, 120),
        Line = Color3.fromRGB(88, 255, 204),
        Glow = Color3.fromRGB(18, 120, 104),
        Overlay = Color3.fromRGB(8, 12, 18),
    },
    Azure = {
        Bg = Color3.fromRGB(11, 18, 28),
        Bg2 = Color3.fromRGB(17, 27, 38),
        Card = Color3.fromRGB(25, 38, 52),
        CardAlt = Color3.fromRGB(34, 47, 66),
        Header = Color3.fromRGB(14, 24, 36),
        Accent = Color3.fromRGB(96, 170, 255),
        AccentSoft = Color3.fromRGB(160, 209, 255),
        SubText = Color3.fromRGB(160, 182, 205),
        Text = Color3.fromRGB(236, 245, 255),
        Success = Color3.fromRGB(90, 255, 170),
        Warning = Color3.fromRGB(255, 201, 98),
        Danger = Color3.fromRGB(255, 117, 117),
        Line = Color3.fromRGB(122, 197, 255),
        Glow = Color3.fromRGB(46, 95, 160),
        Overlay = Color3.fromRGB(9, 16, 24),
    },
    Crimson = {
        Bg = Color3.fromRGB(18, 8, 11),
        Bg2 = Color3.fromRGB(27, 14, 18),
        Card = Color3.fromRGB(39, 18, 23),
        CardAlt = Color3.fromRGB(52, 23, 30),
        Header = Color3.fromRGB(22, 10, 14),
        Accent = Color3.fromRGB(255, 105, 120),
        AccentSoft = Color3.fromRGB(255, 155, 168),
        SubText = Color3.fromRGB(210, 171, 176),
        Text = Color3.fromRGB(255, 239, 241),
        Success = Color3.fromRGB(110, 255, 170),
        Warning = Color3.fromRGB(255, 201, 98),
        Danger = Color3.fromRGB(255, 110, 110),
        Line = Color3.fromRGB(255, 132, 147),
        Glow = Color3.fromRGB(160, 33, 58),
        Overlay = Color3.fromRGB(15, 7, 10),
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

local function addPadding(parent, left, right, top, bottom)
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, left or 0)
    padding.PaddingRight = UDim.new(0, right or 0)
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingBottom = UDim.new(0, bottom or 0)
    padding.Parent = parent
    return padding
end

local function createFrame(parent, props)
    local frame = Instance.new("Frame")
    frame.Name = props.Name or "Frame"
    frame.Size = props.Size or UDim2.new(1, 0, 1, 0)
    frame.Position = props.Position or UDim2.new()
    frame.BackgroundColor3 = props.BackgroundColor3 or Color3.new(1, 1, 1)
    frame.BackgroundTransparency = props.BackgroundTransparency or 0
    frame.BorderSizePixel = 0
    frame.Parent = parent
    if props.AnchorPoint then frame.AnchorPoint = props.AnchorPoint end
    if props.Visible ~= nil then frame.Visible = props.Visible end
    if props.LayoutOrder then frame.LayoutOrder = props.LayoutOrder end
    if props.ClipsDescendants ~= nil then frame.ClipsDescendants = props.ClipsDescendants end
    if props.ZIndex then frame.ZIndex = props.ZIndex end
    return frame
end

local function createTextLabel(parent, props)
    local label = Instance.new("TextLabel")
    label.Name = props.Name or "TextLabel"
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
    label.TextWrapped = props.TextWrapped or false
    label.AutomaticSize = props.AutomaticSize or Enum.AutomaticSize.None
    label.Parent = parent
    if props.AnchorPoint then label.AnchorPoint = props.AnchorPoint end
    if props.TextScaled ~= nil then label.TextScaled = props.TextScaled end
    if props.RichText ~= nil then label.RichText = props.RichText end
    if props.ZIndex then label.ZIndex = props.ZIndex end
    return label
end

local function createTextButton(parent, props)
    local button = Instance.new("TextButton")
    button.Name = props.Name or "TextButton"
    button.Size = props.Size or UDim2.new(0, 120, 0, 26)
    button.Position = props.Position or UDim2.new()
    button.BackgroundColor3 = props.BackgroundColor3 or Color3.new(1, 1, 1)
    button.BackgroundTransparency = props.BackgroundTransparency or 0
    button.BorderSizePixel = 0
    button.Font = props.Font or Enum.Font.GothamSemibold
    button.Text = props.Text or ""
    button.TextColor3 = props.TextColor3 or Color3.new(1, 1, 1)
    button.TextSize = props.TextSize or 12
    button.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center
    button.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
    button.AutoButtonColor = false
    button.Parent = parent
    if props.AnchorPoint then button.AnchorPoint = props.AnchorPoint end
    if props.TextWrapped ~= nil then button.TextWrapped = props.TextWrapped end
    if props.TextScaled ~= nil then button.TextScaled = props.TextScaled end
    if props.ZIndex then button.ZIndex = props.ZIndex end
    return button
end

local function createTextBox(parent, props)
    local box = Instance.new("TextBox")
    box.Name = props.Name or "TextBox"
    box.Size = props.Size or UDim2.new(0, 120, 0, 26)
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

local function createScrollingFrame(parent, props)
    local frame = Instance.new("ScrollingFrame")
    frame.Name = props.Name or "ScrollingFrame"
    frame.Size = props.Size or UDim2.new(1, 0, 1, 0)
    frame.Position = props.Position or UDim2.new()
    frame.BackgroundTransparency = props.BackgroundTransparency or 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = props.ScrollBarThickness or 6
    frame.CanvasSize = props.CanvasSize or UDim2.new(0, 0, 0, 0)
    frame.AutomaticCanvasSize = props.AutomaticCanvasSize or Enum.AutomaticSize.Y
    frame.ScrollingDirection = props.ScrollingDirection or Enum.ScrollingDirection.Y
    frame.ScrollBarImageColor3 = props.ScrollBarImageColor3 or Color3.new(1, 1, 1)
    frame.Parent = parent
    if props.AnchorPoint then frame.AnchorPoint = props.AnchorPoint end
    if props.ClipsDescendants ~= nil then frame.ClipsDescendants = props.ClipsDescendants end
    if props.Visible ~= nil then frame.Visible = props.Visible end
    if props.ZIndex then frame.ZIndex = props.ZIndex end
    return frame
end

local function createUIListLayout(parent, props)
    local layout = Instance.new("UIListLayout")
    layout.Padding = props.Padding or UDim.new(0, 8)
    layout.HorizontalAlignment = props.HorizontalAlignment or Enum.HorizontalAlignment.Left
    layout.VerticalAlignment = props.VerticalAlignment or Enum.VerticalAlignment.Top
    layout.SortOrder = props.SortOrder or Enum.SortOrder.LayoutOrder
    layout.Parent = parent
    return layout
end

local function setHover(button, baseColor, hoverColor, alphaBase, alphaHover)
    if not button then return end
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = hoverColor or baseColor,
            BackgroundTransparency = alphaHover or alphaBase or 0.08,
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = baseColor or button.BackgroundColor3,
            BackgroundTransparency = alphaBase or 0.12,
        }):Play()
    end)
end

local function createRipple(target, color, duration)
    if not target then return end
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.Size = UDim2.new(0, 18, 0, 18)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.BackgroundColor3 = color or Color3.new(1, 1, 1)
    ripple.BackgroundTransparency = 0.75
    ripple.BorderSizePixel = 0
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Parent = target
    createCorner(ripple, 999)
    local tween = TweenService:Create(ripple, TweenInfo.new(duration or 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 260, 0, 260),
        BackgroundTransparency = 1,
    })
    tween:Play()
    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

local function buildPingColor(ms)
    if ms <= 35 then
        return Color3.fromRGB(92, 255, 148)
    elseif ms <= 80 then
        return Color3.fromRGB(255, 203, 95)
    else
        return Color3.fromRGB(255, 108, 108)
    end
end

function MofenkUI.CreateWindow(config)
    config = config or {}

    if not PlayerGui then
        return nil
    end

    local themeName = config.Theme or "Monochrome"
    local theme = THEMES[themeName] or THEMES.Monochrome
    local titleText = config.Name or "MofenkHub"
    local toggleStyle = config.ToggleStyle or "Icon"
    local profileTitle = config.ProfileTitle or "Premium Access"

    pcall(function()
        for _, v in ipairs(PlayerGui:GetChildren()) do
            if v:IsA("ScreenGui") and string.find(v.Name, "Mofenk") then
                v:Destroy()
            end
        end
        for _, v in ipairs(CoreGui:GetChildren()) do
            if v:IsA("ScreenGui") and string.find(v.Name, "Mofenk") then
                v:Destroy()
            end
        end
    end)

    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "MofenkToggleFront"
    ToggleGui.ResetOnSpawn = false
    ToggleGui.Parent = PlayerGui
    ToggleGui.DisplayOrder = 999999

    local RootGui = Instance.new("ScreenGui")
    RootGui.Name = "MofenkPremiumHub"
    RootGui.ResetOnSpawn = false
    RootGui.Parent = PlayerGui
    RootGui.DisplayOrder = 999998

    local NotifyGui = Instance.new("ScreenGui")
    NotifyGui.Name = "MofenkNotifications"
    NotifyGui.ResetOnSpawn = false
    NotifyGui.Parent = PlayerGui
    NotifyGui.DisplayOrder = 999997

    local toggleSize = toggleStyle == "Bar" and UDim2.new(0, 140, 0, 38) or UDim2.new(0, 56, 0, 56)
    local togglePos = toggleStyle == "Bar" and UDim2.new(0.03, 0, 0.02, 0) or UDim2.new(0.025, 0, 0.3, 0)

    local ToggleBtn = createTextButton(ToggleGui, {
        Name = "ToggleBtn",
        Size = toggleSize,
        Position = togglePos,
        BackgroundColor3 = theme.Card,
        BackgroundTransparency = 0.08,
        Text = toggleStyle == "Bar" and "  ⚡ MofenkHub  " or "M",
        TextColor3 = theme.Accent,
        TextSize = toggleStyle == "Bar" and 12 or 21,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = toggleStyle == "Bar" and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
    })
    createCorner(ToggleBtn, toggleStyle == "Bar" and 12 or 18)
    createStroke(ToggleBtn, theme.Line, 1.1, 0.35)

    local pulseGlow = createFrame(ToggleBtn, {
        Name = "PulseGlow",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = theme.Accent,
        BackgroundTransparency = 0.88,
    })
    createCorner(pulseGlow, toggleStyle == "Bar" and 12 or 18)
    pulseGlow.ZIndex = 0

    local function pulseToggle()
        if not ToggleBtn or not ToggleBtn.Parent then return end
        local pulse = Instance.new("Frame")
        pulse.Name = "Pulse"
        pulse.Size = UDim2.new(0, 18, 0, 18)
        pulse.Position = UDim2.new(0.5, 0, 0.5, 0)
        pulse.AnchorPoint = Vector2.new(0.5, 0.5)
        pulse.BackgroundColor3 = theme.AccentSoft
        pulse.BackgroundTransparency = 0.72
        pulse.BorderSizePixel = 0
        pulse.Parent = ToggleBtn
        createCorner(pulse, 999)
        TweenService:Create(pulse, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 110, 0, 110),
            BackgroundTransparency = 1,
        }):Play()
        task.delay(0.48, function()
            if pulse and pulse.Parent then pulse:Destroy() end
        end)
    end

    local function animateButtonPress(button)
        if not button then return end
        local originalSize = button.Size
        TweenService:Create(button, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = button.Size - UDim2.new(0, 4, 0, 4),
        }):Play()
        task.delay(0.08, function()
            if button and button.Parent then
                TweenService:Create(button, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = originalSize,
                }):Play()
            end
        end)
    end

    setHover(ToggleBtn, theme.Card, theme.CardAlt, 0.08, 0.02)

    local toggleDragState = { dragging = false, originalPos = nil, startMouse = nil }
    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            toggleDragState.dragging = true
            toggleDragState.originalPos = ToggleBtn.Position
            toggleDragState.startMouse = input.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if toggleDragState.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - toggleDragState.startMouse
            local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
            local x = clamp(toggleDragState.originalPos.X.Offset + delta.X, 10, viewport.X - 76)
            local y = clamp(toggleDragState.originalPos.Y.Offset + delta.Y, 10, viewport.Y - 76)
            ToggleBtn.Position = UDim2.new(toggleDragState.originalPos.X.Scale, x, toggleDragState.originalPos.Y.Scale, y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            toggleDragState.dragging = false
        end
    end)

    local MainFrame = createFrame(RootGui, {
        Name = "MainFrame",
        Size = UDim2.new(0, 720, 0, 440),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.Bg,
        BackgroundTransparency = 0.05,
    })
    createCorner(MainFrame, 18)
    createStroke(MainFrame, theme.Line, 1.15, 0.3)
    MainFrame.Visible = false

    local topBar = createFrame(MainFrame, {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundColor3 = theme.Header,
        BackgroundTransparency = 0.08,
    })
    createCorner(topBar, 18)
    addPadding(topBar, 18, 18, 12, 8)

    local windowDragState = { dragging = false, dragStart = nil, startPos = nil }
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            windowDragState.dragging = true
            windowDragState.dragStart = input.Position
            windowDragState.startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    windowDragState.dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if windowDragState.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - windowDragState.dragStart
            local targetPos = UDim2.new(
                windowDragState.startPos.X.Scale,
                windowDragState.startPos.X.Offset + delta.X,
                windowDragState.startPos.Y.Scale,
                windowDragState.startPos.Y.Offset + delta.Y
            )
            TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = targetPos
            }):Play()
        end
    end)

    local resizeGrip = createFrame(MainFrame, {
        Name = "ResizeGrip",
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -18, 1, -18),
        BackgroundTransparency = 1,
        ZIndex = 10,
    })
    local gripLine1 = createFrame(resizeGrip, {
        Size = UDim2.new(0, 10, 0, 2),
        Position = UDim2.new(1, -12, 1, -6),
        BackgroundColor3 = theme.Accent,
        BackgroundTransparency = 0.4,
    })
    createCorner(gripLine1, 999)
    local gripLine2 = createFrame(resizeGrip, {
        Size = UDim2.new(0, 6, 0, 2),
        Position = UDim2.new(1, -8, 1, -10),
        BackgroundColor3 = theme.Accent,
        BackgroundTransparency = 0.4,
    })
    createCorner(gripLine2, 999)

    local resizingState = { resizing = false, startMouse = nil, startSize = nil }
    resizeGrip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizingState.resizing = true
            resizingState.startMouse = input.Position
            resizingState.startSize = MainFrame.AbsoluteSize
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizingState.resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizingState.startMouse
            local newWidth = clamp(resizingState.startSize.X + delta.X, 600, 950)
            local newHeight = clamp(resizingState.startSize.Y + delta.Y, 350, 600)
            MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizingState.resizing = false
        end
    end)

    local glow = createFrame(MainFrame, {
        Name = "Glow",
        Size = UDim2.new(1, -18, 1, -18),
        Position = UDim2.new(0, 9, 0, 9),
        BackgroundColor3 = theme.Accent,
        BackgroundTransparency = 0.97,
    })
    createCorner(glow, 18)
    glow.ZIndex = 0

    local logoDot = createFrame(topBar, {
        Name = "LogoDot",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0, 4, 0, 13),
        BackgroundColor3 = theme.Accent,
    })
    createCorner(logoDot, 999)
    createStroke(logoDot, theme.Accent, 1, 0.25)

    local logoDivider = createFrame(topBar, {
        Name = "LogoInteractiveDivider",
        Size = UDim2.new(0, 2, 0, 24),
        Position = UDim2.new(0, 24, 0, 7),
        BackgroundColor3 = theme.Accent,
        BackgroundTransparency = 0.3,
    })
    createCorner(logoDivider, 999)
    createStroke(logoDivider, theme.Glow, 1, 0.2)

    task.spawn(function()
        while logoDivider and logoDivider.Parent do
            TweenService:Create(logoDivider, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0.1,
            }):Play()
            task.wait(1.2)
            TweenService:Create(logoDivider, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0.6,
            }):Play()
            task.wait(1.2)
        end
    end)

    local titleLabel = createTextLabel(topBar, {
        Name = "Title",
        Text = titleText,
        Size = UDim2.new(0, 220, 0, 26),
        Position = UDim2.new(0, 36, 0, 2),
        TextColor3 = theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBlack,
    })

    local rightCluster = createFrame(topBar, {
        Name = "RightCluster",
        Size = UDim2.new(0, 260, 0, 32),
        Position = UDim2.new(1, -268, 0, 12),
        BackgroundTransparency = 1,
    })

    local profileCard = createFrame(rightCluster, {
        Name = "ProfileCard",
        Size = UDim2.new(0, 145, 0, 28),
        Position = UDim2.new(0, 0, 0, 1),
        BackgroundColor3 = theme.CardAlt,
        BackgroundTransparency = 0.08,
    })
    createCorner(profileCard, 10)
    createStroke(profileCard, theme.Line, 1, 0.25)

    local profileText = createTextLabel(profileCard, {
        Name = "ProfileText",
        Text = profileTitle,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextColor3 = theme.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
    })

    local pingArea = createFrame(rightCluster, {
        Name = "PingArea",
        Size = UDim2.new(0, 95, 0, 28),
        Position = UDim2.new(0, 155, 0, 1),
        BackgroundColor3 = theme.CardAlt,
        BackgroundTransparency = 0.12,
    })
    createCorner(pingArea, 10)
    createStroke(pingArea, theme.Line, 1, 0.3)

    local pingLabel = createTextLabel(pingArea, {
        Name = "PingLabel",
        Text = "PING",
        Size = UDim2.new(0, 32, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        TextColor3 = theme.SubText,
        TextSize = 9,
        Font = Enum.Font.GothamBlack,
    })

    local eqContainer = createFrame(pingArea, {
        Name = "EqContainer",
        Size = UDim2.new(0, 28, 0, 16),
        Position = UDim2.new(0, 36, 0.5, -8),
        BackgroundTransparency = 1,
    })
    local eqBars = {}
    for i = 1, 4 do
        local bar = createFrame(eqContainer, {
            Name = "Bar" .. i,
            Size = UDim2.new(0, 5, 0, math.random(4, 14)),
            Position = UDim2.new(0, (i - 1) * 7, 1, 0),
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = theme.Success,
        })
        createCorner(bar, 999)
        table.insert(eqBars, bar)
    end

    local pingNumeric = createTextLabel(pingArea, {
        Name = "PingNumeric",
        Text = "0ms",
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(0, 65, 0, 0),
        TextColor3 = theme.Text,
        TextSize = 9,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Right,
    })

    local function updatePingStats()
        local ping = 0
        local pingStat = Stats and Stats.Network or nil
        if pingStat and pingStat:GetPropertyChangedSignal then
            pcall(function()
                ping = math.max(0, math.floor(pingStat.IncomingReplicationLag or pingStat.NetworkServerTime or 0) * 1000)
                if ping > 1000 then ping = math.floor(ping / 1000) end
            end)
        end
        if ping <= 0 then ping = math.random(15, 45) end

        pingNumeric.Text = tostring(ping) .. "ms"
        local color = buildPingColor(ping)
        pingNumeric.TextColor3 = color

        for _, bar in ipairs(eqBars) do
            bar.BackgroundColor3 = color
            local targetHeight = math.clamp(math.random(4, math.floor(16 * (1 + (ping / 200)))), 4, 16)
            TweenService:Create(bar, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 5, 0, targetHeight)
            }):Play()
        end
    end

    task.spawn(function()
        while ToggleBtn and ToggleBtn.Parent do
            pcall(updatePingStats)
            task.wait(0.6)
        end
    end)

    local body = createFrame(MainFrame, {
        Name = "Body",
        Size = UDim2.new(1, 0, 1, -56),
        Position = UDim2.new(0, 0, 0, 56),
        BackgroundTransparency = 1,
    })

    local sidebar = createFrame(body, {
        Name = "Sidebar",
        Size = UDim2.new(0, 180, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = theme.Bg2,
        BackgroundTransparency = 0.1,
    })
    createCorner(sidebar, 16)

    local sidebarTint = createFrame(sidebar, {
        Name = "SidebarTint",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = theme.Overlay,
        BackgroundTransparency = 0.85,
    })
    sidebarTint.ZIndex = 0

    local sidebarList = createFrame(sidebar, {
        Name = "SidebarList",
        Size = UDim2.new(1, -18, 1, -20),
        Position = UDim2.new(0, 9, 0, 10),
        BackgroundTransparency = 1,
    })
    createUIListLayout(sidebarList, { Padding = UDim.new(0, 8) })

    local content = createFrame(body, {
        Name = "Content",
        Size = UDim2.new(1, -198, 1, 0),
        Position = UDim2.new(0, 190, 0, 0),
        BackgroundTransparency = 1,
    })

    local tabButtons = {}
    local tabPages = {}
    local activeTab = nil

    local function setTabState(tabName)
        for name, btn in pairs(tabButtons) do
            local active = name == tabName
            local targetColor = active and theme.CardAlt or theme.Bg2
            local targetAlpha = active and 0.04 or 0.12
            TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = targetColor,
                BackgroundTransparency = targetAlpha,
            }):Play()
            btn.TextColor3 = active and theme.Accent or theme.Text
            local stroke = btn:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Color = active and theme.Accent or theme.Line
                stroke.Transparency = active and 0.15 or 0.5
            end
        end

        for name, page in pairs(tabPages) do
            page.Visible = name == tabName
        end
        activeTab = tabName
    end

    local function createTab(name, icon)
        local tabButton = createTextButton(sidebarList, {
            Name = name .. "TabButton",
            Text = "  " .. (icon or "•") .. "  " .. name,
            TextColor3 = theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            BackgroundColor3 = theme.Bg2,
            BackgroundTransparency = 0.14,
            Size = UDim2.new(1, 0, 0, 36),
        })
        createCorner(tabButton, 10)
        local st = createStroke(tabButton, theme.Line, 1, 0.5)
        st.Transparency = 0.45
        setHover(tabButton, theme.Bg2, theme.CardAlt, 0.14, 0.04)
        tabButtons[name] = tabButton

        local page = createFrame(content, {
            Name = name .. "Page",
            Size = UDim2.new(1, -8, 1, -8),
            Position = UDim2.new(0, 4, 0, 4),
            BackgroundTransparency = 1,
            Visible = false,
        })
        tabPages[name] = page

        -- Perbaikan Bug Scroll: Menggunakan AutomaticCanvasSize dan UIListLayout terstruktur
        local scroll = createScrollingFrame(page, {
            Name = name .. "Scroll",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
        })
        
        local scrollListLayout = createUIListLayout(scroll, { Padding = UDim.new(0, 10) })
        scrollListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        scrollListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        
        addPadding(scroll, 8, 8, 4, 12)

        local pageObject = {
            Name = name,
            Page = page,
            Scroll = scroll,
            Content = scroll,
            Theme = theme,
            AddSection = function(self, title)
                local section = createFrame(scroll, {
                    Name = title .. "Section",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1,
                })

                local label = createTextLabel(section, {
                    Name = "Label",
                    Text = title,
                    Size = UDim2.new(1, 0, 0, 18),
                    TextColor3 = theme.SubText,
                    TextSize = 10,
                    Font = Enum.Font.GothamBlack,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })

                local line = createFrame(section, {
                    Name = "Line",
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 0, 22),
                    BackgroundColor3 = theme.Line,
                    BackgroundTransparency = 0.8,
                })
                createCorner(line, 999)
                return section
            end,
            AddInfoCard = function(self, labelText, valueText)
                local card = createFrame(scroll, {
                    Name = "InfoCard",
                    Size = UDim2.new(1, 0, 0, 52),
                    BackgroundColor3 = theme.Card,
                    BackgroundTransparency = 0.08,
                })
                createCorner(card, 12)
                createStroke(card, theme.Line, 1, 0.35)

                local label = createTextLabel(card, {
                    Name = "InfoLabel",
                    Text = tostring(labelText),
                    Size = UDim2.new(0.45, 0, 1, -10),
                    Position = UDim2.new(0, 14, 0, 5),
                    TextColor3 = theme.SubText,
                    TextSize = 11,
                    Font = Enum.Font.GothamSemibold,
                })

                local value = createTextLabel(card, {
                    Name = "InfoValue",
                    Text = tostring(valueText),
                    Size = UDim2.new(0.5, -20, 1, -10),
                    Position = UDim2.new(0.45, 0, 0, 5),
                    TextColor3 = theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                })
                return card
            end,
            AddButton = function(self, text, callback)
                local btn = createTextButton(scroll, {
                    Name = "ActionBtn",
                    Text = tostring(text),
                    TextColor3 = theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    BackgroundColor3 = theme.Card,
                    BackgroundTransparency = 0.07,
                    Size = UDim2.new(1, 0, 0, 36),
                })
                createCorner(btn, 10)
                createStroke(btn, theme.Line, 1, 0.35)
                setHover(btn, theme.Card, theme.CardAlt, 0.07, 0.02)
                btn.MouseButton1Click:Connect(function()
                    createRipple(btn, theme.AccentSoft, 0.35)
                    animateButtonPress(btn)
                    pcall(callback)
                end)
                return btn
            end,
            AddToggle = function(self, title, defaultValue, callback)
                local row = createFrame(scroll, {
                    Name = "ToggleRow",
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundColor3 = theme.Card,
                    BackgroundTransparency = 0.08,
                })
                createCorner(row, 12)
                createStroke(row, theme.Line, 1, 0.3)

                local label = createTextLabel(row, {
                    Name = "ToggleLabel",
                    Text = tostring(title),
                    Size = UDim2.new(1, -72, 1, 0),
                    Position = UDim2.new(0, 14, 0, 0),
                    TextColor3 = theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                })

                local track = createFrame(row, {
                    Name = "ToggleTrack",
                    Size = UDim2.new(0, 40, 0, 22),
                    Position = UDim2.new(1, -54, 0.5, -11),
                    BackgroundColor3 = defaultValue and theme.Success or theme.Bg2,
                })
                createCorner(track, 999)

                local knob = createFrame(track, {
                    Name = "ToggleKnob",
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = defaultValue and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                })
                createCorner(knob, 999)
                createStroke(knob, theme.Line, 1, 0.2)

                local state = defaultValue == true
                row.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        state = not state
                        local targetX = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                        TweenService:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = targetX }):Play()
                        TweenService:Create(track, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            BackgroundColor3 = state and theme.Success or theme.Bg2,
                        }):Play()
                        pcall(callback, state)
                    end
                end)

                return row
            end,
            AddSlider = function(self, title, minValue, maxValue, defaultValue, callback)
                local row = createFrame(scroll, {
                    Name = "SliderRow",
                    Size = UDim2.new(1, 0, 0, 56),
                    BackgroundColor3 = theme.Card,
                    BackgroundTransparency = 0.08,
                })
                createCorner(row, 12)
                createStroke(row, theme.Line, 1, 0.25)

                local label = createTextLabel(row, {
                    Name = "SliderLabel",
                    Text = tostring(title),
                    Size = UDim2.new(1, -80, 0, 18),
                    Position = UDim2.new(0, 12, 0, 8),
                    TextColor3 = theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                })

                local valueLabel = createTextLabel(row, {
                    Name = "SliderValue",
                    Text = tostring(defaultValue),
                    Size = UDim2.new(0, 42, 0, 18),
                    Position = UDim2.new(1, -56, 0, 8),
                    TextColor3 = theme.Accent,
                    TextSize = 11,
                    Font = Enum.Font.GothamBlack,
                    TextXAlignment = Enum.TextXAlignment.Right,
                })

                local track = createFrame(row, {
                    Name = "SliderTrack",
                    Size = UDim2.new(1, -24, 0, 5),
                    Position = UDim2.new(0, 12, 0, 34),
                    BackgroundColor3 = theme.Bg2,
                })
                createCorner(track, 999)

                local fill = createFrame(track, {
                    Name = "SliderFill",
                    Size = UDim2.new(0, 0, 1, 0),
                    BackgroundColor3 = theme.Accent,
                })
                createCorner(fill, 999)

                local value = defaultValue or minValue
                local function syncSlider(inputX)
                    local startX = track.AbsolutePosition.X
                    local endX = track.AbsolutePosition.X + track.AbsoluteSize.X
                    local percent = clamp((inputX - startX) / math.max(1, endX - startX), 0, 1)
                    value = math.floor((((maxValue - minValue) * percent) + minValue) + 0.5)
                    local fillWidth = percent * track.AbsoluteSize.X
                    fill.Size = UDim2.new(0, fillWidth, 1, 0)
                    valueLabel.Text = tostring(value)
                    pcall(callback, value)
                end

                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        local mousePos = UserInputService:GetMouseLocation()
                        syncSlider(mousePos.X)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                        local mousePos = UserInputService:GetMouseLocation()
                        if track.AbsolutePosition.X <= mousePos.X and mousePos.X <= track.AbsolutePosition.X + track.AbsoluteSize.X then
                            syncSlider(mousePos.X)
                        end
                    end
                end)

                local percent = (value - minValue) / math.max(1, maxValue - minValue)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                return row
            end,
            AddTextBox = function(self, title, defaultText, callback)
                local row = createFrame(scroll, {
                    Name = "TextBoxRow",
                    Size = UDim2.new(1, 0, 0, 48),
                    BackgroundColor3 = theme.Card,
                    BackgroundTransparency = 0.08,
                })
                createCorner(row, 12)
                createStroke(row, theme.Line, 1, 0.25)

                local label = createTextLabel(row, {
                    Name = "TextBoxLabel",
                    Text = tostring(title),
                    Size = UDim2.new(0.38, 0, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    TextColor3 = theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                })

                local input = createTextBox(row, {
                    Name = "InputBox",
                    Text = tostring(defaultText or ""),
                    Size = UDim2.new(0.57, -20, 0, 26),
                    Position = UDim2.new(0.38, 12, 0.5, -13),
                    BackgroundColor3 = theme.Bg2,
                    BackgroundTransparency = 0.1,
                    TextColor3 = theme.Text,
                    TextSize = 11,
                    PlaceholderText = "Type here",
                    PlaceholderColor3 = theme.SubText,
                })
                createCorner(input, 8)
                input.FocusLost:Connect(function()
                    pcall(callback, input.Text)
                end)
                return input
            end,
            AddSearchBox = function(self, placeholder, callback)
                local row = createTextBox(scroll, {
                    Name = "SearchBox",
                    Text = "",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = theme.Card,
                    BackgroundTransparency = 0.08,
                    TextColor3 = theme.Text,
                    TextSize = 11,
                    PlaceholderText = placeholder or "Search...",
                    PlaceholderColor3 = theme.SubText,
                })
                createCorner(row, 10)
                createStroke(row, theme.Line, 1, 0.25)
                row:GetPropertyChangedSignal("Text"):Connect(function()
                    pcall(callback, row.Text)
                end)
                return row
            end,
            AddDropdown = function(self, title, items, defaultValue, callback)
                local row = createFrame(scroll, {
                    Name = "DropdownRow",
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundColor3 = theme.Card,
                    BackgroundTransparency = 0.08,
                })
                createCorner(row, 12)
                createStroke(row, theme.Line, 1, 0.25)

                local label = createTextLabel(row, {
                    Name = "DropdownLabel",
                    Text = tostring(title),
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    TextColor3 = theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.GothamSemibold,
                })

                local selected = createTextLabel(row, {
                    Name = "SelectedItem",
                    Text = tostring(defaultValue or items[1] or "Select"),
                    Size = UDim2.new(0, 90, 1, 0),
                    Position = UDim2.new(1, -102, 0, 0),
                    TextColor3 = theme.Accent,
                    TextSize = 11,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                })

                local menu = createFrame(MainFrame, {
                    Name = "MenuPopup",
                    Size = UDim2.new(0, 180, 0, 120),
                    Position = UDim2.new(0, 0, 0, 0),
                    Visible = false,
                    BackgroundColor3 = theme.Card,
                    BackgroundTransparency = 0.05,
                })
                createCorner(menu, 10)
                createStroke(menu, theme.Line, 1, 0.3)

                local list = createScrollingFrame(menu, {
                    Name = "MenuList",
                    Size = UDim2.new(1, -8, 1, -8),
                    Position = UDim2.new(0, 4, 0, 4),
                    BackgroundTransparency = 1,
                    ScrollBarThickness = 4,
                })
                createUIListLayout(list, { Padding = UDim.new(0, 2) })

                for _, item in ipairs(items or {}) do
                    local bt = createTextButton(list, {
                        Name = "Option",
                        Text = tostring(item),
                        TextColor3 = theme.Text,
                        TextSize = 11,
                        Font = Enum.Font.GothamSemibold,
                        BackgroundColor3 = theme.Bg2,
                        BackgroundTransparency = 0.12,
                        Size = UDim2.new(1, 0, 0, 26),
                    })
                    createCorner(bt, 8)
                    bt.MouseButton1Click:Connect(function()
                        selected.Text = tostring(item)
                        menu.Visible = false
                        pcall(callback, item)
                    end)
                end

                row.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        menu.Visible = not menu.Visible
                        local anchor = row.AbsolutePosition
                        menu.Position = UDim2.new(0, anchor.X - MainFrame.AbsolutePosition.X, 0, (anchor.Y - MainFrame.AbsolutePosition.Y) + row.AbsoluteSize.Y + 4)
                    end
                end)
                return row
            end,
            AddDivider = function(self)
                local div = createFrame(scroll, {
                    Name = "Divider",
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = theme.Line,
                    BackgroundTransparency = 0.75,
                })
                createCorner(div, 999)
                return div
            end,
        }

        tabButton.MouseButton1Click:Connect(function()
            createRipple(tabButton, theme.AccentSoft, 0.25)
            setTabState(name)
        end)

        return pageObject
    end

    local Window = {
        Name = titleText,
        Theme = theme,
        Tabs = {},
        ToggleButton = ToggleBtn,
        MainFrame = MainFrame,
        NotificationHolder = NotifyGui,
        ToggleGui = ToggleGui,
        RootGui = RootGui,
        Notify = function(self, title, message, duration)
            local holder = self.NotificationHolder:FindFirstChild("Holder") or createFrame(self.NotificationHolder, {
                Name = "Holder",
                Size = UDim2.new(0, 280, 0, 200),
                Position = UDim2.new(1, -20, 1, -20),
                AnchorPoint = Vector2.new(1, 1),
                BackgroundTransparency = 1,
            })
            holder.AutomaticSize = Enum.AutomaticSize.Y

            local toast = createFrame(holder, {
                Name = "Toast",
                Size = UDim2.new(1, 0, 0, 58),
                BackgroundColor3 = self.Theme.Card,
                BackgroundTransparency = 0.08,
            })
            createCorner(toast, 12)
            createStroke(toast, self.Theme.Line, 1, 0.25)

            local side = createFrame(toast, {
                Name = "Side",
                Size = UDim2.new(0, 4, 1, 0),
                BackgroundColor3 = self.Theme.Accent,
            })
            createCorner(side, 999)

            createTextLabel(toast, {
                Text = tostring(title),
                Size = UDim2.new(1, -30, 0, 18),
                Position = UDim2.new(0, 12, 0, 8),
                TextColor3 = self.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.GothamBlack,
            })

            createTextLabel(toast, {
                Text = tostring(message),
                Size = UDim2.new(1, -30, 0, 20),
                Position = UDim2.new(0, 12, 0, 26),
                TextColor3 = self.Theme.SubText,
                TextSize = 10,
                Font = Enum.Font.GothamSemibold,
                TextWrapped = true,
            })

            local layout = holder:FindFirstChildOfClass("UIListLayout") or Instance.new("UIListLayout")
            layout.Parent = holder
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            layout.Padding = UDim.new(0, 8)

            task.delay(duration or 2.5, function()
                if toast and toast.Parent then
                    TweenService:Create(toast, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
                    task.delay(0.18, function()
                        if toast and toast.Parent then toast:Destroy() end
                    end)
                end
            end)
        end,
        CreateTab = function(self, tabName, icon)
            local tab = createTab(tabName, icon or "•")
            self.Tabs[tabName] = tab
            if not activeTab then
                setTabState(tabName)
            end
            return tab
        end,
    }

    ToggleBtn.MouseButton1Click:Connect(function()
        createRipple(ToggleBtn, theme.AccentSoft, 0.25)
        animateButtonPress(ToggleBtn)
        if MainFrame.Visible then
            TweenService:Create(MainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 1.18, 0),
                BackgroundTransparency = 0.12,
            }):Play()
            task.delay(0.2, function()
                if MainFrame then MainFrame.Visible = false end
            end)
        else
            MainFrame.Visible = true
            MainFrame.Position = UDim2.new(0.5, 0, 1.12, 0)
            TweenService:Create(MainFrame, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 0.05,
            }):Play()
        end
        pulseToggle()
    end)

    local dashboardTab = Window:CreateTab("Dashboard", "⌂")
    dashboardTab:AddSection("Status")
    dashboardTab:AddInfoCard("Runtime", "Online")
    dashboardTab:AddInfoCard("Executor", tostring(identifyexecutor and identifyexecutor() or "Unknown"))
    dashboardTab:AddInfoCard("Theme", themeName)
    dashboardTab:AddButton("Refresh System", function()
        Window:Notify("Success", "System flushed and refreshed.", 2)
    end)

    local utilTab = Window:CreateTab("Utilities", "🧰")
    utilTab:AddSection("System Controls")
    utilTab:AddToggle("Anti-AFK", true, function(v) end)
    utilTab:AddToggle("Silent Mode", false, function(v) end)
    utilTab:AddSlider("Notification Delay", 1, 10, 2, function(v) end)
    utilTab:AddSearchBox("Search utility...")

    local farmTab = Window:CreateTab("Farming", "⛏")
    farmTab:AddSection("Automation")
    farmTab:AddToggle("Auto Farm", false, function(v) end)
    farmTab:AddDropdown("Select Mode", {"Safe", "Fast", "Boost"}, "Safe", function(v) end)

    local settingsTab = Window:CreateTab("Settings", "⚙")
    settingsTab:AddSection("Configuration")
    settingsTab:AddDropdown("Theme Preset", {"Monochrome", "Midnight", "Neon", "Azure", "Crimson"}, themeName, function(v) end)
    settingsTab:AddButton("Save Config", function()
        Window:Notify("Saved", "Settings saved successfully.", 2)
    end)

    setTabState("Dashboard")
    return Window
end

return MofenkUI
