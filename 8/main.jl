function parse_input(fname)
    instructions, map = open(fname) do io
        instructions = readline(io)
        map = Dict{String, Tuple{String, String}}()
        _ = readline(io)
        for line in readlines(io)
            pattern = r"^([A-Z0-9]{3}) = \(([A-Z0-9]{3}), ([A-Z0-9]{3})\)$"
            a, b, c = match(pattern, line).captures
            map[a] = (b, c)
        end
        return instructions, map
    end
    return instructions, map
end

function part1()
    instructions, map = parse_input("8/input")
    N = length(instructions)
    i = 0
    cnt = 0
    curr = "AAA"
    while true
        cnt += 1
        lr = (instructions[i+1] == 'R') + 1
        curr = map[curr][lr]
        if curr == "ZZZ"
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

function part2()
    instructions, map = parse_input("8/input")

    N = length(instructions)
    i = 0
    cnt = 0
    starts = [x for x in keys(map) if x[3] == 'A']
    explored = [(-1, "ABC")]
    println("INSTRUCTIONS: $instructions")
    @show starts
    while true
        node = (i, starts[1])
        if (node in explored)
            println("Found loop")
            index = findfirst(==(node), explored)
            offset = length(explored[1:index-1])
            path = explored[index:end]
            @show index
            @show offset
            @show length(path)
            z_index = Int[]
            for (j, n) in enumerate(path)
                if n[2][3] == 'Z'
                    push!(z_index, j)
                end
            end
            @show z_index
            break
        else
            push!(explored, node)
        end
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