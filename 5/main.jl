using DataStructures

function get_seed(srcs, dests, s, default = s)
    #for (map_src, map_dest) in zip(map.srcs, map.dests)
        #if map_src[1] <= src <= map_src[2]
    
    n = length(srcs)
    j = 0
    while j < n
        j += 1
        a = srcs[j][1]
        b = srcs[j][end]
        if a <= s <= b
            i = s - srcs[j][1] + 1
            val = dests[j][i]
            return val
        end
    end
    return default
end

function parse_map(io)
    str = parse.(Int, split(readline(io)))
    srcs = UnitRange{Int}[]
    dests = UnitRange{Int}[]
    while !isempty(str)
        dest = str[1]
        src = str[2]
        range = str[3]

        push!(srcs, src:src+range)
        push!(dests, dest:dest+range)

        str = parse.(Int, split(readline(io)))
    end
    return srcs, dests
end

function parse_input()
    open("input", "r") do io
        line = readline(io)
        seeds = parse.(Int, split(line)[2:end])
        _ = readline(io)
        _ = readline(io)
        src, dest = parse_map(io)
        srcs = [src]
        dests = [dest]
        for _ = 2:7
            _ = readline(io)
            src, dest = parse_map(io)
            push!(srcs, src)
            push!(dests, dest)
        end
        return seeds, srcs, dests
    end
end

function part1()
    seeds, srcs, dests = parse_input()
    score = typemax(Int)
    for seed in seeds
        s = seed
        for (src, dest) in zip(srcs, dests)
            s = get_seed(src, dest, s)
        end
        score = min(score, s)
    end
    score
end

function part2()
    seeds, srcs, dests = parse_input()
    scores = Int[]
    Threads.@threads for i = 1:(length(seeds)÷2)
        score = typemax(Int)
        for seed in seeds[2i-1]:(seeds[2i-1]+seeds[2i]-1)
            s = seed
            for (src, dest) in zip(srcs, dests)
                s = get_seed(src, dest, s)
            end
            score = min(score, s)
        end
        @show score
        push!(scores, score)
    end
    minimum(scores)
end

@show part1()
@show part2() # answer -1 on input file. why?
