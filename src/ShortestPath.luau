--https://en.wikipedia.org/wiki/Christofides_algorithm
--https://en.wikipedia.org/wiki/Prim%27s_algorithm

local ShortestPath = {}
local Vertex = require(script.Parent.Objects.Vertex)
local Edge = require(script.Parent.Objects.Edge)

function ShortestPath:CalculateMST(Verticies, Edges)
    
end

function CreateTestGraph(Reference : {Part})
    local Verticies = {}
    local Edges = {}

    --create verticies from part instances
    for _, part in Reference do
        local pos = part.Position
        part:Destroy()

        local v = Vertex.new(pos)
        table.insert(Verticies, v)
    end

    --connect all verticies with each other
    for i, _ in Verticies do
        for i2 = i+1, #Verticies, 1 do
            local edge = Edge.new(Verticies[i], Verticies[i2])
            table.insert(Edges, edge)
        end
    end

    return Verticies, Edges
end


return ShortestPath