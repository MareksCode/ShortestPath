--https://en.wikipedia.org/wiki/Christofides_algorithm
--https://en.wikipedia.org/wiki/Prim%27s_algorithm

local ShortestPath = {}
local Vertex = require(script.Parent.Objects.Vertex)
local Edge = require(script.Parent.Objects.Edge)

local function removeSmallestEdgeConnectedToT(T, Edges)
	local foundE = nil
	local notNeededEs = {}

	for i, e in Edges do --traverse all edges (sorted a<b)
		local EVerticies = e:GetVerticies()
		local foundVerticies = 0

		for _, TVertex in T do --check for possible connections
			if table.find(EVerticies, TVertex) then
				foundVerticies += 1
			end
		end

		if foundVerticies == 1 then --if connection found, break the loop
			foundE = e

			break
		elseif foundVerticies == 2 then --if conection not needed anymore, schedule to be removed
			table.insert(notNeededEs, e)
		end
	end

	assert(foundE, "No matching edge found! This function should not have been ran") --s

	for _, notNeededE in notNeededEs do --remove all edges that are not needed anymore
		table.remove(Edges, table.find(Edges, notNeededE))
		notNeededE:Destroy()
	end

	return table.remove(Edges, table.find(Edges, foundE))
end

function ShortestPath.CalculateMST(Verticies, Edges)
	table.sort(Edges, function(a, b) --sort edges
		return a.Length < b.Length
	end)

	local T = { Verticies = { Verticies[1] }, Edges = {} }
	table.remove(Verticies, 1) --create new Graph T with startVertex

	while #Verticies > 0 do
		local e = removeSmallestEdgeConnectedToT(T.Verticies, Edges)
		table.insert(T.Edges, e)

		for _, newVertex in e:GetVerticies() do --put the new vertex in the graph T
			if not table.find(T.Verticies, newVertex) then
				table.insert(T.Verticies, newVertex)
				table.remove(Verticies, table.find(Verticies, newVertex))
			end
		end
	end

	for _, e in Edges do
		e:Destroy()
	end

	return T
end

function ShortestPath.CalculateTSPG(oldGraph)
	local Verticies = oldGraph.Verticies
	local MSTEdges = oldGraph.Edges

	local function findOddDegreeVertices(vertices)
		local degree = {}
		for _, v in ipairs(vertices) do
			degree[v] = 0
		end
		for _, edge in ipairs(MSTEdges) do
			local v1, v2 = table.unpack(edge:GetVerticies())
			degree[v1] += 1
			degree[v2] += 1
		end

		local odds = {}
		for v, d in pairs(degree) do
			if d % 2 == 1 then
				table.insert(odds, v)
			end
		end
		return odds
	end

	local function greedyMatching(oddVertices)
		local used = {}
		local matching = {}

		while #oddVertices > 1 do
			local u = table.remove(oddVertices)
			if not used[u] then
				local bestV, bestDist, bestIndex = nil, math.huge, nil
				for i, v in ipairs(oddVertices) do
					if not used[v] then
						local dist = (u:GetPosition() - v:GetPosition()).Magnitude
						if dist < bestDist then
							bestV, bestDist, bestIndex = v, dist, i
						end
					end
				end
				if bestV then
					table.remove(oddVertices, bestIndex)
					local edge = Edge.new(u, bestV)
					table.insert(matching, edge)
					u:AddEdge(edge)
					bestV:AddEdge(edge)
					used[u], used[bestV] = true, true
				end
			end
		end

		return matching
	end

	local function combineEdges(mstEdges, matching)
		local allEdges = {}
		for _, e in ipairs(mstEdges) do
			table.insert(allEdges, e)
		end
		for _, e in ipairs(matching) do
			table.insert(allEdges, e)
		end
		return allEdges
	end

	local function findEulerianTour(vertices, allEdges)
		local graph = {}
		for _, v in ipairs(vertices) do
			graph[v] = {}
		end
		for _, e in ipairs(allEdges) do
			local v1, v2 = table.unpack(e:GetVerticies())
			table.insert(graph[v1], { v = v2, edge = e })
			table.insert(graph[v2], { v = v1, edge = e })
		end

		local tour = {}
		local function visit(v)
			while #graph[v] > 0 do
				local next = table.remove(graph[v])
				local u = next.v
				-- Remove reverse edge
				for i, entry in ipairs(graph[u]) do
					if entry.v == v then
						table.remove(graph[u], i)
						break
					end
				end
				visit(u)
			end
			table.insert(tour, v)
		end

		visit(vertices[1])
		return tour
	end

	local function makeHamiltonianTour(tour)
		local visited = {}
		local path = {}
		for i = #tour, 1, -1 do
			local v = tour[i]
			if not visited[v] then
				table.insert(path, v)
				visited[v] = true
			end
		end
		table.insert(path, path[1]) -- close cycle
		return path
	end

	local function createFinalGraph(path)
		local newEdges = {}
		for i = 1, #path - 1 do
			local v1 = path[i]
			v1:SetId(i)
			local v2 = path[i + 1]
			v2:SetId(i + 1)
			local edge = Edge.new(v1, v2)
			table.insert(newEdges, edge)
			v1:AddEdge(edge)
			v2:AddEdge(edge)
		end
		return {
			Vertices = path,
			Edges = newEdges,
		}
	end

	local oddVertices = findOddDegreeVertices(Verticies)
	local matchingEdges = greedyMatching(oddVertices)
	local allEdges = combineEdges(MSTEdges, matchingEdges)
	local eulerTour = findEulerianTour(Verticies, allEdges)
	local hamiltonianPath = makeHamiltonianTour(eulerTour)
	local finalGraph = createFinalGraph(hamiltonianPath)

	return finalGraph
end

function ShortestPath.CalculateWalkway(Vertices, Edges)
	local MST = ShortestPath.CalculateMST(Vertices, Edges)
	local FinalPath = ShortestPath.CalculateTSPG(MST)

	for _, e in MST.Edges do
		e:Destroy()
	end

	local Edges = FinalPath.Edges
	local Verticies = FinalPath.Vertices

	return { Edges = Edges, Verticies = Verticies } --Vertex IDs are ordered
end

function ShortestPath.GetWalkPositionsArrayFromStartPosition(Graph, StartPosition: Vector3): { Vector3 }
	local nearestVertex = nil --find nearest vertex
	local nearestMagnitude = math.huge
	for _, v in Graph.Verticies do
		local pos = v:GetPosition()
		local magnitude = (pos - StartPosition).Magnitude

		if magnitude < nearestMagnitude then
			nearestMagnitude = magnitude
			nearestVertex = v
		end
	end

	assert(nearestVertex, "No nearest vertex found. Graph might be empty?")

	local nearestID = nearestVertex:GetId()
	local PositionArray = {}

	for i = nearestID, #Graph.Verticies, 1 do
		table.insert(PositionArray, Graph.Verticies[i]:GetPosition())
	end
	if nearestID > 1 then
		for i = 1, nearestID-1, 1 do
			table.insert(PositionArray, Graph.Verticies[i]:GetPosition())
		end
	end

    return PositionArray
end

return ShortestPath