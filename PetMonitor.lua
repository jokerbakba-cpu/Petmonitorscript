-- Santos Hub 🤡 - Grow a Garden Professional Script
-- Inspirado em loaders profissionais com LinoriaLib

-- Carregar LinoriaLib
local lib = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua'))()

-- Serviços
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local lplr = Players.LocalPlayer
local info = MarketplaceService:GetProductInfo(game.PlaceId)

-- Verificar se é o jogo correto (Grow a Garden)
if game.PlaceId ~= 126884695634066 then
    lib:Notify('Jogo não suportado: ' .. info.Name .. '. Este script é para Grow a Garden!')
    return
end

-- Variáveis de controle
local Toggles = {}
local Options = {}

-- Configurações
local config = {
    autoFarm = false,
    autoWater = false,
    autoHarvest = false,
    autoPlant = false,
    autoBuySeeds = false,
    autoBuyGear = false,
    autoFeedPet = false,
    autoEvent = false,
    selectedSeed = "Carrot",
    selectedGear = "Watering Can", 
    selectedFruit = "Apple",
    farmDelay = 2,
    shopDelay = 5,
    petDelay = 3
}

-- Criar a janela principal
local Window = lib:CreateWindow({
    Title = '🤡 Santos Hub - Grow a Garden',
    Center = true,
    AutoShow = true,
    Resizable = true,
    ShowCustomCursor = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- Abas
local MainTab = Window:AddTab('🚜 Auto Farm')
local ShopTab = Window:AddTab('🛒 Auto Shop')
local PetTab = Window:AddTab('🐾 Pet Farm')
local EventTab = Window:AddTab('🎉 Events')
local SettingsTab = Window:AddTab('⚙️ Settings')

-- Funções do jogo
local function findPlots()
    local plots = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:find("Plot") or obj.Name:find("plot") then
            if obj:FindFirstChild("Soil") or obj:IsA("Model") then
                table.insert(plots, obj)
            end
        end
    end
    return plots
end

local function getRemote(name)
    local remote = ReplicatedStorage:FindFirstChild("Remotes")
    if remote then
        return remote:FindFirstChild(name)
    end
    return nil
end

local function waterPlant(plot)
    local remote = getRemote("PlotAction") or getRemote("Water") or getRemote("WaterPlot")
    if remote then
        pcall(function()
            remote:FireServer(plot, "Water")
        end)
    end
end

local function harvestPlant(plot)
    local remote = getRemote("PlotAction") or getRemote("Harvest") or getRemote("HarvestPlot")
    if remote then
        pcall(function()
            remote:FireServer(plot, "Harvest")
        end)
    end
end

local function plantSeed(plot, seedType)
    local remote = getRemote("PlotAction") or getRemote("Plant") or getRemote("PlantSeed")
    if remote then
        pcall(function()
            remote:FireServer(plot, "Plant", seedType or config.selectedSeed)
        end)
    end
end

local function buyItem(itemType, itemName)
    local remote = getRemote("Shop") or getRemote("BuyItem") or getRemote("Purchase")
    if remote then
        pcall(function()
            remote:FireServer(itemType, itemName)
        end)
    end
end

local function feedPet(fruit)
    local remote = getRemote("PetAction") or getRemote("FeedPet") or getRemote("Pet")
    if remote then
        pcall(function()
            remote:FireServer("Feed", fruit or config.selectedFruit)
        end)
    end
end

local function collectEvents()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:find("Event") or obj.Name:find("Gift") or obj.Name:find("Chest") or obj.Name:find("Coin") then
            if obj:FindFirstChild("ClickDetector") then
                pcall(function()
                    fireclickdetector(obj.ClickDetector)
                end)
            elseif obj:FindFirstChild("ProximityPrompt") then
                pcall(function()
                    fireproximityprompt(obj.ProximityPrompt)
                end)
            end
        end
    end
end

-- ABA MAIN FARM
local MainGroup = MainTab:AddLeftGroupbox('🚜 Auto Farm Controls')

MainGroup:AddToggle('AutoFarmToggle', {
    Text = 'Auto Farm Master',
    Default = false,
    Tooltip = 'Ativa/desativa todas as funções de farm automaticamente',
    Callback = function(Value)
        config.autoFarm = Value
        lib:Notify(Value and '🟢 Auto Farm Ativado!' or '🔴 Auto Farm Desativado!')
    end
})

MainGroup:AddToggle('AutoWaterToggle', {
    Text = 'Auto Water Plants',
    Default = false,
    Tooltip = 'Rega plantas automaticamente',
    Callback = function(Value)
        config.autoWater = Value
    end
})

MainGroup:AddToggle('AutoHarvestToggle', {
    Text = 'Auto Harvest Plants',
    Default = false,
    Tooltip = 'Colhe plantas automaticamente',
    Callback = function(Value)
        config.autoHarvest = Value
    end
})

MainGroup:AddToggle('AutoPlantToggle', {
    Text = 'Auto Plant Seeds',
    Default = false,
    Tooltip = 'Planta sementes automaticamente',
    Callback = function(Value)
        config.autoPlant = Value
    end
})

local SeedGroup = MainTab:AddRightGroupbox('🌱 Seed Selection')

SeedGroup:AddDropdown('SeedDropdown', {
    Values = {'Carrot', 'Potato', 'Corn', 'Tomato', 'Wheat', 'Lettuce', 'Onion', 'Pumpkin'},
    Default = 1,
    Multi = false,
    Text = 'Select Seed Type',
    Tooltip = 'Escolha o tipo de semente para plantar',
    Callback = function(Value)
        config.selectedSeed = Value
        lib:Notify('🌱 Semente selecionada: ' .. Value)
    end
})

SeedGroup:AddSlider('FarmDelaySlider', {
    Text = 'Farm Delay (seconds)',
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        config.farmDelay = Value
    end
})

-- ABA SHOP
local ShopGroup = ShopTab:AddLeftGroupbox('🛒 Auto Shop')

ShopGroup:AddToggle('AutoBuySeedsToggle', {
    Text = 'Auto Buy Seeds',
    Default = false,
    Tooltip = 'Compra sementes automaticamente',
    Callback = function(Value)
        config.autoBuySeeds = Value
        lib:Notify(Value and '🟢 Auto Buy Seeds Ativado!' or '🔴 Auto Buy Seeds Desativado!')
    end
})

ShopGroup:AddToggle('AutoBuyGearToggle', {
    Text = 'Auto Buy Gear',
    Default = false,
    Tooltip = 'Compra equipamentos automaticamente',
    Callback = function(Value)
        config.autoBuyGear = Value
        lib:Notify(Value and '🟢 Auto Buy Gear Ativado!' or '🔴 Auto Buy Gear Desativado!')
    end
})

local GearGroup = ShopTab:AddRightGroupbox('🔧 Gear Selection')

GearGroup:AddDropdown('GearDropdown', {
    Values = {'Watering Can', 'Fertilizer', 'Shovel', 'Hoe', 'Sprinkler', 'Garden Gloves'},
    Default = 1,
    Multi = false,
    Text = 'Select Gear Type',
    Tooltip = 'Escolha o tipo de equipamento para comprar',
    Callback = function(Value)
        config.selectedGear = Value
        lib:Notify('🔧 Equipamento selecionado: ' .. Value)
    end
})

GearGroup:AddSlider('ShopDelaySlider', {
    Text = 'Shop Delay (seconds)',
    Default = 5,
    Min = 1,
    Max = 30,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        config.shopDelay = Value
    end
})

-- ABA PET
local PetGroup = PetTab:AddLeftGroupbox('🐾 Pet Management')

PetGroup:AddToggle('AutoFeedPetToggle', {
    Text = 'Auto Feed Pet',
    Default = false,
    Tooltip = 'Alimenta pets automaticamente',
    Callback = function(Value)
        config.autoFeedPet = Value
        lib:Notify(Value and '🟢 Auto Feed Pet Ativado!' or '🔴 Auto Feed Pet Desativado!')
    end
})

local FruitGroup = PetTab:AddRightGroupbox('🍎 Fruit Selection')

FruitGroup:AddDropdown('FruitDropdown', {
    Values = {'Apple', 'Orange', 'Banana', 'Strawberry', 'Watermelon', 'Grapes', 'Pineapple'},
    Default = 1,
    Multi = false,
    Text = 'Select Fruit Type',
    Tooltip = 'Escolha o tipo de fruta para alimentar o pet',
    Callback = function(Value)
        config.selectedFruit = Value
        lib:Notify('🍎 Fruta selecionada: ' .. Value)
    end
})

FruitGroup:AddSlider('PetDelaySlider', {
    Text = 'Pet Feed Delay (seconds)',
    Default = 3,
    Min = 1,
    Max = 15,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        config.petDelay = Value
    end
})

-- ABA EVENTS
local EventGroup = EventTab:AddLeftGroupbox('🎉 Event Farming')

EventGroup:AddToggle('AutoEventToggle', {
    Text = 'Auto Collect Events',
    Default = false,
    Tooltip = 'Coleta eventos, gifts e coins automaticamente',
    Callback = function(Value)
        config.autoEvent = Value
        lib:Notify(Value and '🟢 Auto Event Ativado!' or '🔴 Auto Event Desativado!')
    end
})

EventGroup:AddButton('Collect All Events Now', function()
    collectEvents()
    lib:Notify('🎉 Coletando todos os eventos disponíveis!')
end)

local StatusGroup = EventTab:AddRightGroupbox('📊 Status')

local StatusLabel = StatusGroup:AddLabel('Status: Aguardando...')

-- ABA SETTINGS
local SettingsGroup = SettingsTab:AddLeftGroupbox('⚙️ Hub Settings')

SettingsGroup:AddButton('Destroy Hub', function()
    lib:Unload()
    lib:Notify('🤡 Santos Hub descarregado!')
end)

SettingsGroup:AddLabel('🤡 Santos Hub v1.0')
SettingsGroup:AddLabel('🎪 Feito para Grow a Garden')
SettingsGroup:AddLabel('⚡ Usando LinoriaLib')

-- Configurar temas
ThemeManager:SetLibrary(lib)
ThemeManager:SetFolder('SantosHub')
ThemeManager:ApplyToTab(SettingsTab)

-- Configurar salvamento
SaveManager:SetLibrary(lib)
SaveManager:SetFolder('SantosHub/configs')
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
SaveManager:ApplyToTab(SettingsTab)

-- Loops principais
local farmLoop = nil
local shopLoop = nil  
local petLoop = nil
local eventLoop = nil

-- Loop do Auto Farm
farmLoop = task.spawn(function()
    while true do
        if config.autoFarm then
            local plots = findPlots()
            
            for _, plot in pairs(plots) do
                if config.autoWater then
                    waterPlant(plot)
                    task.wait(0.1)
                end
                
                if config.autoHarvest then
                    harvestPlant(plot)
                    task.wait(0.1)
                end
                
                if config.autoPlant then
                    plantSeed(plot, config.selectedSeed)
                    task.wait(0.1)
                end
            end
            
            StatusLabel:SetText('Status: Farm ativo - ' .. #plots .. ' plots processados')
        else
            StatusLabel:SetText('Status: Farm inativo')
        end
        
        task.wait(config.farmDelay)
    end
end)

-- Loop da Loja
shopLoop = task.spawn(function()
    while true do
        if config.autoBuySeeds then
            buyItem("Seeds", config.selectedSeed)
            task.wait(0.5)
        end
        
        if config.autoBuyGear then
            buyItem("Gear", config.selectedGear)
            task.wait(0.5)
        end
        
        task.wait(config.shopDelay)
    end
end)

-- Loop do Pet
petLoop = task.spawn(function()
    while true do
        if config.autoFeedPet then
            feedPet(config.selectedFruit)
        end
        
        task.wait(config.petDelay)
    end
end)

-- Loop dos Eventos
eventLoop = task.spawn(function()
    while true do
        if config.autoEvent then
            collectEvents()
        end
        
        task.wait(2)
    end
end)

-- Notificação de carregamento
lib:Notify('🤡 Santos Hub carregado com sucesso!')
lib:Notify('🎪 Bem-vindo ao Grow a Garden Hub!')

-- Configuração da tecla de menu
lib.ToggleKeybind = Options.MenuKeybind

-- Carregar configuração
task.spawn(function()
    task.wait(1)
    SaveManager:LoadAutoloadConfig()
end)

print("🤡 SANTOS HUB CARREGADO!")
print("🎪 Versão: Professional com LinoriaLib")
print("⚡ Funcionalidades:")
print("   • Auto Farm completo")
print("   • Auto Shop inteligente") 
print("   • Auto Pet Feed")
print("   • Auto Event Collection")
print("   • Interface profissional")
print("   • Sistema de salvamento")
print("🤡 Divirta-se com o melhor hub!")
