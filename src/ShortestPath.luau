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
            print("index: "..i)
            
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
    table.sort(Edges,function(a,b) --sort edges
	    return a.Length<b.Length
    end)

    local T = {Verticies = {Verticies[1]}, Edges = {}} ; table.remove(Verticies, 1) --create new Graph T with startVertex

    while #Verticies > 0 do
        local e = removeSmallestEdgeConnectedToT(T.Verticies, Edges)
        table.insert(T.Edges, e)

        for _, newVertex in e:GetVerticies() do --put the new vertex in the graph T
            if not table.find(T.Verticies, newVertex) then
                print("inserted new")
                table.insert(T.Verticies, Vertex)
                table.remove(Verticies, table.find(Verticies, newVertex))
            end
        end
    end

    for _, e in Edges do
        e:Destroy()
    end
end

return ShortestPath