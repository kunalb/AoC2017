include("day10.jl")

function defrag(input)
    counter = Dict()
    for i in UInt8(0):UInt8(15)
        bits = 0
        j = i
        while j > 0
            bits += j & 1 > 0 ? 1 : 0
            j = j >> 1
        end 
        counter[string(i, base=16)] = bits
    end 

    used = 0
    for i in 0:127
        row = knot_hash(collect(string(input, "-", i)))
        used += sum(map(x -> counter[string(x)], collect(row)))
    end 
    used
end 

function regions(input)
    grid = Dict()
    for i in 0:127
        row = knot_hash(string(input, "-", i))
        j = 0
        for ch in row 
            index = 8
            for k in 1:4
                grid[(i, j)] = parse(Int8, ch, base=16) & index > 0 ? 1 : 0
                j += 1
                index >>= 1
            end
        end 
    end 

    groups = 0

    for i in 0:127
        for j in 0:127 
            if grid[(i, j)] != 1
                continue
            end

            groups += 1
            q = [(i, j)]
            while !isempty(q)
                cur = popfirst!(q)
                if get(grid, cur, -1) != 1
                    continue
                end

                grid[cur] = 2
                for a in [-1, 1]
                    push!(q, (cur[1], cur[2] + a))
                    push!(q, (cur[1] + a, cur[2]))
                end
            end
        end 
    end 

    groups
end 

function main()
    input = readline()
    if get(ARGS, 1, 1) == 1
        print(defrag(input))
    else    
        print(regions(input))
    end 
end

main()