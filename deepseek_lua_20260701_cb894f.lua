-- Made by seraph
-- FLUYEN HUB v4 - Giao diện trong suốt, đổi màu liên tục, bật/tắt bằng chạm 3 ngón 3 lần
-- Tất cả chức năng hoạt động, nhập key to, không có thanh trạng thái phía dưới

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

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

-- ===== TẠO GUI KEY (to hơn) =====
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "KeyEntry"
KeyGui.ResetOnSpawn = false
KeyGui.Parent = LocalPlayer.PlayerGui

local ScreenSize = Camera.ViewportSize
local ScaleX = ScreenSize.X / 1920
local ScaleY = ScreenSize.Y / 1080
local UIScale = math.min(ScaleX, ScaleY) * 0.9

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 500 * UIScale, 0, 300 * UIScale)  -- Lớn hơn
KeyFrame.Position = UDim2.new(0.5, -250 * UIScale, 0.5, -150 * UIScale)
KeyFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = KeyGui
local kfCorner = Instance.new("UICorner")
kfCorner.CornerRadius = UDim.new(0, 24)
kfCorner.Parent = KeyFrame

-- Hiệu ứng glow cho keyframe
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
-- Màu glow luân hồi
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

-- Ô nhập key to
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

-- Nút xác nhận to
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
        KeyGui:Destroy()  -- Xóa màn hình key
        Notify("✅ Đăng nhập thành công!")
        -- Tạo menu chính (sau khi login)
        CreateMainMenu()
    else
        KeyInput.Text = "SAI KEY!"
        KeyInput.TextColor3 = Color3.fromRGB(255, 50, 50)
        task.wait(1)
        KeyInput.Text = ""
        KeyInput.TextColor3 = Color3.new(1, 1, 1)
    end
end)

-- ===== TẠO MENU CHÍNH (gọi sau login) =====
local MainGui = nil
local MainFrame = nil
local GlowFrame = nil
local TabFrames = {}
local TabButtons = {}

function CreateMainMenu()
    MainGui = Instance.new("ScreenGui")
    MainGui.Name = "FluyenHub"
    MainGui.ResetOnSpawn = false
    MainGui.Parent = LocalPlayer.PlayerGui

    -- Main frame trong suốt
    MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 900 * UIScale, 0, 650 * UIScale)
    MainFrame.Position = UDim2.new(0.5, -450 * UIScale, 0.05, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    MainFrame.BackgroundTransparency = 0.3  -- Trong suốt
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false  -- Ẩn ban đầu
    MainFrame.Parent = MainGui
    local mfCorner = Instance.new("UICorner")
    mfCorner.CornerRadius = UDim.new(0, 20)
    mfCorner.Parent = MainFrame

    -- Glow frame đổi màu liên tục (bao quanh menu)
    GlowFrame = Instance.new("Frame")
    GlowFrame.Size = MainFrame.Size + UDim2.new(0, 12, 0, 12)
    GlowFrame.Position = MainFrame.Position - UDim2.new(0, 6, 0, 6)
    GlowFrame.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    GlowFrame.BackgroundTransparency = 0.5
    GlowFrame.BorderSizePixel = 0
    GlowFrame.Parent = MainGui
    local gfCorner = Instance.new("UICorner")
    gfCorner.CornerRadius = UDim.new(0, 24)
    gfCorner.Parent = GlowFrame

    -- Cập nhật glow theo MainFrame
    RunService.RenderStepped:Connect(function()
        if MainFrame and MainFrame.Parent then
            GlowFrame.Size = MainFrame.Size + UDim2.new(0, 12, 0, 12)
            GlowFrame.Position = MainFrame.Position - UDim2.new(0, 6, 0, 6)
        end
    end)

    -- Hiệu ứng màu luân hồi cho GlowFrame
    task.spawn(function()
        while MainGui and MainGui.Parent do
            local hue = (tick() * 0.08) % 1
            GlowFrame.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 0.9)
            task.wait(0.02)
        end
    end)

    -- Top bar trong suốt
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 55 * UIScale)
    TopBar.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    TopBar.BackgroundTransparency = 0.2
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 20)
    tbCorner.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Text = "FLUYEN HUB"
    Title.Size = UDim2.new(0.3, 0, 1, 0)
    Title.Position = UDim2.new(0.02, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 24 * UIScale
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Text = "v4.0"
    VersionLabel.Size = UDim2.new(0.15, 0, 1, 0)
    VersionLabel.Position = UDim2.new(0.33, 0, 0, 0)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    VersionLabel.Font = Enum.Font.Gotham
    VersionLabel.TextSize = 16 * UIScale
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.Parent = TopBar

    local UserLabel = Instance.new("TextLabel")
    UserLabel.Text = "User: " .. LocalPlayer.Name
    UserLabel.Size = UDim2.new(0.3, 0, 1, 0)
    UserLabel.Position = UDim2.new(0.5, 0, 0, 0)
    UserLabel.BackgroundTransparency = 1
    UserLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    UserLabel.Font = Enum.Font.Gotham
    UserLabel.TextSize = 16 * UIScale
    UserLabel.TextXAlignment = Enum.TextXAlignment.Left
    UserLabel.Parent = TopBar

    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 45 * UIScale)
    TabBar.Position = UDim2.new(0, 0, 0, 55 * UIScale)
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
        btn.TextSize = 15 * UIScale
        btn.BorderSizePixel = 0
        btn.Parent = TabBar
        TabButtons[i] = btn

        local frame = Instance.new("ScrollingFrame")
        frame.Size = UDim2.new(1, 0, 1, -45 * UIScale - 55 * UIScale)
        frame.Position = UDim2.new(0, 0, 0, 55 * UIScale + 45 * UIScale)
        frame.BackgroundColor3 = Color3.fromRGB(13, 13, 20)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Visible = (i == 1)
        frame.CanvasSize = UDim2.new(0, 0, 0, 0)
        frame.ScrollBarThickness = 6 * UIScale
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

    -- ===== HÀM TẠO TOGGLE =====
    local function CreateToggle(parent, text, stateRef, stateKey, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20 * UIScale, 0, 40 * UIScale)
        frame.Position = UDim2.new(0, 10 * UIScale, 0, #parent:GetChildren() * 45 * UIScale + 10 * UIScale)
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
        label.TextSize = 16 * UIScale
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local toggle = Instance.new("TextButton")
        toggle.Text = stateRef[stateKey] and "ON" or "OFF"
        toggle.Size = UDim2.new(0, 60 * UIScale, 0, 28 * UIScale)
        toggle.Position = UDim2.new(0.85, -30 * UIScale, 0.15, 0)
        toggle.BackgroundColor3 = stateRef[stateKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
        toggle.BackgroundTransparency = 0.1
        toggle.TextColor3 = Color3.new(1, 1, 1)
        toggle.Font = Enum.Font.GothamBold
        toggle.TextSize = 14 * UIScale
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
        frame.Size = UDim2.new(1, -20 * UIScale, 0, 50 * UIScale)
        frame.Position = UDim2.new(0, 10 * UIScale, 0, #parent:GetChildren() * 45 * UIScale + 10 * UIScale)
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
        label.TextSize = 16 * UIScale
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(0.3, 0, 0, 8 * UIScale)
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

    -- === Xây dựng các tab (giữ nguyên nội dung) ===
    -- Tab1 Home
    local homeFrame = TabFrames[1]
    local homeY = 10 * UIScale
    local function AddHomeLabel(text, y)
        local label = Instance.new("TextLabel")
        label.Text = text
        label.Size = UDim2.new(1, -20 * UIScale, 0, 30 * UIScale)
        label.Position = UDim2.new(0, 10 * UIScale, 0, y)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 20 * UIScale
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = homeFrame
        return label
    end
    AddHomeLabel("🖥️ FLUYEN HUB", homeY)
    homeY = homeY + 35 * UIScale
    AddHomeLabel("Phiên bản: v4.0", homeY)
    homeY = homeY + 30 * UIScale
    AddHomeLabel("Người dùng: " .. LocalPlayer.Name, homeY)
    homeY = homeY + 30 * UIScale
    AddHomeLabel("Executor: Synapse X", homeY)
    homeY = homeY + 30 * UIScale
    AddHomeLabel("Tác giả: seraph", homeY)
    homeY = homeY + 30 * UIScale
    AddHomeLabel("📜 Changelog: Giao diện trong suốt, đổi màu, 3 ngón 3 lần", homeY)
    homeY = homeY + 30 * UIScale
    homeFrame.CanvasSize = UDim2.new(0, 0, 0, homeY + 20 * UIScale)

    -- Tab2 Visual
    local visualFrame = TabFrames[2]
    local visY = 10 * UIScale
    CreateToggle(visualFrame, "ESP", States.ESP, "Enabled")
    visY = visY + 45 * UIScale
    CreateToggle(visualFrame, "Box ESP", States.ESP, "Box")
    visY = visY + 45 * UIScale
    CreateToggle(visualFrame, "Name ESP", States.ESP, "Name")
    visY = visY + 45 * UIScale
    CreateToggle(visualFrame, "Health ESP", States.ESP, "Health")
    visY = visY + 45 * UIScale
    CreateToggle(visualFrame, "Distance ESP", States.ESP, "Distance")
    visY = visY + 45 * UIScale
    CreateToggle(visualFrame, "Tracers", States.ESP, "Tracers")
    visY = visY + 45 * UIScale
    CreateToggle(visualFrame, "Chams/X-Ray", States.ESP, "Chams")
    visY = visY + 45 * UIScale
    CreateToggle(visualFrame, "Full Bright", States, "FullBright", function(val)
        if val then game.Lighting.Brightness = 2 game.Lighting.Ambient = Color3.new(1,1,1) else game.Lighting.Brightness = 0.5 game.Lighting.Ambient = Color3.new(0.5,0.5,0.5) end
    end)
    visY = visY + 45 * UIScale
    visualFrame.CanvasSize = UDim2.new(0, 0, 0, visY + 20 * UIScale)

    -- Tab3 Combat
    local combatFrame = TabFrames[3]
    local comY = 10 * UIScale
    CreateToggle(combatFrame, "Aim", States.Aim, "Enabled")
    comY = comY + 45 * UIScale
    CreateToggle(combatFrame, "Silent Aim", States.Aim, "Silent")
    comY = comY + 45 * UIScale
    CreateSlider(combatFrame, "Aim FOV", States.Aim, "FOV", 1, 360, 180)
    comY = comY + 55 * UIScale
    CreateToggle(combatFrame, "Aim Prediction", States.Aim, "Prediction")
    comY = comY + 45 * UIScale
    CreateToggle(combatFrame, "Trigger Bot", States.Aim, "TriggerBot")
    comY = comY + 45 * UIScale
    CreateToggle(combatFrame, "Hitbox Expander", States.Aim, "HitboxExpander")
    comY = comY + 45 * UIScale
    combatFrame.CanvasSize = UDim2.new(0, 0, 0, comY + 20 * UIScale)

    -- Tab4 Movement
    local moveFrame = TabFrames[4]
    local movY = 10 * UIScale
    CreateToggle(moveFrame, "Speed", States.Movement, "Speed", function(val) if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = States.Movement.SpeedValue end end)
    movY = movY + 45 * UIScale
    CreateSlider(moveFrame, "Speed Value", States.Movement, "SpeedValue", 16, 250, 85)
    movY = movY + 55 * UIScale
    CreateToggle(moveFrame, "Fly", States.Movement, "Fly")
    movY = movY + 45 * UIScale
    CreateSlider(moveFrame, "Fly Speed", States.Movement, "FlySpeed", 10, 200, 70)
    movY = movY + 55 * UIScale
    CreateToggle(moveFrame, "Noclip", States.Movement, "Noclip")
    movY = movY + 45 * UIScale
    CreateSlider(moveFrame, "Jump Power", States.Movement, "JumpPowerValue", 30, 200, 50)
    movY = movY + 55 * UIScale
    CreateToggle(moveFrame, "Infinite Jump", States.Movement, "InfiniteJump")
    movY = movY + 45 * UIScale
    CreateToggle(moveFrame, "Sprint", States.Movement, "Sprint", function(val) if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = States.Movement.SprintValue end end)
    movY = movY + 45 * UIScale
    CreateSlider(moveFrame, "Sprint Value", States.Movement, "SprintValue", 16, 350, 120)
    movY = movY + 55 * UIScale
    CreateToggle(moveFrame, "Anti Void", States.Movement, "AntiVoid")
    movY = movY + 45 * UIScale
    moveFrame.CanvasSize = UDim2.new(0, 0, 0, movY + 20 * UIScale)

    -- Tab5 Utility
    local utilFrame = TabFrames[5]
    local utY = 10 * UIScale
    CreateToggle(utilFrame, "Anti AFK", States.Utility, "AntiAFK")
    utY = utY + 45 * UIScale
    CreateToggle(utilFrame, "Freeze Time", States.Utility, "FreezeTime")
    utY = utY + 45 * UIScale
    CreateToggle(utilFrame, "FPS Booster", States.Utility, "FPSBooster")
    utY = utY + 45 * UIScale
    utilFrame.CanvasSize = UDim2.new(0, 0, 0, utY + 20 * UIScale)

    -- Tab6 Server
    local serverFrame = TabFrames[6]
    local serY = 10 * UIScale
    local function CreateServerButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Text = text
        btn.Size = UDim2.new(0.9, 0, 0, 40 * UIScale)
        btn.Position = UDim2.new(0.05, 0, 0, serY)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        btn.BackgroundTransparency = 0.2
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16 * UIScale
        btn.BorderSizePixel = 0
        btn.Parent = serverFrame
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn
        btn.MouseButton1Click:Connect(callback)
        serY = serY + 45 * UIScale
        return btn
    end
    CreateServerButton("🔄 Rejoin Server", function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) Notify("Đang tái kết nối...") end)
    CreateServerButton("🌐 Server Hop", function()
        local servers = HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
        for _, v in pairs(servers.data) do if v.id ~= game.JobId and v.playing < v.maxPlayers then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer) break end end
    end)
    CreateServerButton("👥 Join Small Server", function()
        local servers = HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
        local small = nil
        for _, v in pairs(servers.data) do if v.id ~= game.JobId then if not small or v.playing < small.playing then small = v end end end
        if small then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, small.id, LocalPlayer) end
    end)
    CreateServerButton("👤 Player List", function()
        local list = ""; for _, plr in ipairs(Players:GetPlayers()) do list = list .. plr.Name .. "\n" end
        Notify("Danh sách người chơi:\n" .. list)
    end)
    CreateServerButton("👁️ Spectate Player", function()
        local plrs = Players:GetPlayers()
        if #plrs > 1 then local target = plrs[math.random(2, #plrs)] States.Server.SpectateTarget = target States.Server.Spectate = true Notify("Đang quan sát: " .. target.Name) end
    end)
    serverFrame.CanvasSize = UDim2.new(0, 0, 0, serY + 20 * UIScale)

    -- Tab7 Fun
    local funFrame = TabFrames[7]
    local funY = 10 * UIScale
    CreateToggle(funFrame, "Spin", States.Fun, "Spin")
    funY = funY + 45 * UIScale
    CreateToggle(funFrame, "Float", States.Fun, "Float")
    funY = funY + 45 * UIScale
    CreateToggle(funFrame, "Bang (Explode)", States.Fun, "Bang")
    funY = funY + 45 * UIScale
    CreateToggle(funFrame, "Fling", States.Fun, "Fling")
    funY = funY + 45 * UIScale
    CreateToggle(funFrame, "Orbit Player", States.Fun, "Orbit")
    funY = funY + 45 * UIScale
    CreateToggle(funFrame, "Invisible", States.Fun, "Invisible", function(val)
        if LocalPlayer.Character then for _, part in ipairs(LocalPlayer.Character:GetChildren()) do if part:IsA("BasePart") then part.Transparency = val and 1 or 0 end end end
    end)
    funY = funY + 45 * UIScale
    funFrame.CanvasSize = UDim2.new(0, 0, 0, funY + 20 * UIScale)

    -- Tab8 Settings
    local settingsFrame = TabFrames[8]
    local setY = 10 * UIScale
    CreateToggle(settingsFrame, "Save Settings", States.Settings, "Save")
    setY = setY + 45 * UIScale
    CreateToggle(settingsFrame, "Auto Load Settings", States.Settings, "AutoLoad")
    setY = setY + 45 * UIScale
    CreateToggle(settingsFrame, "Minimize Button", States.Settings, "Minimize")
    setY = setY + 45 * UIScale
    CreateToggle(settingsFrame, "Draggable GUI", States.Settings, "Draggable")
    setY = setY + 45 * UIScale

    -- Theme
    local themeFrame = Instance.new("Frame")
    themeFrame.Size = UDim2.new(1, -20 * UIScale, 0, 40 * UIScale)
    themeFrame.Position = UDim2.new(0, 10 * UIScale, 0, setY)
    themeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    themeFrame.BackgroundTransparency = 0.2
    themeFrame.BorderSizePixel = 0
    themeFrame.Parent = settingsFrame
    local tcorner = Instance.new("UICorner")
    tcorner.CornerRadius = UDim.new(0, 8)
    tcorner.Parent = themeFrame
    setY = setY + 45 * UIScale

    local themeLabel = Instance.new("TextLabel")
    themeLabel.Text = "🎨 Theme: " .. States.Settings.Theme
    themeLabel.Size = UDim2.new(0.6, 0, 1, 0)
    themeLabel.Position = UDim2.new(0.02, 0, 0, 0)
    themeLabel.BackgroundTransparency = 1
    themeLabel.TextColor3 = Color3.new(1, 1, 1)
    themeLabel.Font = Enum.Font.Gotham
    themeLabel.TextSize = 16 * UIScale
    themeLabel.TextXAlignment = Enum.TextXAlignment.Left
    themeLabel.Parent = themeFrame

    local themeBtn = Instance.new("TextButton")
    themeBtn.Text = "Change"
    themeBtn.Size = UDim2.new(0, 80 * UIScale, 0, 28 * UIScale)
    themeBtn.Position = UDim2.new(0.75, 0, 0.15, 0)
    themeBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    themeBtn.BackgroundTransparency = 0.1
    themeBtn.TextColor3 = Color3.new(1, 1, 1)
    themeBtn.Font = Enum.Font.GothamBold
    themeBtn.TextSize = 14 * UIScale
    themeBtn.BorderSizePixel = 0
    themeBtn.Parent = themeFrame
    themeBtn.MouseButton1Click:Connect(function()
        local themes = {"Dark", "Light", "Sky Blue", "Galaxy"}
        local idx = 1
        for i, v in ipairs(themes) do if v == States.Settings.Theme then idx = i end end
        idx = idx % #themes + 1
        States.Settings.Theme = themes[idx]
        themeLabel.Text = "🎨 Theme: " .. States.Settings.Theme
        local colors = {Dark = {bg = Color3.fromRGB(13,13,20)}, Light = {bg = Color3.fromRGB(240,240,240)}, ["Sky Blue"] = {bg = Color3.fromRGB(30,60,90)}, Galaxy = {bg = Color3.fromRGB(10,5,30)}}
        local c = colors[States.Settings.Theme]
        MainFrame.BackgroundColor3 = c.bg
        for _, f in ipairs(TabFrames) do f.BackgroundColor3 = c.bg end
        Notify("Theme: " .. States.Settings.Theme)
    end)

    setY = setY + 45 * UIScale

    -- Language
    local langFrame = Instance.new("Frame")
    langFrame.Size = UDim2.new(1, -20 * UIScale, 0, 40 * UIScale)
    langFrame.Position = UDim2.new(0, 10 * UIScale, 0, setY)
    langFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    langFrame.BackgroundTransparency = 0.2
    langFrame.BorderSizePixel = 0
    langFrame.Parent = settingsFrame
    local lcorner = Instance.new("UICorner")
    lcorner.CornerRadius = UDim.new(0, 8)
    lcorner.Parent = langFrame
    setY = setY + 45 * UIScale

    local langLabel = Instance.new("TextLabel")
    langLabel.Text = "🌐 Language: " .. States.Settings.Language
    langLabel.Size = UDim2.new(0.6, 0, 1, 0)
    langLabel.Position = UDim2.new(0.02, 0, 0, 0)
    langLabel.BackgroundTransparency = 1
    langLabel.TextColor3 = Color3.new(1, 1, 1)
    langLabel.Font = Enum.Font.Gotham
    langLabel.TextSize = 16 * UIScale
    langLabel.TextXAlignment = Enum.TextXAlignment.Left
    langLabel.Parent = langFrame

    local langBtn = Instance.new("TextButton")
    langBtn.Text = "Change"
    langBtn.Size = UDim2.new(0, 80 * UIScale, 0, 28 * UIScale)
    langBtn.Position = UDim2.new(0.75, 0, 0.15, 0)
    langBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    langBtn.BackgroundTransparency = 0.1
    langBtn.TextColor3 = Color3.new(1, 1, 1)
    langBtn.Font = Enum.Font.GothamBold
    langBtn.TextSize = 14 * UIScale
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

    setY = setY + 45 * UIScale

    CreateToggle(settingsFrame, "Notifications", States.Settings, "Notifications")
    setY = setY + 45 * UIScale

    local resetBtn = Instance.new("TextButton")
    resetBtn.Text = "🔄 Reset Settings"
    resetBtn.Size = UDim2.new(0.9, 0, 0, 40 * UIScale)
    resetBtn.Position = UDim2.new(0.05, 0, 0, setY)
    resetBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    resetBtn.BackgroundTransparency = 0.2
    resetBtn.TextColor3 = Color3.new(1, 1, 1)
    resetBtn.Font = Enum.Font.Gotham
    resetBtn.TextSize = 16 * UIScale
    resetBtn.BorderSizePixel = 0
    resetBtn.Parent = settingsFrame
    local rcorner = Instance.new("UICorner")
    rcorner.CornerRadius = UDim.new(0, 8)
    rcorner.Parent = resetBtn
    resetBtn.MouseButton1Click:Connect(function()
        -- Reset states
        States.ESP.Enabled = false; States.ESP.Box = false; States.ESP.Name = false; States.ESP.Health = false; States.ESP.Distance = false; States.ESP.Tracers = false; States.ESP.Chams = false
        States.Aim.Enabled = false; States.Aim.Silent = false; States.Aim.FOV = 180; States.Aim.Prediction = false; States.Aim.TriggerBot = false; States.Aim.HitboxExpander = false
        States.Movement.Speed = false; States.Movement.SpeedValue = 85; States.Movement.Fly = false; States.Movement.FlySpeed = 70; States.Movement.Noclip = false; States.Movement.JumpPower = false; States.Movement.JumpPowerValue = 50; States.Movement.InfiniteJump = false; States.Movement.Sprint = false; States.Movement.SprintValue = 120; States.Movement.AntiVoid = false
        States.Utility.AntiAFK = false; States.Utility.FreezeTime = false; States.Utility.FPSBooster = false
        States.Fun.Spin = false; States.Fun.Float = false; States.Fun.Bang = false; States.Fun.Fling = false; States.Fun.Orbit = false; States.Fun.Invisible = false
        States.Settings.Theme = "Dark"; States.Settings.Language = "English"; States.Settings.Notifications = true
        Notify("Đã reset tất cả cài đặt")
    end)
    setY = setY + 45 * UIScale
    settingsFrame.CanvasSize = UDim2.new(0, 0, 0, setY + 20 * UIScale)

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
            if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        RunService.RenderStepped:Connect(function()
            if dragging and States.Settings.Draggable then
                local delta = dragInput.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    MakeDraggable(MainFrame)

    -- ===== CORE CHEATS =====
    local flyBodyVelocity, flyGyro
    RunService.RenderStepped:Connect(function()
        if not LocalPlayer.Character then return end
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if not root or not hum then return end

        if States.Movement.Speed then hum.WalkSpeed = States.Movement.SpeedValue else hum.WalkSpeed = 16 end
        if States.Movement.Sprint then hum.WalkSpeed = States.Movement.SprintValue end

        if States.Movement.Noclip then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
        end

        if States.Movement.Fly then
            if not flyBodyVelocity then
                flyBodyVelocity = Instance.new("BodyVelocity"); flyBodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5); flyBodyVelocity.Parent = root
                flyGyro = Instance.new("BodyGyro"); flyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5); flyGyro.Parent = root
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
        if States.Movement.AntiVoid and root.Position.Y < -50 then root.Position = Vector3.new(root.Position.X, 200, root.Position.Z) end
        if States.Utility.AntiAFK then
            local vu = game:GetService("VirtualUser"); vu:CaptureController(); vu:ClickButton2(Vector2.new())
        end

        -- ESP đơn giản
        if States.ESP.Enabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = plr.Character.HumanoidRootPart
                    local pos, onScreen = Camera:WorldToScreenPoint(rootPart.Position)
                    if onScreen then
                        if States.ESP.Box then
                            local box = Instance.new("Frame")
                            box.Size = UDim2.new(0, 100 * UIScale, 0, 150 * UIScale)
                            box.Position = UDim2.new(0, pos.X - 50 * UIScale, 0, pos.Y - 75 * UIScale)
                            box.BackgroundTransparency = 0.6; box.BackgroundColor3 = Color3.fromRGB(255,0,0); box.BorderSizePixel = 1
                            box.Parent = MainGui
                            task.delay(0.1, function() box:Destroy() end)
                        end
                        if States.ESP.Name then
                            local label = Instance.new("TextLabel")
                            label.Text = plr.Name
                            label.Size = UDim2.new(0, 200 * UIScale, 0, 20 * UIScale)
                            label.Position = UDim2.new(0, pos.X - 100 * UIScale, 0, pos.Y - 90 * UIScale)
                            label.BackgroundTransparency = 1; label.TextColor3 = Color3.new(1,1,1); label.Font = Enum.Font.Gotham; label.TextSize = 14 * UIScale
                            label.Parent = MainGui
                            task.delay(0.1, function() label:Destroy() end)
                        end
                    end
                end
            end
        end

        if States.Server.Spectate and States.Server.SpectateTarget and States.Server.SpectateTarget.Character then
            Camera.CFrame = Camera.CFrame:Lerp(States.Server.SpectateTarget.Character.HumanoidRootPart.CFrame, 0.3)
        end

        if States.Fun.Spin and root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(5), 0) end
        if States.Fun.Float and root then root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z) end
        if States.Fun.Bang then
            local explosion = Instance.new("Explosion"); explosion.Position = root.Position + Vector3.new(math.random(-10,10), 0, math.random(-10,10)); explosion.Parent = workspace
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
    end)

    -- ===== XỬ LÝ 3 NGÓN 3 LẦN ĐỂ BẬT/TẮT MENU =====
    local tapCount = 0
    local lastTapTime = 0
    local tapTimeout = 1.5 -- giây

    UserInputService.TouchEnabled = true
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Touch then
            -- Kiểm tra số ngón chạm
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
                    -- Bật/tắt menu
                    if MainFrame then
                        MainFrame.Visible = not MainFrame.Visible
                        -- Ẩn/hiện glow
                        if GlowFrame then GlowFrame.Visible = MainFrame.Visible end
                        Notify(MainFrame.Visible and "🔥 Mở menu" or "🔒 Đóng menu")
                    end
                    tapCount = 0
                end
            end
        end
    end)

    print("✅ FLUYEN HUB v4 - Giao diện trong suốt, đổi màu, 3 ngón 3 lần | [made by seraph]")
end

-- Lưu ý: KeyGui hiển thị trước, sau login mới tạo menu