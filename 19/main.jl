function parse_input()
    before = true
    workflows = Dict{String, String}()
    inputs = NamedTuple{(:x, :m, :a, :s), Tuple{Int,Int,Int,Int}}[]
    for line in readlines("19/input")
        if line == ""
            before = false
            continue
        end

        if before
            label, instr = split(line, '{')
            instr = instr[1:end-1]
            workflows[label] = instr
        else
            regex = r"{x=(\d+),m=(\d+),a=(\d+),s=(\d+)}"
            x, m, a, s = parse.(Int, match(regex, line).captures)
            push!(inputs, (x=x, m=m, a=a, s=s))
        end
    end
    return workflows, inputs
end

function run_workflow(workflow, node, input)
    new_node = ""
    accepted = 0
    found = false

    x, m, a, s = input
    for operation in split(workflow[node], ',')[1:end-1]
        to_eval, new_node = split(operation, ':')
        if to_eval[1] == 'x'
            y = string(x)
        elseif to_eval[1] == 'm'
            y = string(m)
        elseif to_eval[1] == 'a'
            y = string(a)
        elseif to_eval[1] == 's'
            y = string(s)
        else
            y = ""
        end
        expr = Meta.parse(y * to_eval[2:end])
        if eval(expr)
            found = true
            break
        end
    end

    if !found
        new_node = split(workflow[node], ',')[end]
    end

    if new_node == "A"
        accepted = 1
    elseif new_node == "R"
        accepted = -1
    end

    return new_node, accepted
end


function part1()
    wf, inp = parse_input()
    score = 0
    for xmas in inp
        node = "in"
        accepted = 0
        @show xmas
        @show node
        while accepted == 0
            node, accepted = run_workflow(wf, node, xmas)
            @show node
        end
        if accepted == 1
            score += sum(xmas)
        end
        @show node, accepted, sum(xmas)
        println()
        println()
        println()
    end
    return score
end

@show part1()

function part2()
    wf, _ = parse_input()
    score = 0
    for x = 1:40, m = 1:4, a = 1:4, s = 1:4
        xmas = (x,m,a,s)
        @show xmas
        node = "in"
        accepted = 0
        while accepted == 0
            node, accepted = run_workflow(wf, node, xmas)
        end
        if accepted == 1
            score += 1
        end
    end
    return score
end

@show part2()