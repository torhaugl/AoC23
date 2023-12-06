function part1()
    times = [63, 78, 94, 68]
    #times = [7, 15,  30]
    dists = [411, 1274, 2047, 1035]
    #dists = [9, 40, 200]

    x = []
    for (time, goal_dist) in zip(times, dists)
        wins = 0
        for wait_time = 1:time
            speed = wait_time
            travel_dist = speed * (time - wait_time)
            if travel_dist > goal_dist
                wins += 1
            end
        end
        push!(x, wins)
        @show wins
    end

    prod(x)
end

function part2()
    time = 63789468
    goal_dist = 411127420471035
    wins = 0
    for wait_time = 1:time
        speed = wait_time
        travel_dist = speed * (time - wait_time)
        if travel_dist > goal_dist
            wins += 1
        end
    end
    return wins
end

@show part1()
@show part2()