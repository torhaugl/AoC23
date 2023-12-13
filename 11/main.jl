using SparseArrays

function parse_matrices(n :: Int)
    matrix_str  = read("11/input", String)
    rows = split(matrix_str, "\n")
    starmap = hcat([[char == '#' for char in row] for row in rows]...)'
    indices = findall(==(true), starmap)
    #zero = indices[1]
    zero = CartesianIndex((3,1))

    rows = Set{Int}()
    cols = Set{Int}()
    for index in indices
        push!(rows, index[1])
        push!(cols, index[2])
    end

    galaxy = Tuple{Int,Int}[]
    for index in indices
        x = index[1] - zero[1]
        y = index[2] - zero[2]
        if x >= 0
            a = x - count(z -> 0 <= z - zero[1] < x, rows)
        else
            a = abs(x) - count(z -> x < z - zero[1] <= 0, rows)
        end
        if y >= 0
            b = y - count(z -> 0 <= z - zero[2] < y, cols)
        else
            b = abs(x) - count(z -> y < z - zero[2] <= 0, cols)
        end

        push!(galaxy, ((n-1)a + x, (n-1)b + y))
    end
    return galaxy
end

function part1()
    A = parse_matrices(2)
    dist = 0
    for i = 1:length(A), j = i+1:length(A)
        d = sum(abs, A[i] .- A[j])
        dist += d
    end
    return dist
end

function part2()
    A = parse_matrices(1_000_000)
    dist = 0
    for i = 1:length(A), j = i+1:length(A)
        d = sum(abs, A[i] .- A[j])
        dist += d
    end
    return dist
end

@show part1()
@show part2()