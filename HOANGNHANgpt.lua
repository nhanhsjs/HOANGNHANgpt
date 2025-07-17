repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

--===[ Khởi tạo GUI Custom ]===--
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "HOANGNHANgpt_UI"
gui.ResetOnSpawn = false

--===[ Frame chính ]===--
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 350)
frame.Position = UDim2.new(0.5, -210, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

--===[ Tiêu đề ]===--
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Text = "HOANGNHANgpt v1.4.2 - GUI Custom"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold

--===[ Nút đóng mở GUI ]===--
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

--===[ Tabs khung nhỏ bên trong ]===--
local tabs = {"Auto Farm", "Teleport", "Anti-Ban"}
local currentTab = nil
local contentFrames = {}

local function switchTab(tabName)
    for k,v in pairs(contentFrames) do
        v.Visible = (k == tabName)
    end
end

--===[ Thanh chọn tab ]===--
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

    --===[ Nội dung từng tab ]===--

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

    if tabName == "Teleport" then
        local islands = {
            ["Starter"] = CFrame.new(0, 20, 0),
            ["Jungle"] = CFrame.new(-1150, 50, 350),
            ["Desert"] = CFrame.new(1150, 50, 450)
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
                local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for i = 1, 100 do
                        hrp.CFrame = hrp.CFrame:Lerp(cf, 0.02) -- ✅ Giảm tốc độ bay
                        wait(0.015)
                    end
                end
            end)
        end
    end

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

--===[ Auto Farm Script ]===--
spawn(function()
    while task.wait(0.5) do
        if getgenv().AutoFarmLevel then
            local char = game.Players.LocalPlayer.Character
            if not char then continue end
            local npc = workspace:FindFirstChild("Bandit")
            if npc and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChildOfClass("Humanoid") then
                repeat
                    char:FindFirstChild("HumanoidRootPart").CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
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
        local method = getnamecallmethod()
        if method == "Kick" then return end
        return old(self, ...)
    end)
end)

--===[ Bật tab đầu tiên mặc định ]===--
switchTab("Auto Farm")
