--// Anime Paradox Helper Hub
--// Place in LocalScript (for learning/private testing)

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
    AutoPortal = false,
    Recording = false,
    PlayingMacro = false
}

local Macro = {}

-- =========================
-- 🖥️ SIMPLE GUI
-- =========================

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AP_Hub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 300)
frame.Position = UDim2.new(0, 20, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0,6)

local function createToggle(text, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text .. " : OFF"

    local state = false

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. " : " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

-- =========================
-- 🔘 GUI BUTTONS
-- =========================

createToggle("Anti AFK", function(v)
    getgenv().AP_Settings.AntiAFK = v
end)

createToggle("Auto Start", function(v)
    getgenv().AP_Settings.AutoStart = v
end)

createToggle("Auto Retry", function(v)
    getgenv().AP_Settings.AutoRetry = v
end)

createToggle("Auto Portal Select", function(v)
    getgenv().AP_Settings.AutoPortal = v
end)

createToggle("Record Macro", function(v)
    getgenv().AP_Settings.Recording = v
end)

createToggle("Play Macro", function(v)
    getgenv().AP_Settings.PlayingMacro = v
end)

-- =========================
-- 🛡️ ANTI AFK
-- =========================

task.spawn(function()
    while task.wait(60) do
        if getgenv().AP_Settings.AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end
end)

-- =========================
-- ▶️ AUTO START (EDIT REMOTE)
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
-- 🔁 AUTO RETRY (EDIT REMOTE)
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
-- 🚪 AUTO PORTAL SELECT
-- =========================

local function getNearestPortal()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local closest, dist = nil, math.huge

    for _,v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("portal") and v:IsA("BasePart") then
            local d = (char.HumanoidRootPart.Position - v.Position).Magnitude
            if d < dist then
                dist = d
                closest = v
            end
        end
    end

    return closest
end

task.spawn(function()
    while task.wait(2) do
        if getgenv().AP_Settings.AutoPortal then
            local portal = getNearestPortal()
            if portal and player.Character then
                player.Character:PivotTo(portal.CFrame + Vector3.new(0,3,0))
            end
        end
    end
end)

-- =========================
-- 🎥 MACRO RECORDER
-- =========================

mouse.Button1Down:Connect(function()
    if getgenv().AP_Settings.Recording then
        table.insert(Macro, {
            time = tick(),
            pos = mouse.Hit.Position
        })
        print("Recorded click")
    end
end)

task.spawn(function()
    while task.wait() do
        if getgenv().AP_Settings.PlayingMacro and #Macro > 0 then
            for _,step in ipairs(Macro) do
                if not getgenv().AP_Settings.PlayingMacro then break end

                if player.Character then
                    player.Character:PivotTo(CFrame.new(step.pos + Vector3.new(0,3,0)))
                end

                task.wait(0.5)
            end
        end
        task.wait(1)
    end
end)

print("✅ Anime Paradox Hub Loaded")
