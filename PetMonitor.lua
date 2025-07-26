--[[ Roblox Lua - Pet Monitor & Interactables Highlighter GUI ]]--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local petsFolder = Workspace:WaitForChild("Pets") -- ajuste conforme a pasta onde pets são spawnados
local interactablesFolder = Workspace:WaitForChild("Interactables") -- ajuste conforme necessário

local clonedPets = {}
local highlightActive = false

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "PetMonitorGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "🐾 Pet Monitor"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local togglePets = Instance.new("TextButton")
togglePets.Size = UDim2.new(1, -20, 0, 30)
togglePets.Position = UDim2.new(0, 10, 0, 40)
togglePets.Text = "🔁 Clonar Pets: ON"
togglePets.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
togglePets.TextColor3 = Color3.new(1,1,1)
togglePets.Font = Enum.Font.Gotham
togglePets.TextSize = 14
togglePets.Parent = frame

local toggleNPCs = Instance.new("TextButton")
toggleNPCs.Size = UDim2.new(1, -20, 0, 30)
toggleNPCs.Position = UDim2.new(0, 10, 0, 80)
toggleNPCs.Text = "✨ Marcar NPCs: OFF"
toggleNPCs.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
toggleNPCs.TextColor3 = Color3.new(1,1,1)
toggleNPCs.Font = Enum.Font.Gotham
toggleNPCs.TextSize = 14
toggleNPCs.Parent = frame

local minimize = Instance.new("TextButton")
minimize.Text = "-"
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -30, 0, 0)
minimize.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Font = Enum.Font.SourceSansBold
minimize.TextSize = 20
minimize.Parent = frame

local minimized = false

minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, v in ipairs(frame:GetChildren()) do
		if v ~= title and v ~= minimize then
			v.Visible = not minimized
		end
	end
	minimize.Text = minimized and "+" or "-"
end)

-- Toggle Pet Cloning
local petCloningEnabled = true
togglePets.MouseButton1Click:Connect(function()
	petCloningEnabled = not petCloningEnabled
	togglePets.Text = petCloningEnabled and "🔁 Clonar Pets: ON" or "🔁 Clonar Pets: OFF"
	togglePets.BackgroundColor3 = petCloningEnabled and Color3.fromRGB(70, 130, 180) or Color3.fromRGB(100, 100, 100)
end)

-- Detect Pet Spawns
petsFolder.ChildAdded:Connect(function(pet)
	if petCloningEnabled and pet:IsA("Model") then
		task.wait(0.1)
		if pet.PrimaryPart then
			local clone = pet:Clone()
			clone.Name = pet.Name .. "_Clone"
			clone:SetPrimaryPartCFrame(pet:GetPrimaryPartCFrame() + Vector3.new(3, 0, 3))
			clone.Parent = petsFolder
			table.insert(clonedPets, clone)
		end
	end
end)

-- Toggle NPC Highlight
toggleNPCs.MouseButton1Click:Connect(function()
	highlightActive = not highlightActive
	toggleNPCs.Text = highlightActive and "✨ Marcar NPCs: ON" or "✨ Marcar NPCs: OFF"
	toggleNPCs.BackgroundColor3 = highlightActive and Color3.fromRGB(34, 139, 34) or Color3.fromRGB(128, 128, 128)

	for _, obj in ipairs(interactablesFolder:GetChildren()) do
		if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
			local hl = obj:FindFirstChildOfClass("Highlight")
			if not hl then
				hl = Instance.new("Highlight")
				hl.Parent = obj
			end
			hl.FillColor = Color3.fromRGB(255, 215, 0)
			hl.OutlineColor = Color3.fromRGB(0, 0, 0)
			hl.Enabled = highlightActive
		end
	end
end)
