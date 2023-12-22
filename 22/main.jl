function parse_input()
    blocks = Tuple{UnitRange{Int}, UnitRange{Int}, UnitRange{Int}}[]
    for line in readlines("22/input")
        regex = r"(\d+),(\d+),(\d+)~(\d+),(\d+),(\d+)"
        x1, y1, z1, x2, y2, z2 = parse.(Int, match(regex, line).captures)
        push!(blocks, (x1:x2, y1:y2, z1:z2))
    end
    blocks
end

function isoverlap(block1, block2)
    return !any(isempty(intersect(block1[i], block2[i])) for i = 1:3)
end

function move!(blocks, i)
    # If at ground-level, don't move
    if blocks[i][3][begin] == 1
        moved = false
        return moved
    end

    # Move blocks
    new_pos = (blocks[i][1], blocks[i][2], blocks[i][3] .- 1)

    # If any overlap after move, undo move
    if any(isoverlap(new_pos, blocks[j]) for j = 1:length(blocks) if j != i)
        return false
    end

    blocks[i] = new_pos
    return true
end

function relax_blocks!(blocks)
    moving = true
    count = zeros(Bool, length(blocks))
    while moving
        moving = false
        for i = 1:length(blocks)
            moved = move!(blocks, i)
            moving = moving || moved
            if moved
                count[i] = true
            end
        end
    end
    return blocks, count
end

# This function solves both part1 and part2
function part1()
    blocks = parse_input()
    blocks, _ = relax_blocks!(blocks)
    score1 = 0
    score2 = 0
    for i = 1:length(blocks)
        new_blocks = copy(blocks)
        deleteat!(new_blocks, i)
        _, count = relax_blocks!(new_blocks)

        if !any(count)
            score1 += 1
        end
        score2 += sum(count)
    end
    return score1, score2
end

@show part1()