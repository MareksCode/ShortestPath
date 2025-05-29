local Edge = {}

function Edge.new(Vertex1, Vertex2)
    local self = setmetatable({}, Edge)
    
    self.Vertex1 = Vertex1
    self.Vertex2 = Vertex2

    self.Verticies = {Vertex1, Vertex2}

    return self
end

return Edge