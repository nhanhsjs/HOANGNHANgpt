-- Banana ChatGPT Hub v1.3 - HOANGNHANgpt Edition
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

--==[ Anti-Ban System ]==--
local lp = game.Players.LocalPlayer
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if tostring(self):lower():find("kick") or tostring(args[1]):lower():find("kick") then
        return
    end
    return oldNamecall(self, unpack(args))
end)

task.spawn(function()
    while wait(1) do
        local char = lp.Character
        if char and not char:FindFirstChild("Humanoid") then
            Instance.new("Humanoid", char)
        end
    end
end)

pcall(function()
    for _, v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
        v:Disable()
    end
end)

--==[ Fullscreen Background (Yae Miko) ]==--
pcall(function()
    local bg = Instance.new("ImageLabel")
    bg.Name = "BananaChatGPT_BG"
    bg.Parent = game:GetService("CoreGui")
    bg.Image = "rbxassetid://17121804726" -- hình nền Yae Miko
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.Position = UDim2.new(0, 0, 0, 0)
    bg.BackgroundTransparency = 1
    bg.ImageTransparency = 0.2
    bg.ZIndex = 0
end)

--==[ GUI: Rayfield ]==--
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()
local Window = Rayfield:CreateWindow({
   Name = "Banana ChatGPT Hub v1.3",
   LoadingTitle = "BananaGPT Loading...",
   LoadingSubtitle = "by ChatGPT",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

--==[ Farm Tab ]==--
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

local function StartAutoFarm()
    getgenv().AutoFarm = true
    task.spawn(function()
        while getgenv().AutoFarm do
            pcall(function()
                local enemy = nil
                for i, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        enemy = v
                        break
                    end
                end

                if enemy then
                    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                        repeat task.wait()
                        until not enemy.Parent or enemy.Humanoid.Health <= 0 or not getgenv().AutoFarm
                    end
                else
                    task.wait(0.25)
                end
            end)
            task.wait()
        end
    end)
end

FarmTab:CreateToggle({
   Name = "Auto Farm Mobs",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().AutoFarm = Value
       if Value then StartAutoFarm() end
   end,
})

--==[ Teleport Tab (Fly Mode) ]==--
local function FlyTo(targetPos)
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1,1,1) * 1e9
    bv.Velocity = Vector3.zero
    bv.P = 1250
    bv.Parent = hrp

    local function dist() return (hrp.Position - targetPos).Magnitude end
    while dist() > 5 do
        if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
            bv:Destroy()
            return
        end
        local dir = (targetPos - hrp.Position).Unit
        bv.Velocity = dir * math.clamp(dist() * 2, 100, 300)
        task.wait()
    end

    bv:Destroy()
    hrp.CFrame = CFrame.new(targetPos)
end

local TP = Window:CreateTab("Teleport", 4483362458)

TP:CreateButton({
    Name = "Starter Island",
    Callback = function()
        FlyTo(Vector3.new(1145, 17, 1633)) -- Tọa độ ví dụ
    end,
})
