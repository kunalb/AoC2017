function run_turing_machine(input)
    # Begin in state A
    initial_state = split(input[1], " ")[4][1] - 'A' + 1

    # Perform a diagnostic ...
    steps = parse(Int64, split(input[2], " ")[6])

    # Build machine
    machine = Vector{Vector{Tuple{Int64, Int64, Int64}}}()
    for index in 4:10:length(input)
        # In state...
        state = split(input[index], " ")[3][1]
        pos = state - 'A' + 1
        push!(machine, Vector())

        for cur_val in (0, 1)
            input_index = index + cur_val * 4 + 1
            # Write the value...
            write_val = parse(Int64, split(chomp(input[input_index + 1]))[5][1])
            # Move one slot...
            delta = split(chomp(input[input_index + 2]))[7] == "right." ? 1 : -1
            # Continue with state...
            next_state = split(chomp(input[input_index + 3]))[5][1] - 'A' + 1

            push!(machine[pos], (write_val, delta, next_state))
        end
    end

    # Run the machine
    tape = Set{Int64}()
    pos = 0
    state = initial_state
    for step in 1:steps
        val = in(pos, tape) ? 2 : 1
        action = machine[state][val]

        # Update tape
        (action[1] == 1 ? push! : delete!)(tape, pos)
        # Move on tape
        pos += action[2]
        # Update state
        state = action[3]
    end

    length(tape)
end

function main()
    input = split(chomp("""
Begin in state A.
Perform a diagnostic checksum after 6 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.

"""), "\n")
    input = readlines()
    println(run_turing_machine(input))
end

main()
