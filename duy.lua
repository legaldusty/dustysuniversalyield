local DUY = {
    Version = "1.0.0",
    Prefix = ";",
    Commands = {},
    Settings = {
        Noclip = false,
        Fly = false,
        InfiniteJump = false,
        ESP = false,
        Aimbot = false,
        WalkSpeed = 16,
        JumpPower = 50,
        FOV = 70
    },
    Connections = {},
    ESPObjects = {},
    AimbotTarget = nil
}

local Colors = {
    WindowBackground = Color3.fromRGB(236, 233, 216),
    WindowBorder = Color3.fromRGB(0, 84, 227),
    TitleBar = Color3.fromRGB(0, 84, 227),
    TitleBarInactive = Color3.fromRGB(128, 128, 128),
    ButtonFace = Color3.fromRGB(236, 233, 216),
    ButtonHighlight = Color3.fromRGB(255, 255, 255),
    ButtonShadow = Color3.fromRGB(172, 168, 153),
    ButtonDarkShadow = Color3.fromRGB(113, 111, 100),
    Text = Color3.fromRGB(0, 0, 0),
    TitleText = Color3.fromRGB(255, 255, 255),
    SelectedTab = Color3.fromRGB(255, 255, 255),
    UnselectedTab = Color3.fromRGB(212, 208, 200)
}


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local function CreateShadow(parent, depth)
    depth = depth or 2
    
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, depth, 1, depth)
    shadow.Position = UDim2.new(0, depth, 0, depth)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.5
    shadow.BorderSizePixel = 0
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent.Parent
    
    return shadow
end

local function CreateXPButton(parent, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 75, 0, 23)
    button.Position = position
    button.BackgroundColor3 = Colors.ButtonFace
    button.BorderSizePixel = 0
    button.Font = Enum.Font.SourceSans
    button.Text = text
    button.TextColor3 = Colors.Text
    button.TextSize = 14
    button.Parent = parent
    
    local topBorder = Instance.new("Frame")
    topBorder.Size = UDim2.new(1, 0, 0, 1)
    topBorder.Position = UDim2.new(0, 0, 0, 0)
    topBorder.BackgroundColor3 = Colors.ButtonHighlight
    topBorder.BorderSizePixel = 0
    topBorder.Parent = button
    
    local leftBorder = Instance.new("Frame")
    leftBorder.Size = UDim2.new(0, 1, 1, 0)
    leftBorder.Position = UDim2.new(0, 0, 0, 0)
    leftBorder.BackgroundColor3 = Colors.ButtonHighlight
    leftBorder.BorderSizePixel = 0
    leftBorder.Parent = button
    
    local bottomBorder = Instance.new("Frame")
    bottomBorder.Size = UDim2.new(1, 0, 0, 1)
    bottomBorder.Position = UDim2.new(0, 0, 1, -1)
    bottomBorder.BackgroundColor3 = Colors.ButtonDarkShadow
    bottomBorder.BorderSizePixel = 0
    bottomBorder.Parent = button
    
    local rightBorder = Instance.new("Frame")
    rightBorder.Size = UDim2.new(0, 1, 1, 0)
    rightBorder.Position = UDim2.new(1, -1, 0, 0)
    rightBorder.BackgroundColor3 = Colors.ButtonDarkShadow
    rightBorder.BorderSizePixel = 0
    rightBorder.Parent = button
    
    local innerBottomBorder = Instance.new("Frame")
    innerBottomBorder.Size = UDim2.new(1, -2, 0, 1)
    innerBottomBorder.Position = UDim2.new(0, 1, 1, -2)
    innerBottomBorder.BackgroundColor3 = Colors.ButtonShadow
    innerBottomBorder.BorderSizePixel = 0
    innerBottomBorder.Parent = button
    
    local innerRightBorder = Instance.new("Frame")
    innerRightBorder.Size = UDim2.new(0, 1, 1, -2)
    innerRightBorder.Position = UDim2.new(1, -2, 0, 1)
    innerRightBorder.BackgroundColor3 = Colors.ButtonShadow
    innerRightBorder.BorderSizePixel = 0
    innerRightBorder.Parent = button
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DustysUniversalYield"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end

local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 600, 0, 400)
MainWindow.Position = UDim2.new(1, -620, 1, -420)
MainWindow.BackgroundColor3 = Colors.WindowBackground
MainWindow.BorderSizePixel = 0
MainWindow.ClipsDescendants = true
MainWindow.Parent = ScreenGui

local WindowBorder = Instance.new("Frame")
WindowBorder.Name = "Border"
WindowBorder.Size = UDim2.new(1, 6, 1, 6)
WindowBorder.Position = UDim2.new(0, -3, 0, -3)
WindowBorder.BackgroundColor3 = Colors.WindowBorder
WindowBorder.BorderSizePixel = 0
WindowBorder.ZIndex = MainWindow.ZIndex - 1
WindowBorder.Parent = MainWindow

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Colors.TitleBar
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainWindow

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 88, 238)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(53, 147, 255))
}
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 8, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.SourceSansBold
TitleText.Text = "Dusty's Universal Yield v1.0.0"
TitleText.TextColor3 = Colors.TitleText
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseButton = CreateXPButton(TitleBar, "×", UDim2.new(1, -25, 0, 3), UDim2.new(0, 22, 0, 24), function()
    ScreenGui:Destroy()
end)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 100, 100)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.SourceSansBold

local minimized = false
local originalSize = UDim2.new(0, 600, 0, 400)

local MinimizeButton = CreateXPButton(TitleBar, "−", UDim2.new(1, -50, 0, 3), UDim2.new(0, 22, 0, 24), function()
    minimized = not minimized
    
    if minimized then
        originalSize = MainWindow.Size
        TweenService:Create(MainWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, MainWindow.Size.X.Offset, 0, 30)
        }):Play()
        wait(0.3)
        if TabContainer then TabContainer.Visible = false end
        if ContentFrame then ContentFrame.Visible = false end
    else
        if TabContainer then TabContainer.Visible = true end
        if ContentFrame then ContentFrame.Visible = true end
        TweenService:Create(MainWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = originalSize
        }):Play()
    end
end)
MinimizeButton.TextSize = 18
MinimizeButton.Font = Enum.Font.SourceSansBold

local dragging, dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainWindow.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local resizing = false
local resizeStart, resizeStartSize

local ResizeHandle = Instance.new("Frame")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 15, 0, 15)
ResizeHandle.Position = UDim2.new(1, -15, 1, -15)
ResizeHandle.BackgroundColor3 = Colors.ButtonShadow
ResizeHandle.BorderSizePixel = 0
ResizeHandle.Parent = MainWindow

local ResizeTriangle1 = Instance.new("Frame")
ResizeTriangle1.Size = UDim2.new(0, 10, 0, 2)
ResizeTriangle1.Position = UDim2.new(0, 3, 1, -3)
ResizeTriangle1.BackgroundColor3 = Colors.ButtonHighlight
ResizeTriangle1.BorderSizePixel = 0
ResizeTriangle1.Rotation = 45
ResizeTriangle1.Parent = ResizeHandle

local ResizeTriangle2 = Instance.new("Frame")
ResizeTriangle2.Size = UDim2.new(0, 10, 0, 2)
ResizeTriangle2.Position = UDim2.new(0, 6, 1, -6)
ResizeTriangle2.BackgroundColor3 = Colors.ButtonHighlight
ResizeTriangle2.BorderSizePixel = 0
ResizeTriangle2.Rotation = 45
ResizeTriangle2.Parent = ResizeHandle

ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = input.Position
        resizeStartSize = MainWindow.Size
        
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
        local newWidth = math.max(400, resizeStartSize.X.Offset + delta.X)
        local newHeight = math.max(300, resizeStartSize.Y.Offset + delta.Y)
        MainWindow.Size = UDim2.new(0, newWidth, 0, newHeight)
        originalSize = MainWindow.Size
    end
end)

local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, 0, 0, 28)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Colors.ButtonFace
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainWindow

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -10, 1, -68)
ContentFrame.Position = UDim2.new(0, 5, 0, 63)
ContentFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ContentFrame.BorderColor3 = Colors.ButtonShadow
ContentFrame.BorderSizePixel = 1
ContentFrame.Parent = MainWindow

local Tabs = {}
local CurrentTab = nil

local function CreateTab(name, content)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 100, 1, -2)
    tabButton.Position = UDim2.new(0, #Tabs * 100, 0, 2)
    tabButton.BackgroundColor3 = Colors.UnselectedTab
    tabButton.BorderSizePixel = 0
    tabButton.Font = Enum.Font.SourceSans
    tabButton.Text = name
    tabButton.TextColor3 = Colors.Text
    tabButton.TextSize = 14
    tabButton.Parent = TabContainer
    
    local topBorder = Instance.new("Frame")
    topBorder.Size = UDim2.new(1, 0, 0, 1)
    topBorder.BackgroundColor3 = Colors.ButtonHighlight
    topBorder.BorderSizePixel = 0
    topBorder.Parent = tabButton
    
    local leftBorder = Instance.new("Frame")
    leftBorder.Size = UDim2.new(0, 1, 1, 0)
    leftBorder.BackgroundColor3 = Colors.ButtonHighlight
    leftBorder.BorderSizePixel = 0
    leftBorder.Parent = tabButton
    
    local rightBorder = Instance.new("Frame")
    rightBorder.Size = UDim2.new(0, 1, 1, 0)
    rightBorder.Position = UDim2.new(1, -1, 0, 0)
    rightBorder.BackgroundColor3 = Colors.ButtonShadow
    rightBorder.BorderSizePixel = 0
    rightBorder.Parent = tabButton
    
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Name = name .. "Content"
    contentContainer.Size = UDim2.new(1, 0, 1, 0)
    contentContainer.BackgroundTransparency = 1
    contentContainer.BorderSizePixel = 0
    contentContainer.ScrollBarThickness = 6
    contentContainer.Visible = false
    contentContainer.Parent = ContentFrame
    
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Button.BackgroundColor3 = Colors.UnselectedTab
            tab.Content.Visible = false
        end
        tabButton.BackgroundColor3 = Colors.SelectedTab
        contentContainer.Visible = true
        CurrentTab = contentContainer
    end)
    
    local tab = {
        Button = tabButton,
        Content = contentContainer
    }
    table.insert(Tabs, tab)
    
    return contentContainer
end

local CommandsTab = CreateTab("Commands", nil)

local CommandsScrollContainer = Instance.new("Frame")
CommandsScrollContainer.Size = UDim2.new(1, 0, 1, -35)
CommandsScrollContainer.Position = UDim2.new(0, 0, 0, 0)
CommandsScrollContainer.BackgroundTransparency = 1
CommandsScrollContainer.ClipsDescendants = true
CommandsScrollContainer.Parent = CommandsTab

local CommandsList = Instance.new("Frame")
CommandsList.Size = UDim2.new(1, -10, 1, 0)
CommandsList.Position = UDim2.new(0, 5, 0, 5)
CommandsList.BackgroundTransparency = 1
CommandsList.Parent = CommandsScrollContainer

local CommandsListLayout = Instance.new("UIListLayout")
CommandsListLayout.Padding = UDim.new(0, 2)
CommandsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
CommandsListLayout.Parent = CommandsList

local CommandInput = Instance.new("TextBox")
CommandInput.Size = UDim2.new(1, -10, 0, 25)
CommandInput.Position = UDim2.new(0, 5, 1, -30)
CommandInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CommandInput.BorderColor3 = Colors.ButtonShadow
CommandInput.Font = Enum.Font.SourceSans
CommandInput.PlaceholderText = "Enter command here (prefix: " .. DUY.Prefix .. ")"
CommandInput.Text = ""
CommandInput.TextColor3 = Colors.Text
CommandInput.TextSize = 14
CommandInput.TextXAlignment = Enum.TextXAlignment.Left
CommandInput.ZIndex = 10
CommandInput.Parent = CommandsTab

local ExecutorTab = CreateTab("Executor", nil)

local ScriptBox = Instance.new("TextBox")
ScriptBox.Size = UDim2.new(1, -10, 1, -35)
ScriptBox.Position = UDim2.new(0, 5, 0, 5)
ScriptBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScriptBox.BorderColor3 = Colors.ButtonShadow
ScriptBox.Font = Enum.Font.Code
ScriptBox.MultiLine = true
ScriptBox.ClearTextOnFocus = false
ScriptBox.PlaceholderText = "-- Enter Lua script here"
ScriptBox.Text = ""
ScriptBox.TextColor3 = Colors.Text
ScriptBox.TextSize = 14
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptBox.Parent = ExecutorTab

local ExecuteButton = CreateXPButton(ExecutorTab, "Execute", UDim2.new(0, 5, 1, -27), UDim2.new(0, 80, 0, 23), function()
    local script = ScriptBox.Text
    local success, err = pcall(function()
        loadstring(script)()
    end)
    if not success then
        warn("[DUY] Execution Error:", err)
    end
end)

local ClearButton = CreateXPButton(ExecutorTab, "Clear", UDim2.new(0, 90, 1, -27), UDim2.new(0, 80, 0, 23), function()
    ScriptBox.Text = ""
end)

local PlayerTab = CreateTab("Player", nil)

local PlayerSettings = Instance.new("Frame")
PlayerSettings.Size = UDim2.new(1, -10, 0, 0)
PlayerSettings.BackgroundTransparency = 1
PlayerSettings.Parent = PlayerTab

local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Padding = UDim.new(0, 10)
PlayerLayout.Parent = PlayerSettings

local function CreateSlider(parent, labelText, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.Text = labelText .. ": " .. default
    label.TextColor3 = Colors.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local sliderBack = Instance.new("Frame")
    sliderBack.Size = UDim2.new(1, -20, 0, 20)
    sliderBack.Position = UDim2.new(0, 10, 0, 25)
    sliderBack.BackgroundColor3 = Colors.ButtonFace
    sliderBack.BorderColor3 = Colors.ButtonShadow
    sliderBack.Parent = container
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Colors.TitleBar
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBack
    
    local dragging = false
    
    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local function update()
                local mousePos = input.Position.X
                local sliderPos = sliderBack.AbsolutePosition.X
                local sliderSize = sliderBack.AbsoluteSize.X
                local relative = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
                local value = math.floor(min + (max - min) * relative)
                sliderFill.Size = UDim2.new(relative, 0, 1, 0)
                label.Text = labelText .. ": " .. value
                callback(value)
            end
            update()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local sliderPos = sliderBack.AbsolutePosition.X
            local sliderSize = sliderBack.AbsoluteSize.X
            local relative = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local value = math.floor(min + (max - min) * relative)
            sliderFill.Size = UDim2.new(relative, 0, 1, 0)
            label.Text = labelText .. ": " .. value
            callback(value)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return container
end

CreateSlider(PlayerSettings, "WalkSpeed", 16, 200, 16, function(value)
    DUY.Settings.WalkSpeed = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

CreateSlider(PlayerSettings, "JumpPower", 50, 300, 50, function(value)
    DUY.Settings.JumpPower = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = value
    end
end)

CreateSlider(PlayerSettings, "FOV", 70, 120, 70, function(value)
    DUY.Settings.FOV = value
    Camera.FieldOfView = value
end)

local ESPTab = CreateTab("ESP", nil)

local ESPControls = Instance.new("Frame")
ESPControls.Size = UDim2.new(1, -10, 0, 0)
ESPControls.BackgroundTransparency = 1
ESPControls.Parent = ESPTab

local ESPLayout = Instance.new("UIListLayout")
ESPLayout.Padding = UDim.new(0, 5)
ESPLayout.Parent = ESPControls

local function CreateToggle(parent, labelText, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 30)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local checkbox = CreateXPButton(container, "", UDim2.new(0, 5, 0, 3), UDim2.new(0, 24, 0, 24), nil)
    
    local checkmark = Instance.new("TextLabel")
    checkmark.Size = UDim2.new(1, 0, 1, 0)
    checkmark.BackgroundTransparency = 1
    checkmark.Font = Enum.Font.SourceSansBold
    checkmark.Text = default and "✓" or ""
    checkmark.TextColor3 = Color3.fromRGB(0, 128, 0)
    checkmark.TextSize = 18
    checkmark.Parent = checkbox
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 35, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.Text = labelText
    label.TextColor3 = Colors.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local enabled = default
    
    checkbox.MouseButton1Click:Connect(function()
        enabled = not enabled
        checkmark.Text = enabled and "✓" or ""
        callback(enabled)
    end)
    
    return container
end

CreateToggle(ESPControls, "Player ESP (Boxes)", false, function(enabled)
    DUY.Settings.ESP = enabled
    if enabled then
        DUY:EnableESP()
    else
        DUY:DisableESP()
    end
end)

CreateToggle(ESPControls, "Show Names", false, function(enabled)
    DUY.Settings.ESPNames = enabled
end)

CreateToggle(ESPControls, "Show Distance", false, function(enabled)
    DUY.Settings.ESPDistance = enabled
end)

CreateToggle(ESPControls, "Show Health", false, function(enabled)
    DUY.Settings.ESPHealth = enabled
end)

CreateToggle(ESPControls, "Tracers", false, function(enabled)
    DUY.Settings.Tracers = enabled
end)

local RemoteTab = CreateTab("Remotes", nil)

local RemoteList = Instance.new("ScrollingFrame")
RemoteList.Size = UDim2.new(1, -10, 1, -35)
RemoteList.Position = UDim2.new(0, 5, 0, 5)
RemoteList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RemoteList.BorderColor3 = Colors.ButtonShadow
RemoteList.ScrollBarThickness = 6
RemoteList.Parent = RemoteTab

local RemoteListLayout = Instance.new("UIListLayout")
RemoteListLayout.Padding = UDim.new(0, 2)
RemoteListLayout.Parent = RemoteList

local ClearRemotesButton = CreateXPButton(RemoteTab, "Clear Logs", UDim2.new(0, 5, 1, -27), UDim2.new(0, 100, 0, 23), function()
    for _, child in pairs(RemoteList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end)

local GameScriptsTab = CreateTab("Game Scripts", nil)

local GameScriptsList = Instance.new("Frame")
GameScriptsList.Size = UDim2.new(1, -10, 0, 0)
GameScriptsList.BackgroundTransparency = 1
GameScriptsList.Parent = GameScriptsTab

local GameScriptsLayout = Instance.new("UIListLayout")
GameScriptsLayout.Padding = UDim.new(0, 5)
GameScriptsLayout.Parent = GameScriptsList

function DUY:LoadGameScripts()
    print("[DUY ScriptBlox] Starting to load scripts...")
    
    local gameId = game.PlaceId
    print("[DUY ScriptBlox] Game PlaceId:", gameId)
    
    local gameName = "Unknown"
    pcall(function()
        gameName = game:GetService("MarketplaceService"):GetProductInfo(gameId).Name
        print("[DUY ScriptBlox] Game Name:", gameName)
    end)
    
    local encodedName = gameName:gsub(" ", "%%20"):gsub("[^%w%%]", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    
    print("[DUY ScriptBlox] Attempting to fetch game-specific scripts...")
    local success, response = pcall(function()
        local url = "https://scriptblox.com/api/script/fetch?q=" .. encodedName .. "&max=20"
        print("[DUY ScriptBlox] URL:", url)
        return game:HttpGet(url)
    end)
    
    if success and response then
        print("[DUY ScriptBlox] HTTP request successful!")
        print("[DUY ScriptBlox] Response length:", #response)

        local parseSuccess, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(response)
        end)
        
        if parseSuccess and data then
            print("[DUY ScriptBlox] JSON parsed successfully!")
            
            if data and data.result then
                print("[DUY ScriptBlox] Has result field")
                
                if data.result.scripts then
                    print("[DUY ScriptBlox] Scripts found:", #data.result.scripts)
                    
                    if #data.result.scripts > 0 then
                        for i, scriptData in pairs(data.result.scripts) do
                            print("[DUY ScriptBlox] Creating button for script:", i, scriptData.title or "Untitled")
                            DUY:CreateGameScriptButton(scriptData)
                        end
                        print("[DUY ScriptBlox] Game-specific scripts loaded!")
                        return
                    else
                        print("[DUY ScriptBlox] No scripts in array")
                    end
                else
                    print("[DUY ScriptBlox] No scripts field in result")
                end
            else
                print("[DUY ScriptBlox] No result field in data")
            end
        else
            warn("[DUY ScriptBlox] JSON parse failed:", tostring(data))
        end
    else
        warn("[DUY ScriptBlox] HTTP request failed:", tostring(response))
    end
    
    print("[DUY ScriptBlox] Loading universal scripts as fallback...")
    local success2, response2 = pcall(function()
        local url = "https://scriptblox.com/api/script/fetch?page=1&max=20"
        print("[DUY ScriptBlox] Universal URL:", url)
        return game:HttpGet(url)
    end)
    
    if success2 and response2 then
        print("[DUY ScriptBlox] Universal HTTP request successful!")
        
        local parseSuccess2, data2 = pcall(function()
            return game:GetService("HttpService"):JSONDecode(response2)
        end)
        
        if parseSuccess2 and data2 then
            print("[DUY ScriptBlox] Universal JSON parsed successfully!")
            
            if data2 and data2.result and data2.result.scripts then
                print("[DUY ScriptBlox] Universal scripts found:", #data2.result.scripts)
                
                local infoLabel = Instance.new("TextLabel")
                infoLabel.Size = UDim2.new(1, 0, 0, 30)
                infoLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 200)
                infoLabel.BorderColor3 = Colors.ButtonShadow
                infoLabel.BorderSizePixel = 1
                infoLabel.Font = Enum.Font.SourceSansBold
                infoLabel.Text = "Showing popular universal scripts:"
                infoLabel.TextColor3 = Colors.Text
                infoLabel.TextSize = 12
                infoLabel.TextWrapped = true
                infoLabel.Parent = GameScriptsList
                
                for i, scriptData in pairs(data2.result.scripts) do
                    print("[DUY ScriptBlox] Creating universal script button:", i, scriptData.title or "Untitled")
                    DUY:CreateGameScriptButton(scriptData)
                end
                
                print("[DUY ScriptBlox] Universal scripts loaded!")
            else
                warn("[DUY ScriptBlox] No scripts in universal response")
            end
        else
            warn("[DUY ScriptBlox] Universal JSON parse failed:", tostring(data2))
        end
    else
        warn("[DUY ScriptBlox] Universal HTTP request failed:", tostring(response2))
        
        local errorLabel = Instance.new("TextLabel")
        errorLabel.Size = UDim2.new(1, -20, 0, 50)
        errorLabel.Position = UDim2.new(0, 10, 0, 10)
        errorLabel.BackgroundTransparency = 1
        errorLabel.Font = Enum.Font.SourceSans
        errorLabel.Text = "Failed to load scripts from ScriptBlox.\nCheck console for details."
        errorLabel.TextColor3 = Color3.fromRGB(200, 50, 50)
        errorLabel.TextSize = 14
        errorLabel.TextWrapped = true
        errorLabel.Parent = GameScriptsList
    end
end

function DUY:ShowConfirmationDialog(scriptData)
    local confirmFrame = Instance.new("Frame")
    confirmFrame.Size = UDim2.new(0, 400, 0, 180)
    confirmFrame.Position = UDim2.new(0.5, -200, 0.5, -90)
    confirmFrame.BackgroundColor3 = Colors.WindowBackground
    confirmFrame.BorderSizePixel = 0
    confirmFrame.ZIndex = 100
    confirmFrame.Parent = ScreenGui
    
    local confirmBorder = Instance.new("Frame")
    confirmBorder.Size = UDim2.new(1, 6, 1, 6)
    confirmBorder.Position = UDim2.new(0, -3, 0, -3)
    confirmBorder.BackgroundColor3 = Colors.WindowBorder
    confirmBorder.BorderSizePixel = 0
    confirmBorder.ZIndex = 99
    confirmBorder.Parent = confirmFrame
    
    local confirmTitle = Instance.new("Frame")
    confirmTitle.Size = UDim2.new(1, 0, 0, 30)
    confirmTitle.BackgroundColor3 = Colors.TitleBar
    confirmTitle.BorderSizePixel = 0
    confirmTitle.ZIndex = 100
    confirmTitle.Parent = confirmFrame
    
    local confirmGradient = Instance.new("UIGradient")
    confirmGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 88, 238)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(53, 147, 255))
    }
    confirmGradient.Rotation = 90
    confirmGradient.Parent = confirmTitle
    
    local confirmTitleText = Instance.new("TextLabel")
    confirmTitleText.Size = UDim2.new(1, -10, 1, 0)
    confirmTitleText.Position = UDim2.new(0, 8, 0, 0)
    confirmTitleText.BackgroundTransparency = 1
    confirmTitleText.Font = Enum.Font.SourceSansBold
    confirmTitleText.Text = "⚠ Execute Script?"
    confirmTitleText.TextColor3 = Colors.TitleText
    confirmTitleText.TextSize = 14
    confirmTitleText.TextXAlignment = Enum.TextXAlignment.Left
    confirmTitleText.ZIndex = 101
    confirmTitleText.Parent = confirmTitle
    
    local confirmMessage = Instance.new("TextLabel")
    confirmMessage.Size = UDim2.new(1, -20, 0, 90)
    confirmMessage.Position = UDim2.new(0, 10, 0, 40)
    confirmMessage.BackgroundTransparency = 1
    confirmMessage.Font = Enum.Font.SourceSans
    
    local gameName = scriptData.game and scriptData.game.name or "Universal"
    local scriptOwner = scriptData.owner and scriptData.owner.username or "Unknown"
    
    confirmMessage.Text = "Are you sure you want to execute this script?\n\nTitle: " .. (scriptData.title or "Unknown Script") .. "\nGame: " .. gameName .. "\nBy: " .. scriptOwner .. "\n\nOnly execute scripts from trusted sources!"
    confirmMessage.TextColor3 = Colors.Text
    confirmMessage.TextSize = 13
    confirmMessage.TextWrapped = true
    confirmMessage.TextYAlignment = Enum.TextYAlignment.Top
    confirmMessage.ZIndex = 100
    confirmMessage.Parent = confirmFrame
    
    local yesBtn = CreateXPButton(confirmFrame, "Yes, Execute", UDim2.new(0, 10, 1, -35), UDim2.new(0, 120, 0, 25), function()
        confirmFrame:Destroy()
        
        local scriptUrl = scriptData.script
        if not scriptUrl then
            warn("[DUY] No script URL found")
            return
        end
        
        if scriptUrl:find("scriptblox.com") and not scriptUrl:find("/raw/") then
            if scriptData.slug then
                scriptUrl = "https://rawscripts.net/raw/" .. scriptData.slug
            end
        end
        
        local success, scriptContent = pcall(function()
            return game:HttpGet(scriptUrl)
        end)
        
        if success and scriptContent then
            local execSuccess, execErr = pcall(function()
                loadstring(scriptContent)()
            end)
            
            if execSuccess then
                print("[DUY] Successfully executed:", scriptData.title)
            else
                warn("[DUY] Script execution error:", execErr)
            end
        else
            warn("[DUY] Failed to fetch script content from:", scriptUrl)
        end
    end)
    yesBtn.ZIndex = 100
    yesBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    
    local noBtn = CreateXPButton(confirmFrame, "Cancel", UDim2.new(1, -130, 1, -35), UDim2.new(0, 120, 0, 25), function()
        confirmFrame:Destroy()
    end)
    noBtn.ZIndex = 100
    noBtn.BackgroundColor3 = Color3.fromRGB(220, 100, 100)
end

function DUY:CreateGameScriptButton(scriptData)
    local scriptFrame = Instance.new("Frame")
    scriptFrame.Size = UDim2.new(1, 0, 0, 100)
    scriptFrame.BackgroundColor3 = Colors.ButtonFace
    scriptFrame.BorderColor3 = Colors.ButtonShadow
    scriptFrame.BorderSizePixel = 1
    scriptFrame.Parent = GameScriptsList
    
    local scriptTitle = Instance.new("TextLabel")
    scriptTitle.Size = UDim2.new(1, -95, 0, 25)
    scriptTitle.Position = UDim2.new(0, 5, 0, 5)
    scriptTitle.BackgroundTransparency = 1
    scriptTitle.Font = Enum.Font.SourceSansBold
    scriptTitle.Text = scriptData.title or "Untitled Script"
    scriptTitle.TextColor3 = Colors.Text
    scriptTitle.TextSize = 14
    scriptTitle.TextXAlignment = Enum.TextXAlignment.Left
    scriptTitle.TextTruncate = Enum.TextTruncate.AtEnd
    scriptTitle.Parent = scriptFrame
    
    local scriptGame = Instance.new("TextLabel")
    scriptGame.Size = UDim2.new(1, -95, 0, 20)
    scriptGame.Position = UDim2.new(0, 5, 0, 30)
    scriptGame.BackgroundTransparency = 1
    scriptGame.Font = Enum.Font.SourceSans
    scriptGame.Text = "Game: " .. (scriptData.game and scriptData.game.name or "Universal")
    scriptGame.TextColor3 = Color3.fromRGB(100, 100, 100)
    scriptGame.TextSize = 12
    scriptGame.TextXAlignment = Enum.TextXAlignment.Left
    scriptGame.TextTruncate = Enum.TextTruncate.AtEnd
    scriptGame.Parent = scriptFrame
    
    local scriptViews = Instance.new("TextLabel")
    scriptViews.Size = UDim2.new(1, -95, 0, 15)
    scriptViews.Position = UDim2.new(0, 5, 0, 50)
    scriptViews.BackgroundTransparency = 1
    scriptViews.Font = Enum.Font.SourceSans
    scriptViews.Text = "👁 " .. (scriptData.views or 0) .. " views"
    scriptViews.TextColor3 = Color3.fromRGB(80, 80, 80)
    scriptViews.TextSize = 11
    scriptViews.TextXAlignment = Enum.TextXAlignment.Left
    scriptViews.Parent = scriptFrame
    
    local verified = Instance.new("TextLabel")
    verified.Size = UDim2.new(1, -95, 0, 15)
    verified.Position = UDim2.new(0, 5, 0, 65)
    verified.BackgroundTransparency = 1
    verified.Font = Enum.Font.SourceSans
    
    local isVerified = scriptData.verified == true or scriptData.verified == 1
    local isUniversal = scriptData.isUniversal == true or scriptData.isUniversal == 1
    
    local badges = {}
    if isVerified then
        table.insert(badges, "✓ Verified")
    end
    if isUniversal then
        table.insert(badges, "🌐 Universal")
    end
    if scriptData.key == true or scriptData.key == 1 then
        table.insert(badges, "🔑 Key")
    end
    
    verified.Text = table.concat(badges, " | ")
    verified.TextColor3 = isVerified and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 100, 100)
    verified.TextSize = 10
    verified.TextXAlignment = Enum.TextXAlignment.Left
    verified.Parent = scriptFrame
    
    local ownerLabel = Instance.new("TextLabel")
    ownerLabel.Size = UDim2.new(1, -95, 0, 15)
    ownerLabel.Position = UDim2.new(0, 5, 0, 80)
    ownerLabel.BackgroundTransparency = 1
    ownerLabel.Font = Enum.Font.SourceSansItalic
    ownerLabel.Text = "By: " .. (scriptData.owner and scriptData.owner.username or "Unknown")
    ownerLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
    ownerLabel.TextSize = 10
    ownerLabel.TextXAlignment = Enum.TextXAlignment.Left
    ownerLabel.TextTruncate = Enum.TextTruncate.AtEnd
    ownerLabel.Parent = scriptFrame
    
    local executeBtn = CreateXPButton(scriptFrame, "Execute", UDim2.new(1, -85, 0, 5), UDim2.new(0, 75, 0, 90), function()
        DUY:ShowConfirmationDialog(scriptData)
    end)
    
    GameScriptsList.Size = UDim2.new(1, -10, 0, GameScriptsLayout.AbsoluteContentSize.Y)
    GameScriptsTab.CanvasSize = UDim2.new(1, 0, 0, GameScriptsLayout.AbsoluteContentSize.Y + 10)
end

local SettingsTab = CreateTab("Settings", nil)

local SettingsList = Instance.new("Frame")
SettingsList.Size = UDim2.new(1, -10, 0, 0)
SettingsList.BackgroundTransparency = 1
SettingsList.Parent = SettingsTab

local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Padding = UDim.new(0, 10)
SettingsLayout.Parent = SettingsList

local prefixContainer = Instance.new("Frame")
prefixContainer.Size = UDim2.new(1, 0, 0, 50)
prefixContainer.BackgroundTransparency = 1
prefixContainer.Parent = SettingsList

local prefixLabel = Instance.new("TextLabel")
prefixLabel.Size = UDim2.new(1, 0, 0, 20)
prefixLabel.BackgroundTransparency = 1
prefixLabel.Font = Enum.Font.SourceSans
prefixLabel.Text = "Command Prefix:"
prefixLabel.TextColor3 = Colors.Text
prefixLabel.TextSize = 14
prefixLabel.TextXAlignment = Enum.TextXAlignment.Left
prefixLabel.Parent = prefixContainer

local prefixInput = Instance.new("TextBox")
prefixInput.Size = UDim2.new(0, 50, 0, 25)
prefixInput.Position = UDim2.new(0, 0, 0, 25)
prefixInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
prefixInput.BorderColor3 = Colors.ButtonShadow
prefixInput.Font = Enum.Font.SourceSans
prefixInput.Text = DUY.Prefix
prefixInput.TextColor3 = Colors.Text
prefixInput.TextSize = 14
prefixInput.Parent = prefixContainer

prefixInput.FocusLost:Connect(function()
    if prefixInput.Text ~= "" then
        DUY.Prefix = prefixInput.Text
    end
end)
CreateToggle(SettingsList, "Anti-Kick Protection", true, function(enabled)
    DUY.Settings.AntiKick = enabled
    print("[DUY] Anti-Kick:", enabled and "Enabled" or "Disabled")
end)

CreateToggle(SettingsList, "Anti-Ban Protection", true, function(enabled)
    DUY.Settings.AntiBan = enabled
    print("[DUY] Anti-Ban:", enabled and "Enabled" or "Disabled")
end)


function DUY:AddCommand(name, aliases, description, callback)
    local cmd = {
        Name = name:lower(),
        Aliases = aliases or {},
        Description = description or "No description provided",
        Callback = callback
    }
    table.insert(self.Commands, cmd)
    
    local cmdFrame = Instance.new("Frame")
    cmdFrame.Size = UDim2.new(1, -20, 0, 60)
    cmdFrame.BackgroundColor3 = Colors.ButtonFace
    cmdFrame.BorderColor3 = Colors.ButtonShadow
    cmdFrame.BorderSizePixel = 1
    cmdFrame.Parent = CommandsList
    
    local cmdName = Instance.new("TextLabel")
    cmdName.Size = UDim2.new(1, -10, 0, 20)
    cmdName.Position = UDim2.new(0, 5, 0, 5)
    cmdName.BackgroundTransparency = 1
    cmdName.Font = Enum.Font.SourceSansBold
    cmdName.Text = self.Prefix .. name
    cmdName.TextColor3 = Colors.Text
    cmdName.TextSize = 14
    cmdName.TextXAlignment = Enum.TextXAlignment.Left
    cmdName.Parent = cmdFrame
    
    local cmdDesc = Instance.new("TextLabel")
    cmdDesc.Size = UDim2.new(1, -10, 0, 30)
    cmdDesc.Position = UDim2.new(0, 5, 0, 25)
    cmdDesc.BackgroundTransparency = 1
    cmdDesc.Font = Enum.Font.SourceSans
    cmdDesc.Text = description
    cmdDesc.TextColor3 = Color3.fromRGB(100, 100, 100)
    cmdDesc.TextSize = 12
    cmdDesc.TextXAlignment = Enum.TextXAlignment.Left
    cmdDesc.TextYAlignment = Enum.TextYAlignment.Top
    cmdDesc.TextWrapped = true
    cmdDesc.Parent = cmdFrame
    
    spawn(function()
        wait()
        CommandsList.Size = UDim2.new(1, -10, 0, CommandsListLayout.AbsoluteContentSize.Y)
        CommandsTab.CanvasSize = UDim2.new(1, 0, 0, CommandsListLayout.AbsoluteContentSize.Y + 45)
    end)
end

function DUY:ExecuteCommand(input)
    if not input:sub(1, 1) == self.Prefix then return false end
    
    local args = input:sub(2):split(" ")
    local cmdName = args[1]:lower()
    table.remove(args, 1)
    
    for _, cmd in pairs(self.Commands) do
        if cmd.Name == cmdName then
            local success, err = pcall(function()
                cmd.Callback(args)
            end)
            if not success then
                warn("[DUY] Command Error:", err)
            end
            return true
        end
        for _, alias in pairs(cmd.Aliases) do
            if alias:lower() == cmdName then
                local success, err = pcall(function()
                    cmd.Callback(args)
                end)
                if not success then
                    warn("[DUY] Command Error:", err)
                end
                return true
            end
        end
    end
    
    warn("[DUY] Command not found:", cmdName)
    return false
end

CommandInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = CommandInput.Text
        if text ~= "" then
            print("[DUY] Executing command:", text)
            task.spawn(function()
                DUY:ExecuteCommand(text)
            end)
            CommandInput.Text = ""
        end
    end
end)

function DUY:CreateESP(player)
    if player == LocalPlayer then return end
    
    local ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "ESP_" .. player.Name
    ESPFolder.Parent = CoreGui
    
    self.ESPObjects[player] = ESPFolder
    
    local function createBox()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local hrp = player.Character.HumanoidRootPart
        
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = Color3.fromRGB(255, 0, 0)
        box.Thickness = 2
        box.Transparency = 1
        box.Filled = false
        
        local nameTag = Drawing.new("Text")
        nameTag.Visible = false
        nameTag.Color = Color3.fromRGB(255, 255, 255)
        nameTag.Size = 16
        nameTag.Center = true
        nameTag.Outline = true
        nameTag.Text = player.Name
        
        local distanceTag = Drawing.new("Text")
        distanceTag.Visible = false
        distanceTag.Color = Color3.fromRGB(255, 255, 255)
        distanceTag.Size = 14
        distanceTag.Center = true
        distanceTag.Outline = true
        
        local healthBarOutline = Drawing.new("Square")
        healthBarOutline.Visible = false
        healthBarOutline.Color = Color3.fromRGB(0, 0, 0)
        healthBarOutline.Thickness = 1
        healthBarOutline.Transparency = 1
        healthBarOutline.Filled = false
        
        local healthBarFill = Drawing.new("Square")
        healthBarFill.Visible = false
        healthBarFill.Color = Color3.fromRGB(0, 255, 0)
        healthBarFill.Thickness = 1
        healthBarFill.Transparency = 0.5
        healthBarFill.Filled = true
        
        local tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Color = Color3.fromRGB(255, 0, 0)
        tracer.Thickness = 1
        tracer.Transparency = 0.7
        
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChild("Humanoid") or not DUY.Settings.ESP then
                box.Visible = false
                nameTag.Visible = false
                distanceTag.Visible = false
                healthBarOutline.Visible = false
                healthBarFill.Visible = false
                tracer.Visible = false
                if not player.Character then
                    connection:Disconnect()
                end
                return
            end
            
            local hrp = player.Character.HumanoidRootPart
            local humanoid = player.Character.Humanoid
            local head = player.Character:FindFirstChild("Head")
            
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2
                
                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(vector.X - width / 2, vector.Y - height / 2)
                box.Visible = true
                
                if DUY.Settings.ESPNames then
                    nameTag.Position = Vector2.new(vector.X, headPos.Y - 20)
                    nameTag.Visible = true
                else
                    nameTag.Visible = false
                end
                
                if DUY.Settings.ESPDistance then
                    local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                    distanceTag.Text = distance .. " studs"
                    distanceTag.Position = Vector2.new(vector.X, legPos.Y + 5)
                    distanceTag.Visible = true
                else
                    distanceTag.Visible = false
                end
                
                if DUY.Settings.ESPHealth then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    healthBarOutline.Size = Vector2.new(4, height)
                    healthBarOutline.Position = Vector2.new(box.Position.X - 8, box.Position.Y)
                    healthBarOutline.Visible = true
                    
                    healthBarFill.Size = Vector2.new(2, height * healthPercent)
                    healthBarFill.Position = Vector2.new(box.Position.X - 7, box.Position.Y + height * (1 - healthPercent))
                    healthBarFill.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                    healthBarFill.Visible = true
                else
                    healthBarOutline.Visible = false
                    healthBarFill.Visible = false
                end
                
                if DUY.Settings.Tracers then
                    tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    tracer.To = Vector2.new(vector.X, vector.Y)
                    tracer.Visible = true
                else
                    tracer.Visible = false
                end
            else
                box.Visible = false
                nameTag.Visible = false
                distanceTag.Visible = false
                healthBarOutline.Visible = false
                healthBarFill.Visible = false
                tracer.Visible = false
            end
        end)
        
        player.CharacterRemoving:Connect(function()
            connection:Disconnect()
            box:Remove()
            nameTag:Remove()
            distanceTag:Remove()
            healthBarOutline:Remove()
            healthBarFill:Remove()
            tracer:Remove()
        end)
    end
    
    if player.Character then
        createBox()
    end
    
    player.CharacterAdded:Connect(function()
        wait(0.1)
        createBox()
    end)
end

function DUY:EnableESP()
    for _, player in pairs(Players:GetPlayers()) do
        if not self.ESPObjects[player] then
            self:CreateESP(player)
        end
    end
end

function DUY:DisableESP()
    for player, folder in pairs(self.ESPObjects) do
        if folder then
            folder:Destroy()
        end
    end
    self.ESPObjects = {}
end

pcall(function()
    local PlayersService = game:GetService("Players")
    
    PlayersService.PlayerAdded:Connect(function(player)
        if DUY.Settings.ESP then
            DUY:CreateESP(player)
        end
    end)
    
    PlayersService.PlayerRemoving:Connect(function(player)
        if DUY.ESPObjects[player] then
            pcall(function()
                DUY.ESPObjects[player]:Destroy()
            end)
            DUY.ESPObjects[player] = nil
        end
    end)
end)

local RemoteLogs = {}
DUY.Settings.RemoteSpy = true
DUY.Settings.AntiKick = true
DUY.Settings.AntiBan = true

local function LogRemote(remote, method, args)
    if not DUY.Settings.RemoteSpy then return end
    if not remote or not remote.Name then return end
    
    spawn(function()
        pcall(function()
            print("[DUY RemoteSpy] Caught:", remote.Name, method)
            
            local log = {
                Remote = remote,
                Method = method,
                Args = args,
                Time = os.date("%H:%M:%S")
            }
            table.insert(RemoteLogs, log)
            
            local logFrame = Instance.new("Frame")
            logFrame.Size = UDim2.new(1, -10, 0, 80)
            logFrame.BackgroundColor3 = Colors.ButtonFace
            logFrame.BorderColor3 = Colors.ButtonShadow
            logFrame.BorderSizePixel = 1
            logFrame.Parent = RemoteList
            
            local remoteName = Instance.new("TextLabel")
            remoteName.Size = UDim2.new(1, -10, 0, 20)
            remoteName.Position = UDim2.new(0, 5, 0, 5)
            remoteName.BackgroundTransparency = 1
            remoteName.Font = Enum.Font.SourceSansBold
            remoteName.Text = remote.Name .. " (" .. method .. ")"
            remoteName.TextColor3 = Colors.Text
            remoteName.TextSize = 13
            remoteName.TextXAlignment = Enum.TextXAlignment.Left
            remoteName.Parent = logFrame
            
            local timeLabel = Instance.new("TextLabel")
            timeLabel.Size = UDim2.new(1, -10, 0, 15)
            timeLabel.Position = UDim2.new(0, 5, 0, 25)
            timeLabel.BackgroundTransparency = 1
            timeLabel.Font = Enum.Font.SourceSans
            timeLabel.Text = "Time: " .. log.Time
            timeLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
            timeLabel.TextSize = 11
            timeLabel.TextXAlignment = Enum.TextXAlignment.Left
            timeLabel.Parent = logFrame
            
            local pathLabel = Instance.new("TextLabel")
            pathLabel.Size = UDim2.new(1, -10, 0, 35)
            pathLabel.Position = UDim2.new(0, 5, 0, 40)
            pathLabel.BackgroundTransparency = 1
            pathLabel.Font = Enum.Font.SourceSans
            pathLabel.Text = "Path: " .. remote:GetFullName()
            pathLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
            pathLabel.TextSize = 10
            pathLabel.TextXAlignment = Enum.TextXAlignment.Left
            pathLabel.TextYAlignment = Enum.TextYAlignment.Top
            pathLabel.TextWrapped = true
            pathLabel.Parent = logFrame
            
            task.wait()
            RemoteList.CanvasSize = UDim2.new(1, 0, 0, RemoteListLayout.AbsoluteContentSize.Y)
        end)
    end)
end

if LocalPlayer then
    LocalPlayer.Idled:Connect(function()
        if DUY.Settings.AntiKick then
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

if hookmetamethod then
    pcall(function()
        local oldmt
        oldmt = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if DUY.Settings.AntiKick and method == "Kick" then
                warn("[DUY] Blocked kick attempt!")
                return
            end
            
            if DUY.Settings.AntiBan and (method == "FireServer" or method == "InvokeServer") then
                if self and self.Name then
                    local remoteName = self.Name:lower()
                    if remoteName:find("ban") or remoteName:find("anticheat") or remoteName:find("detection") then
                        warn("[DUY] Blocked potential ban remote:", self.Name)
                        return
                    end
                end
            end
            
            if method == "FireServer" or method == "InvokeServer" then
                spawn(function()
                    pcall(function()
                        LogRemote(self, method, args)
                    end)
                end)
            end
            
            return oldmt(self, ...)
        end)
        print("[DUY] Unified protection system enabled!")
        print("[DUY] Anti-Kick: Enabled")
        print("[DUY] Anti-Ban: Enabled")
        print("[DUY] Remote Spy: Enabled")
    end)
else
    warn("[DUY] Protection features not available (hookmetamethod not found)")
end

local FEBypass = {}

function FEBypass:ToolToCharacter(tool)
    if not tool:IsA("Tool") then return end
    
    tool.Parent = LocalPlayer.Character
    tool.Grip = CFrame.new(0, 0, 0)
    tool.GripForward = Vector3.new(0, 0, -1)
    tool.GripRight = Vector3.new(1, 0, 0)
    tool.GripUp = Vector3.new(0, 1, 0)
end

function FEBypass:CreateFakeCharacter()
    local fakeChar = LocalPlayer.Character:Clone()
    fakeChar.Parent = Workspace
    fakeChar.Name = "FakeCharacter"
    
    for _, part in pairs(fakeChar:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Transparency = 0.5
        end
    end
    
    return fakeChar
end

function FEBypass:ReplicatePosition(target)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target
    end
end

DUY:AddCommand("fly", {"f"}, "Toggle flight mode with WASD controls", function(args)
    local speed = tonumber(args[1]) or 50
    
    if DUY.Settings.Fly then
        DUY.Settings.Fly = false
        if DUY.Connections.Fly then
            DUY.Connections.Fly:Disconnect()
        end
        if DUY.FlyBodyVelocity then
            DUY.FlyBodyVelocity:Destroy()
        end
        if DUY.FlyBodyGyro then
            DUY.FlyBodyGyro:Destroy()
        end
        return
    end
    
    DUY.Settings.Fly = true
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(100000, 100000, 100000)
    bodyVel.Velocity = Vector3.new(0, 0, 0)
    bodyVel.Parent = rootPart
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    DUY.FlyBodyVelocity = bodyVel
    DUY.FlyBodyGyro = bodyGyro
    
    DUY.Connections.Fly = RunService.RenderStepped:Connect(function()
        if not DUY.Settings.Fly or not character or not rootPart then return end
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + (Camera.CFrame.LookVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - (Camera.CFrame.LookVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - (Camera.CFrame.RightVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + (Camera.CFrame.RightVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        bodyVel.Velocity = moveDirection * speed
        bodyGyro.CFrame = Camera.CFrame
    end)
end)

DUY:AddCommand("noclip", {"nc"}, "Toggle noclip mode", function(args)
    DUY.Settings.Noclip = not DUY.Settings.Noclip
    
    if DUY.Settings.Noclip then
        DUY.Connections.Noclip = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if DUY.Connections.Noclip then
            DUY.Connections.Noclip:Disconnect()
        end
    end
end)

DUY:AddCommand("tp", {"teleport"}, "Teleport to a player (username or display name)", function(args)
    if not args[1] then return end
    
    local targetName = args[1]:lower()
    local targetPlayer = nil
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(targetName) or player.DisplayName:lower():find(targetName) then
            targetPlayer = player
            break
        end
    end
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)

DUY:AddCommand("god", {}, "Toggle god mode (infinite health)", function(args)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        
        if humanoid.MaxHealth == math.huge then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        else
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end
end)

DUY:AddCommand("infjump", {"ij"}, "Toggle infinite jump", function(args)
    DUY.Settings.InfiniteJump = not DUY.Settings.InfiniteJump
    
    if DUY.Settings.InfiniteJump then
        DUY.Connections.InfiniteJump = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if DUY.Connections.InfiniteJump then
            DUY.Connections.InfiniteJump:Disconnect()
        end
    end
end)

DUY:AddCommand("ws", {"walkspeed"}, "Set walkspeed (number)", function(args)
    local speed = tonumber(args[1]) or 16
    DUY.Settings.WalkSpeed = speed
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end)

DUY:AddCommand("jp", {"jumppower"}, "Set jump power (number)", function(args)
    local power = tonumber(args[1]) or 50
    DUY.Settings.JumpPower = power
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = power
    end
end)

DUY:AddCommand("fov", {}, "Set field of view (number between 1-120)", function(args)
    local fov = tonumber(args[1]) or 70
    fov = math.clamp(fov, 1, 120)
    DUY.Settings.FOV = fov
    Camera.FieldOfView = fov
end)

DUY:AddCommand("esp", {}, "Toggle ESP (boxes around players)", function(args)
    DUY.Settings.ESP = not DUY.Settings.ESP
    
    if DUY.Settings.ESP then
        DUY:EnableESP()
    else
        DUY:DisableESP()
    end
end)

DUY:AddCommand("fullbright", {"fb"}, "Toggle fullbright (maximum brightness)", function(args)
    if Lighting.Ambient == Color3.fromRGB(255, 255, 255) then
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
        Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    else
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
        Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
    end
end)

DUY:AddCommand("goto", {"to"}, "Teleport to coordinates (x, y, z)", function(args)
    local x = tonumber(args[1])
    local y = tonumber(args[2])
    local z = tonumber(args[3])
    
    if x and y and z and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
    end
end)

DUY:AddCommand("btools", {}, "Gives you building tools (FE limited)", function(args)
    local tools = {
        Instance.new("HopperBin"),
        Instance.new("HopperBin"),
        Instance.new("HopperBin")
    }
    
    tools[1].BinType = "GameTool"
    tools[2].BinType = "Clone"
    tools[3].BinType = "Hammer"
    
    for _, tool in pairs(tools) do
        tool.Parent = LocalPlayer.Backpack
    end
end)

DUY:AddCommand("sit", {}, "Makes your character sit", function(args)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.Sit = true
    end
end)

DUY:AddCommand("swim", {}, "Toggle swim mode in air", function(args)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
        humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
    end
end)

DUY:AddCommand("removetools", {"rtools"}, "Remove all tools from your character", function(args)
    for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") then
            tool:Destroy()
        end
    end
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        tool:Destroy()
    end
end)

DUY:AddCommand("reset", {"re"}, "Reset your character", function(args)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = 0
    end
end)

DUY:AddCommand("respawn", {}, "Respawn your character (better than reset)", function(args)
    local oldPos = nil
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
    
    LocalPlayer.Character:BreakJoints()
    
    LocalPlayer.CharacterAdded:Wait()
    wait(0.1)
    
    if oldPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
    end
end)

DUY:AddCommand("freeze", {"fr"}, "Freeze your character in place", function(args)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Anchored = not hrp.Anchored
    end
end)

DUY:AddCommand("invisible", {"invis"}, "Make yourself invisible (FE method)", function(args)
    if not LocalPlayer.Character then return end
    
    LocalPlayer.Character.Archivable = true
    local clone = LocalPlayer.Character:Clone()
    clone.Parent = Workspace
    clone.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    
    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = 1
        end
        if part:IsA("Accessory") then
            part:Destroy()
        end
    end
    
    wait(0.1)
    clone:Destroy()
end)

DUY:AddCommand("visible", {"vis"}, "Make yourself visible again", function(args)
    if not LocalPlayer.Character then return end
    
    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = 0
        end
    end
end)

DUY:AddCommand("bring", {}, "Bring a player to you (FE limited, visual only)", function(args)
    if not args[1] then return end
    
    local targetName = args[1]:lower()
    local targetPlayer = nil
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(targetName) or player.DisplayName:lower():find(targetName) then
            targetPlayer = player
            break
        end
    end
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            targetPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)

DUY:AddCommand("spamchat", {"spam"}, "Spam a message in chat (message, times)", function(args)
    if #args < 2 then return end
    
    local times = tonumber(args[#args]) or 5
    table.remove(args, #args)
    local message = table.concat(args, " ")
    
    for i = 1, times do
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
        wait(0.5)
    end
end)

DUY:AddCommand("clearws", {"clearworkspace"}, "Clear the workspace (client-side)", function(args)
    for _, obj in pairs(Workspace:GetChildren()) do
        if not obj:IsA("Terrain") and not obj:IsA("Camera") and not Players:GetPlayerFromCharacter(obj) then
            obj:Destroy()
        end
    end
end)

DUY:AddCommand("fogoff", {"nofog"}, "Remove fog", function(args)
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
end)

DUY:AddCommand("day", {}, "Set time to day", function(args)
    Lighting.ClockTime = 14
end)

DUY:AddCommand("night", {}, "Set time to night", function(args)
    Lighting.ClockTime = 0
end)

DUY:AddCommand("freecam", {"fc"}, "Toggle free camera", function(args)
    if DUY.Settings.Freecam then
        DUY.Settings.Freecam = false
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
        return
    end
    
    DUY.Settings.Freecam = true
    Camera.CameraType = Enum.CameraType.Fixed
    
    local speed = 50
    
    RunService.RenderStepped:Connect(function()
        if not DUY.Settings.Freecam then return end
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + (Camera.CFrame.LookVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - (Camera.CFrame.LookVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - (Camera.CFrame.RightVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + (Camera.CFrame.RightVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        Camera.CFrame = Camera.CFrame + (moveDirection * speed * 0.016)
    end)
end)

DUY:AddCommand("killgui", {"destroygui", "removegui"}, "Destroys the Dusty's Universal Yield GUI", function(args)
    ScreenGui:Destroy()
end)

DUY:AddCommand("remotespy", {"rspy"}, "Toggle remote spy", function(args)
    DUY.Settings.RemoteSpy = not DUY.Settings.RemoteSpy
end)

DUY:AddCommand("clicktp", {"ctp"}, "Toggle click to teleport (hold CTRL and click)", function(args)
    DUY.Settings.ClickTP = not DUY.Settings.ClickTP
    
    if DUY.Settings.ClickTP then
        DUY.Connections.ClickTP = Mouse.Button1Down:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position)
                end
            end
        end)
    else
        if DUY.Connections.ClickTP then
            DUY.Connections.ClickTP:Disconnect()
        end
    end
end)
DUY:AddCommand("antikick", {"ak"}, "Toggle anti-kick protection", function(args)
    DUY.Settings.AntiKick = not DUY.Settings.AntiKick
    print("[DUY] Anti-Kick:", DUY.Settings.AntiKick and "Enabled" or "Disabled")
end)

DUY:AddCommand("antiban", {"ab"}, "Toggle anti-ban protection", function(args)
    DUY.Settings.AntiBan = not DUY.Settings.AntiBan
    print("[DUY] Anti-Ban:", DUY.Settings.AntiBan and "Enabled" or "Disabled")
end)

if #Tabs > 0 then
    for _, tab in pairs(Tabs) do
        tab.Button.BackgroundColor3 = Colors.UnselectedTab
        tab.Content.Visible = false
    end
    Tabs[1].Button.BackgroundColor3 = Colors.SelectedTab
    Tabs[1].Content.Visible = true
    CurrentTab = Tabs[1].Content
end

local NotificationFrame = Instance.new("Frame")
NotificationFrame.Size = UDim2.new(0, 300, 0, 60)
NotificationFrame.Position = UDim2.new(0.5, -150, 0, -70)
NotificationFrame.BackgroundColor3 = Colors.WindowBackground
NotificationFrame.BorderSizePixel = 0
NotificationFrame.Parent = ScreenGui

local NotificationBorder = Instance.new("Frame")
NotificationBorder.Size = UDim2.new(1, 4, 1, 4)
NotificationBorder.Position = UDim2.new(0, -2, 0, -2)
NotificationBorder.BackgroundColor3 = Colors.WindowBorder
NotificationBorder.BorderSizePixel = 0
NotificationBorder.ZIndex = NotificationFrame.ZIndex - 1
NotificationBorder.Parent = NotificationFrame

local NotificationText = Instance.new("TextLabel")
NotificationText.Size = UDim2.new(1, -10, 1, -10)
NotificationText.Position = UDim2.new(0, 5, 0, 5)
NotificationText.BackgroundTransparency = 1
NotificationText.Font = Enum.Font.SourceSansBold
NotificationText.Text = "Dusty's Universal Yield loaded!"
NotificationText.TextColor3 = Colors.Text
NotificationText.TextSize = 16
NotificationText.TextWrapped = true
NotificationText.Parent = NotificationFrame

TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -150, 0, 20)
}):Play()

wait(3)

TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
    Position = UDim2.new(0.5, -150, 0, -70)
}):Play()

print("[DUY] Dusty's Universal Yield v1.0.0 loaded successfully!")
spawn(function()
    wait(2)
    print("[DUY] Loading game scripts from ScriptBlox...")
    DUY:LoadGameScripts()
end)
print("[DUY] Prefix: " .. DUY.Prefix)
print("[DUY] Commands loaded: " .. #DUY.Commands)
print("[DUY] Type '" .. DUY.Prefix .. "help' for a list of commands (coming soon!)")
