function bridge(components)
    nodes = Dict{Int64, Set{Tuple{Int64, Int64}}}()
    for component in components
        plugs = Tuple(map(x -> parse(Int64, x), split(component, "/")))
        push!(get!(nodes, plugs[1], Set()), plugs)
        push!(get!(nodes, plugs[2], Set()), plugs)
    end

    bridge_helper(0, nodes)
end

function bridge_helper(root::Int64, nodes::Dict{Int64, Set{Tuple{Int64, Int64}}}) :: Int64
    if !haskey(nodes, root) || isempty(nodes[root])
        return 0
    end

    soln = nothing

    for choices in nodes[root]
        other = choices[1] == root ? choices[2] : choices[1]
        remaining_nodes = copy(nodes)
        delete!(remaining_nodes[other], choices)
        cur = root + other + bridge_helper(other, remaining_nodes)
        if isnothing(soln) || soln < cur
            soln = cur
        end
    end

    soln
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
    # input = readlines()
    println(bridge(input)[1])
end

main()
