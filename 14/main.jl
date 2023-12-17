function parse_matrices()
    matrix_str  = read("14/input", String)
    rows = split(matrix_str, "\n")
    map = permutedims(hcat([[char for char in row] for row in rows]...), (2,1))
    return map
end

function move_up!(index, A)
    if index[1] == 1 || A[index[1] - 1, index[2]] != '.'
        return false
    else
        A[index[1] - 1, index[2]] = 'O'
        A[index] = '.'
        return true
    end
end

function part1()
    A = parse_matrices()
    timetobreak = false
    while !timetobreak
        timetobreak = true
        nodes = findall(==('O'), A)
        for index in nodes
            if move_up!(index, A)
                timetobreak = false
            end
        end
    end
    nodes = findall(==('O'), A)
    score = sum([size(A,1) + 1 - index[1] for index in nodes])
    display(A)
    return score
end

@show part1()