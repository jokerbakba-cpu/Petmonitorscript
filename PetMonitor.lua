local a,b=game:GetService("ReplicatedStorage"),game:GetService("Players")
local c=b.LocalPlayer
local d=c:WaitForChild("PlayerGui")
local e={"Bunny","Black Bunny","Dog","Golden Lab","Bee","Honey Bee","Cat","Orange Tabby","Chicken","Rooster","Deer","Spotted Deer","Hedgehog","Kiwi","Snail","Pig","Monkey","Dragonfly","Giant Ant","Red Giant Ant","Praying Mantis","Mole","Frog","Turtle","Moon Cat","Scarlet Macaw","Ostrich","Peacock","Capybara","Blood Hedgehog","Petal Bee","Moth","Raccoon","Queen Bee","Disco Bee","Fennec Fox","Mimic Octopus","Bear Bee","Brown Mouse","Blood Owl","Butterfly","Firefly","T-Rex","Spinosaurus","Ankylosaurus"}
local f=a:WaitForChild("PetRemotes"):WaitForChild("RequestSpawnPet")
local function g(h,i,j,k,l)
 local m=Instance.new("TextLabel")
 m.BackgroundTransparency=1
 m.Size=h
 m.Position=i
 m.Font=Enum.Font.GothamBold
 m.Text=j
 m.TextColor3=Color3.fromRGB(240,240,240)
 m.TextScaled=true
 m.Parent=l
 return m
end
local function n(o,p,q,r,s)
 local t=Instance.new("TextButton")
 t.Size=o
 t.Position=p
 t.BackgroundColor3=q
 t.Text=r
 t.Font=Enum.Font.GothamBold
 t.TextColor3=Color3.new(1,1,1)
 t.TextScaled=true
 t.Parent=s
 return t
end
local function u(v,w,x,y)
 local z=Instance.new("TextBox")
 z.Size=v
 z.Position=w
 z.PlaceholderText=x
 z.Font=Enum.Font.Gotham
 z.TextColor3=Color3.new(1,1,1)
 z.BackgroundColor3=Color3.fromRGB(50,50,50)
 z.ClearTextOnFocus=false
 z.TextScaled=true
 z.Parent=y
 return z
end
local A=Instance.new("ScreenGui")
A.Name="SantosHub"
A.ResetOnSpawn=false
A.Parent=d
local B=Instance.new("Frame")
B.Size=UDim2.new(0,360,0,520)
B.Position=UDim2.new(0.5,-180,0.5,-260)
B.BackgroundColor3=Color3.fromRGB(40,40,40)
B.BorderSizePixel=0
B.Parent=A
local C=Instance.new("Frame")
C.Size=UDim2.new(1,0,0,40)
C.BackgroundColor3=Color3.fromRGB(25,25,25)
C.Parent=B
local D=g(UDim2.new(0.7,0,1,0),UDim2.new(0,10,0,0),"Santos Hub",C)
D.TextXAlignment=Enum.TextXAlignment.Left
local E=n(UDim2.new(0,40,1,0),UDim2.new(1,-45,0,0),Color3.fromRGB(180,50,50),"-",C)
local F=Instance.new("Frame")
F.Size=UDim2.new(1,0,1, -40)
F.Position=UDim2.new(0,0,0,40)
F.BackgroundTransparency=1
F.Parent=B
g(UDim2.new(1,0,0,25),UDim2.new(0,0,0,0),"Escolha o Pet",F)
local G=Instance.new("TextBox")
G.Size=UDim2.new(1,-20,0,35)
G.Position=UDim2.new(0,10,0,30)
G.PlaceholderText="Clique para escolher"
G.ClearTextOnFocus=false
G.Text=""
G.Font=Enum.Font.Gotham
G.TextColor3=Color3.new(1,1,1)
G.BackgroundColor3=Color3.fromRGB(50,50,50)
G.Parent=F
local H=Instance.new("ScrollingFrame")
H.Size=UDim2.new(1,-20,0,140)
H.Position=UDim2.new(0,10,0,70)
H.BackgroundColor3=Color3.fromRGB(35,35,35)
H.BorderSizePixel=0
H.CanvasSize=UDim2.new(0,0,0,0)
H.ScrollBarThickness=6
H.Visible=false
H.Parent=F
local I=Instance.new("UIListLayout")
I.Parent=H
I.SortOrder=Enum.SortOrder.LayoutOrder
for J,K in ipairs(e)do
 local L=Instance.new("TextButton")
 L.Size=UDim2.new(1,-10,0,30)
 L.Position=UDim2.new(0,5,0,(J-1)*30)
 L.BackgroundColor3=Color3.fromRGB(45,45,45)
 L.TextColor3=Color3.new(1,1,1)
 L.Font=Enum.Font.Gotham
 L.TextSize=20
 L.Text=K
 L.Parent=H
 L.AutoButtonColor=true
 L.MouseEnter:Connect(function()
  L.BackgroundColor3=Color3.fromRGB(70,70,70)
 end)
 L.MouseLeave:Connect(function()
  L.BackgroundColor3=Color3.fromRGB(45,45,45)
 end)
 L.MouseButton1Click:Connect(function()
  G.Text=K
  H.Visible=false
 end)
end
H.CanvasSize=UDim2.new(0,0,0,#e*30)
G.Focused:Connect(function()
 H.Visible=true
end)
G.FocusLost:Connect(function()
 wait(0.2)
 local UIS=game:GetService("UserInputService")
 if not H:IsAncestorOf(UIS:GetFocusedTextBox())then
  H.Visible=false
 end
end)
g(UDim2.new(1,0,0,25),UDim2.new(0,0,0,215),"Peso (kg)",F)
local M=u(F.Size,"Ex: 5.0",UDim2.new(1,-20,0,35),UDim2.new(0,10,0,240))
local N=g(UDim2.new(1,0,0,25),UDim2.new(0,0,0,285),"Idade (dias)",F)
local O=u(F.Size,"Ex: 10",UDim2.new(1,-20,0,35),UDim2.new(0,10,0,310))
local P=g(UDim2.new(1,0,0,25),UDim2.new(0,0,0,355),"Fome (0-100)",F)
local Q=u(F.Size,"Ex: 50",UDim2.new(1,-20,0,35),UDim2.new(0,10,0,380))
local R=n(UDim2.new(1,-20,0,40),UDim2.new(0,10,0,425),Color3.fromRGB(70,70,70),"Mutação: Não",F)
local S=false
R.MouseButton1Click:Connect(function()
 S=not S
 R.Text="Mutação: "..(S and"Sim"or"Não")
 R.BackgroundColor3=S and Color3.fromRGB(100,150,100) or Color3.fromRGB(70,70,70)
end)
local T=n(UDim2.new(1,-20,0,50),UDim2.new(0,10,0,475),Color3.fromRGB(40,130,220),"Spawnar Pet",F)
T.MouseButton1Click:Connect(function()
 local U,G=G.Text,tonumber(M.Text)or 0
 local V=tonumber(O.Text)or 0
 local W=tonumber(Q.Text)or 0
 if not U or U==""then warn("Selecione um pet")return end
 f:FireServer(U,G,V,W,S)
 A:Destroy()
end)
local X=false
E.MouseButton1Click:Connect(function()
 X=not X
 if X then
  F.Visible=false
  B.Size=UDim2.new(0,360,0,40)
  E.Text="+"
 else
  F.Visible=true
  B.Size=UDim2.new(0,360,0,520)
  E.Text="-"
 end
end)
