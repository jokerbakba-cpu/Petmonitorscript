-- Esse código cria o RemoteEvent se não existir, o sistema no servidor e GUI no cliente

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Criar pasta e RemoteEvent para comunicação
local PetRemotes = ReplicatedStorage:FindFirstChild("PetRemotes")
if not PetRemotes then
    PetRemotes = Instance.new("Folder")
    PetRemotes.Name = "PetRemotes"
    PetRemotes.Parent = ReplicatedStorage
end

local RequestSpawnPet = PetRemotes:FindFirstChild("RequestSpawnPet")
if not RequestSpawnPet then
    RequestSpawnPet = Instance.new("RemoteEvent")
    RequestSpawnPet.Name = "RequestSpawnPet"
    RequestSpawnPet.Parent = PetRemotes
end

-- Lista oficial dos pets
local PETS = {
    "Bunny", "Black Bunny", "Dog", "Golden Lab", "Bee", "Honey Bee",
    "Cat", "Orange Tabby", "Chicken", "Rooster", "Deer", "Spotted Deer",
    "Hedgehog", "Kiwi", "Snail", "Pig", "Monkey", "Dragonfly", "Giant Ant",
    "Red Giant Ant", "Praying Mantis", "Mole", "Frog", "Turtle", "Moon Cat",
    "Scarlet Macaw", "Ostrich", "Peacock", "Capybara", "Blood Hedgehog",
    "Petal Bee", "Moth", "Raccoon", "Queen Bee", "Disco Bee", "Fennec Fox",
    "Mimic Octopus", "Bear Bee", "Brown Mouse", "Blood Owl", "Butterfly",
    "Firefly", "T-Rex", "Spinosaurus", "Ankylosaurus"
}

-- SERVIDOR: Função para criar pet no inventário do jogador
local function createPet(player, petName, peso, idade, fome, mutacao)
    local inv = player:FindFirstChild("Inventory")
    if not inv then return end
    local petsFolder = inv:FindFirstChild("Pets")
    if not petsFolder then return end

    local petFolder = Instance.new("Folder")
    petFolder.Name = petName .. "_" .. tostring(math.random(1000,9999))
    petFolder:SetAttribute("Nome", petName)
    petFolder:SetAttribute("Peso", peso)
    petFolder:SetAttribute("Idade", idade)
    petFolder:SetAttribute("Fome", fome)
    petFolder:SetAttribute("Mutacao", mutacao)
    petFolder.Parent = petsFolder

    return petFolder
end

-- Listener do RemoteEvent para spawnar pet
RequestSpawnPet.OnServerEvent:Connect(function(player, petName, peso, idade, fome, mutacao)
    -- Validar dados simples
    if type(petName) ~= "string" then return end
    if not table.find(PETS, petName) then return end
    peso = tonumber(peso) or 0
    idade = tonumber(idade) or 0
    fome = tonumber(fome) or 0
    mutacao = mutacao == true

    local pet = createPet(player, petName, peso, idade, fome, mutacao)
    if pet then
        print("Pet criado para "..player.Name..": "..petName)
    end
end)

-- CLIENTE: criar interface Santos Hub
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local pets = PETS -- mesmo array do servidor

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SantosHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local function createLabel(parent, text, size, pos)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = size
    label.Position = pos
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.TextScaled = true
    label.Parent = parent
    return label
end

local function createButton(parent, text, size, pos, color)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = parent
    return btn
end

local function createTextBox(parent, placeholder, size, pos)
    local tb = Instance.new("TextBox")
    tb.Size = size
    tb.Position = pos
    tb.PlaceholderText = placeholder
    tb.Font = Enum.Font.Gotham
    tb.TextColor3 = Color3.new(1,1,1)
    tb.BackgroundColor3 = Color3.fromRGB(50,50,50)
    tb.ClearTextOnFocus = false
    tb.TextScaled = true
    tb.Parent = parent
    return tb
end

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 520)
frame.Position = UDim2.new(0.5, -180, 0.5, -260)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Barra de título
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.Parent = frame

local titleLabel = createLabel(titleBar, "Santos Hub", UDim2.new(0.7, 0, 1, 0), UDim2.new(0,10,0,0))
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local minimizeBtn = createButton(titleBar, "-", UDim2.new(0, 40, 1, 0), UDim2.new(1, -45, 0, 0), Color3.fromRGB(180, 50, 50))

-- Container para conteúdo
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -40)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundTransparency = 1
content.Parent = frame

-- Dropdown label
createLabel(content, "Escolha o Pet", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, 0))

-- Dropdown box
local dropdownBox = Instance.new("TextBox")
dropdownBox.Size = UDim2.new(1, -20, 0, 35)
dropdownBox.Position = UDim2.new(0, 10, 0, 30)
dropdownBox.PlaceholderText = "Clique para escolher"
dropdownBox.ClearTextOnFocus = false
dropdownBox.Text = ""
dropdownBox.Font = Enum.Font.Gotham
dropdownBox.TextColor3 = Color3.new(1,1,1)
dropdownBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
dropdownBox.Parent = content

-- Lista dropdown
local dropdownList = Instance.new("ScrollingFrame")
dropdownList.Size = UDim2.new(1, -20, 0, 140)
dropdownList.Position = UDim2.new(0, 10, 0, 70)
dropdownList.BackgroundColor3 = Color3.fromRGB(35,35,35)
dropdownList.BorderSizePixel = 0
dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownList.ScrollBarThickness = 6
dropdownList.Visible = false
dropdownList.Parent = content

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = dropdownList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

for i, petName in ipairs(pets) do
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, -10, 0, 30)
    item.Position = UDim2.new(0, 5, 0, (i-1)*30)
    item.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    item.TextColor3 = Color3.new(1,1,1)
    item.Font = Enum.Font.Gotham
    item.TextSize = 20
    item.Text = petName
    item.Parent = dropdownList
    item.AutoButtonColor = true
    item.MouseEnter:Connect(function()
        item.BackgroundColor3 = Color3.fromRGB(70,70,70)
    end)
    item.MouseLeave:Connect(function()
        item.BackgroundColor3 = Color3.fromRGB(45,45,45)
    end)
    item.MouseButton1Click:Connect(function()
        dropdownBox.Text = petName
        dropdownList.Visible = false
    end)
end

dropdownList.CanvasSize = UDim2.new(0, 0, 0, #pets * 30)

dropdownBox.Focused:Connect(function()
    dropdownList.Visible = true
end)

dropdownBox.FocusLost:Connect(function()
    wait(0.2)
    local UIS = game:GetService("UserInputService")
    if not dropdownList:IsAncestorOf(UIS:GetFocusedTextBox()) then
        dropdownList.Visible = false
    end
end)

-- Campo Peso
createLabel(content, "Peso (kg)", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, 215))
local pesoBox = createTextBox(content, "Ex: 5.0", UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 240))

-- Campo Idade
createLabel(content, "Idade (dias)", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, 285))
local idadeBox = createTextBox(content, "Ex: 10", UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 310))

-- Campo Fome
createLabel(content, "Fome (0-100)", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, 355))
local fomeBox = createTextBox(content, "Ex: 50", UDim2.new(1, -20, 0, 35), UDim2.new(0, 10, 0, 380))

-- Botão Mutação
local mutacaoBtn = createButton(content, "Mutação: Não", UDim2.new(1, -20, 0, 40), UDim2.new(0, 10, 0, 425), Color3.fromRGB(70, 70, 70))
local isMutated = false
mutacaoBtn.MouseButton1Click:Connect(function()
    isMutated = not isMutated
    mutacaoBtn.Text = "Mutação: " .. (isMutated and "Sim" or "Não")
    mutacaoBtn.BackgroundColor3 = isMutated and Color3.fromRGB(100, 150, 100) or Color3.fromRGB(70, 70, 70)
end)

-- Botão Spawnar Pet
local spawnBtn = createButton(content, "Spawnar Pet", UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 475), Color3.fromRGB(40, 130, 220))

spawnBtn.MouseButton1Click:Connect(function()
    local petName = dropdownBox.Text
    local peso = tonumber(pesoBox.Text) or 0
    local idade = tonumber(idadeBox.Text) or 0
    local fome = tonumber(fomeBox.Text) or 0

    if not petName or petName == "" then
        warn("Selecione um pet")
        return
    end

    -- Envia pro servidor criar pet
    RequestSpawnPet:FireServer(petName, peso, idade, fome, isMutated)
    -- Fecha interface
    screenGui:Destroy()
end)

-- Minimize funcionalidade
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        content.Visible = false
        frame.Size = UDim2.new(0, 360, 0, 40)
        minimizeBtn.Text = "+"
    else
        content.Visible = true
        frame.Size = UDim2.new(0, 360, 0, 520)
        minimizeBtn.Text = "-"
    end
end)
