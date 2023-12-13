function parse_matrices()
    # Split the input into matrices
    input = read("13/input", String)
    matrices_str = split(input, "\n\n")
    
    # Function to parse a single matrix
    function parse_matrix(matrix_str)
        # Split the matrix into rows
        rows = split(matrix_str, "\n")
        
        # Convert each character to true (for '#') or false (for '.')
        return hcat([[char == '#' for char in row] for row in rows]...)
    end

    # Parse each matrix
    return [parse_matrix(matrix_str) for matrix_str in matrices_str]
end


function find_vertical_reflection(matrix)
    index = 0
    for i = 1:(size(matrix, 2) ÷ 2)
        if (matrix[:, 1:i] == matrix[:, i+i:-1:i+1])
            index = i
        end
    end
    for i = (size(matrix, 2) ÷ 2)+1:size(matrix, 2)-1
        j = size(matrix, 2) - i - 1
        if (matrix[:, end:-1:i+1] == matrix[:, i-j:i])
            index = i
        end
    end
    return index
end

function find_horizontal_reflection(matrix)
    return find_vertical_reflection(matrix')
end

function find_vertical_reflection_smudge(matrix)
    index = 0
    for i = 1:(size(matrix, 2) ÷ 2)
        area = size(matrix, 1) * i
        if sum(matrix[:, 1:i] .== matrix[:, i+i:-1:i+1]) == (area - 1)
            index = i
        end
    end
    for i = (size(matrix, 2) ÷ 2)+1:size(matrix, 2)-1
        j = size(matrix, 2) - i - 1
        area = size(matrix, 1) * (j+1)
        if sum(matrix[:, end:-1:i+1] .== matrix[:, i-j:i]) == (area - 1)
            index = i
        end
    end
    return index
end

function find_horizontal_reflection_smudge(matrix)
    return find_vertical_reflection_smudge(matrix')
end

function part1()
    matrices = parse_matrices()
    score = 0
    for matrix in matrices
        sv = find_vertical_reflection(matrix)
        sh = find_horizontal_reflection(matrix)
        score += sh + 100 * sv
    end
    score
end

function part2()
    matrices = parse_matrices()
    score = 0
    for matrix in matrices
        sv = find_vertical_reflection_smudge(matrix)
        sh = find_horizontal_reflection_smudge(matrix)
        score += sh + 100 * sv
    end
    score
end

@show part1()
@show part2()