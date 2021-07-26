function testphrase(input)
    words = split(chomp(input))
    unique = Set{String}(words)
    length(words) == length(unique) ? 1 : 0
end

function testphrase2(input)
    words = split(chomp(input))
    unique = Set{String}(map(x -> join(sort(split(x, ""))), words))
    length(words) == length(unique) ? 1 : 0
end

function main(lines, f)
    sum(map(f, lines))
end

println(main(readlines(), get(ARGS, 1, 1) == 1 ? testphrase : testphrase2))
