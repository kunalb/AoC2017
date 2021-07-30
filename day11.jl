function hex_distance(steps)
    steps = split(steps, ",")
    pos = 0
    max_distance = 0
    distance = 0

    for step in steps
        pos += if step == "n"
            2im
        elseif step == "s"
            -2im
        elseif step == "ne"
            1 + im
        elseif step == "nw"
            -1 + im
        elseif step == "se"
            1 - im
        elseif step == "sw"
            -1 - im
        else
            throw(InvalidStateException("Unexpected step " + step))
        end 

        r = abs(real(pos))
        i = abs(imag(pos))
        
        distance = r + (i - r) ÷ 2
        max_distance = max(distance, max_distance)
    end 

    (distance, max_distance)
end 

function main()
    distance, max_distance = hex_distance(readline())
    println(
        get(ARGS, 1, 1) == 1 ?  distance : max_distance
    )
end

main()