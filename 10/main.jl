using DelimitedFiles
using DataStructures

#| is a vertical pipe connecting north and south.
#- is a horizontal pipe connecting east and west.
#L is a 90-degree bend connecting north and east.
#J is a 90-degree bend connecting north and west.
#7 is a 90-degree bend connecting south and west.
#F is a 90-degree bend connecting south and east.
#. is ground; there is no pipe in this tile.
#S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
function parse_input(filename, S)
    knowledge = Dict('|' => "NS", '-' => "EW", 'L' => "NE", 'J' => "NW", '7' => "SW", 'F' => "SE", '.' => "0", 'S' => S)
    B = readdlm(filename)
    n = size(B, 1)
    A = Matrix{Char}(undef, n, n)
    start = (0,0)
    for (i, row) in enumerate(B)
        for (j, c) in enumerate(row)
            A[i,j] = c
            if c == 'S'
                start = (i,j)
            end
        end
    end
    C = [knowledge[a] for a in A]
    return C, start
end

function map2graph(map::Matrix)
    graph = Dict{Tuple{Int,Int}, Set{Tuple{Int,Int}}}()
    for i in axes(map, 1), j in axes(map, 2)
        graph[(i,j)] = Set{Tuple{Int}}()
        if occursin("S", map[i,j]) && occursin("N", get(map, (i+1,j), ""))
            push!(graph[(i,j)], (i+1,j))
        end
        if occursin("N", map[i,j]) && occursin("S", get(map, (i-1,j), ""))
            push!(graph[(i,j)], (i-1,j))
        end
        if occursin("E", map[i,j]) && occursin("W", get(map, (i,j+1), ""))
            push!(graph[(i,j)], (i,j+1))
        end
        if occursin("W", map[i,j]) && occursin("E", get(map, (i,j-1), ""))
            push!(graph[(i,j)], (i,j-1))
        end
    end

    return graph
end


function bfs(graph::Dict{T, Set{T}}, start_node::T) where T
    visited = Set{T}()
    queue = Queue{Tuple{T, Int}}()
    enqueue!(queue, (start_node, 0))

    max_distance = 0
    while !isempty(queue)
        node, distance = dequeue!(queue)
        if node in visited
            continue
        end

        max_distance = max(max_distance, distance)

        push!(visited, node)
        for neighbor in get(graph, node, [])
            if !(neighbor in visited)
                enqueue!(queue, (neighbor, distance+1))
            end
        end
    end

    return max_distance, visited
end

# Starting position of my input. My input only allows North-South connection
#   F7F
#   |SL
#   |||

function part1()
    maxdist = 0

    for S in ["NS"]
        map, start = parse_input("10/input", S)
        graph = map2graph(map)
        dist, _ = bfs(graph, start)
        maxdist = max(maxdist, dist)
        @show dist
    end
    return maxdist
end

function part2()
    map, start = parse_input("10/input", "NS")
    graph = map2graph(map)
    _, visited = bfs(graph, start)

    area = 0
    for row = 1:141
        counting = false
        for col = 1:141
            node = (row, col)
            if (node) in visited
                if node in graph[node .+ (1,0)]
                    counting = !counting
                end
            elseif counting
                area += 1
            end
        end
    end
    return area
end

@show part1()
@show part2()