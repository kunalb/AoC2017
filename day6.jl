function eval(input, level)
    seen = Set([copy(input)])
    len = length(input)
    step = 0
    start_step = nothing
    start_input = nothing

    while true
        pos = argmax(input)
        val = input[pos]
        input[pos] = 0

        inc = val ÷ len
        input .+= inc
        rem  = val % len

        while rem > 0
            pos = (pos % len) + 1
            rem -= 1

            input[pos] += 1
        end

        step += 1
        if in(input, seen)
            if level == 1
                return step
            elseif start_step == nothing
                start_step = step
                start_input = copy(input)
            elseif level != 1 && start_input == input
                return step - start_step
            end
        else
            push!(seen, copy(input))
        end
    end
end

if !isinteractive()
    println(eval(map(x -> parse(Int64, x), split(readline())),
                 get(ARGS, 1, 1)))
end
