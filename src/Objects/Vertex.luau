local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Vertex = {}
local VISUALIZE = true

local Trove = require(ReplicatedStorage.Packages.Trove)

function Vertex.new(Position: Vector3, Edges: {}?)
    local self = setmetatable({}, Vertex)

    self.Position = Position
    self.Edges = Edges or {}

    if VISUALIZE then
        self.Trove = Trove.new()

        self.VisualizePart = Trove:Construct(Instance, "Part")
        self.VisualizePart.Size = Vector3.new(1,1,1)
        self.VisualizePart.Color = Color3.fromRGB(100,255,150)
        self.VisualizePart.Anchored = true
        self.VisualizePart.CanCollide = false
        self.VisualizePart.CanQuery = false
        self.VisualizePart.CanTouch = false
        self.VisualizePart.Position = self.Position
        self.VisualizePart.Parent = workspace
    end

    return self
end

function Vertex:GetPosition()
    return self.Position
end

function Vertex:AddEdge(Edge)
    table.insert(self.Edges, Edge)
end

function Vertex:RemoveEdge(Edge)
    local index = table.find(Vertex.Edges, Edge)

    assert(index, "This edge is not connected to this Vertex")

    table.remove(Vertex.Edges, index)
end

function Vertex:Destroy()
    if VISUALIZE then
        self.Trove:Destroy()
    end
end

return Vertex
