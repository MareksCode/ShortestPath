local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Graph = {}
Graph.__index = Graph

function Graph.new(Verticies, Edges)
    local self = setmetatable({}, Graph)

    --warn("creating with:")
    --warn(Verticies)

    self.Verticies = Verticies
    self.Edges = Edges

    return self
end

function Graph:Destroy()
    for _, edge in self.Edges do
        edge:Destroy()
    end
    for _, vertex in self.Verticies do
        vertex:Destroy()
    end
end

return Graph