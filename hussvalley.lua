-- OLIVER Hub for Huss Valley (Exact Speed Flight & No Early Jump)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- 🛡 ប្រព័ន្ធការពារ Anti-Kick / Anti-Cheat Hook
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if tostring(method) == "Kick" or tostring(method) == "kick" then
            return 
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)

-- 📌 ព័ត៌មានរូបភាពរបស់អ្នក
local LOGO_ID = "rbxassetid://131522091567355"     
local BG_IMAGE_ID = "rbxassetid://132347212228560" 

-- លុប UI ចាស់ចោលសិនដើម្បីកុំឱ្យជាន់គ្នា
if CoreGui:FindFirstChild("OliverHussValleyHub") then
    CoreGui.OliverHussValleyHub:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OliverHussValleyHub"
screenGui.Parent = CoreGui

-- ប៊ូតុងអណ្តែត (ImageButton) ជាមួយ Logo ID
local openBtn = Instance.new("ImageButton")
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
openBtn.Image = LOGO_ID
openBtn.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openBtn

-- ផ្ទាំងមេ (Main Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 160)
mainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- 🖼️ Background Image សម្រាប់ Main Frame
local bgImage = Instance.new("ImageLabel")
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = BG_IMAGE_ID
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ZIndex = 1
bgImage.Parent = mainFrame

-- ចំណងជើង Hub (សម្រាប់អូសផ្ទាំងមេ)
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BackgroundTransparency = 0.4
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Text = "OLIVER HUB"
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 12
titleBar.ZIndex = 2
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- ប៊ូតុង Auto
local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(0, 200, 0, 45)
autoBtn.Position = UDim2.new(0, 10, 0, 55)
autoBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
autoBtn.BackgroundTransparency = 0.3
autoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBtn.Text = "Auto: OFF"
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextSize = 14
autoBtn.ZIndex = 2
autoBtn.Parent = mainFrame

local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0, 8)
autoCorner.Parent = autoBtn

-- ប្រព័ន្ធអូសប៊ូតុងអណ្តែត
local buttonDragging = false
local buttonDragStart
local buttonStartPos
local buttonMoved = false
local activeButtonInput

openBtn.Active = true
openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        buttonDragging = true
        buttonMoved = false
        activeButtonInput = input
        buttonDragStart = input.Position
        buttonStartPos = openBtn.Position
    end
end)

openBtn.InputEnded:Connect(function(input)
    if input == activeButtonInput or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        buttonDragging = false
        activeButtonInput = nil
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not buttonDragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end

    local delta = input.Position - buttonDragStart
    if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
        buttonMoved = true
    end

    openBtn.Position = UDim2.new(
        buttonStartPos.X.Scale, buttonStartPos.X.Offset + delta.X,
        buttonStartPos.Y.Scale, buttonStartPos.Y.Offset + delta.Y
    )
end)

openBtn.Activated:Connect(function()
    if buttonMoved then
        buttonMoved = false
        return
    end
    mainFrame.Visible = not mainFrame.Visible
end)

-- ប្រព័ន្ធអូស Main Frame
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ប្រព័ន្ធហោះហើរ (Exact Speed Loop - មិនលោតទៅមុន និងដើរត្រូវតាម WalkSpeed ពិតប្រាកដ)
local autoActive = false

autoBtn.MouseButton1Click:Connect(function()
    if autoActive then return end
    
    autoActive = true
    autoBtn.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
    autoBtn.Text = "Auto: ON (Flying...)"
    
    task.spawn(function()
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            autoActive = false
            autoBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            autoBtn.Text = "Auto: OFF"
            return
        end
        
        local rootPart = character.HumanoidRootPart
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local zoneA = workspace:FindFirstChild("SafezoneASide", true)
        local zoneB = workspace:FindFirstChild("SafezoneBSide", true)
        
        if zoneA and zoneB then
            local distA = (rootPart.Position - zoneA.Position).Magnitude
            local distB = (rootPart.Position - zoneB.Position).Magnitude
            
            local targetZone = (distA < distB) and zoneB or zoneA

            local flightHeight = 12
            local speed = humanoid and humanoid.WalkSpeed or 16
            speed = math.max(speed, 16)

            local startPos = rootPart.Position
            local targetPos = targetZone.Position
            local highStart = Vector3.new(startPos.X, targetPos.Y + flightHeight, startPos.Z)
            local highTarget = Vector3.new(targetPos.X, targetPos.Y + flightHeight, targetPos.Z)
            local landingTarget = targetZone.CFrame + Vector3.new(0, 3, 0)

            -- 1. ហោះឡើងលើភ្លាមៗ (Teleport Up)
            rootPart.CFrame = CFrame.new(highStart)
            task.wait(0.05)

            -- 2. ហោះទៅមុខដោយផ្អែកលើការវាស់ចម្ងាយពិតប្រាកដជារៀងរាល់ Frame (មិនលោតទៅមុន និងមិនរំលងពេល)
            local currentPos = rootPart.Position
            while autoActive and (currentPos - highTarget).Magnitude > 2 do
                local dt = RunService.Heartbeat:Wait()
                local direction = (highTarget - currentPos).Unit
                local step = speed * dt
                
                if step >= (highTarget - currentPos).Magnitude then
                    currentPos = highTarget
                else
                    currentPos = currentPos + direction * step
                end
                
                rootPart.CFrame = CFrame.new(currentPos)
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end

            -- 3. ចុះចតដល់គោលដៅភ្លាមៗ (Teleport Down)
            if autoActive then
                rootPart.CFrame = landingTarget
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end
        
        -- បិទ Auto ស្វ័យប្រវត្តិពេលដល់គោលដៅ
        autoActive = false
        autoBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        autoBtn.Text = "Auto: OFF"
    end)
end)
