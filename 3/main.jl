# Read the Engine Schematic into a matrix of characters.
function parse_input()
    engine_schematic = Matrix{Char}(undef, (140, 140))
    for (i, line) in enumerate(readlines("3/input"))
        for (j, c) in enumerate(line)
            engine_schematic[i, j] = c
        end
    end
    return engine_schematic
end

# Get all adjacent indices of index i in a 2D matrix.
#   x x x
#   x i x
#   x x x
function get_adjacent(i :: CartesianIndex)
    adjacency_list = [
        CartesianIndex(0,1),
        CartesianIndex(1,0),
        CartesianIndex(0,-1),
        CartesianIndex(-1,0),
        CartesianIndex(1,1),
        CartesianIndex(1,-1),
        CartesianIndex(-1,1),
        CartesianIndex(-1,-1),
    ]

    return [i + j for j in adjacency_list]
end

# Given the index of a number in the engine schematic, find the whole number.
# ..14..45.
# ...234... should return 234
#     ^
function findnums(engine_schematic, ind)
    line = prod(engine_schematic[ind[1], :])

    for i = 1:length(line)
        n = 0
        while n+i <= length(line) && all([isnumeric(c) for c in line[i:i+n]])
            n += 1
        end
        if i <= ind[2] < i + n
            indices = [(ind[1], i+x-1) for x = 1:n]
            return parse(Int, line[i:i+n-1]), indices
        end
    end
    return 0, []
end

#PART 1
function part1()
    engine_schematic = parse_input()
    nrows, ncols = size(engine_schematic)

    sum_of_part_numbers = 0
    found = [(0,0)]
    symbol_indices = findall(x -> !isnumeric(x) && x != '.', engine_schematic)

    for ind in symbol_indices
        for n in neighbors
            i = ind + n
            if i[1] <= 0 || i[1] > nrows || i[2] <= 0 || i[2] > ncols
                continue
            end
            if isnumeric(engine_schematic[i])
                part_number, s_ind = findnums(engine_schematic, i)
                if part_number == 0 # NOT FOUND
                    continue
                elseif i.I in found # PART NUMBER ALREADY ADDED
                    continue
                end
                append!(found, s_ind)
                sum_of_part_numbers += part_number
            end
        end
    end
    return sum_of_part_numbers
end

#PART2
function part2()
    engine_schematic = parse_input()

    sum_of_gear_ratios = 0
    found = [(0,0)]
    gear_sym = findall(x -> x == '*', engine_schematic)

    for ind in gear_sym
        num_gear = 0
        gear_score = Int[]
        for n in neighbors
            i = ind + n
            if i[1] <= 0 || i[1] > 140 || i[2] <= 0 || i[2] > 140
                continue
            end
            if isnumeric(engine_schematic[i])
                s, s_ind = findnums(engine_schematic, i)
                if s == 0
                    continue
                end
                if i.I in found
                    continue
                end
                append!(found, s_ind)
                num_gear += 1
                append!(gear_score, s)
            end
        end
        if num_gear == 2
            sum_of_gear_ratios += prod(gear_score)
        end
    end
    return sum_of_gear_ratios
end