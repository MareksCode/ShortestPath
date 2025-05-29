local Vertex = {}

function Vertex.new()
    local self = setmetatable({}, Vertex)

    self.Position = Vector3.new(0,0,0)
    self.Edges = {}

    return self
end

function Vertex:Destroy()
    for _, edge in self.Edges do
        edge:Destroy()
    end
end

return Vertex
