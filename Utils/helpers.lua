--// Helper Functions & Utilities

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ดึง Level ของ Player
function getPlayerLevel()
    local stats = player:FindFirstChild("leaderstats")
    if stats then
        local level = stats:FindFirstChild("Level")
        if level then
            return level.Value
        end
    end
    return 1
end

-- ดึง HumanoidRootPart
function getCharacterRootPart()
    if player.Character then
        return player.Character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

-- ดึง Humanoid
function getCharacterHumanoid()
    if player.Character then
        return player.Character:FindFirstChild("Humanoid")
    end
    return nil
end

-- Teleport ไปยังตำแหน่ง
function teleportToPosition(pos)
    local root = getCharacterRootPart()
    if root then
        root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
        return true
    end
    return false
end

-- ค้นหา Part ตามชื่อ
function findPartByName(name)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == name then
            return obj
        end
    end
    return nil
end

-- Log Debug
function debugLog(message)
    if getgenv().AP_Settings.Debug then
        print("[DEBUG] " .. tostring(message))
    end
end

debugLog("Helpers Loaded")