local Services = setmetatable({}, {
    __index = function(t, k) 
        return game:GetService(k) 
    end
})

local LocalPlayer = Services.Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configs
local Config = {
    TeleportEnabled = true,
    AutoBase1 = false,
    AutoBase2 = false,
    SavedPosition = nil,
    ProximityPosition = nil
}

local Stations = {
    Chest1 = Vector3.new(-336.724335, -4.433933, 5.031977),
    Chest2 = Vector3.new(-334.574585, -4.433943, 108.064049),
    Base1 = Vector3.new(-335.489075, -4.168889, 103.038925),
    Base2 = Vector3.new(-335.223877, -4.168889, 18.079557)
}

local Markers = {}
local TempMarker = nil

local function DecodeString(s)
    local result = ""
    for i = 1, #s do 
        result = result .. string.char(string.byte(s, i) - 1) 
    end
    return result
end

local function BuildMarker(position, text)
    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Block
    part.Size = Vector3.new(1.8, 1.8, 1.8)
    part.Position = position + Vector3.new(0, -1.2, 0)
    part.Anchored = true
    part.CanCollide = false
    part.Color = Color3.new(1, 1, 1)
    part.Material = Enum.Material.SmoothPlastic
    part.Parent = workspace
    
    task.spawn(function()
        while part and part.Parent do
            part.CFrame = part.CFrame * CFrame.Angles(0, 0.03, 0.015)
            task.wait()
        end
    end)
    
    local billboard = Instance.new("BillboardGui", part)
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.2, 0)
    billboard.AlwaysOnTop = true
    
    local label = Instance.new("TextLabel", billboard)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    
    return part
end

if PlayerGui:FindFirstChild("Strawberry_UI") then
    PlayerGui["Strawberry_UI"]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Strawberry_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(230, 230)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -115)
MainFrame.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
MainFrame.BackgroundTransparency = 0.35
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 8)
Title.BackgroundTransparency = 1
Title.RichText = true
Title.Text = "<font color=\"rgb(255,255,255)\"><b>STRAWBERRY</b> TP</font>"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

local Thanks = Instance.new("TextLabel")
Thanks.Size = UDim2.new(1, 0, 0, 15)
Thanks.Position = UDim2.new(0, 0, 0, 38)
Thanks.BackgroundTransparency = 1
Thanks.Text = "Thanks for using this script ^â€¢^"
Thanks.TextColor3 = Color3.fromRGB(255, 100, 100)
Thanks.Font = Enum.Font.GothamMedium
Thanks.TextSize = 10
Thanks.Parent = MainFrame

local function CreateButton(text, size, position)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Color3.new(1, 1, 1)
    button.BackgroundTransparency = 0.7
    button.BorderSizePixel = 0
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 10
    button.Parent = MainFrame
    
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    return button
end

local SetButton = CreateButton("SET TP LOCATION", UDim2.new(0.88, 0, 0, 32), UDim2.new(0.06, 0, 0, 65))
local Base1Button = CreateButton("base 1", UDim2.new(0.42, 0, 0, 32), UDim2.new(0.06, 0, 0, 105))
local Base2Button = CreateButton("base 2", UDim2.new(0.42, 0, 0, 32), UDim2.new(0.52, 0, 0, 105))
local Auto1Button = CreateButton("AUTO TO BASE 1: OFF", UDim2.new(0.88, 0, 0, 32), UDim2.new(0.06, 0, 0, 145))
local Auto2Button = CreateButton("AUTO TO BASE 2: OFF", UDim2.new(0.88, 0, 0, 32), UDim2.new(0.06, 0, 0, 185))

-- Evento: BotÃ£o Base 1
Base1Button.MouseButton1Click:Connect(function() 
    for _, marker in pairs(Markers) do 
        marker:Destroy() 
    end 
    Markers = {BuildMarker(Stations.Base1, "STAND HERE")} 
end)

Base2Button.MouseButton1Click:Connect(function() 
    for _, marker in pairs(Markers) do 
        marker:Destroy() 
    end 
    Markers = {BuildMarker(Stations.Base2, "STAND HERE")} 
end)

SetButton.MouseButton1Click:Connect(function() 
    local character = LocalPlayer.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then 
        Config.SavedPosition = humanoidRootPart.CFrame 
        
        if TempMarker then 
            TempMarker:Destroy() 
        end 
        
        TempMarker = BuildMarker(humanoidRootPart.Position, "TP")
        SetButton.Text = "LOCATION SAVED"
        task.wait(1)
        SetButton.Text = "SET TP LOCATION"
    end 
end)

Auto1Button.MouseButton1Click:Connect(function()
    Config.AutoBase1 = not Config.AutoBase1
    Config.AutoBase2 = false
    
    Auto1Button.Text = Config.AutoBase1 and "AUTO TO BASE 1: ON" or "AUTO TO BASE 1: OFF"
    Auto2Button.Text = "AUTO TO BASE 2: OFF"
    
    Auto1Button.TextColor3 = Config.AutoBase1 and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
    Auto2Button.TextColor3 = Color3.new(1, 1, 1)
end)

-- Evento: Auto Base 2
Auto2Button.MouseButton1Click:Connect(function()
    Config.AutoBase2 = not Config.AutoBase2
    Config.AutoBase1 = false
    
    Auto2Button.Text = Config.AutoBase2 and "AUTO TO BASE 2: ON" or "AUTO TO BASE 2: OFF"
    Auto1Button.Text = "AUTO TO BASE 1: OFF"
    
    Auto2Button.TextColor3 = Config.AutoBase2 and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
    Auto1Button.TextColor3 = Color3.new(1, 1, 1)
end)

local ProximityCoords = {
    Vector3.new(-481.88,-3.79,138.02), Vector3.new(-481.75,-3.79,89.18), Vector3.new(-481.82,-3.79,30.95),
    Vector3.new(-481.75,-3.79,-17.79), Vector3.new(-481.80,-3.79,-76.06), Vector3.new(-481.72,-3.79,-124.70),
    Vector3.new(-337.45,-3.85,-124.72), Vector3.new(-337.37,-3.85,-76.07), Vector3.new(-337.46,-3.79,-17.72),
    Vector3.new(-337.41,-3.79,30.92), Vector3.new(-337.32,-3.79,89.02), Vector3.new(-337.27,-3.79,137.90),
    Vector3.new(-337.45,-3.79,196.29), Vector3.new(-337.37,-3.79,244.91), Vector3.new(-481.72,-3.79,196.21),
    Vector3.new(-481.76,-3.79,244.92)
}

task.spawn(function()
    while task.wait(1) do
        local character = LocalPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if humanoidRootPart then
            local minDistance = math.huge
            local closestPosition = nil
            
            for _, coord in ipairs(ProximityCoords) do
                local distance = (humanoidRootPart.Position - coord).Magnitude
                if distance < minDistance then 
                    minDistance = distance
                    closestPosition = coord 
                end
            end
            
            if closestPosition then 
                Config.ProximityPosition = CFrame.new(closestPosition) 
            end
        end
    end
end)

Services.ProximityPromptService.PromptButtonHoldEnded:Connect(function(prompt, player)
    if player ~= LocalPlayer then return end
    
    if prompt.ActionText == DecodeString("Tubmn") or prompt.Name == DecodeString("Tubmn") then
        local character = LocalPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if humanoidRootPart and Config.SavedPosition and Config.ProximityPosition then
            -- Teleporta para posiÃ§Ã£o salva
            humanoidRootPart.CFrame = Config.SavedPosition
            task.wait(0.1)
            
            -- Teleporta para posiÃ§Ã£o de proximidade
            humanoidRootPart.CFrame = Config.ProximityPosition
            
            -- Caminha automaticamente para base se ativado
            local walkToPosition = nil
            if Config.AutoBase1 then
                walkToPosition = Stations.Chest1
            elseif Config.AutoBase2 then
                walkToPosition = Stations.Chest2
            end
            
            if walkToPosition and humanoid then
                task.spawn(function() 
                    task.wait(0.3) 
                    humanoid:MoveTo(walkToPosition) 
                end)
            end
        end
    end
end)
