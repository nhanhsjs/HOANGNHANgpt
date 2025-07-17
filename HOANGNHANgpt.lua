repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Khởi tạo GUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("HOANGNHANgpt v1.4", "Ocean")

--===[ ANTI BAN TAB ]===--
local tabAnti = Window:NewTab("Anti-Ban")
local sectionAnti = tabAnti:NewSection("Bảo vệ nhân vật")

sectionAnti:NewLabel("Tự động bật Anti-Ban")
pcall(function()
    -- Chống bị kick
    hookfunction(game.Players.LocalPlayer.Kick, function() return end)
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        if getnamecallmethod() == "Kick" then return end
        return old(self, unpack(args))
    end)
end)

--===[ AUTO FARM TAB ]===--
local tabFarm = Window:NewTab("Auto Farm")
local sectionFarm = tabFarm:NewSection("Level Farm (Sea 1)")

getgenv().AutoFarmLevel = false

sectionFarm:NewToggle("Auto Farm Level", "Farm từ LV1 đến 700", function(t)
    getgenv().AutoFarmLevel = t
end)

sectionFarm:NewToggle("Auto Attack", "Tự động đánh thường", function(t)
    getgenv().AutoAttack = t
end)

sectionFarm:NewSlider("Tốc độ bay", "Điều chỉnh tốc độ teleport", 300, 50, function(v)
    getgenv().FlySpeed = v
end)

--===[ TELEPORT TAB ]===--
local tabTP = Window:NewTab("Teleport")
local sectionTP = tabTP:NewSection("Đến các đảo bằng bay")

local islands = {
    ["Starter Island"] = CFrame.new(0, 20, 0),
    ["Jungle"] = CFrame.new(-1150, 50, 350),
    ["Desert"] = CFrame.new(1150, 50, 450),
    ["Frozen Village"] = CFrame.new(1200, 40, -1200),
    ["Marine Fortress"] = CFrame.new(-4500, 70, 4300),
    ["Sky Island"] = CFrame.new(-5000, 500, -100),
    ["Colosseum"] = CFrame.new(-1800, 60, 5400)
}

sectionTP:NewDropdown("Chọn đảo", "Bay đến đảo", table.keys(islands), function(sel)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local target = islands[sel]
        if target then
            local hrp = char.HumanoidRootPart
            for i = 1, 100 do
                hrp.CFrame = hrp.CFrame:Lerp(target, 0.05)
                wait(0.01)
            end
        end
    end
end)

--===[ GIAO DIỆN TAB ]===--
local tabUI = Window:NewTab("Giao diện")
local sectionUI = tabUI:NewSection("Tùy chỉnh giao diện")

sectionUI:NewKeybind("Ẩn/Hiện GUI", "Toggle GUI bằng RightCtrl", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

--===[ AUTO FARM ENGINE (basic) ]===--
spawn(function()
    while wait(0.5) do
        if getgenv().AutoFarmLevel then
            local char = game.Players.LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            -- Ví dụ mục tiêu: NPC "Bandit"
            local npc = workspace:FindFirstChild("Bandit")
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                repeat
                    local hrp = char.HumanoidRootPart
                    hrp.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                    if getgenv().AutoAttack then
                        pcall(function()
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                            wait(0.1)
                        end)
                    end
                    wait(0.2)
                until not npc.Parent or npc.Humanoid.Health <= 0 or not getgenv().AutoFarmLevel
            end
        end
    end
end)
