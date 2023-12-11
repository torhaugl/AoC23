using Primes

function readInstructionsAndMapFromFile(filename)
    instructionLine, conversionMap = open(filename) do file
        instructionLine = readline(file)
        conversionMap = Dict{String, Tuple{String, String}}()

        _ = readline(file)  # Skip a line
        for line in readlines(file)
            pattern = r"^([A-Z0-9]{3}) = \(([A-Z0-9]{3}), ([A-Z0-9]{3})\)$"
            key, val1, val2 = match(pattern, line).captures
            conversionMap[key] = (val1, val2)
        end
        return instructionLine, conversionMap
    end
    return instructionLine, conversionMap
end

function part1()
    instructions, map = readInstructionsAndMapFromFile("8/input")
    N = length(instructions)
    i = 0
    cnt = 0
    curr = "DXA"
    while true
        cnt += 1
        lr = (instructions[i+1] == 'R') + 1
        curr = map[curr][lr]
        if curr[3] == 'Z' #"ZZZ"
            break
        end
        i = (i+1) % N
    end
    return cnt
end

function iterate!(starts, map, lr)
    goal = true
    for i = 1:length(starts)
        starts[i] = map[starts[i]][lr]
        goal = goal * (starts[i][3] == 'Z')
    end
    return goal
end

# CYCLIC
# (i, "ABC")
# 
# (1, 11A), (2, 11B), (1, 11Z), (2, 11B)
#                    -------------------
#
# (1, 22A), (2, 22B), (1, 22C), (2, 22Z), (1, 22B), (2, 22C), (1, 22Z), (2, 22B)
#                     ----------------------------------------------------------
#
# if (i, ABC) in explored
#    x = 
# end

function find_loop(start, instructions, map)
    N = length(instructions)
    i = 0
    cnt = 0
    explored = Tuple{Int64, String}[]

    pathOffset, pathLength, goalIndex = while true
        node = (i, start)
        if (node in explored)
            index = findfirst(==(node), explored)
            path = explored[index:end]
            pathLength = length(path)
            pathOffset = length(explored[1:index-1])
            goalIndex = 0
            for (j, n) in enumerate(path)
                if n[2][3] == 'Z'
                    goalIndex = j
                end
            end
            return pathOffset, pathLength, goalIndex
            break
        else
            push!(explored, node)
        end
        cnt += 1
        lr = (instructions[i+1] == 'R') + 1
        start = map[start][lr]
        i = (i+1) % N
    end

    return pathOffset, pathLength, goalIndex
end

function part2()
    instructions, map = readInstructionsAndMapFromFile("8/input")
    starts = [x for x in keys(map) if x[3] == 'A']

    nums = Int[]
    for start in starts
        _, pathLength, _ = find_loop(start, instructions, map)
        push!(nums, pathLength)
    end
    primes = [factor(Vector, num) for num in nums]
    common_primes = reduce(union, primes)
    return prod(common_primes)
end

function part2_iterate(k)
    instructions, map = readInstructionsAndMapFromFile("8/input")
    N = length(instructions)
    i = 0
    cnt = 0
    starts = [x for x in keys(map) if x[3] == 'A'][1:k]
    while true
        cnt += 1
        lr = (instructions[i+1] == 'R') + 1
        goal = iterate!(starts, map, lr)
        if goal
            break
        end
        i = (i+1) % N
    end
    return cnt
end

@show part1()
@show part2()

# Naive and slow, but working implementation
#@show part2_iterate(1)
#@show part2_iterate(2)
#@show part2_iterate(3)
#@show part2_iterate(4)