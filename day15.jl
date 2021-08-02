function generatorA(prev)
    (16807 * prev) % 2147483647
end 

function generatorB(prev)
    (48271 * prev) % 2147483647
end 

function count_matches(inputs, iterations)
    mask = 2^16 - 1
    vals = inputs
    total = 0
    for _ in 1:iterations 
        next_vals = (generatorA(vals[1]), generatorB(vals[2]))
        if (mask & next_vals[1]) == (mask & next_vals[2])
            total += 1
        end
        vals = next_vals
    end 
    total
end 

function count_matches2(inputs, iterations)
    mask = 2^16 - 1
    valA = inputs[1]
    valB = inputs[2]
    total = 0
    for _ in 1:iterations 
        while true
            valA = generatorA(valA)
            if valA % 4 == 0
                break
            end
        end
        
        while true
            valB = generatorB(valB)
            if valB % 8 == 0
                break
            end
        end

        if (mask & valA) == (mask & valB)
            total += 1
        end
    end 
    total
end 

function extract_number(s)
    parse(Int64, match(r"\d+", s).match)
end 

function main() 
    inputs = collect(map(extract_number, readlines()))
    if get(ARGS, 1, 1) == 1 
        println(count_matches(inputs, 40_000_000))
    else
        println(count_matches2(inputs, 5_000_000))
    end
end

main()