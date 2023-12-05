sing DataStructures

struct SeedMap
    srcs # Range of src
    dests # Range of dest
end

function get_seed(map :: SeedMap, src, default)
    for (map_src, map_dest) in zip(map.srcs, map.dests)
        if map_src[1] <= src <= map_src[2]
            i = src - map_src[1] + 1
            val = map_dest[i]
            return val
        end
    end
    return default
end

function parse_map(io)
    str = parse.(Int, split(readline(io)))
    srcs = StepRange{Int,Int}[]
    dests = StepRange{Int,Int}[]
    while !isempty(str)
        dest = str[1]
        src = str[2]
        range = str[3]

        push!(srcs, src:src+range)
        push!(dests, dest:dest+range)

        str = parse.(Int, split(readline(io)))
    end
    return SeedMap(srcs, dests)
end

function parse_input()
    open("input", "r") do io
        line = readline(io)
        global seeds = parse.(Int, split(line)[2:end])
        _ = readline(io)
        _ = readline(io)
        map1 = parse_map(io)
        global maps = [map1]
        for _ = 2:7
            _ = readline(io)
            map = parse_map(io)
            push!(maps, map)
        end
    end
    return seeds, maps
end

function merge_map(maps)
    src = values(maps[7])
    for i = 7:1
        key = keys(maps[i])
        val = values(maps[i])
        y = Int[]
        for x in src
            if x in val
                push!(y, key[val == x])
            end
        end
        x = copy(y)
    end

    loc_map = OrderedDict{Int,Int}()
    loc_map[]

    return loc_map
end

function find_seed(src, map)
    x = -1
    for i = 0:src
        x += 1
        while (x in keys(map))
            x += 1
        end
    end
    return x
end

function part1()
    seeds, maps = parse_input()
    score = typemax(Int)
    for seed in seeds
        src = seed
        for map in maps
            src = get_seed(map, src, src)
        end
        score = min(score, src)
    end
    score
end

function part2()
    seeds, maps = parse_input()
    scores = Int[]
    for i = 1:(length(seeds)÷2)
        score = typemax(Int)
        @show i
        for seed in seeds[2i-1]:(seeds[2i-1]+seeds[2i])
        #for seed in seeds[2i-1]:(seeds[2i-1])#+seeds[2i])
        #for seed in (seeds[2i-1]+seeds[2i]):(seeds[2i-1]+seeds[2i])
            src = seed
            for map in maps
                src = get_seed(map, src, src)
            end
            score = min(score, src)
        end
        push!(scores, score)
    end
    @show scores
    minimum(scores)
end

@show part1()
@show part2()
