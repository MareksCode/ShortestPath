local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Vertex = {}
Vertex.__index = Vertex

local Trove = require(ReplicatedStorage.Packages.Trove)

function Vertex.new(Position: Vector3, Edges: {}?)
	local self = setmetatable({}, Vertex)

	self.Position = Position
	self.Edges = Edges or {}
	self.id = -1

	return self
end

function Vertex:Visualize()
	self.VISUALIZED = true

	self.Trove = Trove.new()

	self.VisualizePart = self.Trove:Construct(Instance, "Part")
	self.VisualizePart.Size = Vector3.new(1, 1, 1)
	self.VisualizePart.Color = Color3.fromRGB(100, 255, 150)
	self.VisualizePart.Material = Enum.Material.Neon
	self.VisualizePart.Anchored = true
	self.VisualizePart.CanCollide = false
	self.VisualizePart.CanQuery = false
	self.VisualizePart.CanTouch = false
	self.VisualizePart.Position = self.Position
	self.VisualizePart.Parent = workspace
end

function Vertex:SetId(id)
	self.id = id

	if self.VISUALIZED then
		if not self.textLabel then
			self.bbgui = self.Trove:Construct(Instance, "BillboardGui")
			self.textLabel = self.Trove:Construct(Instance, "TextLabel")

			self.bbgui.Parent = self.VisualizePart
			self.bbgui.Size = UDim2.new(1.2, 0, 1.2, 0)
			self.bbgui.AlwaysOnTop = true
			self.bbgui.Adornee = self.VisualizePart

			self.textLabel.Parent = self.bbgui
			self.textLabel.Size = UDim2.new(1, 0, 1, 0)
			self.textLabel.BackgroundTransparency = 1
			self.textLabel.TextScaled = true
		end
		self.textLabel.Text = id
	end
end
function Vertex:GetId()
	return self.id
end

function Vertex:GetPosition()
	return self.Position
end

function Vertex:AddEdge(Edge)
	table.insert(self.Edges, Edge)
end

function Vertex:RemoveEdge(Edge)
	local index = table.find(self.Edges, Edge)

	assert(index, "This edge is not connected to this Vertex")

	table.remove(self.Edges, index)
end

function Vertex:Destroy()
	if self.VISUALIZED then
		self.Trove:Destroy()
	end
end

return Vertex
