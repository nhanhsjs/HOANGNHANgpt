repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Tải Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

local Window = Rayfield:CreateWindow({
    Name = "HOANGNHANgpt v1.4",
    LoadingTitle = "HOANGNHANgpt Hub",
    LoadingSubtitle = "Delta Android Premium",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

--===[ ANTI BAN TAB ]===--
local TabAnti = Window:CreateTab("Anti-Ban")
TabAnti:CreateParagraph({
    Title = "Anti-Ban",
    Content = "Chống Kick, phá GUI, Remote nguy hiểm."
})

pcall(function()
    hookfunction(game.Players.LocalPlayer.Kick, function() return end)
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then return end
        return old(self, unpack(args))
    end)
end)

--===[ AUTO FARM TAB ]===--
local TabFarm = Window:CreateTab("Auto Farm")
TabFarm:CreateSection("Farm Level")

getgenv().AutoFarmLevel = false
getgenv().AutoAttack = false
getgenv().FlySpeed = 150

TabFarm:CreateToggle({
    Name = "Auto Farm Level",
    CurrentValue = false,
    Callback = function(v)
        getgenv().AutoFarmLevel = v
    end
})

TabFarm:CreateToggle({
    Name = "Auto Attack",
    CurrentValue = false,
    Callback = function(v)
        getgenv().AutoAttack = v
    end
})

TabFarm:CreateSlider({
    Name = "Tốc độ bay",
    Range = {50, 300},
    Increment = 10,
    CurrentValue = 150,
    Callback = function(v)
        getgenv().FlySpeed = v
    end
})

--===[ TELEPORT TAB ]===--
local TabTP = Window:CreateTab("Teleport")
TabTP:CreateSection("Bay đến các đảo")

local islands = {
    ["Starter Island"] = CFrame.new(0, 20, 0),
    ["Jungle"] = CFrame.new(-1150, 50, 350),
    ["Desert"] = CFrame.new(1150, 50, 450),
    ["Frozen Village"] = CFrame.new(1200, 40, -1200),
    ["Marine Fortress"] = CFrame.new(-4500, 70, 4300),
    ["Sky Island"] = CFrame.new(-5000, 500, -100),
    ["Colosseum"] = CFrame.new(-1800, 60, 5400)
}

TabTP:CreateDropdown({
    Name = "Chọn đảo cần đến",
    Options = table.pack(unpack((function()
        local list = {}
        for k in pairs(islands) do table.insert(list, k) end
        return list
    end)())),
    CurrentOption = "Starter Island",
    Callback = function(option)
        local target = islands[option]
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if target and hrp then
            for i = 1, 100 do
                hrp.CFrame = hrp.CFrame:Lerp(target, 0.05)
                wait(0.01)
            end
        end
    end
})

--===[ GIAO DIỆN TAB ]===--
local TabUI = Window:CreateTab("Giao Diện")
TabUI:CreateParagraph({
    Title = "GUI",
    Content = "GUI Rayfield hỗ trợ kéo, theme mặc định."
})
TabUI:CreateButton({
    Name = "Ẩn/Hiện GUI (RightCtrl)",
    Callback = function()
        Rayfield:Toggle()
    end
})

--===[ AUTO FARM ENGINE ]===--
spawn(function()
    while wait(0.5) do
        if getgenv().AutoFarmLevel then
            local char = game.Players.LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            local npc = workspace:FindFirstChild("Bandit") -- Demo enemy
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                repeat
                    local hrp = char.HumanoidRootPart
                    hrp.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                    if getgenv().AutoAttack then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                        wait(0.1)
                    end
                    wait(0.2)
                until not npc.Parent or npc.Humanoid.Health <= 0 or not getgenv().AutoFarmLevel
            end
        end
    end
end)
