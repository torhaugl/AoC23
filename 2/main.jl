rules = Dict("blue" => 14, "red" => 12, "green" => 13)

score = 0
part2 = 0
for line in readlines("2/input")
    count = Dict("blue" => 0, "red" => 0, "green" => 0)
    minim = Dict("blue" => 0, "red" => 0, "green" => 0)
    above = false
    words = split(line)
    ID = parse(Int, words[2][1:end-1])
    for n = 3:2:length(words)-1
        y = parse(Int, words[n])
        @show y
        try
            x = words[n+1][1:end-1]
            @show x
            count[x] += y
            if words[n+1][end] == ';'
                for k in keys(count)
                    minim[k] = max(minim[k], count[k])
                    if count[k] > rules[k]
                        above = true
                    end
                    count[k] = 0
                end
            end
        catch
            @show count
            x = words[n+1][1:end]
            count[x] += y
            for k in keys(count)
                minim[k] = max(minim[k], count[k])
                if count[k] > rules[k]
                        @show count
                    above = true
                end
                count[k] = 0
            end
        end
    end
    if !above
        @show ID
        score += ID
    end

    part2 += minim["blue"] * minim["red"] * minim["green"]
    #"Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
end
@show score
@show part2