local Vertex = require(script.Parent.Parent.Objects.Vertex)
local Edge = require(script.Parent.Parent.Objects.Edge)
local Graph = require(script.Parent.Parent.Objects.Graph)

return function (Reference : {Vector3})
    local Verticies = {}
    local Edges = {}

    --create verticies from part instances
    for _, pos in Reference do
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