local Players = game:GetService("Players")
local player = Players.LocalPlayer
local petsFolder = workspace:WaitForChild("Pets")

-- Criar GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PetCloneGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 220)
frame.Position = UDim2.new(0.7, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0, 0)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "🐕 Pet Cloner"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = frame

local minimize = Instance.new("TextButton")
minimize.Text = "-"
minimize.Size = UDim2.new(0, 40, 0, 40)
minimize.Position = UDim2.new(1, -40, 0, 0)
minimize.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 28
minimize.Parent = frame

local infoLabel = Instance.new("TextLabel")
infoLabel.Text = "Equipe um pet para cloná-lo automaticamente."
infoLabel.Size = UDim2.new(1, -20, 0, 50)
infoLabel.Position = UDim2.new(0, 10, 0, 50)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextWrapped = true
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 16
infoLabel.Parent = frame

local cloneButton = Instance.new("TextButton")
cloneButton.Text = "Clone Pet Agora"
cloneButton.Size = UDim2.new(1, -20, 0, 40)
cloneButton.Position = UDim2.new(0, 10, 0, 100)
cloneButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
cloneButton.TextColor3 = Color3.new(1, 1, 1)
cloneButton.Font = Enum.Font.GothamBold
cloneButton.TextSize = 18
cloneButton.Parent = frame

local clonedCountLabel = Instance.new("TextLabel")
clonedCountLabel.Text = "Pets clonados: 0"
clonedCountLabel.Size = UDim2.new(1, -20, 0, 30)
clonedCountLabel.Position = UDim2.new(0, 10, 0, 150)
clonedCountLabel.BackgroundTransparency = 1
clonedCountLabel.TextColor3 = Color3.fromRGB(120, 255, 120)
clonedCountLabel.Font = Enum.Font.GothamBold
clonedCountLabel.TextSize = 18
clonedCountLabel.TextXAlignment = Enum.TextXAlignment.Left
clonedCountLabel.Parent = frame

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

local clonedPetsCount = 0
local currentEquippedPet = nil

local function clonePet(pet)
	if not pet or not pet:IsA("Model") then return end
	if not pet.PrimaryPart then return end

	local clone = pet:Clone()
	clone.Name = pet.Name .. "_Clone"

	local datValue = pet:FindFirstChild("Dat")
	if datValue then
		if datValue:IsA("ValueBase") then
			local datClone = datValue:Clone()
			datClone.Parent = clone
		else
			pcall(function()
				clone.Dat = pet.Dat
			end)
		end
	end

	clone:SetPrimaryPartCFrame(pet:GetPrimaryPartCFrame() + Vector3.new(3, 0, 3))
	clone.Parent = petsFolder

	clonedPetsCount += 1
	clonedCountLabel.Text = "Pets clonados: " .. clonedPetsCount
end

local function onCharacterAdded(character)
	character.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then
			child.Equipped:Connect(function()
				local pet = petsFolder:FindFirstChild(child.Name)
				if pet then
					currentEquippedPet = pet
					clonePet(pet)
				end
			end)

			child.Unequipped:Connect(function()
				currentEquippedPet = nil
			end)
		end
	end)
end

if player.Character then
	onCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(onCharacterAdded)

-- Botão clonar manual
cloneButton.MouseButton1Click:Connect(function()
	if currentEquippedPet then
		clonePet(currentEquippedPet)
	else
		-- Se nenhum pet equipado, tenta pegar o primeiro pet da pasta Pets para clonar (opcional)
		local firstPet = petsFolder:GetChildren()[1]
		if firstPet and firstPet:IsA("Model") then
			clonePet(firstPet)
		end
	end
end)
