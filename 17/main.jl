using DataStructures

function parse_matrices()
    matrix_str  = read("17/input", String)
    rows = split(matrix_str, "\n")
    map = hcat([[parse(Int, char) for char in row] for row in rows]...)'
    return map
end

function djikstra(graph, start_node, goal, neighbor_func)
    dist = Dict(start_node => 0)
    prev = Dict{Tuple{Int,Int,Char,Int}, Tuple{Int,Int,Char,Int}}()
    Q = PriorityQueue(start_node => 0)

    while !isempty(Q)
        u = dequeue!(Q)
        for (neighbor, weight) in neighbor_func(u, graph)
            alt = dist[u] + weight
            if alt < get(dist, neighbor, typemax(Int))
                dist[neighbor] = alt
                prev[neighbor] = u
                Q[neighbor] = alt
                if neighbor[1] == goal[1] && neighbor[2] == goal[2]
                    return dist, prev, dist[neighbor]
                end
            end
        end
    end

    return dist, prev, 0
end

function get_neighbors((i, j, dir, n), graph)
    if (dir == 'D')
        neighbors = [(i+1, j, 'D', n+1), (i, j+1, 'R', 1), (i, j-1, 'L', 1)]
    elseif (dir == 'L')
        neighbors = [(i+1, j, 'D', 1), (i-1, j, 'U', 1), (i, j-1, 'L', n+1)]
    elseif (dir == 'R')
        neighbors = [(i+1, j, 'D', 1), (i-1, j, 'U', 1), (i, j+1, 'R', n+1)]
    elseif (dir == 'U')
        neighbors = [(i-1, j, 'U', n+1), (i, j+1, 'R', 1), (i, j-1, 'L', 1)]
    else
        error("Error neighbors")
    end
    filter!(x -> 1 <= x[1] <= size(graph, 1), neighbors)
    filter!(x -> 1 <= x[2] <= size(graph, 2), neighbors)
    filter!(x -> x[4] <= 3, neighbors)
    node_dist = [((i, j, dir, n), graph[i,j]) for (i,j,dir,n) in neighbors]
    return node_dist
end

function get_neighbors_2((i, j, dir, n), graph)
    if (dir == 'D')
        neighbors = [(i+1, j, 'D', n+1), (i, j+1, 'R', 1), (i, j-1, 'L', 1)]
    elseif (dir == 'L')
        neighbors = [(i+1, j, 'D', 1), (i-1, j, 'U', 1), (i, j-1, 'L', n+1)]
    elseif (dir == 'R')
        neighbors = [(i+1, j, 'D', 1), (i-1, j, 'U', 1), (i, j+1, 'R', n+1)]
    elseif (dir == 'U')
        neighbors = [(i-1, j, 'U', n+1), (i, j+1, 'R', 1), (i, j-1, 'L', 1)]
    else
        error("Error neighbors")
    end
    filter!(x -> 1 <= x[1] <= size(graph, 1), neighbors)
    filter!(x -> 1 <= x[2] <= size(graph, 2), neighbors)
    filter!(x -> x[4] <= 10, neighbors)
    if n < 4
        filter!(x -> x[3] == dir, neighbors)
    end
    node_dist = [((i1, j1, dir, n), graph[i1,j1]) for (i1,j1,dir,n) in neighbors]
    return node_dist
end

function part1()
    graph = parse_matrices()
    _, _, score = djikstra(graph, (1,1,'D',0), size(graph), get_neighbors)
    return score
end

function part2()
    graph = parse_matrices()
    _, _, score1 = djikstra(graph, (1,1,'D',0), size(graph), get_neighbors_2)
    _, _, score2 = djikstra(graph, (1,1,'R',0), size(graph), get_neighbors_2)
    return min(score1, score2)
end

@show part1()
@show part2()