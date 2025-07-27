-- Santos Hub 🤡 - Grow a Garden Client-Side
-- Feito para KRNL - Only Client Effects

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variáveis de controle
local autoFarmEnabled = false
local autoEventEnabled = false
local autoWaterEnabled = false
local autoHarvestEnabled = false
local autoPlantEnabled = false
local autoBuySeedEnabled = false
local autoBuyGearEnabled = false
local autoFeedPetEnabled = false
local selectedFruit = "Apple"
local selectedSeed = "Carrot"
local selectedGear = "Watering Can"
local minimized = false

-- Interface
local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local orbFrame = Instance.new("Frame")

-- Configuração da GUI principal
screenGui.Name = "SantosHub"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ORB (quando minimizado)
orbFrame.Name = "OrbFrame"
orbFrame.Parent = screenGui
orbFrame.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
orbFrame.BorderSizePixel = 0
orbFrame.Position = UDim2.new(0, 50, 0, 50)
orbFrame.Size = UDim2.new(0, 60, 0, 60)
orbFrame.Active = true
orbFrame.Draggable = true
orbFrame.Visible = false

-- Orb design
local orbCorner = Instance.new("UICorner")
orbCorner.CornerRadius = UDim.new(0.5, 0)
orbCorner.Parent = orbFrame

local orbGradient = Instance.new("UIGradient")
orbGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 30, 30))
}
orbGradient.Parent = orbFrame

local orbLabel = Instance.new("TextLabel")
orbLabel.Parent = orbFrame
orbLabel.BackgroundTransparency = 1
orbLabel.Size = UDim2.new(1, 0, 1, 0)
orbLabel.Font = Enum.Font.GothamBold
orbLabel.Text = "🤡"
orbLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
orbLabel.TextSize = 24

-- Frame principal
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.3, 0, 0.15, 0)
mainFrame.Size = UDim2.new(0, 450, 0, 550)
mainFrame.Active = true
mainFrame.Draggable = true

-- Gradiente vermelho
local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 25, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
}
mainGradient.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Borda vermelha
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(200, 50, 50)
border.Thickness = 2
border.Parent = mainFrame

-- Barra superior
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Parent = mainFrame
topBar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
topBar.BorderSizePixel = 0
topBar.Size = UDim2.new(1, 0, 0, 50)

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 15)
topCorner.Parent = topBar

-- Título com palhaço
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Parent = topBar
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "🤡 SANTOS HUB 🤡"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Decoração de palhaço
local clownDecor = Instance.new("TextLabel")
clownDecor.Parent = topBar
clownDecor.BackgroundTransparency = 1
clownDecor.Position = UDim2.new(1, -70, 0, 0)
clownDecor.Size = UDim2.new(0, 30, 1, 0)
clownDecor.Font = Enum.Font.GothamBold
clownDecor.Text = "🎪"
clownDecor.TextColor3 = Color3.fromRGB(255, 255, 255)
clownDecor.TextSize = 20

-- Botão minimizar
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Parent = topBar
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.BorderSizePixel = 0
minimizeButton.Position = UDim2.new(1, -35, 0.5, -12)
minimizeButton.Size = UDim2.new(0, 24, 0, 24)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(200, 50, 50)
minimizeButton.TextSize = 16

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0.5, 0)
minCorner.Parent = minimizeButton

-- ScrollFrame para conteúdo
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Parent = mainFrame
scrollFrame.BackgroundTransparency = 1
scrollFrame.Position = UDim2.new(0, 0, 0, 50)
scrollFrame.Size = UDim2.new(1, 0, 1, -50)
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 50, 50)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)

-- Função para criar seções
local function createSection(name, yPos)
    local section = Instance.new("Frame")
    section.Name = name
    section.Parent = scrollFrame
    section.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    section.BorderSizePixel = 0
    section.Position = UDim2.new(0, 15, 0, yPos)
    section.Size = UDim2.new(1, -30, 0, 120)
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 10)
    sectionCorner.Parent = section
    
    local sectionBorder = Instance.new("UIStroke")
    sectionBorder.Color = Color3.fromRGB(200, 50, 50)
    sectionBorder.Thickness = 1
    sectionBorder.Parent = section
    
    return section
end

-- Função para criar botões
local function createButton(parent, name, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    button.BorderSizePixel = 0
    button.Position = position
    button.Size = size
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end)
    
    button.MouseLeave:Connect(function()
        if not button:GetAttribute("Active") then
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
        end
    end)
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Função para criar dropdown
local function createDropdown(parent, name, options, position, callback)
    local dropdown = Instance.new("TextButton")
    dropdown.Name = name
    dropdown.Parent = parent
    dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    dropdown.BorderSizePixel = 0
    dropdown.Position = position
    dropdown.Size = UDim2.new(0, 120, 0, 25)
    dropdown.Font = Enum.Font.Gotham
    dropdown.Text = options[1] .. " ▼"
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.TextSize = 10
    
    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 5)
    dropCorner.Parent = dropdown
    
    local currentIndex = 1
    dropdown.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then currentIndex = 1 end
        dropdown.Text = options[currentIndex] .. " ▼"
        callback(options[currentIndex])
    end)
    
    return dropdown
end

-- SEÇÃO 1: AUTO FARM
local farmSection = createSection("FarmSection", 20)
local farmTitle = Instance.new("TextLabel")
farmTitle.Parent = farmSection
farmTitle.BackgroundTransparency = 1
farmTitle.Position = UDim2.new(0, 10, 0, 5)
farmTitle.Size = UDim2.new(1, -20, 0, 20)
farmTitle.Font = Enum.Font.GothamBold
farmTitle.Text = "🚜 AUTO FARM"
farmTitle.TextColor3 = Color3.fromRGB(200, 50, 50)
farmTitle.TextSize = 14
farmTitle.TextXAlignment = Enum.TextXAlignment.Left

local autoFarmBtn = createButton(farmSection, "AutoFarmBtn", "🔴 Auto Farm: OFF", UDim2.new(0, 10, 0, 30), UDim2.new(0, 180, 0, 30), function()
    autoFarmEnabled = not autoFarmEnabled
    autoFarmBtn.Text = (autoFarmEnabled and "🟢" or "🔴") .. " Auto Farm: " .. (autoFarmEnabled and "ON" or "OFF")
    autoFarmBtn.BackgroundColor3 = autoFarmEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 75)
    autoFarmBtn:SetAttribute("Active", autoFarmEnabled)
end)

local autoWaterBtn = createButton(farmSection, "AutoWaterBtn", "🔴 Water: OFF", UDim2.new(0, 200, 0, 30), UDim2.new(0, 120, 0, 30), function()
    autoWaterEnabled = not autoWaterEnabled
    autoWaterBtn.Text = (autoWaterEnabled and "🟢" or "🔴") .. " Water: " .. (autoWaterEnabled and "ON" or "OFF")
    autoWaterBtn.BackgroundColor3 = autoWaterEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 75)
end)

local autoHarvestBtn = createButton(farmSection, "AutoHarvestBtn", "🔴 Harvest: OFF", UDim2.new(0, 330, 0, 30), UDim2.new(0, 90, 0, 30), function()
    autoHarvestEnabled = not autoHarvestEnabled
    autoHarvestBtn.Text = (autoHarvestEnabled and "🟢" or "🔴") .. " Harvest: " .. (autoHarvestEnabled and "ON" or "OFF")
    autoHarvestBtn.BackgroundColor3 = autoHarvestEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 75)
end)

local autoPlantBtn = createButton(farmSection, "AutoPlantBtn", "🔴 Plant: OFF", UDim2.new(0, 10, 0, 70), UDim2.new(0, 120, 0, 30), function()
    autoPlantEnabled = not autoPlantEnabled
    autoPlantBtn.Text = (autoPlantEnabled and "🟢" or "🔴") .. " Plant: " .. (autoPlantEnabled and "ON" or "OFF")
    autoPlantBtn.BackgroundColor3 = autoPlantEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 75)
end)

local seedDropdown = createDropdown(farmSection, "SeedDropdown", {"Carrot", "Potato", "Corn", "Tomato", "Wheat"}, UDim2.new(0, 140, 0, 75), function(seed)
    selectedSeed = seed
end)

-- SEÇÃO 2: LOJA
local shopSection = createSection("ShopSection", 160)
local shopTitle = Instance.new("TextLabel")
shopTitle.Parent = shopSection
shopTitle.BackgroundTransparency = 1
shopTitle.Position = UDim2.new(0, 10, 0, 5)
shopTitle.Size = UDim2.new(1, -20, 0, 20)
shopTitle.Font = Enum.Font.GothamBold
shopTitle.Text = "🛒 AUTO SHOP"
shopTitle.TextColor3 = Color3.fromRGB(200, 50, 50)
shopTitle.TextSize = 14
shopTitle.TextXAlignment = Enum.TextXAlignment.Left

local autoBuySeedBtn = createButton(shopSection, "AutoBuySeedBtn", "🔴 Buy Seeds: OFF", UDim2.new(0, 10, 0, 30), UDim2.new(0, 150, 0, 30), function()
    autoBuySeedEnabled = not autoBuySeedEnabled
    autoBuySeedBtn.Text = (autoBuySeedEnabled and "🟢" or "🔴") .. " Buy Seeds: " .. (autoBuySeedEnabled and "ON" or "OFF")
    autoBuySeedBtn.BackgroundColor3 = autoBuySeedEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 75)
end)

local autoBuyGearBtn = createButton(shopSection, "AutoBuyGearBtn", "🔴 Buy Gear: OFF", UDim2.new(0, 170, 0, 30), UDim2.new(0, 150, 0, 30), function()
    autoBuyGearEnabled = not autoBuyGearEnabled
    autoBuyGearBtn.Text = (autoBuyGearEnabled and "🟢" or "🔴") .. " Buy Gear: " .. (autoBuyGearEnabled and "ON" or "OFF")
    autoBuyGearBtn.BackgroundColor3 = autoBuyGearEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 75)
end)

local gearDropdown = createDropdown(shopSection, "GearDropdown", {"Watering Can", "Fertilizer", "Shovel", "Hoe", "Sprinkler"}, UDim2.new(0, 330, 0, 35), function(gear)
    selectedGear = gear
end)

-- SEÇÃO 3: PET
local petSection = createSection("PetSection", 300)
local petTitle = Instance.new("TextLabel")
petTitle.Parent = petSection
petTitle.BackgroundTransparency = 1
petTitle.Position = UDim2.new(0, 10, 0, 5)
petTitle.Size = UDim2.new(1, -20, 0, 20)
petTitle.Font = Enum.Font.GothamBold
petTitle.Text = "🐾 AUTO PET FEED"
petTitle.TextColor3 = Color3.fromRGB(200, 50, 50)
petTitle.TextSize = 14
petTitle.TextXAlignment = Enum.TextXAlignment.Left

local autoFeedBtn = createButton(petSection, "AutoFeedBtn", "🔴 Feed Pet: OFF", UDim2.new(0, 10, 0, 30), UDim2.new(0, 150, 0, 30), function()
    autoFeedPetEnabled = not autoFeedPetEnabled
    autoFeedBtn.Text = (autoFeedPetEnabled and "🟢" or "🔴") .. " Feed Pet: " .. (autoFeedPetEnabled and "ON" or "OFF")
    autoFeedBtn.BackgroundColor3 = autoFeedPetEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 75)
end)

local fruitDropdown = createDropdown(petSection, "FruitDropdown", {"Apple", "Orange", "Banana", "Strawberry", "Watermelon"}, UDim2.new(0, 170, 0, 35), function(fruit)
    selectedFruit = fruit
end)

-- SEÇÃO 4: EVENTOS
local eventSection = createSection("EventSection", 440)
local eventTitle = Instance.new("TextLabel")
eventTitle.Parent = eventSection
eventTitle.BackgroundTransparency = 1
eventTitle.Position = UDim2.new(0, 10, 0, 5)
eventTitle.Size = UDim2.new(1, -20, 0, 20)
eventTitle.Font = Enum.Font.GothamBold
eventTitle.Text = "🎉 EVENT FARM"
eventTitle.TextColor3 = Color3.fromRGB(200, 50, 50)
eventTitle.TextSize = 14
eventTitle.TextXAlignment = Enum.TextXAlignment.Left

local autoEventBtn = createButton(eventSection, "AutoEventBtn", "🔴 Event Farm: OFF", UDim2.new(0, 10, 0, 30), UDim2.new(0, 200, 0, 30), function()
    autoEventEnabled = not autoEventEnabled
    autoEventBtn.Text = (autoEventEnabled and "🟢" or "🔴") .. " Event Farm: " .. (autoEventEnabled and "ON" or "OFF")
    autoEventBtn.BackgroundColor3 = autoEventEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(60, 60, 75)
end)

-- Status e créditos
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = scrollFrame
statusLabel.BackgroundTransparency = 1
statusLabel.Position = UDim2.new(0, 15, 0, 580)
statusLabel.Size = UDim2.new(1, -30, 0, 25)
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "🤡 Status: Aguardando comandos..."
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

local creditsLabel = Instance.new("TextLabel")
creditsLabel.Parent = scrollFrame
creditsLabel.BackgroundTransparency = 1
creditsLabel.Position = UDim2.new(0, 15, 0, 610)
creditsLabel.Size = UDim2.new(1, -30, 0, 25)
creditsLabel.Font = Enum.Font.Gotham
creditsLabel.Text = "🎪 Santos Hub - Client Side Only | Made by Santos 🤡"
creditsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
creditsLabel.TextSize = 10
creditsLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Função de minimizar para orbe
minimizeButton.MouseButton1Click:Connect(function()
    minimized = true
    mainFrame.Visible = false
    orbFrame.Visible = true
    
    -- Animação da orbe
    local orbTween = TweenService:Create(orbFrame, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {
        Size = UDim2.new(0, 70, 0, 70)
    })
    orbTween:Play()
    
    wait(0.2)
    orbTween = TweenService:Create(orbFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 60, 0, 60)
    })
    orbTween:Play()
end)

-- Função para abrir da orbe
orbFrame.MouseButton1Click:Connect(function()
    minimized = false
    orbFrame.Visible = false
    mainFrame.Visible = true
    
    -- Animação de abertura
    mainFrame.Size = UDim2.new(0, 50, 0, 50)
    local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 450, 0, 550)
    })
    openTween:Play()
end)

-- Funções CLIENT-SIDE (não afetam server)
local function simulatePlantAction(action, plot)
    -- Apenas visual/cliente
    statusLabel.Text = "🤡 Status: " .. action .. " simulado no plot " .. tostring(plot)
    
    -- Notificação cliente
    StarterGui:SetCore("SendNotification", {
        Title = "Santos Hub 🤡";
        Text = action .. " executado (CLIENT)";
        Duration = 2;
    })
end

local function simulateShopPurchase(item)
    statusLabel.Text = "🤡 Status: Comprando " .. item .. " (CLIENT)"
    
    StarterGui:SetCore("SendNotification", {
        Title = "Santos Hub 🤡";
        Text = "Comprou " .. item .. " (CLIENT)";
        Duration = 2;
    })
end

local function simulatePetFeed(fruit)
    statusLabel.Text = "🤡 Status: Alimentando pet com " .. fruit .. " (CLIENT)"
    
    StarterGui:SetCore("SendNotification", {
        Title = "Santos Hub 🤡";
        Text = "Pet alimentado com " .. fruit .. " (CLIENT)";
        Duration = 2;
    })
end

-- Loop principal CLIENT-SIDE
spawn(function()
    while true do
        wait(2)
        
        if autoFarmEnabled then
            if autoWaterEnabled then
                simulatePlantAction("Regando", "Plot1")
            end
            if autoHarvestEnabled then
                simulatePlantAction("Colhendo", "Plot2")
            end
            if autoPlantEnabled then
                simulatePlantAction("Plantando " .. selectedSeed, "Plot3")
            end
        end
        
        if autoBuySeedEnabled then
            simulateShopPurchase(selectedSeed .. " Seeds")
        end
        
        if autoBuyGearEnabled then
            simulateShopPurchase(selectedGear)
        end
        
        if autoFeedPetEnabled then
            simulatePetFeed(selectedFruit)
        end
        
        if autoEventEnabled then
            statusLabel.Text = "🤡 Status: Coletando eventos (CLIENT)"
        end
        
        if not (autoFarmEnabled or autoEventEnabled or autoBuySeedEnabled or autoBuyGearEnabled or autoFeedPetEnabled) then
            statusLabel.Text = "🤡 Status: Aguardando comandos..."
        end
    end
end)

-- Efeito de rotação na orbe
spawn(function()
    while true do
        if orbFrame.Visible then
            for i = 0, 360, 5 do
                if not orbFrame.Visible then break end
                orbFrame.Rotation = i
                wait(0.05)
            end
        else
            wait(1)
        end
    end
end)

print("🤡 SANTOS HUB CARREGADO!")
print("🎪 Versão: CLIENT-SIDE ONLY")
print("🔴 Todas as ações são simuladas no cliente")
print("⭐ Funcionalidades:")
print("   • Auto Farm completo")
print("   • Auto Shop (Seeds & Gear)")
print("   • Auto Pet Feed")
print("   • Auto Event Farm")
print("   • Interface com tema de palhaço")
print("   • Minimizar para orbe rotativa")
print("🤡 Criado por Santos - Divirta-se!")
