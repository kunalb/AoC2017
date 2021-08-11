function show_grid(grid, pos)
    x0, x1 =  minimum(real, grid), maximum(real, grid)
    y0, y1 = minimum(imag, grid), maximum(imag, grid)
    println(grid)
    println((x0, x1, y0, y1))

    for y in y0:y1
        for x in x0:x1
            here = pos == x + im * y
            print(here ? "[" : " ")
            print(in(x + im * y, grid) ? "#" : ".")
            print(here ? "]" : " ")
        end
        println()
    end
    println()
end

function show_complex(states, pos)
    grid = keys(states)
    x0, x1 =  minimum(real, grid), maximum(real, grid)
    y0, y1 = minimum(imag, grid), maximum(imag, grid)
    println(grid)
    println((x0, x1, y0, y1))

    for y in y0:y1
        for x in x0:x1
            here = pos == x + im * y
            print(here ? "[" : " ")
            print(get(states, x + im * y, "."))
            print(here ? "]" : " ")
        end
        println()
    end
    println()
end

function read_grid(map)
    grid = Set()  # 0-indexed map of infected cells
    x = 0
    y = 0

    for row in map
        x = 0
        for el in row
            if el == '#'
                push!(grid, x + im * y)
            end
            x += 1
        end
        y += 1
    end

    pos = x ÷ 2 + (y ÷ 2) * im

    grid, pos
end

function spread_virus(map, bursts=70)
    grid, pos = read_grid(map)
    dir = -im

    count = 0
    for b in 1:bursts
        if in(pos, grid)
            dir *= im
            delete!(grid, pos)
        else
            dir *= -im
            push!(grid, pos)
            count += 1
        end
        pos += dir
    end
    # show_grid(grid, pos)

    count
end

function complex_virus(map, bursts=10000)
    infected, pos = read_grid(map)
    states = Dict()
    for pos in infected
        states[pos] = '#'
    end

    count = 0
    dir = -im
    # show_complex(states, pos)
    for b in 1:bursts
        cur = get(states, pos, nothing)
        if cur == '#'
            dir *= im
            states[pos] = 'F'
        elseif cur == 'W'
            dir = dir
            states[pos] = '#'
            count += 1
        elseif cur == 'F'
            dir = -dir
            pop!(states, pos)
        else
            dir *= -im
            states[pos] = 'W'
        end
        pos += dir

        # show_complex(states, pos)
    end

    count
end

function main()
    input = split(chomp("""
..#
#..
...
"""), "\n")
    input = readlines()
    if get(ARGS, 1, 1) == 1
        println(spread_virus(input, 10000))
    else
        println(complex_virus(input, 10000000))
    end
end

main()
