local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Edge = {}
Edge.__index = Edge
local Trove = require(ReplicatedStorage.Packages.Trove)

function Edge.new(Vertex1, Vertex2)
	local self = setmetatable({}, Edge)

	self.id = -1

	self.Verticies = { Vertex1, Vertex2 }

	Vertex1:AddEdge(self)
	Vertex2:AddEdge(self)

	self.Length = (Vertex1:GetPosition() - Vertex2:GetPosition()).Magnitude

	return self
end

function Edge:Visualize()
	self.VISUALIZED = true
    self.Trove = Trove.new()

    self.VisualTrail = self.Trove:Construct(Instance, "Beam")
    self.VisualAttach1 = self.Trove:Construct(Instance, "Attachment")
    self.VisualAttach2 = self.Trove:Construct(Instance, "Attachment")
    self.VisualPart = self.Trove:Construct(Instance, "Part")

    self.VisualPart.Transparency = 1
    self.VisualPart.Anchored = true
    self.VisualPart.CanCollide = false
    self.VisualPart.CanTouch = false
    self.VisualPart.CanQuery = false

    self.VisualAttach1.WorldPosition = self.Verticies[1]:GetPosition()
    self.VisualAttach2.WorldPosition = self.Verticies[2]:GetPosition()

    self.VisualTrail.Attachment0 = self.VisualAttach1
    self.VisualTrail.Attachment1 = self.VisualAttach2
    self.VisualTrail.FaceCamera = true
    self.VisualTrail.Width0 = 0.1
    self.VisualTrail.Width1 = 0.1
    self.VisualTrail.Transparency =
        NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0) })
    self.VisualTrail.LightInfluence = 0
    self.VisualTrail.LightEmission = 1
    self.VisualTrail.Brightness = 5

    self.VisualTrail.Parent = self.VisualPart
    self.VisualAttach1.Parent = self.VisualPart
    self.VisualAttach2.Parent = self.VisualPart
    self.VisualPart.Parent = workspace
end

function Edge:SetId(id)
	self.id = id
end
function Edge:GetId()
	return self.id
end

function Edge:GetVerticies()
	return self.Verticies
end

function Edge:Destroy()
	for _, vertex in self.Verticies do
		vertex:RemoveEdge(self)
	end

	if self.VISUALIZED then
		self.Trove:Destroy()
	end
end

return Edge
