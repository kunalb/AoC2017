const START = permutedims(reshape(filter(x -> x != "\n", split("""
.#.
..#
###""", "")), 3, 3))

function rotate_once(pattern)
    pieces = collect(split(pattern, "/"))
    new_grid = split(pattern, "/") .|> collect

    for i in 1:length(pieces)
        for r in 1:length(pieces[1])
            pos = (r - 1) + (i - 1) * im
            rpos = im * pos + (length(pieces) - 1)
            # println(pos, " = ", rpos)

            new_r = real(rpos) + 1
            new_i = imag(rpos) + 1
            # println(r, ", ", i, " = ", new_r, ", ", new_i)
            new_grid[new_i][new_r] = pieces[i][r]
        end
    end

    join(map(x -> join(x), new_grid), "/")
end

function print_grid(grid)
    for y in 1:size(grid, 2)
        for x in 1:size(grid, 1)
            print(grid[y, x])
        end
        println()
    end
end


function fractal(input, iterations=5)
    rules = Dict()
    for rule in input
        pattern, replacement = split(rule, " => ")

        for _ in 1:4
            rules[pattern] = replacement
            pattern = rotate_once(pattern)
        end

        pattern = join(map(reverse, split(pattern, "/")), "/")
        for _ in 1:4
            rules[pattern] = replacement
            pattern = rotate_once(pattern)
        end
    end

    grid = copy(START)
    # print_grid(grid)

    for iter in 1:iterations
        sz = length(grid) % 2 == 0 ? 2 : 3
        pieces = size(grid, 1) ÷ sz
        next_sz = (sz + 1)
        next_side = (next_sz) * pieces
        next_grid = fill(' ', (next_side, next_side))

        for i in 1:pieces
            for j in 1:pieces
                key = ""
                for i1 in 1:sz
                    for j1 in 1:sz
                        x = (i - 1) * sz + i1
                        y = (j - 1) * sz + j1
                        key = string(key, grid[x, y])
                    end

                    if i1 != sz
                        key = string(key, "/")
                    end
                end

                replacement = rules[key]
                k = 1
                for i1 in 1:(sz + 1)
                    for j1 in 1:(sz + 1)
                        x = (i - 1) * next_sz + i1
                        y = (j - 1) * next_sz + j1
                        next_grid[x, y] = replacement[k]
                        k += 1
                    end
                    k += 1
                end
            end
        end

        grid = next_grid
        # print_grid(grid)
    end

    sum([1 for x in grid if x == '#'])
end

function main()
    input = split(chomp("""
../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#
"""), "\n")
    count = 2

    input = readlines()
    count = get(ARGS, 1, 1) == 1 ? 5 : 18
    println(fractal(input, count))
end

main()
