-- HOANGNHANgpt v1.4 - Full Script (Sea 1 Auto Farm Level + GUI + Anti-Ban + Teleport Bay)

--// Anti-Ban
pcall(function()
    local lp = game:GetService("Players").LocalPlayer
    if lp and lp.Character then
        for _, v in ipairs(lp.Character:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                v:Destroy()
            end
        end
    end
end)

--// Toggle Button
local toggleBtn = Instance.new("TextButton", game.CoreGui)
toggleBtn.Size = UDim2.new(0, 100, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Mở Hub"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 16
toggleBtn.Visible = true

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "HOANGNHANgptHub"
gui.Enabled = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 350, 0, 300)
main.Position = UDim2.new(0.5, -175, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "HOANGNHANgpt v1.4"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

--// Tabs
local function createTabButton(name, posX)
    local btn = Instance.new("TextButton", main)
    btn.Position = UDim2.new(0, posX, 0, 50)
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    btn.TextColor3 = Color3.new(1, 1, 1)
    return btn
end

local tabAuto = createTabButton("Auto", 10)
local tabLevel = createTabButton("Farm Level", 120)
local tabTP = createTabButton("Teleport", 230)

--// Tab Contents
local function createTabContent()
    local tab = Instance.new("Frame", main)
    tab.Position = UDim2.new(0, 10, 0, 90)
    tab.Size = UDim2.new(1, -20, 1, -100)
    tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tab.Visible = false
    return tab
end

local autoTab = createTabContent()
local levelTab = createTabContent()
local tpTab = createTabContent()

local function showTab(tab)
    autoTab.Visible = false
    levelTab.Visible = false
    tpTab.Visible = false
    tab.Visible = true
end

tabAuto.MouseButton1Click:Connect(function() showTab(autoTab) end)
tabLevel.MouseButton1Click:Connect(function() showTab(levelTab) end)
tabTP.MouseButton1Click:Connect(function() showTab(tpTab) end)
showTab(autoTab)

--// Auto Farm Thường
local afBtn = Instance.new("TextButton", autoTab)
afBtn.Size = UDim2.new(1, -20, 0, 40)
afBtn.Position = UDim2.new(0, 10, 0, 10)
afBtn.Text = "Bật Auto Farm"
afBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
afBtn.TextColor3 = Color3.new(1, 1, 1)
afBtn.TextSize = 18

local autoFarm = false
afBtn.MouseButton1Click:Connect(function()
    autoFarm = not autoFarm
    afBtn.Text = autoFarm and "Tắt Auto Farm" or "Bật Auto Farm"
    local lp = game.Players.LocalPlayer
    spawn(function()
        while autoFarm do
            local enemies = workspace:FindFirstChild("Enemies")
            local enemy = enemies and enemies:FindFirstChildWhichIsA("Model")
            if enemy and enemy:FindFirstChild("HumanoidRootPart") and lp.Character then
                lp.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                local vim = game:GetService("VirtualInputManager")
                vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                wait(0.05)
                vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end
            wait(0.2)
        end
    end)
end)

--// Auto Farm Theo Level
local levelBtn = Instance.new("TextButton", levelTab)
levelBtn.Size = UDim2.new(1, -20, 0, 40)
levelBtn.Position = UDim2.new(0, 10, 0, 10)
levelBtn.Text = "Bật Auto Farm Level"
levelBtn.BackgroundColor3 = Color3.fromRGB(180, 130, 0)
levelBtn.TextColor3 = Color3.new(1, 1, 1)
levelBtn.TextSize = 18

local farmingLevel = false
levelBtn.MouseButton1Click:Connect(function()
    farmingLevel = not farmingLevel
    levelBtn.Text = farmingLevel and "Tắt Farm Level" or "Bật Auto Farm Level"
    local lp = game.Players.LocalPlayer
    spawn(function()
        while farmingLevel do
            local level = lp:FindFirstChild("Data") and lp.Data:FindFirstChild("Level") and lp.Data.Level.Value
            local mobName, mobPos
            if level then
                if level < 10 then mobName = "Bandit"; mobPos = CFrame.new(1149, 17, 1633)
                elseif level < 30 then mobName = "Monkey"; mobPos = CFrame.new(-1615, 35, 145)
                elseif level < 60 then mobName = "Gorilla"; mobPos = CFrame.new(-1323, 80, -522)
                elseif level < 90 then mobName = "Pirate"; mobPos = CFrame.new(-4950, 20, 3950)
                elseif level < 120 then mobName = "Brute"; mobPos = CFrame.new(-1143, 15, 4325)
                elseif level < 150 then mobName = "Desert Bandit"; mobPos = CFrame.new(1056, 6, 4487)
                elseif level < 175 then mobName = "Desert Officer"; mobPos = CFrame.new(1572, 10, 4373)
                elseif level < 200 then mobName = "Snow Bandit"; mobPos = CFrame.new(1357, 87, -1326)
                elseif level < 225 then mobName = "Snowman"; mobPos = CFrame.new(1224, 144, -1650)
                elseif level < 275 then mobName = "Chief Petty Officer"; mobPos = CFrame.new(-4855, 20, 4300)
                elseif level < 300 then mobName = "Sky Bandit"; mobPos = CFrame.new(-4981, 718, -2625)
                elseif level < 325 then mobName = "Dark Master"; mobPos = CFrame.new(-5252, 384, -2340)
                elseif level < 375 then mobName = "Toga Warrior"; mobPos = CFrame.new(-7950, 5606, -2272)
                elseif level < 400 then mobName = "Gladiator"; mobPos = CFrame.new(-7842, 5636, -1837)
                elseif level < 450 then mobName = "Military Soldier"; mobPos = CFrame.new(-5412, 85, 8447)
                elseif level < 475 then mobName = "Military Spy"; mobPos = CFrame.new(-5077, 70, 8487)
                elseif level < 500 then mobName = "Fishman Warrior"; mobPos = CFrame.new(6183, 19, -6880)
                elseif level < 525 then mobName = "Fishman Commando"; mobPos = CFrame.new(6267, 19, -7195)
                elseif level < 550 then mobName = "God's Guard"; mobPos = CFrame.new(-4607, 867, -1666)
                elseif level < 625 then mobName = "Shanda"; mobPos = CFrame.new(-7677, 5606, -2315)
                elseif level < 650 then mobName = "Royal Squad"; mobPos = CFrame.new(-7822, 5607, -2668)
                elseif level < 700 then mobName = "Royal Soldier"; mobPos = CFrame.new(-7882, 5606, -2894)
                else mobName = "Galley Pirate"; mobPos = CFrame.new(5554, 72, 3933)
                end
            end

            if mobName and mobPos then
                lp.Character.HumanoidRootPart.CFrame = mobPos + Vector3.new(0, 20, 0)
                local enemies = workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, enemy in ipairs(enemies:GetChildren()) do
                        if enemy.Name:match(mobName) and enemy:FindFirstChild("HumanoidRootPart") then
                            repeat
                                if not farmingLevel then break end
                                lp.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                                local vim = game:GetService("VirtualInputManager")
                                vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                wait(0.05)
                                vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                                wait(0.2)
                            until not enemy or not enemy:FindFirstChild("Humanoid") or enemy.Humanoid.Health <= 0
                        end
                    end
                end
            end
            wait(0.5)
        end
    end)
end)

--// Teleport Bay
local tpBtn = Instance.new("TextButton", tpTab)
tpBtn.Size = UDim2.new(1, -20, 0, 40)
tpBtn.Position = UDim2.new(0, 10, 0, 10)
tpBtn.Text = "Bay đến đảo chính"
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.TextSize = 18

tpBtn.MouseButton1Click:Connect(function()
    local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local island = workspace:FindFirstChild("MainIsland") or workspace:FindFirstChild("Island 1")
    if root and island and island:IsA("BasePart") then
        for i = 1, 50 do
            root.CFrame = root.CFrame:Lerp(island.CFrame * CFrame.new(0, 10, 0), 0.1)
            wait()
        end
    end
end)

--// Toggle GUI
toggleBtn.MouseButton1Click:Connect(function()
    gui.Enabled = not gui.Enabled
    toggleBtn.Text = gui.Enabled and "Ẩn Hub" or "Mở Hub"
end)
