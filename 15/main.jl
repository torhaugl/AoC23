function hash(str)
    current = 0
    for c in str
        current = ((current + Int(c)) * 17) % 256
    end
    return current
end

function part1()
    input = readline("15/input")
    score = 0
    for str in split(input, ',')
        score += hash(str)
    end
    return score
end

using DataStructures

function part2()
    input = readline("15/input")
    boxes = OrderedDict{String, Int}[]
    for _ = 1:256
        push!(boxes, OrderedDict{String, Int}())
    end
    for str in split(input, ',')
        if occursin('=', str)
            label, focal = split(str, '=')
            box_index = hash(label) + 1
            focal_length = parse(Int, focal)
            boxes[box_index][label] = focal_length
        elseif occursin('-', str)
            label, _ = split(str, '-')
            box_index = hash(label) + 1
            if label in keys(boxes[box_index])
                pop!(boxes[box_index], label)
            end
        else
            println("Error")
        end

    end
    score = 0
    for (i,box) in enumerate(boxes)
        for (j, (_, focal_length)) in enumerate(box)
            s = i * j * focal_length
            @show i, j, focal_length, s
            score += s
        end
    end
    score
end

@show part1()
@show part2()