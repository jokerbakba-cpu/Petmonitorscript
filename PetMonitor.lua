for _, obj in pairs(game:GetDescendants()) do
    if obj:IsA("Model") and obj.Name:lower():find("pet") and obj:FindFirstChild("data") then
        print("Pet encontrado em:", obj:GetFullName())
        for _, val in pairs(obj.data:GetChildren()) do
            print(val.Name, val.Value)
        end
    end
end
