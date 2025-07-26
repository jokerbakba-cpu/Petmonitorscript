for _, pet in pairs(workspace.Pets:GetChildren()) do
    if pet:FindFirstChild("data") then
        local d = pet.data
        print("Pet:", pet.Name)
        print("Peso:", d.weight.Value)
        print("Idade (Level):", d.level.Value)
        print("Altura:", d.height.Value)
    end
end
