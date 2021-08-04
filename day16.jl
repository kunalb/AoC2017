function dance!(input, positions=nothing)
    positions = isnothing(positions) ? collect('a':'p') : positions
    moves = split(input, ",")

    # println("dance!")
    for move in moves
        m = move[1]
        if m == 's'
            # Thank you Programming Pearls
            offset = parse(Int32, move[2:end])
            point = length(positions) - offset
            reverse!(positions, 1, point)
            reverse!(positions, point + 1)
            reverse!(positions)
        elseif m == 'x'
            i1, i2 = map(x -> parse(Int32, x) + 1, split(move[2:end], "/"))
            positions[i1], positions[i2] = positions[i2], positions[i1]
        elseif m == 'p'
            p1, i2 = map(x -> x[1], split(move[2:end], "/"))
            i1 = findall(x -> x == p1, positions)[1]
            i2 = findall(x -> x == i2, positions)[1]
            positions[i1], positions[i2] = positions[i2], positions[i1]
        end

        # println(join(positions))
    end

    positions
end

function cycle_length(input, positions)
    len = 1
    base = copy(positions)
    iter = dance!(input, copy(positions))

    while true
        if iter == base
            return len
        end

        dance!(input, iter)
        len += 1
    end
end

function billion(input, positions)
    positions = isnothing(positions) ? collect('a':'p') : positions
    cycle = cycle_length(input, positions)
    # println(cycle)
    rem = 1_000_000_000 % cycle
    # println(rem)

    while rem > 0
        dance!(input, positions)
        rem -= 1
    end
    positions
end

function main()
    if true 
        input = readline() 
        positions = nothing
    else
        input = "s1,x3/4,pe/b"
        positions = collect('a':'e')
    end 

    if get(ARGS, 1, 1) == 1
        println(join(dance!(input, positions)))
    else 
        println(join(billion(input, positions)))
    end 
end

main()