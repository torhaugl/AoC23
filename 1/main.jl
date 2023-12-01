x = []
int0 = 0
int1 = 0
s = 0
for line in readlines("input")
    first = true
    print(line)
    for c in line

        try
            if (first)
                int0 = parse(Int, c)
                first = false
            end
            int1 = parse(Int, c)
        catch
            continue
        end
    end
    s += 10*int0 + int1
    @show int0, int1
    @show s
end
@show s

x = []
int0 = 0
int1 = 0
s = 0
num = Dict("one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9, "zero" => 0)
for line in readlines("input")
    first = true
    print(line)

    for (i, c) in enumerate(line)
        for k in keys(num)
            if startswith(line[i:end], k)
                if (first)
                    int0 = num[k]
                    first = false
                end
                int1 = num[k]
            end
        end

        try
            if (first)
                int0 = parse(Int, c)
                first = false
            end
            int1 = parse(Int, c)
        catch
            continue
        end
    end
    s += 10*int0 + int1
    @show int0, int1
    @show s
end
@show s