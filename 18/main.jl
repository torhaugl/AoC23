function parse_input()
    instr = Char[]
    for line in readlines("18/input")
        dir, num, _ = split(line)
        num = parse(Int, num)
        for _ = 1:num
            push!(instr, dir[1])
        end
    end
    return instr
end

function parse_input2()
    instr = Tuple{Char,Int}[]
    for line in readlines("18/input")
        dir, num, _ = split(line)
        num = parse(Int, num)
        push!(instr, (dir[1], num))
    end
    return instr
end

function parse_input3()
    instr = Tuple{Char,Int}[]
    for line in readlines("18/input")
        _, _, hex = split(line)
        dec = parse(Int, hex[3:end-1], base=16)
        num = dec ÷ 16
        dir = ['R', 'D', 'L', 'U'][(dec % 16) + 1]
        push!(instr, (dir[1], num))
    end
    return instr
end

function flood_fill(grid, x, y, visited)
    if !((x, y) in grid) || ((x, y) in visited)
        return 0
    end

    push!(visited, (x, y))

    area = 1
    area += flood_fill(grid, x+1, y, visited)
    area += flood_fill(grid, x-1, y, visited)
    area += flood_fill(grid, x, y+1, visited)
    area += flood_fill(grid, x, y-1, visited)

    return area
end

function part1()
    instr = parse_input()
    dir2move = Dict('L' => (0, -1), 'R' => (0, +1), 'U' => (-1, 0), 'D' => (+1, 0))

    boundary = Set{Tuple{Int,Int}}()
    machine = (0,0)
    for i in instr
        push!(boundary, machine)
        move = dir2move[i]
        machine = machine .+ move
    end

    min_x = minimum(x[1] for x in boundary)
    max_x = maximum(x[1] for x in boundary)
    min_y = minimum(x[2] for x in boundary)
    max_y = maximum(x[2] for x in boundary)

    grid = Set((x, y) for x in min_x:max_x for y in min_y:max_y)
    for point in boundary
        delete!(grid, point)
    end

    # Dictionary to keep track of visited points
    visited = Set{Tuple{Int,Int}}()

    # Calculate the area
    area = flood_fill(grid, 1, 1, visited)
    area += length(boundary)
    return area
end

function polygon_area(vertices)
    # Trapezoid formula
    n = length(vertices)
    area = 0

    for i in 1:n-1
        area += (vertices[i][1] + vertices[i+1][1]) * (vertices[i][2] - vertices[i+1][2])
    end

    # Add the last term separately for the vertex n and vertex 1
    area += (vertices[n][1] + vertices[1][1]) * (vertices[n][2] - vertices[1][2])
    area = abs(area ÷ 4)

    return round(Int, area)
end

function part2()
    instr = parse_input3()
    dir2move = Dict('L' => (0, -1), 'R' => (0, +1), 'U' => (-1, 0), 'D' => (+1, 0))

    boundary = Vector{Tuple{Int,Int}}(undef, length(instr))
    machine = (0,0)
    boundary_length = 0
    for (j, (dir, nsteps)) in enumerate(instr)
        boundary[j] = machine
        push!(boundary, machine)
        move = dir2move[dir]
        machine = machine .+ move .* nsteps
        boundary_length += nsteps
    end

    area = polygon_area(boundary) + (boundary_length ÷ 2) + 1
    return area
end

@show part1()
@show part2()