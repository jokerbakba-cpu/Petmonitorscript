-- Santos Hub 🔪🤡 - Mobile Killer Clown Edition
-- Otimizado para Mobile com tema assombrado

-- Serviços
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")

local lplr = Players.LocalPlayer
local playerGui = lplr:WaitForChild("PlayerGui")

-- Variáveis globais
local config = {
    autoFarm = false,
    autoWater = false,
    autoHarvest = false,
    autoPlant = false,
    autoBuySeeds = false,
    autoBuyGear = false,
    autoFeedPet = false,
    autoEvent = false,
    autoSell = false,
    autoUpgrade = false,
    autoCollectCoins = false,
    selectedSeed = "Carrot",
    selectedGear = "Watering Can",
    selectedFruit = "Apple",
    farmDelay = 2,
    walkSpeed = 16,
    jumpPower = 50
}

local isMinimized = false
local currentTab = 1

-- Cores do tema Killer Clown
local colors = {
    background = Color3.fromRGB(15, 15, 20),
    secondary = Color3.fromRGB(25, 25, 35),
    accent = Color3.fromRGB(180, 30, 30),
    danger = Color3.fromRGB(220, 20, 20),
    success = Color3.fromRGB(50, 180, 50),
    warning = Color3.fromRGB(255, 150, 0),
    text = Color3.fromRGB(255, 255, 255),
    textDark = Color3.fromRGB(200, 200, 200),
    border = Color3.fromRGB(100, 20, 20)
}

-- Criar GUI principal
local gui = Instance.new("ScreenGui")
gui.Name = "SantosHubMobile"
gui.Parent = playerGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = gui
mainFrame.Size = UDim2.new(0, 380, 0, 500)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
mainFrame.BackgroundColor3 = colors.background
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

-- Sombra assombrada
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Parent = gui
shadow.Size = UDim2.new(0, 385, 0, 505)
shadow.Position = UDim2.new(0.5, -187.5, 0.5, -247.5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.3
shadow.ZIndex = mainFrame.ZIndex - 1

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 15)
shadowCorner.Parent = shadow

-- Borda vermelha sangrenta
local stroke = Instance.new("UIStroke")
stroke.Parent = mainFrame
stroke.Color = colors.danger
stroke.Thickness = 3

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Header assombrado
local header = Instance.new("Frame")
header.Parent = mainFrame
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = colors.danger
header.BorderSizePixel = 0

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 20, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 15, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 10, 10))
}
headerGradient.Rotation = 45
headerGradient.Parent = header

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Título macabro
local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔪🤡 SANTOS HUB 🤡🔪"
title.TextColor3 = colors.text
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

-- Emoji piscante
local blinkingEmoji = Instance.new("TextLabel")
blinkingEmoji.Parent = header
blinkingEmoji.Size = UDim2.new(0, 40, 0, 40)
blinkingEmoji.Position = UDim2.new(1, -110, 0.5, -20)
blinkingEmoji.BackgroundTransparency = 1
blinkingEmoji.Text = "👁️"
blinkingEmoji.TextScaled = true
blinkingEmoji.TextColor3 = colors.text

-- Botão minimizar
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Parent = header
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -45, 0.5, -17.5)
minimizeBtn.BackgroundColor3 = colors.text
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = colors.danger
minimizeBtn.TextSize = 20
minimizeBtn.Font = Enum.Font.GothamBold

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0.5, 0)
minCorner.Parent = minimizeBtn

-- Orbe minimizada
local orbFrame = Instance.new("ImageButton")
orbFrame.Name = "OrbFrame"
orbFrame.Parent = gui
orbFrame.Size = UDim2.new(0, 70, 0, 70)
orbFrame.Position = UDim2.new(0, 30, 0, 100)
orbFrame.BackgroundColor3 = colors.danger
orbFrame.BorderSizePixel = 0
orbFrame.Visible = false
orbFrame.Active = true
orbFrame.Draggable = true

local orbCorner = Instance.new("UICorner")
orbCorner.CornerRadius = UDim.new(0.5, 0)
orbCorner.Parent = orbFrame

local orbGradient = Instance.new("UIGradient")
orbGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 30, 30))
}
orbGradient.Parent = orbFrame

local orbText = Instance.new("TextLabel")
orbText.Parent = orbFrame
orbText.Size = UDim2.new(1, 0, 1, 0)
orbText.BackgroundTransparency = 1
orbText.Text = "🤡"
orbText.TextScaled = true
orbText.TextColor3 = colors.text

-- Sistema de abas mobile
local tabContainer = Instance.new("Frame")
tabContainer.Parent = mainFrame
tabContainer.Size = UDim2.new(1, 0, 0, 50)
tabContainer.Position = UDim2.new(0, 0, 0, 60)
tabContainer.BackgroundColor3 = colors.secondary
tabContainer.BorderSizePixel = 0

local tabs = {"🚜", "🛒", "🐾", "🎉", "⚙️"}
local tabNames = {"Farm", "Shop", "Pet", "Event", "Settings"}
local tabButtons = {}

-- Container de conteúdo
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Parent = mainFrame
contentFrame.Size = UDim2.new(1, 0, 1, -110)
contentFrame.Position = UDim2.new(0, 0, 0, 110)
contentFrame.BackgroundColor3 = colors.background
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 5
contentFrame.ScrollBarImageColor3 = colors.accent
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 800)

-- Função para criar botão
local function createButton(text, position, size, callback, color)
    local btn = Instance.new("TextButton")
    btn.Parent = contentFrame
    btn.Size = size or UDim2.new(0, 340, 0, 45)
    btn.Position = position
    btn.BackgroundColor3 = color or colors.secondary
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = colors.text
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.TextStrokeTransparency = 0.5
    btn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = colors.border
    btnStroke.Thickness = 2
    btnStroke.Parent = btn
    
    -- Efeito de toque
    btn.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(btn, TweenInfo.new(0.1), {Size = (size or UDim2.new(0, 340, 0, 45)) + UDim2.new(0, 10, 0, 5)})
        tween:Play()
        tween.Completed:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = size or UDim2.new(0, 340, 0, 45)}):Play()
        end)
        callback()
    end)
    
    return btn
end

-- Função para criar dropdown mobile
local function createMobileDropdown(options, position, callback)
    local dropdown = Instance.new("TextButton")
    dropdown.Parent = contentFrame
    dropdown.Size = UDim2.new(0, 160, 0, 35)
    dropdown.Position = position
    dropdown.BackgroundColor3 = colors.secondary
    dropdown.BorderSizePixel = 0
    dropdown.Text = options[1] .. " ▼"
    dropdown.TextColor3 = colors.text
    dropdown.TextSize = 12
    dropdown.Font = Enum.Font.Gotham
    
    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 8)
    dropCorner.Parent = dropdown
    
    local dropStroke = Instance.new("UIStroke")
    dropStroke.Color = colors.border
    dropStroke.Thickness = 1
    dropStroke.Parent = dropdown
    
    local currentIndex = 1
    dropdown.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then currentIndex = 1 end
        dropdown.Text = options[currentIndex] .. " ▼"
        callback(options[currentIndex])
    end)
    
    return dropdown
end

-- Função para criar label
local function createLabel(text, position, color)
    local label = Instance.new("TextLabel")
    label.Parent = contentFrame
    label.Size = UDim2.new(0, 340, 0, 25)
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or colors.textDark
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    return label
end

-- Criar abas
for i, icon in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Parent = tabContainer
    tabBtn.Size = UDim2.new(1/#tabs, 0, 1, 0)
    tabBtn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    tabBtn.BackgroundColor3 = i == 1 and colors.accent or colors.secondary
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = icon
    tabBtn.TextColor3 = colors.text
    tabBtn.TextSize = 20
    tabBtn.Font = Enum.Font.GothamBold
    
    tabBtn.MouseButton1Click:Connect(function()
        for j, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = colors.secondary
        end
        tabBtn.BackgroundColor3 = colors.accent
        currentTab = i
        showTab(i)
    end)
    
    tabButtons[i] = tabBtn
end

-- Função para mostrar aba
function showTab(tabIndex)
    -- Limpar conteúdo
    for _, child in pairs(contentFrame:GetChildren()) do
        if not child:IsA("UICorner") and not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
    
    local yPos = 20
    
    if tabIndex == 1 then -- Farm Tab
        createLabel("🔪 AUTO FARM MACABRO 🔪", UDim2.new(0, 20, 0, yPos), colors.danger)
        yPos = yPos + 35
        
        local autoFarmBtn = createButton("🔴 Master Farm: OFF", UDim2.new(0, 20, 0, yPos), nil, function()
            config.autoFarm = not config.autoFarm
            autoFarmBtn.Text = (config.autoFarm and "🟢" or "🔴") .. " Master Farm: " .. (config.autoFarm and "ON" or "OFF")
            autoFarmBtn.BackgroundColor3 = config.autoFarm and colors.success or colors.secondary
            notify(config.autoFarm and "🤡 Farm do Terror Ativado!" or "🤡 Farm Desativado!")
        end)
        yPos = yPos + 55
        
        local autoWaterBtn = createButton("🔴 Auto Water: OFF", UDim2.new(0, 20, 0, yPos), nil, function()
            config.autoWater = not config.autoWater
            autoWaterBtn.Text = (config.autoWater and "🟢" or "🔴") .. " Auto Water: " .. (config.autoWater and "ON" or "OFF")
            autoWaterBtn.BackgroundColor3 = config.autoWater and colors.success or colors.secondary
        end)
        yPos = yPos + 55
        
        local autoHarvestBtn = createButton("🔴 Auto Harvest: OFF", UDim2.new(0, 20, 0, yPos), nil, function()
            config.autoHarvest = not config.autoHarvest
            autoHarvestBtn.Text = (config.autoHarvest and "🟢" or "🔴") .. " Auto Harvest: " .. (config.autoHarvest and "ON" or "OFF")
            autoHarvestBtn.BackgroundColor3 = config.autoHarvest and colors.success or colors.secondary
        end)
        yPos = yPos + 55
        
        local autoPlantBtn = createButton("🔴 Auto Plant: OFF", UDim2.new(0, 20, 0, yPos), nil, function()
            config.autoPlant = not config.autoPlant
            autoPlantBtn.Text = (config.autoPlant and "🟢" or "🔴") .. " Auto Plant: " .. (config.autoPlant and "ON" or "OFF")
            autoPlantBtn.BackgroundColor3 = config.autoPlant and colors.success or colors.secondary
        end)
        yPos = yPos + 60
        
        createLabel("🌱 Selecionar Semente:", UDim2.new(0, 20, 0, yPos), colors.textDark)
        createMobileDropdown({"Carrot", "Potato", "Corn", "Tomato", "Wheat", "Lettuce"}, UDim2.new(0, 200, 0, yPos - 5), function(seed)
            config.selectedSeed = seed
            notify("🌱 Semente: " .. seed)
        end)
        yPos = yPos + 60
        
        createButton("🌾 Collect All Grown Plants", UDim2.new(0, 20, 0, yPos), nil, function()
            harvestAllPlants()
            notify("🤡 Coletando todas as plantas!")
        end, colors.warning)
        
    elseif tabIndex == 2 then -- Shop Tab
        createLabel("🛒 LOJA DO TERROR 🛒", UDim2.new(0, 20, 0, yPos), colors.danger)
        yPos = yPos + 35
        
        local autoBuySeedsBtn = createButton("🔴 Auto Buy Seeds: OFF", UDim2.new(0, 20, 0, yPos), nil, function()
            config.autoBuySeeds = not config.autoBuySeeds
            autoBuySeedsBtn.Text = (config.autoBuySeeds and "🟢" or "🔴") .. " Auto Buy Seeds: " .. (config.autoBuySeeds and "ON" or "OFF")
            autoBuySeedsBtn.BackgroundColor3 = config.autoBuySeeds and colors.success or colors.secondary
        end)
        yPos = yPos + 55
        
        local autoBuyGearBtn = createButton("🔴 Auto Buy Gear: OFF", UDim2.new(0, 20, 0, yPos), nil, function()
            config.autoBuyGear = not config.autoBuyGear
            autoBuyGearBtn.Text = (config.autoBuyGear and "🟢" or "🔴") .. " Auto Buy Gear: " .. (config.autoBuyGear and "ON" or "OFF")
            autoBuyGearBtn.BackgroundColor3 = config.autoBuyGear and colors.success or colors.secondary
        end)
        yPos = yPos + 60
        
        createLabel("🔧 Selecionar Gear:", UDim2.new(0, 20, 0, yPos), colors.textDark)
        createMobileDropdown({"Watering Can", "Fertilizer", "Shovel", "Hoe", "Sprinkler"}, UDim2.new(0, 200, 0, yPos - 5), function(gear)
            config.selectedGear = gear
            notify("🔧 Gear: " .. gear)
        end)
        yPos = yPos + 60
        
        local autoSellBtn = createButton("🔴 Auto Sell Crops: OFF", UDim2.new(0, 20, 0, yPos), nil, function()
            config.autoSell = not config.autoSell
            autoSellBtn.Text = (config.autoSell and "🟢" or "🔴") .. " Auto Sell Crops: " .. (config.autoSell and "ON" or "OFF")
            autoSellBtn.BackgroundColor3 = config.autoSell and colors.success or colors.secondary
        end)
        yPos = yPos + 55
        
        createButton("💰 Sell All Items Now", UDim2.new(0, 20, 0, yPos), nil, function()
            sellAllItems()
            notify("🤡 Vendendo tudo!")
        end, colors.warning)
        
    elseif tabIndex == 3 then -- Pet Tab
        createLabel("🐾 PETS ASSOMBRADOS 🐾", UDim2.new(0, 20, 0, yPos), colors.danger)
        yPos = yPos + 35
        
        local autoFeedPetBtn = createButton("🔴 Auto Feed Pet: OFF", UDim2.new(0, 20, 0, yPos), nil, function()
            config.autoFeedPet = not config.autoFeedPet
            autoFeedPetBtn.Text = (config.autoFeedPet and "🟢" or "🔴") .. " Auto Feed Pet: " .. (config.autoFeedPet and "ON" or "OFF")
            autoFeedPetBtn.BackgroundColor3 = config.autoFeedPet and colors.success or colors.secondary
        end)
        yPos = yPos + 60
        
        createLabel("🍎 Selecionar Fruta:", UDim2.new(0, 20, 0, yPos), colors.textDark)
        createMobileDropdown({"Apple", "Orange", "Banana", "Strawberry", "Watermelon"}, UDim2.new(0, 200, 0, yPos - 5), function(fruit)
            config.selectedFruit = fruit
            notify("🍎 Fruta: " .. fruit)
        end)
        yPos = yPos + 60
        
        createButton("🐕 Find and Feed All Pets", UDim2.new(0, 20, 0, yPos), nil, function()
            feedAllPets()
            notify("🤡 Alimentando todos os pets!")
        end, colors.warning)
        
    elseif tabIndex == 4 then -- Event Tab
        createLabel("🎉 EVENTOS MACABROS 🎉", UDim2.new(0, 20, 0, yPos), colors.danger)
        yPos = yPos + 35
        
        local autoEventBtn = createButton("🔴 Auto Collect Events: OFF", UDim2.new(0, 20, 0, yPos), nil, function()
            config.autoEvent = not config.autoEvent
            autoEventBtn.Text = (config.autoEvent and "🟢" or "🔴") .. " Auto Collect Events: " .. (config.autoEvent and "ON" or "OFF")
            autoEventBtn.BackgroundColor3 = config.autoEvent and colors.warning or colors.secondary
        end)
        yPos = yPos + 55
        
        local autoCoinsBtn = createButton("🔴 Auto Collect Coins: OFF", UDim2.new(0, 20, 0, yPos), nil, function()
            config.autoCollectCoins = not config.autoCollectCoins
            autoCoinsBtn.Text = (config.autoCollectCoins and "🟢" or "🔴") .. " Auto Collect Coins: " .. (config.autoCollectCoins and "ON" or "OFF")
            autoCoinsBtn.BackgroundColor3 = config.autoCollectCoins and colors.success or colors.secondary
        end)
        yPos = yPos + 55
        
        createButton("🎁 Collect All Events Now", UDim2.new(0, 20, 0, yPos), nil, function()
            collectAllEvents()
            notify("🤡 Coletando todos os eventos!")
        end, colors.warning)
        
    elseif tabIndex == 5 then -- Settings Tab
        createLabel("⚙️ CONFIGURAÇÕES DO TERROR ⚙️", UDim2.new(0, 20, 0, yPos), colors.danger)
        yPos = yPos + 35
        
        createButton("🚀 Speed Boost (WalkSpeed)", UDim2.new(0, 20, 0, yPos), nil, function()
            if lplr.Character and lplr.Character:FindFirstChild("Humanoid") then
                lplr.Character.Humanoid.WalkSpeed = lplr.Character.Humanoid.WalkSpeed == 16 and 50 or 16
                notify("🤡 Speed: " .. lplr.Character.Humanoid.WalkSpeed)
            end
        end, colors.warning)
        yPos = yPos + 55
        
        createButton("🦘 Jump Boost (JumpPower)", UDim2.new(0, 20, 0, yPos), nil, function()
            if lplr.Character and lplr.Character:FindFirstChild("Humanoid") then
                lplr.Character.Humanoid.JumpPower = lplr.Character.Humanoid.JumpPower == 50 and 120 or 50
                notify("🤡 Jump: " .. lplr.Character.Humanoid.JumpPower)
            end
        end, colors.warning)
        yPos = yPos + 55
        
        createButton("👻 Noclip Toggle", UDim2.new(0, 20, 0, yPos), nil, function()
            toggleNoclip()
        end, colors.accent)
        yPos = yPos + 55
        
        createButton("🌙 Fullbright Toggle", UDim2.new(0, 20, 0, yPos), nil, function()
            toggleFullbright()
        end, colors.accent)
        yPos = yPos + 55
        
        createButton("🔪 Destroy Hub", UDim2.new(0, 20, 0, yPos), nil, function()
            gui:Destroy()
            notify("🤡 Santos Hub destruído!")
        end, colors.danger)
        yPos = yPos + 70
        
        createLabel("🎪 Santos Hub Mobile v2.0", UDim2.new(0, 20, 0, yPos), colors.textDark)
        yPos = yPos + 25
        createLabel("🤡 Killer Clown Edition", UDim2.new(0, 20, 0, yPos), colors.danger)
        yPos = yPos + 25
        createLabel("📱 Otimizado para Mobile", UDim2.new(0, 20, 0, yPos), colors.textDark)
    end
end

-- Funções do jogo
function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "🤡 Santos Hub";
            Text = text;
            Duration = 3;
        })
    end)
end

function findPlots()
    local plots = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("plot") and (obj:FindFirstChild("Soil") or obj:IsA("Model")) then
            table.insert(plots, obj)
        end
    end
    return plots
end

function harvestAllPlants()
    local plots = findPlots()
    for _, plot in pairs(plots) do
        pcall(function()
            local remote = ReplicatedStorage:FindFirstChild("Remotes")
            if remote and 
