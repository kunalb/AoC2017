function checksum1(numbers)
    maximum(numbers) - minimum(numbers)
end

function checksum2(numbers)
    sort(numbers)
    l = length(numbers)
    for i in 1:l
        for j in 1:l
            if i != j && numbers[j] % numbers[i] == 0
                return numbers[j] ÷ numbers[i]
            end
        end
    end
end

function main(f)
    sum = 0
    for line in readlines()
        line = chomp(line)
        numbers = map(x -> parse(Int64, x), split(line))
        sum += f(numbers)
    end

    sum
end

println(main(get(ARGS, 1, 1) == 1 ? checksum1 : checksum2))
