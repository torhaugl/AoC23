# Read the Engine Schematic into a matrix of characters.
function parse_input()

    a = Vector{Vector{Int}}(undef, 0)
    b = Vector{Vector{Int}}(undef, 0)
    #for (i, line) in enumerate(readlines("4/test"))
    for (i, line) in enumerate(readlines("4/input"))
        str = split(line)
        #bef = parse.(Int, str[3:7])
        bef = parse.(Int, str[3:12])
        push!(b, bef)
        #after = parse.(Int, str[9:end])
        after = parse.(Int, str[14:end])
        push!(a, after)
    end
    return b, a
end

function part1()
    b, a = parse_input()
    score = 0
    for (x, y) in zip(b, a)
        n = length(intersect(x, y))
        if (n == 0)
            score += 0
        else
            score += 2^(n-1)
        end
    end
    return score
end

function part2()
    b, a = parse_input()
    score = 0
    Nmax = length(b)
    cards = Dict(i => 1 for i = 1:Nmax)
    count = 0
    for (i, (x, y)) in enumerate(zip(b, a))
        ncard = cards[i]
        cards[i] = 0

        n = length(intersect(a[i], b[i]))
        for j = 1:n
            if (i+j > Nmax)
                break
            end
            cards[i+j] += ncard
        end
        score += ncard
    end
    return score
end

@show part1()
@show part2();