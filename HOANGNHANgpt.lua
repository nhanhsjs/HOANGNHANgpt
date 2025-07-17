-- HOANGNHANgpt v1.3 - Delta Android | Giao diện đơn giản, tối ưu, có kéo thả

-- [1] Anti-ban cơ bản
local lp = game:GetService("Players").LocalPlayer
if lp and lp.Character then
    for _, v in ipairs(lp.Character:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            pcall(function() v:Destroy() end)
        end
    end
end

-- [2] GUI - Giao diện đơn giản
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "HOANGNHANgptHub"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 260)
frame.Position = UDim2.new(0.5, -150, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "HOANGNHANgpt v1.3"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- [3] Nút Auto Farm
local afBtn = Instance.new("TextButton", frame)
afBtn.Size = UDim2.new(1, -20, 0, 40)
afBtn.Position = UDim2.new(0, 10, 0, 60)
afBtn.Text = "Bật Auto Farm"
afBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
afBtn.TextColor3 = Color3.new(1, 1, 1)
afBtn.Font = Enum.Font.SourceSans
afBtn.TextSize = 18

-- [4] Nút Teleport bay
local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(1, -20, 0, 40)
tpBtn.Position = UDim2.new(0, 10, 0, 110)
tpBtn.Text = "Bay đến Đảo Chính"
tpBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.Font = Enum.Font.SourceSans
tpBtn.TextSize = 18

-- [5] Nút Thoát Hub
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(1, -20, 0, 40)
closeBtn.Position = UDim2.new(0, 10, 0, 210)
closeBtn.Text = "Đóng Hub"
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSans
closeBtn.TextSize = 18

-- [6] Chức năng Auto Farm
local autoFarm = false
afBtn.MouseButton1Click:Connect(function()
    autoFarm = not autoFarm
    afBtn.Text = autoFarm and "Tắt Auto Farm" or "Bật Auto Farm"
    spawn(function()
        while autoFarm do
            local enemyFolder = workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("NPCs")
            local enemy = enemyFolder and enemyFolder:FindFirstChildWhichIsA("Model")
            if enemy and enemy:FindFirstChild("HumanoidRootPart") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
            end
            wait(0.15)
        end
    end)
end)

-- [7] Chức năng Teleport Bay (chống kick)
tpBtn.MouseButton1Click:Connect(function()
    local target = workspace:FindFirstChild("MainIsland") or workspace:FindFirstChild("Island 1")
    if target and target:IsA("BasePart") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local root = lp.Character.HumanoidRootPart
        spawn(function()
            for i = 1, 50 do
                root.CFrame = root.CFrame:Lerp(target.CFrame * CFrame.new(0, 10, 0), 0.1)
                wait()
            end
        end)
    end
end)

-- [8] Đóng hub
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
