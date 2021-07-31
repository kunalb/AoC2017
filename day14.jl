include("day10.jl")

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

function defrag(input)
    used = 0
    for i in 0:127
        row = knot_hash(collect(string(input, "-", i)))
        used += sum(map(x -> counter[string(x)], collect(row)))
    end 
    used
end 

function main()
    print(defrag(readline()))
end

main()