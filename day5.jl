function eval(instructions, jmp=x -> x + 1)
    pointer = 1
    steps = 0
    while pointer >= 1 && pointer <= length(instructions)
        next_pointer = pointer + instructions[pointer]
        instructions[pointer] = jmp(instructions[pointer])
        pointer = next_pointer
        steps += 1
    end

    steps
end

if !isinteractive()
    println(eval(
        map(x -> parse(Int64, x), readlines()),
        get(ARGS, 1, 1) == 1 ? (x -> x + 1) : (x -> x >= 3 ? x - 1 : x + 1)
    ))
end
