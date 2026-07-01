-- Made by seraph
-- FLUYEN HUB v7 - Hiệu ứng mở/đóng menu siêu đẹp (scale + fade + glow pulse)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")

-- ===== CẤU HÌNH KEY =====
local ADMIN_KEY = "huyandkhang"
local FREE_KEY = "free1"
local IsAdmin = false
local IsLoggedIn = false

-- ===== TRẠNG THÁI =====
local States = {
    ESP = { Enabled = false, Box = false, Name = false, Health = false, Distance = false, Tracers = false, Chams = false },
    Aim = { Enabled = false, Silent = false, FOV = 180, Prediction = false, TriggerBot = false, HitboxExpander = false },
    Movement = { Speed = false, SpeedValue = 85, Fly = false, FlySpeed = 70, Noclip = false, JumpPower = false, JumpPowerValue = 50, InfiniteJump = false, Sprint = false, SprintValue = 120, AntiVoid = false },
    Utility = { AntiAFK = false, FreezeTime = false, FPSBooster = false },
    Server = { Rejoin = false, ServerHop = false, JoinSmall = false, Spectate = false, SpectateTarget = nil },
    Fun = { Spin = false, Float = false, Bang = false, Fling = false, Orbit = false, OrbitTarget = nil, Invisible = false },
    Settings = { Theme = "Dark", Language = "English", Save = false, AutoLoad = false, Minimize = false, Draggable = true, Notifications = true }
}

-- ===== HÀM NOTIFY =====
local function Notify(text)
    if not States.Settings.Notifications then return end
    local gui = Instance.new("ScreenGui")
    gui.Name = "Notify"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer.PlayerGui
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 50)
    frame.Position = UDim2.new(0.5, -150, 0.8, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    frame.Parent = gui
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.Parent = frame
    TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0.75, 0)}):Play()
    task.wait(2)
    TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0.85, 0)}):Play()
    task.wait(0.3)
    gui:Destroy()
end

-- ===== TẠO GUI KEY =====
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "KeyEntry"
KeyGui.ResetOnSpawn = false
KeyGui.Parent = LocalPlayer.PlayerGui

local ScreenSize = GuiService:GetViewportSize()
local ScaleX = ScreenSize.X / 1920
local ScaleY = ScreenSize.Y / 1080
local UIScale = math.min(ScaleX, ScaleY) * 0.9

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 500 * UIScale, 0, 300 * UIScale)
KeyFrame.Position = UDim2.new(0.5, -250 * UIScale, 0.5, -150 * UIScale)
KeyFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = KeyGui
local kfCorner = Instance.new("UICorner")
kfCorner.CornerRadius = UDim.new(0, 24)
kfCorner.Parent = KeyFrame

local KeyGlow = Instance.new("Frame")
KeyGlow.Size = KeyFrame.Size + UDim2.new(0, 10, 0, 10)
KeyGlow.Position = KeyFrame.Position - UDim2.new(0, 5, 0, 5)
KeyGlow.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
KeyGlow.BackgroundTransparency = 0.4
KeyGlow.BorderSizePixel = 0
KeyGlow.Parent = KeyGui
local kgCorner = Instance.new("UICorner")
kgCorner.CornerRadius = UDim.new(0, 28)
kgCorner.Parent = KeyGlow
task.spawn(function()
    while KeyGui and KeyGui.Parent do
        local hue = (tick() * 0.1) % 1
        KeyGlow.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 0.9)
        task.wait(0.02)
    end
end)
RunService.RenderStepped:Connect(function()
    if KeyGui and KeyGui.Parent then
        KeyGlow.Size = KeyFrame.Size + UDim2.new(0, 10, 0, 10)
        KeyGlow.Position = KeyFrame.Position - UDim2.new(0, 5, 0, 5)
    end
end)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "FLUYEN HUB"
TitleLabel.Size = UDim2.new(1, 0, 0, 70 * UIScale)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 32 * UIScale
TitleLabel.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.PlaceholderText = "NHẬP KEY..."
KeyInput.Size = UDim2.new(0.8, 0, 0, 60 * UIScale)
KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.Font = Enum.Font.GothamBold
KeyInput.TextSize = 24 * UIScale
KeyInput.Parent = KeyFrame
local kiCorner = Instance.new("UICorner")
kiCorner.CornerRadius = UDim.new(0, 12)
kiCorner.Parent = KeyInput

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Text = "✔️ XÁC NHẬN"
SubmitBtn.Size = UDim2.new(0.8, 0, 0, 60 * UIScale)
SubmitBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
SubmitBtn.TextColor3 = Color3.new(1, 1, 1)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 24 * UIScale
SubmitBtn.BorderSizePixel = 0
SubmitBtn.Parent = KeyFrame
local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 12)
sbCorner.Parent = SubmitBtn

SubmitBtn.MouseButton1Click:Connect(function()
    local key = KeyInput.Text
    if key == ADMIN_KEY or key == FREE_KEY then
        IsAdmin = (key == ADMIN_KEY)
        IsLoggedIn = true
        KeyGui:Destroy()
        Notify("✅ Đăng nhập thành công!")
        CreateMainMenu()
    else
        KeyInput.Text = "SAI KEY!"
        KeyInput.TextColor3 = Color3.fromRGB(255, 50, 50)
        task.wait(1)
        KeyInput.Text = ""
        KeyInput.TextColor3 = Color3.new(1, 1, 1)
    end
end)

-- ===== CÁC HÀM TẠO UI =====
local function CreateToggle(parent, text, stateRef, stateKey, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 45 + 10)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.02, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Text = stateRef[stateKey] and "ON" or "OFF"
    toggle.Size = UDim2.new(0, 60, 0, 28)
    toggle.Position = UDim2.new(0.85, -30, 0.15, 0)
    toggle.BackgroundColor3 = stateRef[stateKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
    toggle.BackgroundTransparency = 0.1
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 14
    toggle.BorderSizePixel = 0
    toggle.Parent = frame
    local tcorner = Instance.new("UICorner")
    tcorner.CornerRadius = UDim.new(0, 6)
    tcorner.Parent = toggle

    toggle.MouseButton1Click:Connect(function()
        stateRef[stateKey] = not stateRef[stateKey]
        toggle.Text = stateRef[stateKey] and "ON" or "OFF"
        toggle.BackgroundColor3 = stateRef[stateKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
        if callback then callback(stateRef[stateKey]) end
        Notify(text .. " " .. (stateRef[stateKey] and "BẬT" or "TẮT"))
    end)
    return frame
end

local function CreateSlider(parent, text, stateRef, stateKey, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 45 + 10)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Text = text .. " (" .. tostring(stateRef[stateKey] or default) .. ")"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.02, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.3, 0, 0, 8)
    slider.Position = UDim2.new(0.7, 0, 0.4, 0)
    slider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    local scorner = Instance.new("UICorner")
    scorner.CornerRadius = UDim.new(0, 4)
    scorner.Parent = slider

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((stateRef[stateKey] or default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    fill.BackgroundTransparency = 0.1
    fill.BorderSizePixel = 0
    fill.Parent = slider
    local fcorner = Instance.new("UICorner")
    fcorner.CornerRadius = UDim.new(0, 4)
    fcorner.Parent = fill

    local function updateSlider(val)
        val = math.clamp(val, min, max)
        stateRef[stateKey] = val
        label.Text = text .. " (" .. tostring(val) .. ")"
        fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
        if callback then callback(val) end
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local val = min + (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X * (max - min)
            updateSlider(val)
        end
    end)
    slider.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            local val = min + (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X * (max - min)
            updateSlider(val)
        end
    end)
    return frame
end

-- ===== MENU CHÍNH =====
local MainGui = nil
local MainFrame = nil
local GlowFrame = nil
local TabFrames = {}
local TabButtons = {}
local MenuVisible = false
local isAnimating = false

function CreateMainMenu()
    MainGui = Instance.new("ScreenGui")
    MainGui.Name = "FluyenHub"
    MainGui.ResetOnSpawn = false
    MainGui.Parent = LocalPlayer.PlayerGui

    local viewport = GuiService:GetViewportSize()
    local menuWidth = math.min(viewport.X * 0.85, 900)
    local menuHeight = math.min(viewport.Y * 0.8, 650)

    MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, menuWidth, 0, menuHeight)
    MainFrame.Position = UDim2.new(0.5, -menuWidth/2, 0.05, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    MainFrame.BackgroundTransparency = 0.3
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.Parent = MainGui
    -- Scale ban đầu nhỏ (để hiệu ứng mở)
    MainFrame.Scale = 0.8
    MainFrame.BackgroundTransparency = 0.8
    local mfCorner = Instance.new("UICorner")
    mfCorner.CornerRadius = UDim.new(0, 20)
    mfCorner.Parent = MainFrame

    GlowFrame = Instance.new("Frame")
    GlowFrame.Size = MainFrame.Size + UDim2.new(0, 12, 0, 12)
    GlowFrame.Position = MainFrame.Position - UDim2.new(0, 6, 0, 6)
    GlowFrame.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    GlowFrame.BackgroundTransparency = 0.8
    GlowFrame.BorderSizePixel = 0
    GlowFrame.Visible = false
    GlowFrame.Parent = MainGui
    GlowFrame.Scale = 0.8
    local gfCorner = Instance.new("UICorner")
    gfCorner.CornerRadius = UDim.new(0, 24)
    gfCorner.Parent = GlowFrame

    RunService.RenderStepped:Connect(function()
        if MainFrame and MainFrame.Parent then
            GlowFrame.Size = MainFrame.Size + UDim2.new(0, 12, 0, 12)
            GlowFrame.Position = MainFrame.Position - UDim2.new(0, 6, 0, 6)
        end
    end)

    -- Luồng màu glow
    task.spawn(function()
        while MainGui and MainGui.Parent do
            local hue = (tick() * 0.08) % 1
            GlowFrame.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 0.9)
            task.wait(0.02)
        end
    end)

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 55)
    TopBar.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    TopBar.BackgroundTransparency = 0.2
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 20)
    tbCorner.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Text = "FLUYEN HUB"
    Title.Size = UDim2.new(0.4, 0, 1, 0)
    Title.Position = UDim2.new(0.02, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 24
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Text = "v7.0"
    VersionLabel.Size = UDim2.new(0.2, 0, 1, 0)
    VersionLabel.Position = UDim2.new(0.35, 0, 0, 0)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    VersionLabel.Font = Enum.Font.Gotham
    VersionLabel.TextSize = 16
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text = "✕"
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -50, 0.5, -20)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.BackgroundTransparency = 0.2
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 24
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = TopBar
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 12)
    cCorner.Parent = CloseBtn
    CloseBtn.MouseButton1Click:Connect(function()
        ToggleMenu(false)
    end)

    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 45)
    TabBar.Position = UDim2.new(0, 0, 0, 55)
    TabBar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    TabBar.BackgroundTransparency = 0.4
    TabBar.BorderSizePixel = 0
    TabBar.Parent = MainFrame

    local tabNames = {"🏠 Home", "👁️ Visual", "🎯 Combat", "🏃 Movement", "🛡️ Utility", "🌐 Server", "😂 Fun", "⚙️ Settings"}
    local tabWidth = 1 / #tabNames
    TabButtons = {}
    TabFrames = {}

    for i, name in ipairs(tabNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(tabWidth, 0, 1, 0)
        btn.Position = UDim2.new((i-1)*tabWidth, 0, 0, 0)
        btn.Text = name
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.BackgroundTransparency = 0.3
        btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.Parent = TabBar
        TabButtons[i] = btn

        local frame = Instance.new("ScrollingFrame")
        frame.Size = UDim2.new(1, 0, 1, -55 - 45)
        frame.Position = UDim2.new(0, 0, 0, 55 + 45)
        frame.BackgroundColor3 = Color3.fromRGB(13, 13, 20)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Visible = (i == 1)
        frame.CanvasSize = UDim2.new(0, 0, 0, 0)
        frame.ScrollBarThickness = 6
        frame.Parent = MainFrame
        TabFrames[i] = frame

        btn.MouseButton1Click:Connect(function()
            for j, f in ipairs(TabFrames) do
                f.Visible = (j == i)
            end
            for j, b in ipairs(TabButtons) do
                if j == i then
                    b.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
                    b.BackgroundTransparency = 0.2
                    b.TextColor3 = Color3.new(1, 1, 1)
                else
                    b.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                    b.BackgroundTransparency = 0.3
                    b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
                end
            end
        end)
    end

    -- === XÂY DỰNG CÁC TAB ===
    -- Tab1: Home
    local homeFrame = TabFrames[1]
    local homeY = 10
    local function AddHomeLabel(text, y)
        local label = Instance.new("TextLabel")
        label.Text = text
        label.Size = UDim2.new(1, -20, 0, 30)
        label.Position = UDim2.new(0, 10, 0, y)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 20
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = homeFrame
        return label
    end
    AddHomeLabel("🖥️ FLUYEN HUB", homeY)
    homeY = homeY + 35
    AddHomeLabel("Phiên bản: v7.0", homeY)
    homeY = homeY + 30
    AddHomeLabel("Người dùng: " .. LocalPlayer.Name, homeY)
    homeY = homeY + 30
    AddHomeLabel("Executor: Synapse X", homeY)
    homeY = homeY + 30
    AddHomeLabel("Tác giả: seraph", homeY)
    homeY = homeY + 30
    AddHomeLabel("📜 Changelog: Hiệu ứng mở/đóng siêu đẹp", homeY)
    homeY = homeY + 30
    homeFrame.CanvasSize = UDim2.new(0, 0, 0, homeY + 20)

    -- Tab2: Visual
    local visualFrame = TabFrames[2]
    local visY = 10
    CreateToggle(visualFrame, "ESP", States.ESP, "Enabled")
    visY = visY + 45
    CreateToggle(visualFrame, "Box ESP", States.ESP, "Box")
    visY = visY + 45
    CreateToggle(visualFrame, "Name ESP", States.ESP, "Name")
    visY = visY + 45
    CreateToggle(visualFrame, "Health ESP", States.ESP, "Health")
    visY = visY + 45
    CreateToggle(visualFrame, "Distance ESP", States.ESP, "Distance")
    visY = visY + 45
    CreateToggle(visualFrame, "Tracers", States.ESP, "Tracers")
    visY = visY + 45
    CreateToggle(visualFrame, "Chams/X-Ray", States.ESP, "Chams")
    visY = visY + 45
    CreateToggle(visualFrame, "Full Bright", States, "FullBright", function(val)
        if val then
            Workspace.Lighting.Brightness = 2
            Workspace.Lighting.Ambient = Color3.new(1,1,1)
        else
            Workspace.Lighting.Brightness = 0.5
            Workspace.Lighting.Ambient = Color3.new(0.5,0.5,0.5)
        end
    end)
    visY = visY + 45
    visualFrame.CanvasSize = UDim2.new(0, 0, 0, visY + 20)

    -- Tab3: Combat
    local combatFrame = TabFrames[3]
    local comY = 10
    CreateToggle(combatFrame, "Aim", States.Aim, "Enabled")
    comY = comY + 45
    CreateToggle(combatFrame, "Silent Aim", States.Aim, "Silent")
    comY = comY + 45
    CreateSlider(combatFrame, "Aim FOV", States.Aim, "FOV", 1, 360, 180)
    comY = comY + 55
    CreateToggle(combatFrame, "Aim Prediction", States.Aim, "Prediction")
    comY = comY + 45
    CreateToggle(combatFrame, "Trigger Bot", States.Aim, "TriggerBot")
    comY = comY + 45
    CreateToggle(combatFrame, "Hitbox Expander", States.Aim, "HitboxExpander")
    comY = comY + 45
    combatFrame.CanvasSize = UDim2.new(0, 0, 0, comY + 20)

    -- Tab4: Movement
    local moveFrame = TabFrames[4]
    local movY = 10
    CreateToggle(moveFrame, "Speed", States.Movement, "Speed", function(val)
        if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = States.Movement.SpeedValue
        end
    end)
    movY = movY + 45
    CreateSlider(moveFrame, "Speed Value", States.Movement, "SpeedValue", 16, 250, 85)
    movY = movY + 55
    CreateToggle(moveFrame, "Fly", States.Movement, "Fly")
    movY = movY + 45
    CreateSlider(moveFrame, "Fly Speed", States.Movement, "FlySpeed", 10, 200, 70)
    movY = movY + 55
    CreateToggle(moveFrame, "Noclip", States.Movement, "Noclip")
    movY = movY + 45
    CreateSlider(moveFrame, "Jump Power", States.Movement, "JumpPowerValue", 30, 200, 50)
    movY = movY + 55
    CreateToggle(moveFrame, "Infinite Jump", States.Movement, "InfiniteJump")
    movY = movY + 45
    CreateToggle(moveFrame, "Sprint", States.Movement, "Sprint", function(val)
        if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = States.Movement.SprintValue
        end
    end)
    movY = movY + 45
    CreateSlider(moveFrame, "Sprint Value", States.Movement, "SprintValue", 16, 350, 120)
    movY = movY + 55
    CreateToggle(moveFrame, "Anti Void", States.Movement, "AntiVoid")
    movY = movY + 45
    moveFrame.CanvasSize = UDim2.new(0, 0, 0, movY + 20)

    -- Tab5: Utility
    local utilFrame = TabFrames[5]
    local utY = 10
    CreateToggle(utilFrame, "Anti AFK", States.Utility, "AntiAFK")
    utY = utY + 45
    CreateToggle(utilFrame, "Freeze Time", States.Utility, "FreezeTime")
    utY = utY + 45
    CreateToggle(utilFrame, "FPS Booster", States.Utility, "FPSBooster")
    utY = utY + 45
    utilFrame.CanvasSize = UDim2.new(0, 0, 0, utY + 20)

    -- Tab6: Server
    local serverFrame = TabFrames[6]
    local serY = 10
    local function CreateServerButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Text = text
        btn.Size = UDim2.new(0.9, 0, 0, 40)
        btn.Position = UDim2.new(0.05, 0, 0, serY)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        btn.BackgroundTransparency = 0.2
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16
        btn.BorderSizePixel = 0
        btn.Parent = serverFrame
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn
        btn.MouseButton1Click:Connect(callback)
        serY = serY + 45
        return btn
    end
    CreateServerButton("🔄 Rejoin Server", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
        Notify("Đang tái kết nối...")
    end)
    CreateServerButton("🌐 Server Hop", function()
        local servers = HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
        for _, v in pairs(servers.data) do
            if v.id ~= game.JobId and v.playing < v.maxPlayers then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                break
            end
        end
    end)
    CreateServerButton("👥 Join Small Server", function()
        local servers = HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
        local small = nil
        for _, v in pairs(servers.data) do
            if v.id ~= game.JobId then
                if not small or v.playing < small.playing then
                    small = v
                end
            end
        end
        if small then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, small.id, LocalPlayer)
        end
    end)
    CreateServerButton("👤 Player List", function()
        local list = ""
        for _, plr in ipairs(Players:GetPlayers()) do
            list = list .. plr.Name .. "\n"
        end
        Notify("Danh sách người chơi:\n" .. list)
    end)
    CreateServerButton("👁️ Spectate Player", function()
        local plrs = Players:GetPlayers()
        if #plrs > 1 then
            local target = plrs[math.random(2, #plrs)]
            States.Server.SpectateTarget = target
            States.Server.Spectate = true
            Notify("Đang quan sát: " .. target.Name)
        end
    end)
    serverFrame.CanvasSize = UDim2.new(0, 0, 0, serY + 20)

    -- Tab7: Fun
    local funFrame = TabFrames[7]
    local funY = 10
    CreateToggle(funFrame, "Spin", States.Fun, "Spin")
    funY = funY + 45
    CreateToggle(funFrame, "Float", States.Fun, "Float")
    funY = funY + 45
    CreateToggle(funFrame, "Bang (Explode)", States.Fun, "Bang")
    funY = funY + 45
    CreateToggle(funFrame, "Fling", States.Fun, "Fling")
    funY = funY + 45
    CreateToggle(funFrame, "Orbit Player", States.Fun, "Orbit")
    funY = funY + 45
    CreateToggle(funFrame, "Invisible", States.Fun, "Invisible", function(val)
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = val and 1 or 0
                end
            end
        end
    end)
    funY = funY + 45
    funFrame.CanvasSize = UDim2.new(0, 0, 0, funY + 20)

    -- Tab8: Settings
    local settingsFrame = TabFrames[8]
    local setY = 10
    CreateToggle(settingsFrame, "Save Settings", States.Settings, "Save")
    setY = setY + 45
    CreateToggle(settingsFrame, "Auto Load Settings", States.Settings, "AutoLoad")
    setY = setY + 45
    CreateToggle(settingsFrame, "Minimize Button", States.Settings, "Minimize")
    setY = setY + 45
    CreateToggle(settingsFrame, "Draggable GUI", States.Settings, "Draggable")
    setY = setY + 45

    -- Theme
    local themeFrame = Instance.new("Frame")
    themeFrame.Size = UDim2.new(1, -20, 0, 40)
    themeFrame.Position = UDim2.new(0, 10, 0, setY)
    themeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    themeFrame.BackgroundTransparency = 0.2
    themeFrame.BorderSizePixel = 0
    themeFrame.Parent = settingsFrame
    local tcorner = Instance.new("UICorner")
    tcorner.CornerRadius = UDim.new(0, 8)
    tcorner.Parent = themeFrame
    setY = setY + 45

    local themeLabel = Instance.new("TextLabel")
    themeLabel.Text = "🎨 Theme: " .. States.Settings.Theme
    themeLabel.Size = UDim2.new(0.6, 0, 1, 0)
    themeLabel.Position = UDim2.new(0.02, 0, 0, 0)
    themeLabel.BackgroundTransparency = 1
    themeLabel.TextColor3 = Color3.new(1, 1, 1)
    themeLabel.Font = Enum.Font.Gotham
    themeLabel.TextSize = 16
    themeLabel.TextXAlignment = Enum.TextXAlignment.Left
    themeLabel.Parent = themeFrame

    local themeBtn = Instance.new("TextButton")
    themeBtn.Text = "Change"
    themeBtn.Size = UDim2.new(0, 80, 0, 28)
    themeBtn.Position = UDim2.new(0.75, 0, 0.15, 0)
    themeBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    themeBtn.BackgroundTransparency = 0.1
    themeBtn.TextColor3 = Color3.new(1, 1, 1)
    themeBtn.Font = Enum.Font.GothamBold
    themeBtn.TextSize = 14
    themeBtn.BorderSizePixel = 0
    themeBtn.Parent = themeFrame
    themeBtn.MouseButton1Click:Connect(function()
        local themes = {"Dark", "Light", "Sky Blue", "Galaxy"}
        local idx = 1
        for i, v in ipairs(themes) do if v == States.Settings.Theme then idx = i end end
        idx = idx % #themes + 1
        States.Settings.Theme = themes[idx]
        themeLabel.Text = "🎨 Theme: " .. States.Settings.Theme
        local colors = {
            Dark = {bg = Color3.fromRGB(13,13,20)},
            Light = {bg = Color3.fromRGB(240,240,240)},
            ["Sky Blue"] = {bg = Color3.fromRGB(30,60,90)},
            Galaxy = {bg = Color3.fromRGB(10,5,30)}
        }
        local c = colors[States.Settings.Theme]
        MainFrame.BackgroundColor3 = c.bg
        for _, f in ipairs(TabFrames) do f.BackgroundColor3 = c.bg end
        Notify("Theme: " .. States.Settings.Theme)
    end)
    setY = setY + 45

    -- Language
    local langFrame = Instance.new("Frame")
    langFrame.Size = UDim2.new(1, -20, 0, 40)
    langFrame.Position = UDim2.new(0, 10, 0, setY)
    langFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    langFrame.BackgroundTransparency = 0.2
    langFrame.BorderSizePixel = 0
    langFrame.Parent = settingsFrame
    local lcorner = Instance.new("UICorner")
    lcorner.CornerRadius = UDim.new(0, 8)
    lcorner.Parent = langFrame
    setY = setY + 45

    local langLabel = Instance.new("TextLabel")
    langLabel.Text = "🌐 Language: " .. States.Settings.Language
    langLabel.Size = UDim2.new(0.6, 0, 1, 0)
    langLabel.Position = UDim2.new(0.02, 0, 0, 0)
    langLabel.BackgroundTransparency = 1
    langLabel.TextColor3 = Color3.new(1, 1, 1)
    langLabel.Font = Enum.Font.Gotham
    langLabel.TextSize = 16
    langLabel.TextXAlignment = Enum.TextXAlignment.Left
    langLabel.Parent = langFrame

    local langBtn = Instance.new("TextButton")
    langBtn.Text = "Change"
    langBtn.Size = UDim2.new(0, 80, 0, 28)
    langBtn.Position = UDim2.new(0.75, 0, 0.15, 0)
    langBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    langBtn.BackgroundTransparency = 0.1
    langBtn.TextColor3 = Color3.new(1, 1, 1)
    langBtn.Font = Enum.Font.GothamBold
    langBtn.TextSize = 14
    langBtn.BorderSizePixel = 0
    langBtn.Parent = langFrame
    langBtn.MouseButton1Click:Connect(function()
        local langs = {"English", "Tiếng Việt", "Español", "Português", "Русский"}
        local idx = 1
        for i, v in ipairs(langs) do if v == States.Settings.Language then idx = i end end
        idx = idx % #langs + 1
        States.Settings.Language = langs[idx]
        langLabel.Text = "🌐 Language: " .. States.Settings.Language
        Notify("Language: " .. States.Settings.Language)
    end)
    setY = setY + 45

    CreateToggle(settingsFrame, "Notifications", States.Settings, "Notifications")
    setY = setY + 45

    local resetBtn = Instance.new("TextButton")
    resetBtn.Text = "🔄 Reset Settings"
    resetBtn.Size = UDim2.new(0.9, 0, 0, 40)
    resetBtn.Position = UDim2.new(0.05, 0, 0, setY)
    resetBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    resetBtn.BackgroundTransparency = 0.2
    resetBtn.TextColor3 = Color3.new(1, 1, 1)
    resetBtn.Font = Enum.Font.Gotham
    resetBtn.TextSize = 16
    resetBtn.BorderSizePixel = 0
    resetBtn.Parent = settingsFrame
    local rcorner = Instance.new("UICorner")
    rcorner.CornerRadius = UDim.new(0, 8)
    rcorner.Parent = resetBtn
    resetBtn.MouseButton1Click:Connect(function()
        States.ESP.Enabled = false
        States.ESP.Box = false
        States.ESP.Name = false
        States.ESP.Health = false
        States.ESP.Distance = false
        States.ESP.Tracers = false
        States.ESP.Chams = false
        States.Aim.Enabled = false
        States.Aim.Silent = false
        States.Aim.FOV = 180
        States.Aim.Prediction = false
        States.Aim.TriggerBot = false
        States.Aim.HitboxExpander = false
        States.Movement.Speed = false
        States.Movement.SpeedValue = 85
        States.Movement.Fly = false
        States.Movement.FlySpeed = 70
        States.Movement.Noclip = false
        States.Movement.JumpPower = false
        States.Movement.JumpPowerValue = 50
        States.Movement.InfiniteJump = false
        States.Movement.Sprint = false
        States.Movement.SprintValue = 120
        States.Movement.AntiVoid = false
        States.Utility.AntiAFK = false
        States.Utility.FreezeTime = false
        States.Utility.FPSBooster = false
        States.Fun.Spin = false
        States.Fun.Float = false
        States.Fun.Bang = false
        States.Fun.Fling = false
        States.Fun.Orbit = false
        States.Fun.Invisible = false
        States.Settings.Theme = "Dark"
        States.Settings.Language = "English"
        States.Settings.Notifications = true
        Notify("Đã reset tất cả cài đặt")
    end)
    setY = setY + 45
    settingsFrame.CanvasSize = UDim2.new(0, 0, 0, setY + 20)

    -- ===== DRAGGABLE =====
    local function MakeDraggable(frame)
        local dragging, dragInput, dragStart, startPos
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
            end
        end)
        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        RunService.RenderStepped:Connect(function()
            if dragging and States.Settings.Draggable then
                local delta = dragInput.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    MakeDraggable(MainFrame)

    -- ===== HÀM TOGGLE MENU VỚI HIỆU ỨNG =====
    function ToggleMenu(show)
        if isAnimating then return end
        isAnimating = true
        local targetScale = show and 1 or 0.7
        local targetTransparency = show and 0.3 or 0.9
        local targetGlowTrans = show and 0.5 or 0.9
        local duration = 0.35

        if show then
            MainFrame.Visible = true
            GlowFrame.Visible = true
            MainFrame.Scale = 0.6
            GlowFrame.Scale = 0.6
            MainFrame.BackgroundTransparency = 0.9
            GlowFrame.BackgroundTransparency = 0.9
        end

        local tween1 = TweenService:Create(MainFrame, TweenInfo.new(duration, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = targetScale,
            BackgroundTransparency = targetTransparency
        })
        local tween2 = TweenService:Create(GlowFrame, TweenInfo.new(duration, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = targetScale,
            BackgroundTransparency = targetGlowTrans
        })

        tween1:Play()
        tween2:Play()
        tween1.Completed:Connect(function()
            if not show then
                MainFrame.Visible = false
                GlowFrame.Visible = false
            end
            isAnimating = false
        end)
        MenuVisible = show
        Notify(show and "🔥 Mở menu" or "🔒 Đóng menu")
    end

    -- ===== CÁC CHỨC NĂNG CHÍNH =====
    local flyBodyVelocity, flyGyro

    local function GetClosestEnemy()
        local closest = nil
        local minDist = math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = plr.Character.HumanoidRootPart
                local pos, onScreen = Camera:WorldToScreenPoint(rootPart.Position)
                if onScreen then
                    local dist = (rootPart.Position - Camera.CFrame.Position).magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = plr
                    end
                end
            end
        end
        return closest
    end

    RunService.RenderStepped:Connect(function()
        if not LocalPlayer.Character then return end
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if not root or not hum then return end

        -- Movement
        if States.Movement.Speed then hum.WalkSpeed = States.Movement.SpeedValue else hum.WalkSpeed = 16 end
        if States.Movement.Sprint then hum.WalkSpeed = States.Movement.SprintValue end

        if States.Movement.Noclip then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end

        if States.Movement.Fly then
            if not flyBodyVelocity then
                flyBodyVelocity = Instance.new("BodyVelocity")
                flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                flyBodyVelocity.Parent = root
                flyGyro = Instance.new("BodyGyro")
                flyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                flyGyro.Parent = root
            end
            local speed = States.Movement.FlySpeed
            local move = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, speed, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, speed, 0) end
            flyBodyVelocity.Velocity = move
            flyGyro.CFrame = Camera.CFrame
            hum.PlatformStand = true
        else
            if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
            if flyGyro then flyGyro:Destroy(); flyGyro = nil end
            hum.PlatformStand = false
        end

        if States.Movement.JumpPower then hum.JumpPower = States.Movement.JumpPowerValue else hum.JumpPower = 50 end
        if States.Movement.InfiniteJump then
            UserInputService.JumpRequest:Connect(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
        end
        if States.Movement.AntiVoid and root.Position.Y < -50 then
            root.Position = Vector3.new(root.Position.X, 200, root.Position.Z)
        end

        if States.Utility.AntiAFK then
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end

        -- ESP
        if States.ESP.Enabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = plr.Character.HumanoidRootPart
                    local pos, onScreen = Camera:WorldToScreenPoint(rootPart.Position)
                    if onScreen then
                        if States.ESP.Box then
                            local box = Instance.new("Frame")
                            box.Size = UDim2.new(0, 100, 0, 150)
                            box.Position = UDim2.new(0, pos.X - 50, 0, pos.Y - 75)
                            box.BackgroundTransparency = 0.6
                            box.BackgroundColor3 = Color3.fromRGB(255,0,0)
                            box.BorderSizePixel = 1
                            box.Parent = MainGui
                            task.delay(0.1, function() box:Destroy() end)
                        end
                        if States.ESP.Name then
                            local label = Instance.new("TextLabel")
                            label.Text = plr.Name
                            label.Size = UDim2.new(0, 200, 0, 20)
                            label.Position = UDim2.new(0, pos.X - 100, 0, pos.Y - 90)
                            label.BackgroundTransparency = 1
                            label.TextColor3 = Color3.new(1,1,1)
                            label.Font = Enum.Font.Gotham
                            label.TextSize = 14
                            label.Parent = MainGui
                            task.delay(0.1, function() label:Destroy() end)
                        end
                        if States.ESP.Health then
                            local health = plr.Character:FindFirstChild("Humanoid")
                            if health then
                                local hp = health.Health
                                local label = Instance.new("TextLabel")
                                label.Text = tostring(math.floor(hp)) .. " HP"
                                label.Size = UDim2.new(0, 100, 0, 20)
                                label.Position = UDim2.new(0, pos.X - 50, 0, pos.Y + 80)
                                label.BackgroundTransparency = 1
                                label.TextColor3 = Color3.fromRGB(0,255,0)
                                label.Font = Enum.Font.Gotham
                                label.TextSize = 14
                                label.Parent = MainGui
                                task.delay(0.1, function() label:Destroy() end)
                            end
                        end
                        if States.ESP.Distance then
                            local dist = (rootPart.Position - Camera.CFrame.Position).magnitude
                            local label = Instance.new("TextLabel")
                            label.Text = tostring(math.floor(dist)) .. "m"
                            label.Size = UDim2.new(0, 100, 0, 20)
                            label.Position = UDim2.new(0, pos.X - 50, 0, pos.Y + 100)
                            label.BackgroundTransparency = 1
                            label.TextColor3 = Color3.fromRGB(255,255,255)
                            label.Font = Enum.Font.Gotham
                            label.TextSize = 14
                            label.Parent = MainGui
                            task.delay(0.1, function() label:Destroy() end)
                        end
                        if States.ESP.Tracers then
                            local tracer = Instance.new("Frame")
                            tracer.Size = UDim2.new(0, 2, 0, pos.Y)
                            tracer.Position = UDim2.new(0, pos.X, 0, 0)
                            tracer.BackgroundColor3 = Color3.fromRGB(0,255,255)
                            tracer.BackgroundTransparency = 0.5
                            tracer.Parent = MainGui
                            task.delay(0.1, function() tracer:Destroy() end)
                        end
                        if States.ESP.Chams then
                            for _, part in pairs(plr.Character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.Material = Enum.Material.Neon
                                    part.Color = Color3.fromRGB(0,255,0)
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Spectate
        if States.Server.Spectate and States.Server.SpectateTarget and States.Server.SpectateTarget.Character then
            Camera.CFrame = Camera.CFrame:Lerp(States.Server.SpectateTarget.Character.HumanoidRootPart.CFrame, 0.3)
        end

        -- Fun
        if States.Fun.Spin and root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(5), 0)
        end
        if States.Fun.Float and root then
            root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        end
        if States.Fun.Bang then
            local explosion = Instance.new("Explosion")
            explosion.Position = root.Position + Vector3.new(math.random(-10,10), 0, math.random(-10,10))
            explosion.Parent = Workspace
            States.Fun.Bang = false
        end
        if States.Fun.Fling and root then
            root.Velocity = Vector3.new(math.random(-100,100), math.random(50,200), math.random(-100,100))
            States.Fun.Fling = false
        end
        if States.Fun.Orbit and States.Fun.OrbitTarget and States.Fun.OrbitTarget.Character then
            local targetRoot = States.Fun.OrbitTarget.Character.HumanoidRootPart
            local angle = tick() * 2
            local radius = 10
            local pos = targetRoot.Position + Vector3.new(math.cos(angle) * radius, 3, math.sin(angle) * radius)
            root.CFrame = CFrame.new(pos, targetRoot.Position)
        end

        -- Aim
        if States.Aim.Enabled then
            local target = GetClosestEnemy()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = target.Character.HumanoidRootPart.Position
                if States.Aim.Prediction then
                    local velocity = target.Character.HumanoidRootPart.Velocity
                    targetPos = targetPos + velocity * 0.2
                end
                local aimPos = Camera:WorldToScreenPoint(targetPos)
                local fov = States.Aim.FOV
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local distance = (Vector2.new(aimPos.X, aimPos.Y) - screenCenter).magnitude
                if distance <= fov then
                    if States.Aim.Silent then
                        local direction = (targetPos - Camera.CFrame.Position).unit
                        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + direction)
                    else
                        Mouse.Move(Vector2.new(aimPos.X, aimPos.Y))
                    end
                    if States.Aim.TriggerBot then
                        Mouse.Button1Down()
                        task.wait(0.05)
                        Mouse.Button1Up()
                    end
                end
            end
        end
    end)

    -- ===== XỬ LÝ 3 NGÓN 3 LẦN =====
    local tapCount = 0
    local lastTapTime = 0
    local tapTimeout = 1.5

    UserInputService.TouchEnabled = true
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Touch then
            local touches = UserInputService:GetTouchPositions()
            if #touches >= 3 then
                local now = tick()
                if now - lastTapTime < tapTimeout then
                    tapCount = tapCount + 1
                else
                    tapCount = 1
                end
                lastTapTime = now

                if tapCount >= 3 then
                    ToggleMenu(not MenuVisible)
                    tapCount = 0
                end
            end
        end
    end)

    print("✅ FLUYEN HUB v7 - Hiệu ứng mở/đóng siêu đẹp | [made by seraph]")
end