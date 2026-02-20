--// Global Settings & Configuration

getgenv().AP_Settings = {
    AntiAFK = false,
    AutoStart = false,
    AutoRetry = false,
    AutoPortal = false,
    Debug = true
}

getgenv().AP_Colors = {
    Dark = Color3.fromRGB(30, 30, 30),
    DarkGray = Color3.fromRGB(50, 50, 50),
    MediumGray = Color3.fromRGB(70, 70, 70),
    Green = Color3.fromRGB(47, 105, 52),
    LightGreen = Color3.fromRGB(76, 175, 80),
    Red = Color3.fromRGB(100, 50, 50),
    LightRed = Color3.fromRGB(244, 67, 54),
    Blue = Color3.fromRGB(63, 72, 204),
    Gold = Color3.fromRGB(255, 200, 87),
    White = Color3.new(1, 1, 1)
}

getgenv().AP_Config = {
    GuiWidth = 340,
    GuiHeight = 700,
    GuiPosX = 20,
    ToggleKeycode = Enum.KeyCode.F2,
    MenuName = "AP_HubV2"
}

if getgenv().AP_Settings.Debug then
    print("✅ Settings Loaded")
end