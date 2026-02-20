--// Core System - Anti AFK, Auto Start, Auto Retry

local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ========== ANTI AFK ==========
task.spawn(function()
    while task.wait(60) do
        if getgenv().AP_Settings.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
            debugLog("Anti AFK: Click")
        end
    end
end)

-- ========== AUTO START ==========
task.spawn(function()
    while task.wait(3) do
        if getgenv().AP_Settings.AutoStart then
            pcall(function()
                local remote = ReplicatedStorage:FindFirstChild("StartGame")
                if remote then
                    remote:FireServer()
                    debugLog("Auto Start: Fired")
                end
            end)
        end
    end
end)

-- ========== AUTO RETRY ==========
task.spawn(function()
    while task.wait(5) do
        if getgenv().AP_Settings.AutoRetry then
            pcall(function()
                local remote = ReplicatedStorage:FindFirstChild("Retry")
                if remote then
                    remote:FireServer()
                    debugLog("Auto Retry: Fired")
                end
            end)
        end
    end
end)

print("✅ Core System Loaded")