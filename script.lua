--// Anime Paradox Enhanced Helper Hub
--// ✨ Menu บรรใจ + Macro Record/Playback แยกชัดเจน + Portal เลือกจาก Level

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- =========================
-- ⚙️ GLOBAL SETTINGS
-- =========================
getgenv().AP_Settings = {
    AntiAFK = false,
    AutoStart = false,
    AutoRetry = false,
    AutoPortal = false
}

local Macro = {}
local isRecording = false
local isPlaying = false
local lastClickTime = tick()

-- =========================
-- 🖥️ ENHANCED GUI (Menu ใหม่สวย)
-- =========================

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AP_HubV2"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 340, 0, 700)
frame.Position = UDim2.new(0, 20, 0.5, -350)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.CanvasSize = UDim2.new(1, 0, 1, 0)

local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)

local layout = Instance.new("UIListLayout", scrollFrame)
layout.Padding = UDim.new(0, 8)
layout.FillDirection = Enum.FillDirection.Vertical

-- Function: สร้าง Label (หัวข้อ Section)
local function addSection(text)
    local lbl = Instance.new("TextLabel", scrollFrame)
    lbl.Size = UDim2.new(1, -10, 0, 28)
    lbl.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    lbl.TextColor3 = Color3.fromRGB(255, 200, 87)
    lbl.Text = text
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 16
    return lbl
end

-- Function: สร้าง Toggle Button
local function createToggle(text, callback)
    local btn = Instance.new("TextButton", scrollFrame)
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.Text = text .. " : OFF"

    local state = false

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. " : " .. (state and "✅ ON" or "❌ OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(47, 105, 52) or Color3.fromRGB(50, 50, 50)
        callback(state, btn)
    end)
    return btn
end

-- Function: สร้าง Button (Action)
local function createButton(text, bgColor, callback)
    local btn = Instance.new("TextButton", scrollFrame)
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.BackgroundColor3 = bgColor
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Text = text

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- =========================
-- 📋 HEADER
-- =========================
addSection("🎮 ANIME PARADOX HUB (ENHANCED)")

-- =========================
-- ⚙️ SYSTEM SECTION
-- =========================
addSection("⚙️ SYSTEM")

createToggle("Anti AFK", function(v)
    getgenv().AP_Settings.AntiAFK = v
end)

createToggle("Auto Start Game", function(v)
    getgenv().AP_Settings.AutoStart = v
end)

createToggle("Auto Retry", function(v)
    getgenv().AP_Settings.AutoRetry = v
end)

-- =========================
-- 🚪 PORTAL SELECTION SECTION
-- =========================
addSection("🚪 PORTAL SELECTOR")

-- Function: ดึง Level ของตัวละคร
local function getPlayerLevel()
    local stats = player:FindFirstChild("leaderstats")
    if stats then
        local level = stats:FindFirstChild("Level")
        if level then
            return level.Value
        end
    end
    return 1
end

-- Function: ดึง Portal ที่เหมาะสม
local availablePortals = {}
local selectedPortalName = nil

local function updateAvailablePortals()
    availablePortals = {}
    local currentLevel = getPlayerLevel()
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        -- ตัวอย่าง: Portal_Level10, Portal_Level20 เป็นต้น
        if obj:IsA("BasePart") and obj.Name:find("Portal_Level") then
            local levelMatch = tonumber(obj.Name:match("Level(%d+)"))
            if levelMatch and currentLevel >= levelMatch then
                table.insert(availablePortals, obj.Name)
            end
        end
    end
    
    table.sort(availablePortals)
end

-- Portal Selector Button
local portalBtn = createButton("🔍 เลือก Portal", Color3.fromRGB(63, 72, 204), function(btn)
    updateAvailablePortals()
    
    if #availablePortals == 0 then
        btn.Text = "❌ ไม่พบ Portal ที่เหมาะสม"
    else
        -- Cycle portal selection
        local currentIndex = 1
        if selectedPortalName then
            for i, name in ipairs(availablePortals) do
                if name == selectedPortalName then
                    currentIndex = (i % #availablePortals) + 1
                    break
                end
            end
        end
        selectedPortalName = availablePortals[currentIndex]
        btn.Text = "✅ Portal: " .. selectedPortalName
    end
end)

-- Status Portal
local portalStatusLbl = Instance.new("TextLabel", scrollFrame)
portalStatusLbl.Size = UDim2.new(1, -10, 0, 24)
portalStatusLbl.BackgroundTransparency = 1
portalStatusLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
portalStatusLbl.Text = "Status: Not selected"
portalStatusLbl.Font = Enum.Font.SourceSans
portalStatusLbl.TextSize = 11

-- Auto Portal Toggle
createToggle("Auto Go To Portal", function(v)
    getgenv().AP_Settings.AutoPortal = v
end)

-- =========================
-- 🎥 MACRO SECTION
-- =========================
addSection("🎥 MACRO RECORDER & PLAYBACK")

-- Status Label
local macroStatusLbl = Instance.new("TextLabel", scrollFrame)
macroStatusLbl.Size = UDim2.new(1, -10, 0, 28)
macroStatusLbl.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
macroStatusLbl.TextColor3 = Color3.fromRGB(144, 238, 144)
macroStatusLbl.Text = "📊 สถานะ: พร้อม | จุด: 0"
macroStatusLbl.Font = Enum.Font.SourceSans
macroStatusLbl.TextSize = 12

-- Record Button
local recordBtn = createButton("⏺️ เริ่มบันทึก Macro", Color3.fromRGB(100, 50, 50), function(btn)
    if not isRecording then
        Macro = {}
        isRecording = true
        lastClickTime = tick()
        btn.Text = "⏹️ หยุดบันทึก Macro"
        btn.BackgroundColor3 = Color3.fromRGB(150, 80, 80)
        macroStatusLbl.Text = "📊 สถานะ: 🔴 กำลังบันทึก | จุด: 0"
    else
        isRecording = false
        btn.Text = "⏺️ เริ่มบันทึก Macro"
        btn.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
        macroStatusLbl.Text = "📊 สถานะ: ✅ ��ยุดบันทึก | จุด: " .. #Macro
    end
end)

-- Playback Button
local playBtn = createButton("▶️ เล่น Macro", Color3.fromRGB(50, 100, 50), function(btn)
    if isPlaying or #Macro == 0 then
        macroStatusLbl.Text = "📊 สถานะ: ❌ ไม่มี Macro ในหน่วยความจำ"
        return
    end
    
    isPlaying = true
    btn.Text = "⏸️ กำลังเล่น..."
    btn.BackgroundColor3 = Color3.fromRGB(100, 150, 50)
    macroStatusLbl.Text = "📊 สถานะ: ▶️ กำลังเล่น Macro"
    
    for i, step in ipairs(Macro) do
        if not isPlaying then break end
        
        if player.Character and step.pos then
            player.Character:PivotTo(CFrame.new(step.pos + Vector3.new(0, 3, 0)))
        end
        
        -- รอเวลาจริงระหว่างจุด
        if Macro[i + 1] then
            task.wait(Macro[i + 1].t - step.t)
        else
            task.wait(0.3)
        end
    end
    
    isPlaying = false
    btn.Text = "▶️ เล่น Macro"
    btn.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
    macroStatusLbl.Text = "📊 สถานะ: ✅ เล่น Macro เสร็จ"
end)

-- Clear Macro Button
createButton("🗑️ ลบ Macro", Color3.fromRGB(100, 50, 50), function(btn)
    Macro = {}
    macroStatusLbl.Text = "📊 สถานะ: 🗑️ ลบ Macro แล้ว | จุด: 0"
end)

-- =========================
-- 🛡️ ANTI AFK LOGIC
-- =========================

task.spawn(function()
    while task.wait(60) do
        if getgenv().AP_Settings.AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            print("🛡️ Anti AFK: Active")
        end
    end
end)

-- =========================
-- ▶️ AUTO START LOGIC
-- =========================

task.spawn(function()
    while task.wait(3) do
        if getgenv().AP_Settings.AutoStart then
            local remote = ReplicatedStorage:FindFirstChild("StartGame")
            if remote then
                remote:FireServer()
            end
        end
    end
end)

-- =========================
-- 🔁 AUTO RETRY LOGIC
-- =========================

task.spawn(function()
    while task.wait(5) do
        if getgenv().AP_Settings.AutoRetry then
            local remote = ReplicatedStorage:FindFirstChild("Retry")
            if remote then
                remote:FireServer()
            end
        end
    end
end)

-- =========================
-- 🎥 MACRO RECORDING LOGIC
-- =========================

mouse.Button1Down:Connect(function()
    if isRecording then
        local currentTime = tick()
        local clickPos = mouse.Hit and mouse.Hit.Position or nil
        
        if clickPos then
            table.insert(Macro, {
                t = currentTime,
                pos = clickPos
            })
            
            macroStatusLbl.Text = "📊 สถานะ: 🔴 กำลังบันทึก | จุด: " .. #Macro
            print("✏️ Record: " .. #Macro .. " clicks")
        end
    end
end)

-- =========================
-- 🚪 AUTO PORTAL LOGIC
-- =========================

local function getSelectedPortalPart()
    if not selectedPortalName then return nil end
    
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == selectedPortalName then
            return v
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(2) do
        if getgenv().AP_Settings.AutoPortal then
            local portal = getSelectedPortalPart()
            if portal and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character:PivotTo(portal.CFrame + Vector3.new(0, 3, 0))
                portalStatusLbl.Text = "Status: ✅ Teleported to " .. selectedPortalName
            end
        end
    end
end)

-- =========================
-- ✅ STARTUP
-- =========================

print("✨ Anime Paradox Enhanced Hub V2 Loaded")
print("📍 Current Level: " .. getPlayerLevel())
