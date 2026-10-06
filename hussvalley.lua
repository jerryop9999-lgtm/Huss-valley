-- OLIVER Hub for Huss Valley (Auto Fly Safezones)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- លុប UI ចាស់ចោលសិនដើម្បីកុំឱ្យជាន់គ្នា
if CoreGui:FindFirstChild("OliverHussValleyHub") then
    CoreGui.OliverHussValleyHub:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OliverHussValleyHub"
screenGui.Parent = CoreGui

-- ប៊ូតុងអណ្តែតសម្រាប់បើក/បិទផ្ទាំង Hub
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Text = "OLIVER"
openBtn.TextSize = 10
openBtn.Font = Enum.Font.GothamBold
openBtn.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openBtn

-- ផ្ទាំងមេ (Main Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 150)
mainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- ចំណងជើង Hub (ប្រើសម្រាប់អូសផ្ទាំងមេ)
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Text = "⚡ OLIVER HUB - Huss Valley"
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 12
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- ប៊ូតុង Auto (เปิด/ปิด)
local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(0, 200, 0, 45)
autoBtn.Position = UDim2.new(0, 10, 0, 55)
autoBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
autoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoBtn.Text = "Auto: OFF"
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextSize = 14
autoBtn.Parent = mainFrame

local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0, 8)
autoCorner.Parent = autoBtn

-- បើក/បិទ ផ្ទាំង Main Frame ពេលចុចប៊ូតុងអណ្តែត OLIVER
openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- ប្រព័ន្ធអូស Main Frame ចេញពី TitleBar
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

-- ប្រព័ន្ធ Auto Fly រវាង SafezoneASide និង SafezoneBSide
local autoActive = false

autoBtn.MouseButton1Click:Connect(function()
    autoActive = not autoActive
    if autoActive then
        autoBtn.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        autoBtn.Text = "Auto: ON"
    else
        autoBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        autoBtn.Text = "Auto: OFF"
    end
end)

-- Loop ពិនិត្យទីតាំង និងហោះហើរទៅកន្លែងគោលដៅស្វ័យប្រវត្តិ
task.spawn(function()
    while true do
        task.wait(0.5)
        if autoActive then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                
                -- រកមើល SafezoneASide និង SafezoneBSide ក្នុង Workspace
                local zoneA = workspace:FindFirstChild("SafezoneASide", true)
                local zoneB = workspace:FindFirstChild("SafezoneBSide", true)
                
                if zoneA and zoneB then
                    local distA = (rootPart.Position - zoneA.Position).Magnitude
                    local distB = (rootPart.Position - zoneB.Position).Magnitude
                    
                    local destination
                    -- បើយើងនៅជិត A វានឹងហោះទៅ B / បើនៅជិត B វានឹងហោះទៅ A
                    if distA < distB then
                        destination = zoneB.CFrame + Vector3.new(0, 3, 0)
                    else
                        destination = zoneA.CFrame + Vector3.new(0, 3, 0)
                    end
                    
                    -- ហោះហើរទៅកាន់គោលដៅដោយរលូន (Tween Flying)
                    local distance = (rootPart.Position - destination.Position).Magnitude
                    local speed = 60 -- ល្បឿននៃការហោះ ( studs per second )
                    local timeToTravel = distance / speed
                    
                    local tweenInfo = TweenInfo.new(timeToTravel, Enum.EasingStyle.Linear)
                    local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = destination})
                    tween:Play()
                    
                    task.wait(timeToTravel + 0.1)
                end
            end
        end
    end
end)
