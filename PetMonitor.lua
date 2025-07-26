local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "TestGui"
gui.Parent = playerGui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0, 200, 0, 50)
textLabel.Position = UDim2.new(0.5, -100, 0.5, -25)
textLabel.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.Text = "KRNL GUI Test"
textLabel.Parent = gui
