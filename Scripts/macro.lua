--// Macro System - Record & Playback

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

getgenv().AP_Macro = {
    data = {},
    isRecording = false,
    isPlaying = false,
    recordCount = 0
}

-- เริ่มบันทึก Macro
getgenv().startMacroRecord = function()
    if getgenv().AP_Macro.isRecording then
        print("⚠️ Already Recording!")
        return
    end
    
    getgenv().AP_Macro.data = {}
    getgenv().AP_Macro.isRecording = true
    getgenv().AP_Macro.recordCount = 0
    print("🔴 Macro Recording Started - Click to Record")
end

-- หยุดบันทึก Macro
getgenv().stopMacroRecord = function()
    if not getgenv().AP_Macro.isRecording then
        print("⚠️ Not Recording!")
        return
    end
    
    getgenv().AP_Macro.isRecording = false
    print("✅ Macro Recording Stopped - " .. #getgenv().AP_Macro.data .. " Points Recorded")
end

-- เล่น Macro
getgenv().playMacro = function()
    if getgenv().AP_Macro.isPlaying then
        print("⚠️ Macro Already Playing!")
        return
    end
    
    if #getgenv().AP_Macro.data == 0 then
        print("❌ No Macro Data")
        return
    end
    
    getgenv().AP_Macro.isPlaying = true
    print("▶️ Macro Playback Started")
    
    for i, step in ipairs(getgenv().AP_Macro.data) do
        if not getgenv().AP_Macro.isPlaying then
            print("⏹️ Macro Playback Stopped")
            break
        end
        
        if player.Character and step.pos then
            player.Character:PivotTo(CFrame.new(step.pos + Vector3.new(0, 3, 0)))
        end
        
        -- รอเวลาจริงระหว่างจุด
        if getgenv().AP_Macro.data[i + 1] then
            local waitTime = getgenv().AP_Macro.data[i + 1].t - step.t
            if waitTime > 0 then
                task.wait(waitTime)
            end
        else
            task.wait(0.3)
        end
    end
    
    getgenv().AP_Macro.isPlaying = false
    print("✅ Macro Playback Finished")
end

-- ลบ Macro
getgenv().clearMacro = function()
    getgenv().AP_Macro.data = {}
    getgenv().AP_Macro.recordCount = 0
    getgenv().AP_Macro.isRecording = false
    getgenv().AP_Macro.isPlaying = false
    print("🗑️ Macro Cleared")
end

-- ได้จำนวน Points ใน Macro
getgenv().getMacroCount = function()
    return #getgenv().AP_Macro.data
end

-- บันทึก Click ตอน Recording
mouse.Button1Down:Connect(function()
    if getgenv().AP_Macro.isRecording then
        local currentTime = tick()
        local clickPos = mouse.Hit and mouse.Hit.Position or nil
        
        if clickPos then
            table.insert(getgenv().AP_Macro.data, {
                t = currentTime,
                pos = clickPos
            })
            getgenv().AP_Macro.recordCount = #getgenv().AP_Macro.data
            debugLog("✏️ Recorded Click #" .. getgenv().AP_Macro.recordCount)
        end
    end
end)

print("✅ Macro System Loaded")