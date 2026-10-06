-- OLIVER Hub for Huss Valley (Custom Logo & Background Image)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- 📌 កន្លែងសម្រាប់ដាក់ Image ID របស់អ្នក (អាចប្តូរលេខ ID បានតាមតម្រូវការ)
local LOGO_ID = "rbxassetid://131522091567355"     -- Logo ID សម្រាប់ប៊ូតុងអណ្តែត
local BG_IMAGE_ID = "rbxassetid://132347212228560" -- Background Image ID សម្រាប់ Main Frame

-- លុប UI ចាស់ចោលសិនដើម្បីកុំឱ្យជាន់គ្នា
if CoreGui:FindFirstChild("OliverHussValleyHub") then
    CoreGui.OliverHussValleyHub:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OliverHussValleyHub"
screenGui.Parent = CoreGui

-- ប៊ូតុងអណ្តែត (ImageButton) ជាមួយ Logo ID សម្រាប់បើក/បិទផ្ទាំង Hub
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
bgImage.BackgroundTransparency = 1
bgImage.Image = BG_IMAGE_ID
bgImage.ScaleType = Enum.ScaleType.Slice
bgImage.Parent = mainFrame

-- ចំណងជើង Hub (ប្រើសម្រាប់អូសផ្ទាំងមេ)
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BackgroundTransparency = 0.4 -- ធ្វើឱ្យស្រាលបន្តិចមើលឃើញ Background ខាងក្រោម
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Text = "OLIVER HUB"
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 12
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
autoBtn.Parent = mainFrame

local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0, 8)
autoCorner.Parent = autoBtn

-- ប៊ូតុងអណ្តែត: អូសបានដោយ Mouse/Touch ហើយចុចធម្មតាសម្រាប់បើក/បិទ Main Frame
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
    -- បើមានការអូស កុំឲ្យវាបើក/បិទ Main Frame ដោយចៃដន្យ
    if buttonMoved then
        buttonMoved = false
        return
    end
    mainFrame.Visible = not mainFrame.Visible
end)

-- ប្រព័ន្ធអូស Main Frame ចេញពី TitleBar (Draggable)
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

-- ប្រព័ន្ធ Auto Fly និងបិទស្វ័យប្រវត្តិពេលដល់គោលដៅ
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
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart or not rootPart:IsA("BasePart") then
            autoActive = false
            autoBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            autoBtn.Text = "Auto: OFF"
            return
        end

        local function getCFrame(instance)
            if not instance then return nil end
            if instance:IsA("BasePart") then
                return instance.CFrame
            end
            if instance:IsA("Model") then
                return instance:GetPivot()
            end
            local part = instance:FindFirstChildWhichIsA("BasePart", true)
            return part and part.CFrame or nil
        end

        local zoneA = workspace:FindFirstChild("SafezoneASide", true)
        local zoneB = workspace:FindFirstChild("SafezoneBSide", true)
        local cframeA = getCFrame(zoneA)
        local cframeB = getCFrame(zoneB)

        if cframeA and cframeB then
            local distA = (rootPart.Position - cframeA.Position).Magnitude
            local distB = (rootPart.Position - cframeB.Position).Magnitude

            local destination
            if distA < distB then
                destination = cframeB + Vector3.new(0, 3, 0)
            else
                destination = cframeA + Vector3.new(0, 3, 0)
            end

            local distance = (rootPart.Position - destination.Position).Magnitude
            local speed = 70
            local timeToTravel = distance / speed

            if timeToTravel > 0 then
                local tweenInfo = TweenInfo.new(timeToTravel, Enum.EasingStyle.Linear)
                local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = destination})
                tween:Play()
                tween.Completed:Wait()
            end
        end

        autoActive = false
        autoBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        autoBtn.Text = "Auto: OFF"
    end)
end)
