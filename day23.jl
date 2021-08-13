using Printf

function read_arg(registers, arg)
    parsed = tryparse(Int64, arg)
    isnothing(parsed) ? get(registers, arg, 0) : parsed
end

function processor(instructions)
    registers = Dict()
    mul_count = 0
    p = 1
    while true
        if p < 1 || p > length(instructions)
            break
        end

        opcode, x, y = split(instructions[p])
        if opcode == "set"
            registers[x] = read_arg(registers, y)
        elseif opcode == "sub"
            registers[x] = read_arg(registers, x) - read_arg(registers, y)
        elseif opcode == "mul"
            registers[x] = read_arg(registers, x) * read_arg(registers, y)
            mul_count += 1
        elseif opcode == "jnz"
            if read_arg(registers, x) != 0
                p += read_arg(registers, y)
                continue
            end
        end

        p += 1
    end

    mul_count
end

function explore(instructions, debug=true)
    registers = Dict("a" => 1)
    p = 1
    counter = 0
    while true
        # if counter > 100
        #     break
        # end

        if p < 1 || p > length(instructions)
            debug && @Printf.printf "Pointer %d outside range\n" p
            break
        end

        opcode, x, y = split(instructions[p])
        debug && @Printf.printf "%3d %s %10s=%10d %10s=%10d => " p opcode x read_arg(registers, x) y read_arg(registers, y)

        if opcode == "set"
            registers[x] = read_arg(registers, y)
        elseif opcode == "sub"
            registers[x] = read_arg(registers, x) - read_arg(registers, y)
        elseif opcode == "mul"
            registers[x] = read_arg(registers, x) * read_arg(registers, y)
        elseif opcode == "jnz"
            if read_arg(registers, x) != 0
                p += read_arg(registers, y)
                debug && @printf "%d\n" p
                continue
            end
        end

        debug && @printf "%d\n" registers[x]
        p += 1
        counter += 1
    end

    get(registers, "h", 0)
end

#=
                 set b 65            b = 65
                 mul b 100           b *= 100 = 6500
                 sub b -100000       b += 100,000 = 106500
                 set c b             c = 106500
                 sub c -17000        c = 123500

                 set b 106500
                 set c 123500
         +------>set f 1             do  f = 1
         |       set d 2                 d = 2
         | +---->set e 2                 do  e = 2
         | | +-->set g d                     do  g = d = 2
         | | |   mul g e                         g *= e = 4
         | | |   sub g b                         g -= b = -106496
         | | | +-jnz g 2                         if g == 0
         | | | | set f 0                            f = 0
         | | | +>sub e -1                        e += 1 = 3
         | | |   set g e                         g = e = 3
         | | |   sub g b                         g -= b = -106497
         | | +---jnz g -8                    while g != 0 => g=0, e=106500, f=0
         | |     sub d -1                    d += 1 = 3
         | |     set g d                     g = d = 3
         | |     sub g b                     g -= b = -106497
         | +-----jnz g -13               while g != 0 => g=0, d=106500
         |     +-jnz f 2                 if f == 0
         |     | sub h -1                    h += 1 = 1
         |     +>set g b                 g = b = 106500
         |       sub g c                 g -= c = 17000
         |     +-jnz g 2                 if g == 0
         |   +-|-jnz 1 3                     exit
         |   | +>sub b -17               b -= 17
         +---|---jnz 1 -23           while True
             +-->
=#
function direct_translation()
    b = 106500
    c = 123500
    h = 0
    while true
        f = 1
        d = 2
        while true
            e = 2
            while true
                g = d
                g *= e
                g -= b
                if g == 0
                    f = 0
                end
                e += 1
                g = e
                g -= b
                g != 0 || break
            end
            d += 1
            g = d
            g -= b
            g != 0 || break
        end
        if f == 0
            h += 1
        end
        g = b
        g -= c
        b += 17
        g != 0 || break
    end

    h
end

function optimized()
    function is_composite(b)
        for i in 2:floor(sqrt(b))
            if b % i == 0
                return true
            end
        end

        return false
    end

    sum(1 for b in 106500:17:123500 if is_composite(b))
end


function main()
    if get(ARGS, 1, 1) == 1
        println(processor(readlines()))
    else
        # println(explore(readlines(), true))
        println(optimized())
    end
end

main()
