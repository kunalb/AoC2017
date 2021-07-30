function firewall(input)
    ranges = map(x -> map(y -> parse(Int32, y), split(x, ": ")), input)
    severity = 0

    for (depth, range) in ranges
        tick = depth

        pos_in_cycle = tick % (2 * range - 2)
        # pos = pos_in_cycle - (pos_in_cycle ÷ range) * (range)
        pos = if pos_in_cycle < range
            pos_in_cycle
        else
            range - (pos_in_cycle - range) - 2
        end
        # print(depth, " ", pos, " / ")

        if pos == 0
            severity += depth * range
        end
    end 

    severity
end

function delay(input)
    ranges = map(x -> map(y -> parse(Int32, y), split(x, ": ")), input)
    delay = 0
    while true
        for (depth, range) in ranges
            tick = depth + delay
            pos = tick % (2 * range - 2)
            if pos == 0
                @goto increment
            end
        end 

        return delay

        @label increment
        delay += 1
    end 
end

testinput = """0: 3
1: 2
4: 4
6: 4"""

function main()
    if get(ARGS, 1, 1) == 1
        println(firewall(readlines()))
    else
        println(delay(readlines()))
    end
    # println(firewall(split(testinput, "\n")))
end

main()

