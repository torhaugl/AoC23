
"""
Parse input line like 
".??..??...?##. 1,1,3"
to 
(".??..??...?##.", (1, 1, 3))
Here different chars indicate operational (.) or damaged (#) or unknown (?)
condition on the hot spring (onsen). The numbers instead indicate number of
onsen adjacent to each other.
"""
function parse_line(line)
    onsen, nums_str = split(line)
    onsen = string(onsen)
    nums = parse.(Int, split(nums_str, ','))
    return onsen, nums
end

"""
Validate string of (.#) versus nums.
The input string must not contain '?'
If possible, return True, else, False
"""
function validate(line, nums)
    # @assert '?' ∉ line
    onsen_nums = split(line, '.') .|> length
    onsen = [x for x in onsen_nums if x != 0]
    return onsen == nums
end

"""
Replace question marks with . and #
"""
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
    return lines
end

"""
Count all possible onsen arrangements
by creating every arrangement.

Provides a naive ground truth.
"""
function count_arrangements_naive(onsen, nums)
    lines = [onsen]
    while occursin("?", lines[1])
        lines = create_all_possible_strings(lines)
    end
    valid = [validate(line, nums) for line in lines]
    sum(valid)
end

function screening(spring_conditions, group_sizes)
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

    # Did not screen
    return -1
end

function count_arrangements_recursive(spring_conditions, group_sizes)
    # Screening returns 0 or larger if successful
    # Otherwise screening did not work and full algorhitm must be run
    info = screening(spring_conditions, group_sizes)
    if info >= 0
        return info
    end

    # Recursive loop
end

function count_arrangements(onsen, nums)
    count_arrangements_naive(onsen, nums)
end

function test()
    @assert count_arrangements(".", []) == 1
    @assert count_arrangements("#", []) == 0
    @assert count_arrangements("?", []) == 1
    @assert count_arrangements(".", [1]) == 0
    @assert count_arrangements("#", [1]) == 1
    @assert count_arrangements("?", [1]) == 1
    @assert count_arrangements("..", []) == 1
    @assert count_arrangements("#.", []) == 0
    @assert count_arrangements("?.", []) == 1
    @assert count_arrangements(".#", []) == 0
    @assert count_arrangements("##", []) == 0
    @assert count_arrangements("?#", []) == 0
    @assert count_arrangements(".?", []) == 1
    @assert count_arrangements("#?", []) == 0
    @assert count_arrangements("??", []) == 1
    @assert count_arrangements("..", [1]) == 0
    @assert count_arrangements("#.", [1]) == 1
    @assert count_arrangements("?.", [1]) == 1
    @assert count_arrangements(".#", [1]) == 1
    @assert count_arrangements("##", [1]) == 0
    @assert count_arrangements("?#", [1]) == 1
    @assert count_arrangements(".?", [1]) == 1
    @assert count_arrangements("#?", [1]) == 1
    @assert count_arrangements("??", [1]) == 2
    @assert count_arrangements("..", [2]) == 0
    @assert count_arrangements("#.", [2]) == 0
    @assert count_arrangements("?.", [2]) == 0
    @assert count_arrangements(".#", [2]) == 0
    @assert count_arrangements("##", [2]) == 1
    @assert count_arrangements("?#", [2]) == 1
    @assert count_arrangements(".?", [2]) == 0
    @assert count_arrangements("#?", [2]) == 1
    @assert count_arrangements("??", [2]) == 1
    @assert count_arrangements("..", [1, 1]) == 0
    @assert count_arrangements("#.", [1, 1]) == 0
    @assert count_arrangements("?.", [1, 1]) == 0
    @assert count_arrangements(".#", [1, 1]) == 0
    @assert count_arrangements("##", [1, 1]) == 0
    @assert count_arrangements("?#", [1, 1]) == 0
    @assert count_arrangements(".?", [1, 1]) == 0
    @assert count_arrangements("#?", [1, 1]) == 0
    @assert count_arrangements("??", [1, 1]) == 0
    @assert count_arrangements("???", [1, 1, 1]) == 0
    @assert count_arrangements("???", [1, 2]) == 0
    @assert count_arrangements("???", [2, 1]) == 0
    @assert count_arrangements("???", [1, 1]) == 1
    @assert count_arrangements("???", [3]) == 1
    @assert count_arrangements("???", [2]) == 2
    @assert count_arrangements("???", [1]) == 3
    @assert count_arrangements("?###????????", [3, 2, 1]) == 10
    @assert count_arrangements("#.?", [2]) == 0
    @assert count_arrangements(".??..??...?##.?.??..??...?##.?.??..??...?##.", [1, 1, 3, 1, 1, 3, 1, 1, 3]) == 256
    # @show count_arrangements("???????????????????????????????????????????????????", [3, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1])
end

function part1()
    score = 0
    Threads.@threads for line in readlines("12/input")
        onsen, nums = parse_line(line)
        @time valid = count_arrangements(onsen, nums)
        score += valid
    end
    return score
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

test()
@show part1()
