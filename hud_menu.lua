--[[
    HUD Menu — Toggle bằng gesture chạm 3 ngón x 3 lần
    Không có ESP / aimbot / exploit. Chỉ là khung UI.
--]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============ CẤU HÌNH GESTURE ============
local REQUIRED_FINGERS = 3
local REQUIRED_TAPS = 3
local TAP_WINDOW = 1.2 -- giây, khoảng thời gian tối đa giữa các lần chạm

local tapCount = 0
local lastTapTime = 0

-- ============ TẠO GIAO DIỆN ============
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HudMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 100
screenGui.Parent = playerGui

-- Lớp phủ mờ phía sau menu (backdrop) — chạm vào để đóng, tạo chiều sâu
local backdrop = Instance.new("Frame")
backdrop.Name = "Backdrop"
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.Position = UDim2.new(0, 0, 0, 0)
backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backdrop.BackgroundTransparency = 1
backdrop.BorderSizePixel = 0
backdrop.Visible = false
backdrop.ZIndex = 1
backdrop.Parent = screenGui

local backdropClose = Instance.new("TextButton")
backdropClose.Size = UDim2.new(1, 0, 1, 0)
backdropClose.BackgroundTransparency = 1
backdropClose.Text = ""
backdropClose.ZIndex = 1
backdropClose.Parent = backdrop

-- Khung menu chính — bố cục NGANG, neo giữa màn hình để phóng to/thu nhỏ từ tâm
local MENU_WIDTH, MENU_HEIGHT = 560, 340

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, MENU_WIDTH, 0, MENU_HEIGHT)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 2
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(70, 70, 90)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- UIScale điều khiển hiệu ứng phóng to / thu nhỏ từ tâm (không trượt)
local uiScale = Instance.new("UIScale")
uiScale.Scale = 0
uiScale.Parent = mainFrame

-- Thanh tiêu đề
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame") -- che góc bo dưới của title bar
titleFix.Size = UDim2.new(1, 0, 0, 14)
titleFix.Position = UDim2.new(0, 0, 1, -14)
titleFix.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 16, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "FLUYEN"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Cho phép kéo cửa sổ bằng thanh tiêu đề
do
    local dragging = false
    local dragStart, startPos

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Cột tab bên trái
local TAB_WIDTH = 150
local tabList = {"Trang chủ", "Cài đặt", "Thông tin"}
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(0, TAB_WIDTH, 1, -44)
tabContainer.Position = UDim2.new(0, 0, 0, 44)
tabContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 4)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabContainer

local tabPadding = Instance.new("UIPadding")
tabPadding.PaddingTop = UDim.new(0, 8)
tabPadding.Parent = tabContainer

-- Vùng nội dung bên phải
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -TAB_WIDTH, 1, -44)
contentArea.Position = UDim2.new(0, TAB_WIDTH, 0, 44)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

local pages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, -16, 1, -16)
    page.Position = UDim2.new(0, 8, 0, 8)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = contentArea

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 26)
    header.BackgroundTransparency = 1
    header.Text = name
    header.Font = Enum.Font.GothamBold
    header.TextSize = 18
    header.TextColor3 = Color3.fromRGB(235, 235, 240)
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.LayoutOrder = 0
    header.Parent = page

    pages[name] = page
    return page
end

local function selectTab(name, buttons)
    for pageName, page in pairs(pages) do
        page.Visible = (pageName == name)
    end
    for btnName, btn in pairs(buttons) do
        local active = (btnName == name)
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = active and Color3.fromRGB(70, 110, 255) or Color3.fromRGB(30, 30, 36)
        }):Play()
    end
end

local buttons = {}
for i, name in ipairs(tabList) do
    createPage(name)

    local btn = Instance.new("TextButton")
    btn.Name = name .. "Button"
    btn.Size = UDim2.new(1, -12, 0, 34)
    btn.Position = UDim2.new(0, 6, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    btn.AutoButtonColor = false
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(220, 220, 225)
    btn.LayoutOrder = i
    btn.Parent = tabContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    buttons[name] = btn
end

for name, btn in pairs(buttons) do
    btn.MouseButton1Click:Connect(function()
        selectTab(name, buttons)
    end)
end

selectTab(tabList[1], buttons)

-- Hàm dùng chung: tạo 1 dòng có nút gạt (toggle) để test bật/tắt
local function addToggleRow(page, label, layoutOrder, defaultOn)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundTransparency = 1
    row.LayoutOrder = layoutOrder
    row.Parent = page

    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(1, -60, 1, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.Font = Enum.Font.Gotham
    labelText.TextSize = 14
    labelText.TextColor3 = Color3.fromRGB(220, 220, 225)
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = row

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 46, 0, 24)
    toggleBg.Position = UDim2.new(1, -46, 0.5, -12)
    toggleBg.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
    toggleBg.Parent = row

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBg

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = toggleBg

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.Parent = toggleBg

    local state = false

    local function applyState(animated)
        local knobGoal = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local bgGoal = state and Color3.fromRGB(70, 110, 255) or Color3.fromRGB(50, 50, 58)
        if animated then
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = knobGoal}):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.15), {BackgroundColor3 = bgGoal}):Play()
        else
            knob.Position = knobGoal
            toggleBg.BackgroundColor3 = bgGoal
        end
    end

    if defaultOn then
        state = true
        applyState(false)
    end

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        applyState(true)
    end)

    return row
end

-- Nội dung test cho từng tab — để không trang nào bị trống trơn khi mở lên
addToggleRow(pages["Trang chủ"], "Hiển thị nhanh", 1, true)
addToggleRow(pages["Trang chủ"], "Tự động ẩn", 2, false)

addToggleRow(pages["Cài đặt"], "Ví dụ tuỳ chọn", 1, false)
addToggleRow(pages["Cài đặt"], "Rung khi chạm", 2, true)

addToggleRow(pages["Thông tin"], "Thông báo cập nhật", 1, false)

-- ============ HIỆU ỨNG MỞ / ĐÓNG: PHÓNG TO TỪ TÂM (KHÔNG TRƯỢT) ============
local isOpen = false
local isAnimating = false

local OPEN_INFO  = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local CLOSE_INFO = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
local FADE_INFO  = TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local function openMenu()
    if isOpen or isAnimating then return end
    isAnimating = true
    isOpen = true

    uiScale.Scale = 0
    mainFrame.Visible = true
    backdrop.Visible = true
    backdrop.BackgroundTransparency = 1

    TweenService:Create(uiScale, OPEN_INFO, {Scale = 1}):Play()
    TweenService:Create(backdrop, FADE_INFO, {BackgroundTransparency = 0.45}):Play()

    task.delay(OPEN_INFO.Time, function() isAnimating = false end)
end

local function closeMenu()
    if not isOpen or isAnimating then return end
    isAnimating = true
    isOpen = false

    local tween = TweenService:Create(uiScale, CLOSE_INFO, {Scale = 0})
    TweenService:Create(backdrop, CLOSE_INFO, {BackgroundTransparency = 1}):Play()
    tween:Play()
    tween.Completed:Connect(function()
        mainFrame.Visible = false
        backdrop.Visible = false
        isAnimating = false
    end)
end

local function toggleMenu()
    if isOpen then
        closeMenu()
    else
        openMenu()
    end
end

-- Chạm ra ngoài (vào backdrop) cũng đóng menu lại
backdropClose.MouseButton1Click:Connect(closeMenu)

-- ============ NHẬN DIỆN GESTURE: 3 NGÓN x 3 LẦN ============
-- Đếm số ngón đang thực sự chạm màn hình (TouchStarted/TouchEnded) thay vì
-- dùng TouchTap — vì TouchTap chỉ tính là "tap" khi ngón hoàn toàn không
-- di chuyển. Cách này chỉ quan tâm thời điểm đủ 3 ngón cùng chạm xuống,
-- nên dù tay có hơi trượt/di chuyển sau đó, gesture vẫn được ghi nhận.
local activeTouches = {}
local activeCount = 0
local reachedRequired = false -- tránh đếm lặp khi vẫn còn giữ đủ 3 ngón

local function onGestureTap()
    local now = os.clock()

    if now - lastTapTime > TAP_WINDOW then
        tapCount = 0
    end

    tapCount += 1
    lastTapTime = now

    if tapCount >= REQUIRED_TAPS then
        tapCount = 0
        toggleMenu()
    end
end

UserInputService.TouchStarted:Connect(function(touch, gameProcessedEvent)
    if gameProcessedEvent then return end

    activeTouches[touch] = true
    activeCount += 1

    if activeCount == REQUIRED_FINGERS and not reachedRequired then
        reachedRequired = true
        onGestureTap()
    end
end)

UserInputService.TouchEnded:Connect(function(touch, _gameProcessedEvent)
    if activeTouches[touch] then
        activeTouches[touch] = nil
        activeCount = math.max(0, activeCount - 1)
    end

    if activeCount < REQUIRED_FINGERS then
        reachedRequired = false
    end
end)
