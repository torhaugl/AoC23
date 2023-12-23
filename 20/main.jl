@enum SIGNAL low high

function parse_input()
    flipflops = Dict{String, Bool}()
    conjuction = Dict{String, Dict{String,SIGNAL}}()
    connection_graph = Dict{String, Vector{String}}()

    for line in readlines("20/input")
        if line[1] == '&'
            label = split(line[2:end])[1]
            conjuction[label] = Dict{String,SIGNAL}()
        elseif line[1] == '%'
            label = split(line[2:end])[1]
            flipflops[label] = false
        elseif startswith(line, "broadcaster")
            label = "broadcaster"
        else
            label = ""
            throw("Error: $line")
        end
        connections = strip.(split(split(line, '>')[end], ','))
        connection_graph[label] = connections
    end

    for key in keys(conjuction)
        for (k,v) in connection_graph
            if key in v
                conjuction[key][k] = low
            end
        end
    end

    return flipflops, conjuction, connection_graph
end

#Flip-flop modules (prefix %) are either on or off;
# they are initially off.
# If a flip-flop module receives a high pulse, it is ignored and nothing happens.
# However, if a flip-flop module receives a low pulse, it flips between on and off.
# If it was off, it turns on and sends a high pulse.
# If it was on, it turns off and sends a low pulse.

#Conjunction modules (prefix &) remember the type of the most recent pulse received from each of their connected input modules;
# they initially default to remembering a low pulse for each input.
# When a pulse is received, the conjunction module first updates its memory for that input.
# Then, if it remembers high pulses for all inputs, it sends a low pulse;
# otherwise, it sends a high pulse.

function push_button!(ff, conj, graph)
    nodes = [("broadcaster", "button", low)]
    output_low = 0
    output_high = 0
    i = 0
    rx = false

    while !isempty(nodes)
        i += 1
        #@show i 
        #display([(x[1], x[2], x[3]) for x in nodes])
        #println()

        j = 0
        to_delete = Int[]
        for (l,_,s) in nodes
            j += 1
            if l == "output"
                to_break = true
                push!(to_delete, j)
                if s == low
                    output_low += 1
                elseif s == high
                    output_high += 1
                else
                    println("Not possible?")
                end
            end
            if l == "rx" && s == low
                rx = true
            end
        end
        deleteat!(nodes, to_delete)


        new_nodes = Tuple{String, String, SIGNAL}[]
        for (label, prev, sig) in nodes
            skip = false
            if sig == low
                output_low += 1
            else
                output_high += 1
            end
            if label == "output"
                println("Not possible?")
                continue
            elseif label == "broadcaster"
                new_signal = sig
            elseif label in keys(ff)
                if sig == low
                    # Switch signal on/off
                    if !ff[label]
                        ff[label] = true
                        new_signal = high
                    else
                        ff[label] = false
                        new_signal = low
                    end
                else
                    skip = true
                end
            elseif label in keys(conj)
                conj[label][prev] = sig
                c = conj[label]
                if all(values(c) .== high)
                    new_signal = low
                else
                    new_signal = high
                end
            end
            if !skip
                for new_label in get(graph, label, "")
                    if new_label !== ""
                        push!(new_nodes, (new_label, label, new_signal))
                    end
                end
            end
        end

        nodes = copy(new_nodes)
    end
    return output_low, output_high, rx
end

function part1()
    ff, conj, graph = parse_input()

    score1 = 0
    score2 = 0
    for _ = 1:1000
        output_low, output_high, _ = push_button!(ff, conj, graph)
        score1 += output_low
        score2 += output_high
    end

    return score1 * score2
end

function part2()
    ff, conj, graph = parse_input()

    rx = false
    i = 0
    while !rx
        i += 1
        _, _, rx = push_button!(ff, conj, graph)
    end

    return i
end

@show part1()
@show part2()