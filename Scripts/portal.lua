--// Portal System - Select & Auto Teleport

local Players = game:GetService("Players")
local player = Players.LocalPlayer

getgenv().AP_Portal = {
    selectedName = nil,
    availableList = {},
}

-- อัปเดตรายการพอร์ทัลที่ใช้ได้
local function updateAvailablePortals()
    getgenv().AP_Portal.availableList = {}
    local currentLevel = getPlayerLevel()
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:find("Portal_Level") then
            local levelMatch = tonumber(obj.Name:match("Level(%d+)"))
            if levelMatch and currentLevel >= levelMatch then
                table.insert(getgenv().AP_Portal.availableList, obj.Name)
            end
        end
    end
    
    table.sort(getgenv().AP_Portal.availableList)
    debugLog("Portals Found: " .. #getgenv().AP_Portal.availableList)
    return getgenv().AP_Portal.availableList
end

-- เลือกพอร์ทัลโดยชื่อ
getgenv().selectPortal = function(portalName)
    updateAvailablePortals()
    if table.find(getgenv().AP_Portal.availableList, portalName) then
        getgenv().AP_Portal.selectedName = portalName
        debugLog("Portal Selected: " .. portalName)
        return true
    end
    return false
end

-- เลือกพอร์ทัลโดย Index
getgenv().selectPortalByIndex = function(index)
    updateAvailablePortals()
    local list = getgenv().AP_Portal.availableList
    if index > 0 and index <= #list then
        getgenv().AP_Portal.selectedName = list[index]
        debugLog("Portal Selected (Index " .. index .. "): " .. list[index])
        return true
    end
    return false
end

-- ไปยังพอร์ทัลที่เลือก
getgenv().goToPortal = function()
    if not getgenv().AP_Portal.selectedName then
        print("❌ No Portal Selected")
        return false
    end
    
    local portal = findPartByName(getgenv().AP_Portal.selectedName)
    if portal then
        teleportToPosition(portal.Position)
        debugLog("Teleported to: " .. getgenv().AP_Portal.selectedName)
        return true
    end
    return false
end

-- ดึงรายการพอร์ทัลที่ใช้ได้
getgenv().getAvailablePortals = function()
    return updateAvailablePortals()
end

-- Auto Portal Teleport Loop
task.spawn(function()
    while task.wait(2) do
        if getgenv().AP_Settings.AutoPortal and getgenv().AP_Portal.selectedName then
            pcall(function()
                local portal = findPartByName(getgenv().AP_Portal.selectedName)
                if portal and player.Character then
                    player.Character:PivotTo(portal.CFrame + Vector3.new(0, 3, 0))
                    debugLog("Auto Portal: Teleported")
                end
            end)
        end
    end
end)

print("✅ Portal System Loaded")