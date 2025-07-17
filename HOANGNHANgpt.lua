repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

--===[ GUI Custom ]===--
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "HOANGNHANgpt_UI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 350)
frame.Position = UDim2.new(0.5, -210, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Text = "HOANGNHANgpt v1.4.5 - Bay Liên Tục Cao"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Ẩn/Hiện GUI"
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BorderSizePixel = 0
toggleBtn.TextScaled = true

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Tabs
local tabs = {"Auto Farm", "Teleport", "Anti-Ban"}
local contentFrames = {}

local function switchTab(tabName)
    for k,v in pairs(contentFrames) do
        v.Visible = (k == tabName)
    end
end

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 120, 0, 30)
    btn.Position = UDim2.new(0, 10 + (i-1)*130, 0, 50)
    btn.Text = tabName
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.BorderSizePixel = 0

    local content = Instance.new("Frame", frame)
    content.Size = UDim2.new(1, -20, 1, -100)
    content.Position = UDim2.new(0, 10, 0, 90)
    content.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    content.Visible = false
    contentFrames[tabName] = content

    btn.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)

    -- Nội dung Auto Farm
    if tabName == "Auto Farm" then
        getgenv().AutoFarmLevel = false
        getgenv().AutoAttack = false

        local farmBtn = Instance.new("TextButton", content)
        farmBtn.Size = UDim2.new(1, -20, 0, 40)
        farmBtn.Position = UDim2.new(0, 10, 0, 10)
        farmBtn.Text = "Auto Farm Level: OFF"
        farmBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        farmBtn.TextColor3 = Color3.new(1,1,1)
        farmBtn.TextScaled = true
        farmBtn.MouseButton1Click:Connect(function()
            getgenv().AutoFarmLevel = not getgenv().AutoFarmLevel
            farmBtn.Text = "Auto Farm Level: " .. (getgenv().AutoFarmLevel and "ON" or "OFF")
        end)

        local atkBtn = Instance.new("TextButton", content)
        atkBtn.Size = UDim2.new(1, -20, 0, 40)
        atkBtn.Position = UDim2.new(0, 10, 0, 60)
        atkBtn.Text = "Auto Attack (Z): OFF"
        atkBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        atkBtn.TextColor3 = Color3.new(1,1,1)
        atkBtn.TextScaled = true
        atkBtn.MouseButton1Click:Connect(function()
            getgenv().AutoAttack = not getgenv().AutoAttack
            atkBtn.Text = "Auto Attack (Z): " .. (getgenv().AutoAttack and "ON" or "OFF")
        end)
    end

    -- Nội dung Teleport
    if tabName == "Teleport" then
        getgenv().Teleporting = false
        local islands = {
            ["Starter"] = CFrame.new(0, 50, 0),
            ["Jungle"] = CFrame.new(-1150, 100, 350),
            ["Desert"] = CFrame.new(1150, 80, 450)
        }

        for island, cf in pairs(islands) do
            local btn = Instance.new("TextButton", content)
            btn.Size = UDim2.new(1, -20, 0, 30)
            btn.Position = UDim2.new(0, 10, 0, 10 + (#content:GetChildren()-1)*35)
            btn.Text = "Bay tới: "..island
            btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.TextScaled = true

            btn.MouseButton1Click:Connect(function()
                getgenv().Teleporting = true
                spawn(function()
                    local char = game.Players.LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    while getgenv().Teleporting and hrp and (hrp.Position - cf.Position).Magnitude > 10 do
                        hrp.CFrame = hrp.CFrame:Lerp(cf, 0.01) + Vector3.new(0,3,0)
                        wait(0.03)
                    end
                    getgenv().Teleporting = false
                end)
            end)
        end
    end

    -- Nội dung Anti-Ban
    if tabName == "Anti-Ban" then
        local info = Instance.new("TextLabel", content)
        info.Size = UDim2.new(1, -20, 1, -20)
        info.Position = UDim2.new(0, 10, 0, 10)
        info.Text = "Anti-Kick, phá GUI, remote nguy hiểm đã được bật."
        info.TextWrapped = true
        info.TextColor3 = Color3.new(1,1,1)
        info.BackgroundTransparency = 1
        info.TextScaled = true
    end
end

--===[ Auto Farm Logic ]===--
spawn(function()
    while wait(0.5) do
        if getgenv().AutoFarmLevel then
            local char = game.Players.LocalPlayer.Character
            if not char then continue end
            local npc = workspace:FindFirstChild("Bandit")
            if npc and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChildOfClass("Humanoid") then
                repeat
                    char.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                    if getgenv().AutoAttack then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                    end
                    wait(0.2)
                until npc.Humanoid.Health <= 0 or not npc:IsDescendantOf(workspace) or not getgenv().AutoFarmLevel
            end
        end
    end
end)

--===[ Anti Ban ]===--
pcall(function()
    hookfunction(game.Players.LocalPlayer.Kick, function() return end)
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "Kick" then return end
        return old(self, ...)
    end)
end)

-- Mặc định bật tab đầu
switchTab("Auto Farm")
