using DataStructures
using Memoize

@memoize function count_reachable_plots_naive(map, start, steps; bounded_score = false, bounded_map = false)
    if steps < 0
        return 0
    end

    # Define possible move directions (north, south, east, west)
    directions = ((0, 1), (0, -1), (1, 0), (-1, 0))

    # Get the dimensions of the map
    nrows, ncols = size(map)

    # Initialize a queue for BFS
    queue = Queue{Tuple{Tuple{Int,Int},Int}}()
    enqueue!(queue, (start, steps))

    # Start BFS
    score = 0
    while !isempty(queue)
        (x, y), remaining_steps = dequeue!(queue)

        # Check if the Elf has no more steps left
        if remaining_steps == 0
            if bounded_score
                if 1 <= x <= nrows && 1 <= y <= nrows
                    score += 1
                end
            else
                score += 1
            end
            continue
        end

        # Explore all possible directions
        for (dx, dy) in directions
            new_node = ((x + dx, y + dy), remaining_steps - 1)

            # Check if the new position is a garden plot and not visited
            current_plot = map[mod(new_node[1][1] - 1, nrows) + 1, mod(new_node[1][2] - 1, ncols) + 1]
            if current_plot != '#' && new_node ∉ queue
                if bounded_map
                    # If inside bounds
                    if 1 <= new_node[1][1] <= nrows && 1 <= new_node[1][2] <= nrows
                        enqueue!(queue, new_node)
                    end
                else
                    enqueue!(queue, new_node)
                end
            end
        end
    end

    return score
end

function bound_index(index, map)
    nrows, ncols = size(map)
    bounded_index = (mod(index[1] - 1, nrows) + 1, mod(index[2] - 1, ncols) + 1)
    map_index = (div(index[1] - 1, nrows) + 1, div(index[2] - 1, ncols) + 1)
    return bounded_index, map_index
end

const first_second = (7498, 7592)
const important = Dict(
        (1,1) => 259,
        (66,1) => 194,
        (131,1) => 259,
        (1,66) => 194,
        (66,66) => 129,
        (131,66) => 194,
        (1,131) => 259,
        (66,131) => 194,
        (131,131) => 259,
    )

function count_reachable_plots_dynamic(map, start, steps, visited = Set{Tuple{Int,Int}}())
    # BUG at steps>=197
    # Find index of start relative to map
    if steps < 0
        return 0
    end
    bstart, map_index = bound_index(start, map)
    if map_index in visited
        return 0
    end

    # Recursively search neighboring boxes and add scores
    score = 0
    if bstart == (66,66)
        # Start in middle
        for z in [(66, 66), (0, 66), (-66, 66), (66, 0), (-66, 0), (66, -66), (0, -66), (-66, -66)]
            new_start = start .+ z
            dist = sum(abs, z)
            score += count_reachable_plots_dynamic(map, new_start, steps - dist, visited)
        end
    else
        # Start on edge/corner
        for z in [(0,131), (131,0), (0,-131), (-131,0)]
            new_start = start .+ z
            dist = sum(abs, z)
            score += count_reachable_plots_dynamic(map, new_start, steps - dist, visited)
        end
    end

    # If many steps, use blinking solution. Else do a naive bounded BFS for this box
    goal_steps = important[bstart]
    if steps >= goal_steps
        odd = mod(steps - goal_steps, 2)
        b = first_second[odd + 1]
        @show b
        score += b
    else
        s = count_reachable_plots_naive(map, bstart, steps; bounded_map = true)
        @show s
        score += s
    end

    return score
end

function count_reachable_plots(map, start, steps)
    # Total amount of boxes
    L, _ = size(map)

    # Contribution from starting box
    if steps < 129
        middle = count_reachable_plots_naive(map, start, steps, bounded_map = true)
    else
        odd = mod(steps - 129, 2)
        middle = first_second[odd + 1]
    end

    # Contribution from blinking boxes (except starting)
    #t = max(div(steps + (L÷2) + 1 - 259, L), 0)
    t = max(div(steps + (L÷2) + 1 - 259, L), 0)
    nboxes = 2t*(t+1)+1
    @show nboxes, t, L, L*t, steps+66

    inner_box = (nboxes ÷ 2) * sum(first_second)
    @show middle
    @show inner_box
    
    edges = 0
    for s in [(66,1), (1,66), (131,66), (66,131)]
        edge1 = count_reachable_plots_naive(map, s, steps + 66 - 1 - L*(t+1), bounded_map=true)
        @show edge1
        edges += edge1
    end
    for s in [(66,1), (1,66), (131,66), (66,131)]
        edge2 = count_reachable_plots_naive(map, s, steps + 66 - 1 - L*(t+2), bounded_map=true)
        @show edge2
        edges += edge2
    end
    #@show edges

    corner1s = 0
    for s in [(1,1), (131,131), (1,131), (131,1)]
        corner1 = count_reachable_plots_naive(map, s, steps - 1 - L*(t+1), bounded_map=true)
        @show corner1
        corner1s += corner1 * nboxes
    end
    #@show corner1s

    corner2s = 0
    for s in [(1,1), (131,131), (1,131), (131,1)]
        corner2 = count_reachable_plots_naive(map, s, steps - 1 - L*(t+2), bounded_map=true)
        @show corner2
        corner2s += corner2 * (nboxes-1)
    end
    #@show corner2s

    score = middle + inner_box + corner1s + corner2s + edges
    return score
end


function part1()
    # Convert input map to a 2D array
    map = permutedims(hcat([[char for char in row] for row in readlines("21/input")]...), (2,1))

    # Call the function to count reachable garden plots with 64 steps
    start = findfirst(==('S'), map).I
    return count_reachable_plots(map, start, 64)
end

@show part1()

# Convert input map to a 2D array
#map = permutedims(hcat([[char for char in row] for row in readlines("21/test")]...), (2,1))
#start = findfirst(==('S'), map)
#@time reachable_plots = count_reachable_plots(map, start, 6) # 16
#@time reachable_plots = count_reachable_plots(map, start, 10) # 50
#@time reachable_plots = count_reachable_plots(map, start, 50) # 1594
#@time reachable_plots = count_reachable_plots(map, start, 100) # 6536
#@time reachable_plots = count_reachable_plots(map, start, 500) # 167004
#@time reachable_plots = count_reachable_plots(map, start, 1000) # 668697
#@time reachable_plots = count_reachable_plots(map, start, 5000) # 16733044

# Part 2
map = permutedims(hcat([[char for char in row] for row in readlines("21/input")]...), (2,1))
start = findfirst(==('S'), map).I
@time reachable_plots = count_reachable_plots(map, start, 26501365)
#@time reachable_plots = count_reachable_plots_dynamic(map, start, 210)
#@time reachable_plots = count_reachable_plots_naive(map, start, 197)

# 933583100646353 is too high