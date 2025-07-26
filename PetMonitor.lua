-- Script para detectar itens equipados na hotbar
-- Coloque este script em StarterGui ou StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Função para obter todas as informações de um item
local function getItemInfo(tool)
    if not tool or not tool:IsA("Tool") then
        return
    end
    
    print("=" .. string.rep("=", 50))
    print("ITEM EQUIPADO DETECTADO!")
    print("=" .. string.rep("=", 50))
    
    -- Informações básicas
    print("Nome: " .. tool.Name)
    print("Classe: " .. tool.ClassName)
    print("Parent: " .. tostring(tool.Parent))
    
    -- Localização completa
    local fullPath = {}
    local current = tool
    while current and current ~= game do
        table.insert(fullPath, 1, current.Name)
        current = current.Parent
    end
    print("Caminho completo: game." .. table.concat(fullPath, "."))
    
    -- Propriedades específicas da ferramenta
    if tool.ToolTip and tool.ToolTip ~= "" then
        print("Descrição: " .. tool.ToolTip)
    end
    
    print("Pode ser Equipado: " .. tostring(tool.CanBeDropped))
    print("Requer Handle: " .. tostring(tool.RequiresHandle))
    print("Manual de Ativação: " .. tostring(tool.ManualActivationOnly))
    
    -- Informações do Handle se existir
    local handle = tool:FindFirstChild("Handle")
    if handle then
        print("\n--- INFORMAÇÕES DO HANDLE ---")
        print("Handle Nome: " .. handle.Name)
        print("Handle Classe: " .. handle.ClassName)
        print("Handle Material: " .. tostring(handle.Material))
        print("Handle Cor: " .. tostring(handle.Color))
        print("Handle Tamanho: " .. tostring(handle.Size))
        print("Handle Posição: " .. tostring(handle.Position))
        print("Handle Rotação: " .. tostring(handle.Rotation))
        
        -- Mesh informações se houver
        local mesh = handle:FindFirstChildOfClass("SpecialMesh") or handle:FindFirstChildOfClass("Mesh")
        if mesh then
            print("Mesh Tipo: " .. tostring(mesh.MeshType or "N/A"))
            print("Mesh ID: " .. tostring(mesh.MeshId or "N/A"))
            print("Mesh Textura: " .. tostring(mesh.TextureId or "N/A"))
            print("Mesh Escala: " .. tostring(mesh.Scale or "N/A"))
        end
    end
    
    -- Scripts dentro do item
    print("\n--- SCRIPTS ENCONTRADOS ---")
    local scripts = {}
    for _, child in pairs(tool:GetDescendants()) do
        if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript") then
            table.insert(scripts, child.ClassName .. ": " .. child.Name .. " (em " .. child.Parent.Name .. ")")
        end
    end
    
    if #scripts > 0 then
        for _, scriptInfo in pairs(scripts) do
            print("  " .. scriptInfo)
        end
    else
        print("  Nenhum script encontrado")
    end
    
    -- Valores e configurações
    print("\n--- VALORES E CONFIGURAÇÕES ---")
    for _, child in pairs(tool:GetChildren()) do
        if child:IsA("ValueBase") then
            local valueType = child.ClassName:gsub("Value", "")
            print("  " .. valueType .. " '" .. child.Name .. "': " .. tostring(child.Value))
        elseif child:IsA("Configuration") then
            print("  Configuração: " .. child.Name)
        end
    end
    
    -- Atributos customizados
    local attributes = tool:GetAttributes()
    if next(attributes) then
        print("\n--- ATRIBUTOS CUSTOMIZADOS ---")
        for name, value in pairs(attributes) do
            print("  " .. name .. ": " .. tostring(value))
        end
    end
    
    -- Informações de tempo
    print("\n--- INFORMAÇÕES DE TEMPO ---")
    print("Timestamp: " .. os.date("%H:%M:%S"))
    
    print("=" .. string.rep("=", 50))
    print("")
end

-- Função para monitorar quando um item é equipado
local function onToolEquipped(tool)
    getItemInfo(tool)
end

-- Função para monitorar quando um item é desequipado
local function onToolUnequipped(tool)
    print("ITEM DESEQUIPADO: " .. tool.Name)
    print("")
end

-- Conectar aos eventos de equipar/desequipar
local function setupCharacter(char)
    local hum = char:WaitForChild("Humanoid")
    
    -- Conectar eventos
    hum.ToolEquipped:Connect(onToolEquipped)
    hum.ToolUnequipped:Connect(onToolUnequipped)
    
    print("Sistema de detecção de itens ativado!")
    print("Equipe qualquer ferramenta para ver suas informações completas.")
end

-- Configurar para o personagem atual
if character then
    setupCharacter(character)
end

-- Configurar para futuros respawns
player.CharacterAdded:Connect(setupCharacter)

-- Monitorar mudanças na mochila (hotbar)
player:WaitForChild("Backpack").ChildAdded:Connect(function(tool)
    if tool:IsA("Tool") then
        print("Novo item adicionado à mochila: " .. tool.Name)
    end
end)

player.Backpack.ChildRemoved:Connect(function(tool)
    if tool:IsA("Tool") then
        print("Item removido da mochila: " .. tool.Name)
    end
end)
