-- Grow a Garden Hub by Claude
-- Compatível com KRNL

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variáveis de controle
local autoFarmEnabled = false
local autoEventEnabled = false
local autoWaterEnabled = false
local autoHarvestEnabled = false
local autoPlantEnabled = false
local minimized = false

-- Interface
local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local topBar = Instance.new("Frame")
local titleLabel = Instance.new("TextLabel")
local minimizeButton = Instance.new("TextButton")
local contentFrame = Instance.new("Frame")

-- Configuração da GUI
screenGui.Name = "GrowGardenHub"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame principal
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.Size = UDim2.new(0, 400, 0, 450)
mainFrame.Active = true
mainFrame.Draggable = true

-- Cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Barra superior
topBar.Name = "TopBar"
topBar.Parent = mainFrame
topBar.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
topBar.BorderSizePixel = 0
topBar.Size = UDim2.new(1, 0, 0, 40)

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

-- Título
titleLabel.Name = "Title"
titleLabel.Parent = topBar
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "🌱 Grow a Garden Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Botão minimizar
minimizeButton.Name = "MinimizeButton"
minimizeButton.Parent = topBar
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 95, 95)
minimizeButton.BorderSizePixel = 0
minimizeButton.Position = UDim2.new(1, -35, 0.5, -10)
minimizeButton.Size = UDim2.new(0, 20, 0, 20)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 14

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 10)
minCorner.Parent = minimizeButton

-- Frame de conteúdo
contentFrame.Name = "ContentFrame"
contentFrame.Parent = mainFrame
contentFrame.BackgroundTransparency = 1
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.Size = UDim2.new(1, 0, 1, -40)

-- Função para criar botões
local function createButton(name, text, position, callback)
    local button = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    
    button.Name = name
    button.Parent = contentFrame
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    button.BorderSizePixel = 0
    button.Position = position
    button.Size = UDim2.new(0, 360, 0, 35)
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 95)
    end)
    
    button.MouseLeave:Connect(function()
        if not button:GetAttribute("Active") then
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
        end
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Função para criar labels de status
local function createStatusLabel(name, text, position)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Parent = contentFrame
    label.BackgroundTransparency = 1
    label.Position = position
    label.Size = UDim2.new(0, 360, 0, 25)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

-- Botões principais
local autoFarmButton = createButton("AutoFarm", "🚜 Auto Farm: OFF", UDim2.new(0, 20, 0, 20), function()
    autoFarmEnabled = not autoFarmEnabled
    autoFarmButton.Text = "🚜 Auto Farm: " .. (autoFarmEnabled and "ON" or "OFF")
    autoFarmButton.BackgroundColor3 = autoFarmEnabled and Color3.fromRGB(95, 200, 95) or Color3.fromRGB(60, 60, 75)
    autoFarmButton:SetAttribute("Active", autoFarmEnabled)
end)

local autoWaterButton = createButton("AutoWater", "💧 Auto Water: OFF", UDim2.new(0, 20, 0, 70), function()
    autoWaterEnabled = not autoWaterEnabled
    autoWaterButton.Text = "💧 Auto Water: " .. (autoWaterEnabled and "ON" or "OFF")
    autoWaterButton.BackgroundColor3 = autoWaterEnabled and Color3.fromRGB(95, 200, 95) or Color3.fromRGB(60, 60, 75)
    autoWaterButton:SetAttribute("Active", autoWaterEnabled)
end)

local autoHarvestButton = createButton("AutoHarvest", "🌾 Auto Harvest: OFF", UDim2.new(0, 20, 0, 120), function()
    autoHarvestEnabled = not autoHarvestEnabled
    autoHarvestButton.Text = "🌾 Auto Harvest: " .. (autoHarvestEnabled and "ON" or "OFF")
    autoHarvestButton.BackgroundColor3 = autoHarvestEnabled and Color3.fromRGB(95, 200, 95) or Color3.fromRGB(60, 60, 75)
    autoHarvestButton:SetAttribute("Active", autoHarvestEnabled)
end)

local autoPlantButton = createButton("AutoPlant", "🌱 Auto Plant: OFF", UDim2.new(0, 20, 0, 170), function()
    autoPlantEnabled = not autoPlantEnabled
    autoPlantButton.Text = "🌱 Auto Plant: " .. (autoPlantEnabled and "ON" or "OFF")
    autoPlantButton.BackgroundColor3 = autoPlantEnabled and Color3.fromRGB(95, 200, 95) or Color3.fromRGB(60, 60, 75)
    autoPlantButton:SetAttribute("Active", autoPlantEnabled)
end)

-- Separador
local separator = Instance.new("Frame")
separator.Name = "Separator"
separator.Parent = contentFrame
separator.BackgroundColor3 = Color3.fromRGB(80, 80, 95)
separator.BorderSizePixel = 0
separator.Position = UDim2.new(0, 20, 0, 220)
separator.Size = UDim2.new(0, 360, 0, 1)

-- Seção de eventos
local eventLabel = createStatusLabel("EventLabel", "🎉 EVENT FARMING", UDim2.new(0, 20, 0, 240))
eventLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
eventLabel.Font = Enum.Font.GothamBold

local autoEventButton = createButton("AutoEvent", "⭐ Auto Event Farm: OFF", UDim2.new(0, 20, 0, 270), function()
    autoEventEnabled = not autoEventEnabled
    autoEventButton.Text = "⭐ Auto Event Farm: " .. (autoEventEnabled and "ON" or "OFF")
    autoEventButton.BackgroundColor3 = autoEventEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(60, 60, 75)
    autoEventButton:SetAttribute("Active", autoEventEnabled)
end)

-- Informações
local infoLabel = createStatusLabel("InfoLabel", "ℹ️ Status: Aguardando...", UDim2.new(0, 20, 0, 320))

-- Créditos
local creditsLabel = createStatusLabel("Credits", "Made by Claude | KRNL Compatible", UDim2.new(0, 20, 0, 380))
creditsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
creditsLabel.TextSize = 10

-- Função de minimizar
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    local targetSize = minimized and UDim2.new(0, 400, 0, 40) or UDim2.new(0, 400, 0, 450)
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = targetSize})
    
    minimizeButton.Text = minimized and "+" or "-"
    contentFrame.Visible = not minimized
    
    tween:Play()
end)

-- Funções do jogo
local function findPlots()
    local plots = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:find("Plot") and obj:FindFirstChild("Soil") then
            table.insert(plots, obj)
        end
    end
    return plots
end

local function waterPlant(plot)
    local args = {
        [1] = plot,
        [2] = "Water"
    }
    
    pcall(function()
        ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("PlotAction"):FireServer(unpack(args))
    end)
end

local function harvestPlant(plot)
    local args = {
        [1] = plot,
        [2] = "Harvest"
    }
    
    pcall(function()
        ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("PlotAction"):FireServer(unpack(args))
    end)
end

local function plantSeed(plot, seedType)
    local args = {
        [1] = plot,
        [2] = "Plant",
        [3] = seedType or "Carrot"
    }
    
    pcall(function()
        ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("PlotAction"):FireServer(unpack(args))
    end)
end

local function collectEvent()
    pcall(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:find("Event") or obj.Name:find("Gift") or obj.Name:find("Chest") then
                if obj:FindFirstChild("ClickDetector") then
                    fireclickdetector(obj.ClickDetector)
                end
            end
        end
    end)
end

-- Loop principal
spawn(function()
    while true do
        wait(1)
        
        if autoFarmEnabled then
            infoLabel.Text = "ℹ️ Status: Auto Farm Ativo"
            
            local plots = findPlots()
            for _, plot in pairs(plots) do
                if autoWaterEnabled then
                    waterPlant(plot)
                end
                
                if autoHarvestEnabled then
                    harvestPlant(plot)
                end
                
                if autoPlantEnabled then
                    plantSeed(plot)
                end
            end
        end
        
        if autoEventEnabled then
            infoLabel.Text = "ℹ️ Status: Farmando Eventos..."
            collectEvent()
        end
        
        if not autoFarmEnabled and not autoEventEnabled then
            infoLabel.Text = "ℹ️ Status: Aguardando..."
        end
    end
end)

-- Proteção contra erros
spawn(function()
    while true do
        wait(5)
        if not screenGui.Parent then
            break
        end
    end
end)

print("🌱 Grow a Garden Hub carregado com sucesso!")
print("📋 Funcionalidades:")
print("   • Auto Farm completo")
print("   • Auto Water/Harvest/Plant")
print("   • Auto Event Farm")
print("   • Interface minimizável")
print("🎯 Hub criado by Claude")-- Grow a Garden Hub by Claude
-- Compatível com KRNL

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variáveis de controle
local autoFarmEnabled = false
local autoEventEnabled = false
local autoWaterEnabled = false
local autoHarvestEnabled = false
local autoPlantEnabled = false
local minimized = false

-- Interface
local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local topBar = Instance.new("Frame")
local titleLabel = Instance.new("TextLabel")
local minimizeButton = Instance.new("TextButton")
local contentFrame = Instance.new("Frame")

-- Configuração da GUI
screenGui.Name = "GrowGardenHub"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame principal
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.Size = UDim2.new(0, 400, 0, 450)
mainFrame.Active = true
mainFrame.Draggable = true

-- Cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Barra superior
topBar.Name = "TopBar"
topBar.Parent = mainFrame
topBar.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
topBar.BorderSizePixel = 0
topBar.Size = UDim2.new(1, 0, 0, 40)

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

-- Título
titleLabel.Name = "Title"
titleLabel.Parent = topBar
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "🌱 Grow a Garden Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Botão minimizar
minimizeButton.Name = "MinimizeButton"
minimizeButton.Parent = topBar
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 95, 95)
minimizeButton.BorderSizePixel = 0
minimizeButton.Position = UDim2.new(1, -35, 0.5, -10)
minimizeButton.Size = UDim2.new(0, 20, 0, 20)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 14

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 10)
minCorner.Parent = minimizeButton

-- Frame de conteúdo
contentFrame.Name = "ContentFrame"
contentFrame.Parent = mainFrame
contentFrame.BackgroundTransparency = 1
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.Size = UDim2.new(1, 0, 1, -40)

-- Função para criar botões
local function createButton(name, text, position, callback)
    local button = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    
    button.Name = name
    button.Parent = contentFrame
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    button.BorderSizePixel = 0
    button.Position = position
    button.Size = UDim2.new(0, 360, 0, 35)
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 95)
    end)
    
    button.MouseLeave:Connect(function()
        if not button:GetAttribute("Active") then
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
        end
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Função para criar labels de status
local function createStatusLabel(name, text, position)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Parent = contentFrame
    label.BackgroundTransparency = 1
    label.Position = position
    label.Size = UDim2.new(0, 360, 0, 25)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

-- Botões principais
local autoFarmButton = createButton("AutoFarm", "🚜 Auto Farm: OFF", UDim2.new(0, 20, 0, 20), function()
    autoFarmEnabled = not autoFarmEnabled
    autoFarmButton.Text = "🚜 Auto Farm: " .. (autoFarmEnabled and "ON" or "OFF")
    autoFarmButton.BackgroundColor3 = autoFarmEnabled and Color3.fromRGB(95, 200, 95) or Color3.fromRGB(60, 60, 75)
    autoFarmButton:SetAttribute("Active", autoFarmEnabled)
end)

local autoWaterButton = createButton("AutoWater", "💧 Auto Water: OFF", UDim2.new(0, 20, 0, 70), function()
    autoWaterEnabled = not autoWaterEnabled
    autoWaterButton.Text = "💧 Auto Water: " .. (autoWaterEnabled and "ON" or "OFF")
    autoWaterButton.BackgroundColor3 = autoWaterEnabled and Color3.fromRGB(95, 200, 95) or Color3.fromRGB(60, 60, 75)
    autoWaterButton:SetAttribute("Active", autoWaterEnabled)
end)

local autoHarvestButton = createButton("AutoHarvest", "🌾 Auto Harvest: OFF", UDim2.new(0, 20, 0, 120), function()
    autoHarvestEnabled = not autoHarvestEnabled
    autoHarvestButton.Text = "🌾 Auto Harvest: " .. (autoHarvestEnabled and "ON" or "OFF")
    autoHarvestButton.BackgroundColor3 = autoHarvestEnabled and Color3.fromRGB(95, 200, 95) or Color3.fromRGB(60, 60, 75)
    autoHarvestButton:SetAttribute("Active", autoHarvestEnabled)
end)

local autoPlantButton = createButton("AutoPlant", "🌱 Auto Plant: OFF", UDim2.new(0, 20, 0, 170), function()
    autoPlantEnabled = not autoPlantEnabled
    autoPlantButton.Text = "🌱 Auto Plant: " .. (autoPlantEnabled and "ON" or "OFF")
    autoPlantButton.BackgroundColor3 = autoPlantEnabled and Color3.fromRGB(95, 200, 95) or Color3.fromRGB(60, 60, 75)
    autoPlantButton:SetAttribute("Active", autoPlantEnabled)
end)

-- Separador
local separator = Instance.new("Frame")
separator.Name = "Separator"
separator.Parent = contentFrame
separator.BackgroundColor3 = Color3.fromRGB(80, 80, 95)
separator.BorderSizePixel = 0
separator.Position = UDim2.new(0, 20, 0, 220)
separator.Size = UDim2.new(0, 360, 0, 1)

-- Seção de eventos
local eventLabel = createStatusLabel("EventLabel", "🎉 EVENT FARMING", UDim2.new(0, 20, 0, 240))
eventLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
eventLabel.Font = Enum.Font.GothamBold

local autoEventButton = createButton("AutoEvent", "⭐ Auto Event Farm: OFF", UDim2.new(0, 20, 0, 270), function()
    autoEventEnabled = not autoEventEnabled
    autoEventButton.Text = "⭐ Auto Event Farm: " .. (autoEventEnabled and "ON" or "OFF")
    autoEventButton.BackgroundColor3 = autoEventEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(60, 60, 75)
    autoEventButton:SetAttribute("Active", autoEventEnabled)
end)

-- Informações
local infoLabel = createStatusLabel("InfoLabel", "ℹ️ Status: Aguardando...", UDim2.new(0, 20, 0, 320))

-- Créditos
local creditsLabel = createStatusLabel("Credits", "Made by Claude | KRNL Compatible", UDim2.new(0, 20, 0, 380))
creditsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
creditsLabel.TextSize = 10

-- Função de minimizar
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    local targetSize = minimized and UDim2.new(0, 400, 0, 40) or UDim2.new(0, 400, 0, 450)
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = targetSize})
    
    minimizeButton.Text = minimized and "+" or "-"
    contentFrame.Visible = not minimized
    
    tween:Play()
end)

-- Funções do jogo
local function findPlots()
    local plots = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:find("Plot") and obj:FindFirstChild("Soil") then
            table.insert(plots, obj)
        end
    end
    return plots
end

local function waterPlant(plot)
    local args = {
        [1] = plot,
        [2] = "Water"
    }
    
    pcall(function()
        ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("PlotAction"):FireServer(unpack(args))
    end)
end

local function harvestPlant(plot)
    local args = {
        [1] = plot,
        [2] = "Harvest"
    }
    
    pcall(function()
        ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("PlotAction"):FireServer(unpack(args))
    end)
end

local function plantSeed(plot, seedType)
    local args = {
        [1] = plot,
        [2] = "Plant",
        [3] = seedType or "Carrot"
    }
    
    pcall(function()
        ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("PlotAction"):FireServer(unpack(args))
    end)
end

local function collectEvent()
    pcall(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:find("Event") or obj.Name:find("Gift") or obj.Name:find("Chest") then
                if obj:FindFirstChild("ClickDetector") then
                    fireclickdetector(obj.ClickDetector)
                end
            end
        end
    end)
end

-- Loop principal
spawn(function()
    while true do
        wait(1)
        
        if autoFarmEnabled then
            infoLabel.Text = "ℹ️ Status: Auto Farm Ativo"
            
            local plots = findPlots()
            for _, plot in pairs(plots) do
                if autoWaterEnabled then
                    waterPlant(plot)
                end
                
                if autoHarvestEnabled then
                    harvestPlant(plot)
                end
                
                if autoPlantEnabled then
                    plantSeed(plot)
                end
            end
        end
        
        if autoEventEnabled then
            infoLabel.Text = "ℹ️ Status: Farmando Eventos..."
            collectEvent()
        end
        
        if not autoFarmEnabled and not autoEventEnabled then
            infoLabel.Text = "ℹ️ Status: Aguardando..."
        end
    end
end)

-- Proteção contra erros
spawn(function()
    while true do
        wait(5)
        if not screenGui.Parent then
            break
        end
    end
end)

print("🌱 Grow a Garden Hub carregado com sucesso!")
print("📋 Funcionalidades:")
print("   • Auto Farm completo")
print("   • Auto Water/Harvest/Plant")
print("   • Auto Event Farm")
print("   • Interface minimizável")
print("🎯 Hub criado by Claude")
