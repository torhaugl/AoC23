function parse_line(line)
    onsen, nums_str = split(line)
    onsen = string(onsen)
    nums = parse.(Int, split(nums_str, ','))
    return onsen, nums
end

function validate(line, nums)
    onsen_nums = split(line, '.') .|> length 
    onsen = [x for x in onsen_nums if x != 0]
    return onsen == nums
end

function create_all_possible_strings(lines_in)
    lines = String[]
    for line in lines_in
        for (i, c) in enumerate(line)
            if c == '?'
                new_line1 = [c for c in line]
                new_line1[i] = '.'
                new_line2 = [c for c in line]
                new_line2[i] = '#'
                push!(lines, prod(new_line1))
                push!(lines, prod(new_line2))
                break
            end
        end
    end
    lines
end

function count_arrangements_naive(onsen, nums)
    lines = [onsen]
    while occursin("?", lines[1])
        lines = create_all_possible_strings(lines)
    end
    valid = [validate(line, nums) for line in lines]
    sum(valid)
end

function count_arrangements(spring_conditions, group_sizes)#, memo)
    #memo_key = (spring_conditions, group_sizes)
    #if memo_key in keys(memo)
    #    return memo[memo_key]
    #end
    #@show spring_conditions, group_sizes

    #if 0 in group_sizes
        #println("WARNING zero found")
    #end

    # Screening
    if isempty(group_sizes)
        if occursin("#", spring_conditions)
            return 0
        else
            return 1
        end
    end

    possible = length(spring_conditions) - count(==('.'), spring_conditions)
    if sum(group_sizes) > possible
        return 0
    end

    current = count(==('#'), spring_conditions)
    if current > sum(group_sizes)
        return 0
    end

    if sum(group_sizes) + length(group_sizes) - 1 > length(spring_conditions)
        return 0
    end

    if spring_conditions == ""
        return 0
    end

    # Main loop
    if spring_conditions[1] == '.'
        return count_arrangements(spring_conditions[2:end], group_sizes)
    elseif spring_conditions[1] == '#'
        new = spring_conditions[2:end]
        if group_sizes[1] >= 2
            if length(spring_conditions) == 1
                return 0
            end
            new_group = copy(group_sizes)
            new_group[1] -= 1
            if spring_conditions[2] == '?'
                new = '#' * spring_conditions[3:end]
            elseif spring_conditions[2] == '.'
                return 0
            end
        elseif group_sizes[1] == 1
            if length(spring_conditions) == 1
                if length(group_sizes) == 1
                    return 1
                else
                    return 0
                end
            end
            if spring_conditions[2] == '#'
                return 0
            end
            if spring_conditions[2] == '?'
                new = '.' * spring_conditions[3:end]
            else
                new = spring_conditions[2:end]
            end
            new_group = copy(group_sizes[2:end])
        else
            println("Error group")
        end
        return count_arrangements(new, new_group)
    elseif spring_conditions[1] == '?'
        new_condition1 = '.' * spring_conditions[2:end]
        new_condition2 = '#' * spring_conditions[2:end]
        a = count_arrangements(new_condition1, group_sizes)
        a += count_arrangements(new_condition2, group_sizes)
        return a
    else
        println("Error spring")
    end

    println("Error end")
end

using Memoize

@memoize function count_arrangements_v2(spring_conditions, group_sizes)
    # Screening
    if isempty(group_sizes)
        if occursin("#", spring_conditions)
            return 0
        else
            return 1
        end
    end

    possible = length(spring_conditions) - count(==('.'), spring_conditions)
    if sum(group_sizes) > possible
        return 0
    end

    current = count(==('#'), spring_conditions)
    if current > sum(group_sizes)
        return 0
    end

    if sum(group_sizes) + length(group_sizes) - 1 > length(spring_conditions)
        return 0
    end

    if spring_conditions == ""
        return 0
    end

    # Main loop
    if spring_conditions[1] == '.'
        return count_arrangements(spring_conditions[2:end], group_sizes)
    elseif spring_conditions[1] == '#'
        n = new_group[1]
        if length(spring_conditions == n)
            stop = any(spring_conditions[1:n] .== '.')
        else
            stop = any(spring_conditions[1:n] .== '.') * (spring_conditions[n+1] == '#')
        end
        if stop
            return 0
        end
        if length(spring_conditions) < n+2
            new = ""
        else
            new = spring_conditions[n+2:end]
        end
        if length(group_sizes) < 2
            new_group = []
        else
            new_group = group_sizes[2:end]
        end
        return count_arrangements(new, new_group)
    elseif spring_conditions[1] == '?'
        new_condition1 = '.' * spring_conditions[2:end]
        new_condition2 = '#' * spring_conditions[2:end]
        a = count_arrangements(new_condition1, group_sizes)
        a += count_arrangements(new_condition2, group_sizes)
        return a
    else
        println("Error spring")
    end

    println("Error end")
end

function part2()
    score = 0
    Threads.@threads for line in readlines("12/input")
        onsen, nums = parse_line(line)
        @show onsen, nums
        onsen5 = "$onsen?$onsen?$onsen?$onsen?$onsen"
        nums5 = repeat(nums, 5)
        @time valid = count_arrangements(onsen5, nums5)
        @show valid
        score += valid
    end
    return score
end

#@show part1() # 7251
#@show part2()
#
#count_arrangements(".", [])  # 1
#count_arrangements("#", [])  # 0
#count_arrangements("?", [])  # 1
#count_arrangements(".", [1]) # 0
#count_arrangements("#", [1]) # 1
#count_arrangements("?", [1]) # 1
#
#count_arrangements("..", [])  # 1
#count_arrangements("#.", [])  # 0
#count_arrangements("?.", [])  # 1
#count_arrangements(".#", [])  # 0
#count_arrangements("##", [])  # 0
#count_arrangements("?#", [])  # 0
#count_arrangements(".?", [])  # 1
#count_arrangements("#?", [])  # 0
#count_arrangements("??", [])  # 1
#count_arrangements("..", [1]) # 0
#count_arrangements("#.", [1]) # 1 
#count_arrangements("?.", [1]) # 1
#count_arrangements(".#", [1]) # 1
#count_arrangements("##", [1]) # 0
#count_arrangements("?#", [1]) # 1
#count_arrangements(".?", [1]) # 1
#count_arrangements("#?", [1]) # 1
#count_arrangements("??", [1]) # 2
#count_arrangements("..", [2]) # 0
#count_arrangements("#.", [2]) # 0
#count_arrangements("?.", [2]) # 0
#count_arrangements(".#", [2]) # 0
#count_arrangements("##", [2]) # 1
#count_arrangements("?#", [2]) # 1
#count_arrangements(".?", [2]) # 0
#count_arrangements("#?", [2]) # 1
#count_arrangements("??", [2]) # 1
#count_arrangements("..", [1,1]) # 0
#count_arrangements("#.", [1,1]) # 0
#count_arrangements("?.", [1,1]) # 0
#count_arrangements(".#", [1,1]) # 0
#count_arrangements("##", [1,1]) # 0
#count_arrangements("?#", [1,1]) # 0
#count_arrangements(".?", [1,1]) # 0
#count_arrangements("#?", [1,1]) # 0
#count_arrangements("??", [1,1]) # 0
#
count_arrangements("???", [1,1,1]) # 0
count_arrangements("???", [1,2]) # 0
count_arrangements("???", [2,1]) # 0
count_arrangements("???", [1,1]) # 1
count_arrangements("???", [3]) # 1
count_arrangements("???", [2]) # 2
count_arrangements("???", [1]) # 3
#
#onsen = "?###????????"
#nums = [3,2,1]
#count_arrangements(onsen, nums)
#count_arrangements_naive(onsen, nums)
#
#onsen = "???"
#nums = [2]
#count_arrangements(onsen, nums)
#count_arrangements_naive(onsen, nums)
#
#onsen = "#??"
#nums = [2]
#count_arrangements(onsen, nums)
#count_arrangements_naive(onsen, nums)

onsen = ".??..??...?##.?.??..??...?##.?.??..??...?##."
nums = [1, 1, 3, 1, 1, 3, 1, 1, 3]
@time count_arrangements(onsen, nums)
@time count_arrangements_v2(onsen, nums)
#onsen = "????????????????????????????????????????????????????????????????"
onsen = "???????????????????????????????????????????????????"
nums = repeat([3, 1, 1, 1], 4)
@time count_arrangements(onsen, nums)
@time count_arrangements_v2(onsen, nums)
#count_arrangements_naive(onsen, nums)

#onsen = "?.?"
#nums = [2]
#count_arrangements(onsen, nums)
#count_arrangements_naive(onsen, nums)