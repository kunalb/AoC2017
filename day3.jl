function spiral(limit)
    pos = 0
    i = 1
    dir = 1
    arm_length = 1

    while true
        for _ in 1:2
            for _ in 1:arm_length
                if i == limit
                    @goto solved
                end

                pos += dir
                i += 1
            end
            dir *= 1im
        end
        arm_length += 1
    end

    @label solved
    abs(real(pos)) + abs(imag(pos))
end

function spiral2(limit)
    grid = Dict{Complex{Int64}, Int64}(0 => 1)

    pos = 0
    i = 1
    dir = 1
    arm_length = 1

    while true
        for _a in 1:2
            for _b in 1:arm_length
                if pos != 0
                    sum = 0
                    for s_dir in [1, 1 + im]
                        for _c in 1:4
                            sum += get(grid, pos + s_dir, 0)
                            s_dir *= 1im
                        end
                    end
                    grid[pos] = sum
                end

                if grid[pos] > limit
                    return grid[pos]
                end

                pos += dir
                i += 1
            end
            dir *= 1im
        end
        arm_length += 1
    end
end


limit = parse(Int64, chomp(readline()))
println(get(ARGS, 1, 1) == 1 ? spiral(limit) : spiral2(limit))
