global cards2num = Dict(
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    'T' => 10,
    'J' => 11,
    'Q' => 12,
    'K' => 13,
    'A' => 14,
)

global cards2num_v2 = Dict(
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    'T' => 10,
    'J' => 1,
    'Q' => 12,
    'K' => 13,
    'A' => 14,
)

function get_hand_value(cards)
    A = [cards2num[c] for c in cards]
    x = Dict(i => count(==(i), A) for i in unique(A))
    y = Dict(i => count(==(i), values(x)) for i in unique(values(x)))
    if maximum(values(x)) == 5
        return 5.0
    elseif maximum(values(x)) == 4
        return 4.0
    elseif maximum(values(x)) == 3
        if get(y, 2, 0) == 1
            return 3.5
        else
            return 3.0
        end
    elseif maximum(values(x)) == 2
        if y[2] == 2
            return 2.5
        else
            return 2.0
        end
    else
        return 1.0
    end
end

function parse_input()
    tot = []
    for line in readlines("7/input")
        cards, bid = split(line)
        bid = parse(Int, bid)
        val = get_hand_value(cards)
        A = [cards2num[c] for c in cards]
        push!(tot, (val, A, bid))
    end
    return tot
end

function part1()
    x = parse_input()
    sum(i * y[3] for (i, y) in enumerate(sort(x)))
end

function get_hand_value_v2(cards)
    A = [cards2num_v2[c] for c in cards]
    x = Dict(i => count(==(i), A) for i in values(cards2num_v2))
    y = Dict(i => count(==(i), values(x)) for i = 1:5)
    if maximum(values(x)) + x[1] == 5
        return 5.0
    elseif maximum(values(x)) + x[1] == 4
        return 4.0
    elseif maximum(values(x)) + x[1] == 3
        if x[1] == 2
            return 3.0
        elseif x[1] == 1 && get(y, 2, 0) == 2
            return 3.5
        elseif x[1] == 1 && get(y, 2, 0) == 1
            return 3.0
        elseif get(y, 2, 0) == 1
            return 3.5
        else
            return 3.0
        end
    elseif maximum(values(x)) + x[1] == 2
        if x[1] > 0
            return 2.0
        elseif get(y, 2, 0) == 2
            return 2.5
        else
            return 2.0
        end
    else
        return 1.0
    end
end

function parse_input_v2()
    tot = []
    for line in readlines("7/input")
        cards, bid = split(line)
        bid = parse(Int, bid)
        val = get_hand_value_v2(cards)
        A = [cards2num_v2[c] for c in cards]
        push!(tot, (val, A, bid))
    end
    return tot
end

function part2()
    x = parse_input_v2()
    sum(i * y[3] for (i, y) in enumerate(sort(x)))
end

@show part1()
@show part2()