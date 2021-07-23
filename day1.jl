function main(input, distance=1)
    counter = 1
    sum = 0
    len = length(input)

    while counter <= len
        next = (counter - 1 + distance) % len + 1
        if input[counter] == input[next]
            sum += parse(Int64, input[counter])
        end
        counter += 1
    end

    sum
end

input = chomp(readline())
println(main(input, get(ARGS, 1, 1) == 1 ? 1 : length(input) ÷ 2))
