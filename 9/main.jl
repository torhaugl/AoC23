function reduce_diff(v)
    [v[i] - v[i-1] for i = 2:length(v)]
end

function part1()
    score = 0
    for line in readlines("9/input")
        matrix = []
        nums = parse.(Int, split(line))
        push!(matrix, nums)
        while (sum(abs, nums) != 0)
            nums = reduce_diff(nums)
            push!(matrix, nums)
        end
        for row in matrix
            score += row[end]
        end
    end
    return score
end

function part2()
    score = 0
    for line in readlines("9/input")
        matrix = []
        nums = parse.(Int, split(line))
        push!(matrix, nums)
        while (sum(abs, nums) != 0)
            nums = reduce_diff(nums)
            push!(matrix, nums)
        end
        s = 0
        prev = 0
        for row in reverse(matrix[1:end-1])
            prev = row[begin] - prev
        end
        score += prev
    end
    return score
end

@show part1()
@show part2()