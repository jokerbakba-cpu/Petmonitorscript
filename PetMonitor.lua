--[[ Pet Cloner GUI Script ]]--

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local petsFolder = workspace:WaitForChild("Pets")

-- Criar GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PetCloneGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Painel principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 160)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🐾 Pet Cloner"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

-- Botão minimizar
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -30, 0, 0)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.Parent = frame

-- Botão clonar pet equipado
local cloneBtn = Instance.new("TextButton")
cloneBtn.Size = UDim2.new(1, -20, 0, 40)
cloneBtn.Position = UDim2.new(0, 10, 0, 50)
cloneBtn.Text = "🔁 Clonar Pet Equipado"
cloneBtn.BackgroundColor3 = Color3.fromRGB(80, 160, 100)
cloneBtn.TextColor3 = Color3.new(1, 1, 1)
cloneBtn.Font = Enum.Font.Gotham
cloneBtn.TextSize = 16
cloneBtn.Parent = frame

-- Label informativo
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 30)
infoLabel.Position = UDim2.new(0, 10, 0, 100)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Equipe uma ferramenta com 'dat' para clonar."
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 14
infoLabel.TextWrapped = true
infoLabel.Parent = frame

-- Contador
local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(1, -20, 0, 30)
countLabel.Position = UDim2.new(0, 10, 0, 130)
countLabel.BackgroundTransparency = 1
countLabel.Text = "Clones: 0"
countLabel.TextColor3 = Color3.fromRGB(120, 255, 120)
countLabel.Font = Enum.Font.GothamBold
countLabel.TextSize = 16
countLabel.TextXAlignment = Enum.TextXAlignment.Left
countLabel.Parent = frame

-- Lógica minimizar
local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in ipairs(frame:GetChildren()) do
        if child ~= title and child ~= minimize then
            child.Visible = not minimized
        end
    end
    minimize.Text = minimized and "+" or "-"
end)

-- Função clonar pet
local clonedCounter = 0
local function clonePet(petModel)
    if not (petModel and petModel:IsA("Model") and petModel.PrimaryPart) then return end

    local clone = petModel:Clone()
    clone.Name = petModel.Name .. "_Clone"

    local dat = petModel:FindFirstChild("Dat")
    if dat then
        if dat:IsA("ValueBase") then
            dat:Clone().Parent = clone
        else
            pcall(function() clone.Dat = petModel.Dat end)
        end
    end

    clone:SetPrimaryPartCFrame(petModel:GetPrimaryPartCFrame() + Vector3.new(3,0,3))
    clone.Parent = petsFolder

    clonedCounter += 1
    countLabel.Text = "Clones: " .. clonedCounter
end

-- Detectar pet equipado
local PlayersService = game:GetService("Players")
PlayersService.LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            child.Equipped:Connect(function()
                local pet = petsFolder:FindFirstChild(child.Name)
                if pet then clonePet(pet) end
            end)
        end
    end)
end)

-- Botão clonar manual
cloneBtn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("dat") then
            local pet = petsFolder:FindFirstChild(tool.Name)
            if pet then clonePet(pet) end
        end
    end
end)
