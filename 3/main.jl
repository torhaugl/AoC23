mat = Matrix{Char}(undef, (140, 140))
for (i, line) in enumerate(readlines("3/input"))
    for (j, c) in enumerate(line)
        mat[i, j] = c
    end
end
mat

symbols = findall(x -> !isnumeric(x) && x != '.', mat)
for s in symbols
    println(mat[s])
end
neighbors = [
    CartesianIndex(0,1),
    CartesianIndex(1,0),
    CartesianIndex(0,-1),
    CartesianIndex(-1,0),
    CartesianIndex(1,1),
    CartesianIndex(1,-1),
    CartesianIndex(-1,1),
    CartesianIndex(-1,-1),
]

function findnums(mat, ind)
    line = prod(mat[ind[1],:])
    #println(line)
    #@show ind

    for i = 1:length(line)
        #@show i
        n = 0
        while n+i <= 140 && all([isnumeric(c) for c in line[i:i+n]])
            n += 1
        end
        #@show n
        #@show i <= ind[2]
        #@show ind[2] < i + n
        if i <= ind[2] < i + n
            #println("FOUND")
            #println(line[i:i+n-1])
            indices = [(ind[1], i+x-1) for x = 1:n]
            return parse(Int, line[i:i+n-1]), indices
        end
    end
    return 0, []
end

#PART 1
score = 0
found = [(0,0)]
for ind in symbols
    println()
    @show ind
    for n in neighbors
        i = ind + n
        if i[1] <= 0 || i[1] > 140 || i[2] <= 0 || i[2] > 140
            continue
        end
        #@show i
        if isnumeric(mat[i])
            s, s_ind = findnums(mat, i)
            if s == 0
                continue
            end
            if i.I in found
                continue
            end
            append!(found, s_ind)
            score += s
        end
    end
end
@show score
found

#PART2
score = 0
found = [(0,0)]
gear_sym = findall(x -> x == '*', mat)
for ind in gear_sym
    println()
    @show ind
    num_gear = 0
    gear_score = Int[]
    for n in neighbors
        i = ind + n
        if i[1] <= 0 || i[1] > 140 || i[2] <= 0 || i[2] > 140
            continue
        end
        #@show i
        if isnumeric(mat[i])
            s, s_ind = findnums(mat, i)
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
        score += prod(gear_score)
    end
end
@show score
found