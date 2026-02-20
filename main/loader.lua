--// Anime Paradox Hub - Main Loader
--// โหลดทุกระบบ

local baseUrl = "https://raw.githubusercontent.com/ComeZl3acK/anime-paradox/main"

local function loadScript(path)
    local url = baseUrl .. path
    print("📦 Loading: " .. path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if not success then
        print("❌ Error loading " .. path .. ": " .. tostring(result))
    end
    return success
end

print("=" .. string.rep("=", 50))
print("🎮 Anime Paradox Hub V2.0 - Starting...")
print("=" .. string.rep("=", 50))

-- โหลด Settings ก่อน
loadScript("/utils/settings.lua")
task.wait(0.3)

-- โหลด Helpers
loadScript("/utils/helpers.lua")
task.wait(0.3)

-- โหลด Core Systems
loadScript("/scripts/core.lua")
task.wait(0.3)

-- โหลด Portal System
loadScript("/scripts/portal.lua")
task.wait(0.3)

-- โหลด Macro System
loadScript("/scripts/macro.lua")
task.wait(0.3)

-- โหลด UI (ทำให้สุดท้าย)
loadScript("/scripts/ui.lua")
task.wait(0.5)

print("=" .. string.rep("=", 50))
print("✅ Anime Paradox Hub Loaded Successfully!")
print("=" .. string.rep("=", 50))