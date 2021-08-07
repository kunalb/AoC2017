function duet(instructions)
    registers = Dict()
    function parse_arg(arg)
        parsed = tryparse(Int64, arg)
        isnothing(parsed) ? get(registers, arg, 0) : parsed
    end

    freq = nothing
    pos = 1
    len = length(instructions)
    while true
        if pos < 1 || pos > len
            break
        end

        instruction = instructions[pos]
        parts = split(instruction)
        inst = parts[1]
        if inst == "snd"
            freq = parse_arg(parts[2])
        elseif inst == "set"
            registers[parts[2]] = parse_arg(parts[3])
        elseif inst == "add"
            registers[parts[2]] = parse_arg(parts[2]) + parse_arg(parts[3])
        elseif inst == "mul"
            registers[parts[2]] = parse_arg(parts[2]) * parse_arg(parts[3])
        elseif inst == "mod"
            registers[parts[2]] = parse_arg(parts[2]) % parse_arg(parts[3])
        elseif inst == "rcv"
            if parse_arg(parts[2]) != 0
                return freq
            end
        elseif inst == "jgz"
            if parse_arg(parts[2]) > 0
                pos += parse_arg(parts[3]) - 1  # Extra -1 for pos += 1
            end
        end 

        # println(inst, " -> ", registers)
        pos += 1
    end
end

function parallel_duet(instructions)
    ch0 = Channel(Inf)
    ch1 = Channel(Inf)
    counters = Dict()
    p0 = make_program(0, instructions, ch0, ch1, counters)
    p1 = make_program(1, instructions, ch1, ch0, counters)

    schedule(Task(p0)) 
    schedule(Task(p1))

    sleep(5)
    while isready(ch0) || isready(ch1)
        sleep(5)
    end

    counters[1]
end

function make_program(program_id, instructions, snd_ch, rcv_ch, counters)
    function program()
        registers = Dict()
        registers["p"] = program_id
        function parse_arg(arg)
            parsed = tryparse(Int64, arg)
            isnothing(parsed) ? get(registers, arg, 0) : parsed
        end

        freq = nothing
        pos = 1
        len = length(instructions)
        while true
            if pos < 1 || pos > len
                break
            end

            instruction = instructions[pos]
            parts = split(instruction)
            inst = parts[1]
            if inst == "snd"
                counters[program_id] = get(counters, program_id, 0) + 1
                put!(snd_ch, parse_arg(parts[2]))
                # println("Sending from ", program_id)
            elseif inst == "set"
                registers[parts[2]] = parse_arg(parts[3])
            elseif inst == "add"
                registers[parts[2]] = parse_arg(parts[2]) + parse_arg(parts[3])
            elseif inst == "mul"
                registers[parts[2]] = parse_arg(parts[2]) * parse_arg(parts[3])
            elseif inst == "mod"
                registers[parts[2]] = parse_arg(parts[2]) % parse_arg(parts[3])
            elseif inst == "rcv"
                registers[parts[2]] = take!(rcv_ch)
            elseif inst == "jgz"
                if parse_arg(parts[2]) > 0
                    pos += parse_arg(parts[3]) - 1  # Extra -1 for pos += 1
                end
            end 

            pos += 1

            # println("Yielding from ", program_id)
            yield()
        end
    end
    program
end

function main()
    if get(ARGS, 1, 1) == 1
        input = split(chomp("""
set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2
    """), "\n")
        input = readlines()
        println(duet(input))
    else 
        input = split(chomp("""
snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d
"""), "\n")
        input = readlines()
        println(parallel_duet(input))
    end
end

main()