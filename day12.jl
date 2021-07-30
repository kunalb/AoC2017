function explore(input)
    graph = Dict()

    for line in input
        pieces = split(line, " <-> ")
        root = parse(Int32, pieces[1])
        connections = map(x -> parse(Int32, x), split(pieces[2], ", "))
        graph[root] = connections
    end 

    q = Vector([0])
    visited = Set()
    size = 0
    while !isempty(q)
        cur = popfirst!(q)
        if cur in visited
            continue
        end 

        push!(visited, cur)
        size += 1

        append!(q, graph[cur])
    end

    size
end

function count_groups(input)
    graph = Dict()

    for line in input
        pieces = split(line, " <-> ")
        root = parse(Int32, pieces[1])
        connections = map(x -> parse(Int32, x), split(pieces[2], ", "))
        graph[root] = connections
    end 

    groups = 0
    visited = Set()
    ks = collect(keys(graph))

    while length(visited) < length(graph)
        for key in ks
            if key in visited
                continue
            end

            groups += 1

            q = Vector([key])
            while !isempty(q)
                cur = popfirst!(q)
                if cur in visited
                    continue
                end 

                push!(visited, cur)
                append!(q, graph[cur])
            end
        end 
    end 

    groups
end

test_input = "0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5"

function main()
    # println(explore(split(test_input, "\n")))
    # input = split(test_input, "\n")
    input = readlines()
    if get(ARGS, 1, 1) == 1
        println(explore(input))
    else    
        println(count_groups(input))
    end 
end

main()