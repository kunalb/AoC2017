function bridge2(components)
    plugs_list = []
    nodes_list = [[] for _ in 1:100]
    for component in components
        plugs = Tuple(map(x -> parse(Int64, x), split(component, "/")))
        push!(plugs_list, plugs)
        push!(nodes_list[plugs[1] + 1], (plugs[2], length(plugs_list)))
        push!(nodes_list[plugs[2] + 1], (plugs[1], length(plugs_list)))
    end

    used_list = [0 for _ in plugs_list]

    bridge2_helper(plugs_list, nodes_list, used_list, 0)
end

function bridge2_helper(plugs_list, nodes_list, used_list, root)
    if isempty(nodes_list[root + 1])
        return 0
    end

    max_strength = 0
    longest = 0
    longest_strength = 0

    for (next_root, plug) in nodes_list[root + 1]
        if used_list[plug] != 0
            continue
        end

        used_list[plug] = 1
        inner_problem = bridge2_helper(plugs_list, nodes_list, used_list, next_root)
        cur_strength = root + next_root + inner_problem[1]
        cur_length = 1 + inner_problem[2]
        cur_longest_strength = root + next_root + inner_problem[3]

        max_strength = max(max_strength, cur_strength)

        if longest < cur_length || (longest == cur_length && longest_strength < cur_longest_strength)
            longest = cur_length
            longest_strength = cur_longest_strength
        end

        used_list[plug] = 0
    end

    max_strength, longest, longest_strength
end

function main()
    input = split(chomp("""
0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10
"""), "\n")
    input = readlines()
    result = bridge2(input)
    println(result[get(ARGS, 1, 1) == 1 ? 1 : 3])
end

main()
