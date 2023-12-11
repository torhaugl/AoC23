const wordMap = Dict("one" => 1, "two" => 2, "three" => 3, "four" => 4, 
                     "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, 
                     "nine" => 9, "zero" => 0)

function extractFirstAndLastNumbers(line, useWords=false)
    firstNum = -1
    lastNum = -1
    wordMap = Dict("one" => 1, "two" => 2, "three" => 3, "four" => 4, 
                   "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, 
                   "nine" => 9, "zero" => 0)

    for (index, char) in enumerate(line)
        if isdigit(char)
            num = parse(Int, char)
            firstNum = (firstNum == -1) ? num : firstNum
            lastNum = num
        elseif useWords && isletter(char)
            for (word, number) in wordMap
                if startswith(line[index:end], word)
                    firstNum = (firstNum == -1) ? number : firstNum
                    lastNum = number
                    break  # Exit the loop as we found a valid number word
                end
            end
        end
    end

    return firstNum, lastNum
end

function partOneCalibration()
    totalSum = 0
    for line in readlines("1/input")
        firstNum, lastNum = extractFirstAndLastNumbers(line)
        totalSum += 10 * firstNum + lastNum
    end
    return totalSum
end

function partTwoCalibration()
    totalSum = 0
    for line in readlines("1/input")
        firstNum, lastNum = extractFirstAndLastNumbers(line, true)
        totalSum += 10 * firstNum + lastNum
    end
    return totalSum
end

println("Part One Total Sum: ", partOneCalibration())
println("Part Two Total Sum: ", partTwoCalibration())