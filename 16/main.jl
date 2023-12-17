function parse_matrices()
    matrix_str  = read("16/input", String)
    rows = split(matrix_str, "\n")
    map = permutedims(hcat([[char for char in row] for row in rows]...), (2,1))
    return map
end

dir2move = Dict('L' => (0, -1), 'R' => (0, +1), 'U' => (-1, 0), 'D' => (+1, 0))

function part1(ray0 = ((1, 0), 'R'))
    map = parse_matrices()
    visited = Set{Tuple{Int,Int}}()
    already_exists = Set{Tuple{Tuple{Int,Int},Char}}()

    push!(already_exists, ray0)
    new_rays = [ray0]

    i = 0
    while !isempty(new_rays)
        i += 1
        prev = length(visited)
        rays = new_rays
        new_rays = []
        for (pos, dir) in rays
            push!(visited, pos)

            new_index = pos .+ dir2move[dir]
            if !( 1 <= new_index[1] <= size(map, 1) ) || !( 1 <= new_index[2] <= size(map, 2) ) 
               continue
            end
            if (new_index, dir) ∈ already_exists
                continue
            else
                push!(already_exists, (new_index, dir))
            end

            c = map[new_index...]
            if c == '.'
                ray = (new_index, dir)
            elseif c == '/'
                if dir == 'R'
                    ray = (new_index, 'U')
                elseif dir == 'U'
                    ray = (new_index, 'R')
                elseif dir == 'L'
                    ray = (new_index, 'D')
                elseif dir == 'D'
                    ray = (new_index, 'L')
                end
            elseif c == '\\'
                if dir == 'R'
                    ray = (new_index, 'D')
                elseif dir == 'D'
                    ray = (new_index, 'R')
                elseif dir == 'L'
                    ray = (new_index, 'U')
                elseif dir == 'U'
                    ray = (new_index, 'L')
                end
            elseif c == '|'
                if (dir == 'L' || dir == 'R')
                    push!(new_rays, (new_index, 'U'))
                    ray = (new_index, 'D')
                else
                    ray = (new_index, dir)
                end
            elseif c == '-'
                if (dir == 'D' || dir == 'U')
                    push!(new_rays, (new_index, 'L'))
                    ray = (new_index, 'R')
                else
                    ray = (new_index, dir)
                end
            else
                println("Error: $c")
                ray = ((0,0), '?')
            end
            push!(new_rays, ray)
        end
    end

    return length(visited) - 1
end

function part2()
    map = parse_matrices()
    s = 0
    for i = 1:size(map, 2)
        ray0 = ((0, i), 'D')
        s = max(s, part1(ray0))
        ray0 = ((size(map,1)+1, i), 'U')
        s = max(s, part1(ray0))
    end
    for i = 1:size(map, 1)
        ray0 = ((i, 0), 'R')
        s = max(s, part1(ray0))
        ray0 = ((i, size(map,2)+1), 'L')
        s = max(s, part1(ray0))
    end
    s
end

@show part1()
@show part2()