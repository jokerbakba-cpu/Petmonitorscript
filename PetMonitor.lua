local code = [[
    function spawnPet()
        local pet = {}
        pet.sizeY = math.random(5,15)
        pet.peso = math.random(10,50)
        pet.level = math.random(1,10)

        print("Pet Spawned!")
        print("Altura:", pet.sizeY)
        print("Peso:", pet.peso)
        print("Level (idade):", pet.level)
    end

    spawnPet()
]]

local func = loadstring(code) -- carrega o código
func() -- executa
