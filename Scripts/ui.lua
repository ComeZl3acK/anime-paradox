--// UI System - Menu & Controls

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Create Main GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = getgenv().AP_Config.MenuName
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, getgenv().AP_Config.GuiWidth, 0, getgenv().AP_Config.GuiHeight)
frame.Position = UDim2.new(0, getgenv().AP_Config.GuiPosX, 0.5, -350)
frame.BackgroundColor3 = getgenv().AP_Colors.Dark
frame.BorderSizePixel = 0

local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundColor3 = getgenv().AP_Colors.Dark
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 900)
scrollFrame.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout", scrollFrame)
layout.Padding = UDim.new(0, 8)
layout.FillDirection = Enum.FillDirection.Vertical

-- Helper Functions
local function createSection(text)
    local lbl = Instance.new("TextLabel", scrollFrame)
    lbl.Size = UDim2.new(1, -10, 0, 28)
    lbl.BackgroundColor3 = getgenv().AP_Colors.DarkGray
    lbl.TextColor3 = getgenv().AP_Colors.Gold
    lbl.Text = text
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 16
    lbl.BorderSizePixel = 0
    return lbl
end

local function createToggle(text, key, callback)
    local btn = Instance.new("TextButton", scrollFrame)
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = getgenv().AP_Colors.DarkGray
    btn.TextColor3 = getgenv().AP_Colors.White
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 12
    btn.Text = text .. " : ❌ OFF"
    btn.BorderSizePixel = 0
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. " : " .. (state and "✅ ON" or "❌ OFF")
        btn.BackgroundColor3 = state and getgenv().AP_Colors.Green or getgenv().AP_Colors.DarkGray
        if callback then callback(state) end
        getgenv().AP_Settings[key] = state
    end)
    return btn
end

local function createButton(text, bgColor, callback)
    local btn = Instance.new("TextButton", scrollFrame)
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.BackgroundColor3 = bgColor
    btn.TextColor3 = getgenv().AP_Colors.White
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Text = text
    btn.BorderSizePixel = 0
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

local function createStatus(text)
    local lbl = Instance.new("TextLabel", scrollFrame)
    lbl.Size = UDim2.new(1, -10, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = getgenv().AP_Colors.Gold
    lbl.Text = text
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 11
    lbl.BorderSizePixel = 0
    return lbl
end

-- ========== HEADER SECTION ==========
createSection("🎮 ANIME PARADOX HUB V2.0")

-- ========== SYSTEM SECTION ==========
createSection("⚙️ SYSTEM")

createToggle("Anti AFK", "AntiAFK")
createToggle("Auto Start", "AutoStart")
createToggle("Auto Retry", "AutoRetry")

-- ========== PORTAL SECTION ==========
createSection("🚪 PORTAL SELECTOR")

local portalStatusLbl = createStatus("📍 Status: Not Selected")

local portalBtn = createButton("🔍 Select Portal", getgenv().AP_Colors.Blue, function(btn)
    local portals = getgenv().getAvailablePortals()
    
    if #portals == 0 then
        btn.Text = "❌ No Portals Available"
        portalStatusLbl.Text = "❌ No portals found for your level"
    else
        -- Cycle through portals
        local currentIndex = 1
        if getgenv().AP_Portal.selectedName then
            for i, name in ipairs(portals) do
                if name == getgenv().AP_Portal.selectedName then
                    currentIndex = (i % #portals) + 1
                    break
                end
            end
        end
        
        getgenv().selectPortalByIndex(currentIndex)
        btn.Text = "✅ Portal: " .. getgenv().AP_Portal.selectedName
        portalStatusLbl.Text = "📍 Selected: " .. getgenv().AP_Portal.selectedName
    end
end)

createToggle("Auto Go To Portal", "AutoPortal")

-- ========== MACRO SECTION ==========
createSection("🎥 MACRO RECORDER & PLAYBACK")

local macroStatusLbl = createStatus("📊 Status: Ready | Points: 0")

local recordBtn = createButton("⏺️ Start Recording", getgenv().AP_Colors.LightRed, function(btn)
    if not getgenv().AP_Macro.isRecording then
        getgenv().startMacroRecord()
        btn.Text = "⏹️ Stop Recording"
        btn.BackgroundColor3 = getgenv().AP_Colors.Red
        macroStatusLbl.Text = "📊 Status: 🔴 Recording... | Points: 0"
    else
        getgenv().stopMacroRecord()
        btn.Text = "⏺️ Start Recording"
        btn.BackgroundColor3 = getgenv().AP_Colors.LightRed
        macroStatusLbl.Text = "📊 Status: ✅ Stopped | Points: " .. getgenv().getMacroCount()
    end
end)

local playBtn = createButton("▶️ Play Macro", getgenv().AP_Colors.LightGreen, function(btn)
    if getgenv().AP_Macro.isPlaying then
        getgenv().AP_Macro.isPlaying = false
        btn.Text = "▶️ Play Macro"
        btn.BackgroundColor3 = getgenv().AP_Colors.LightGreen
    else
        if getgenv().getMacroCount() == 0 then
            macroStatusLbl.Text = "❌ No Macro Data"
            return
        end
        
        getgenv().playMacro()
        btn.Text = "⏸️ Playing..."
        btn.BackgroundColor3 = getgenv().AP_Colors.Green
        macroStatusLbl.Text = "📊 Status: ▶️ Playing Macro"
    end
end)

createButton("🗑️ Clear Macro", getgenv().AP_Colors.Red, function(btn)
    getgenv().clearMacro()
    macroStatusLbl.Text = "📊 Status: 🗑️ Cleared | Points: 0"
    recordBtn.Text = "⏺️ Start Recording"
    recordBtn.BackgroundColor3 = getgenv().AP_Colors.LightRed
end)

-- ========== INFO SECTION ==========
createSection("ℹ️ INFORMATION")

createStatus("Current Level: " .. getPlayerLevel())
createStatus("Macro Points: " .. getgenv().getMacroCount())
createStatus("Press F2 to toggle menu (in future update)")

-- ========== FOOTER ==========
createStatus("✨ Made by ComeZl3acK | Version 2.0")

print("✅ UI System Loaded")