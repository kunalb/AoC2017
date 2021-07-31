function inner_hash(lengths, sz=256, rounds=1)
    # Start at 0, skip sz at 0
    # Reverse the order of length elements
    # Move the current position forward by length + skip sz
    # Increase skip sz by 1

    pos = 1
    skip = 0
    nums = collect(0:sz-1)

    for _ in 1:rounds 
        for l in lengths
            for k in 0 : (l ÷ 2 - 1)  
                swap = (pos + l - k - 2) % sz + 1
                cur = (pos + k - 1) % sz + 1

                tmp = nums[cur]
                nums[cur] = nums[swap]
                nums[swap] = tmp
            end

            pos = (pos + skip + l - 1) % sz + 1
            skip += 1
        end
    end

    nums
end 

function knot_hash(input)
    bytes = map(x -> convert(UInt8, x), collect(input))
    append!(bytes, [17, 31, 73, 47, 23])
    hash = inner_hash(bytes, 256, 64)
    dense = Vector(undef, 16)
    for i in 1:16
        dense[i] = hash[(i - 1) * 16 + 1]
        for j in 2:16
            dense[i] ⊻= hash[(i - 1) * 16 + j]
        end
    end 

    join(map(x -> lpad(string(x, base=16), 2, "0"), dense))
end 

function main()
    if get(ARGS, 1, 1) == 1
        inputs = map(x -> parse(Int32, x), split(chomp(readline()), ","))
        nums = inner_hash(inputs, 256)
        println(nums[1] * nums[2])
    else
        chars = chomp(readline())
        # chars = collect("AoC 2017")
        println(knot_hash(chars))
    end  
end 

if abspath(PROGRAM_FILE) == @__FILE__()
    main()
end 

# Other people's solutions:
# - should use mod1
# - Int(ch) also works
# - vcat to extend along a dimension
# - bytes2hex, TSIA