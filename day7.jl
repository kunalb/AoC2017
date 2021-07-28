function root(lines)
    seen = Set()
    leaves = Set()

    for line in lines
        pieces = split(line)
        push!(seen, pieces[1])
        for piece in pieces[4:end]
            push!(leaves, strip(piece, [',']))
        end
    end
    first(setdiff(seen, leaves))
end

# Really, really hacky code
function adjust_tree(tree, node)
    if length(tree[node][2]) == 0
        return (tree[node][1], tree[node][1], nothing) # my value, total value
    end

    vals = map(x -> adjust_tree(tree, x), tree[node][2])
    seen = Dict()
    for val in vals
        if !isnothing(val[3])
            return (0, 0, val[3])
        end

        if haskey(seen, val[2])
            seen[val[2]] += 1
        else
            seen[val[2]] = 1
        end
    end

    ks = collect(keys(seen))
    for (val, count) in seen
        if count == 1
            for v in vals
                if v[2] == val
                    return (0, 0, v[1] - abs(ks[1] - ks[2]))
                end
            end
        end
    end

    s = sum(map(x -> x[2], vals)) + tree[node][1]
    return (tree[node][1], s, nothing)
end

function make_tree(lines)
    r = root(lines)
    tree = Dict()
    for line in lines
        pieces = split(line)
        tree[pieces[1]] = (parse(Int64, strip(pieces[2], ['(', ')'])),
                           map(x -> strip(x, [',']), pieces[4:end]))
    end

    adjust_tree(tree, r)[3]
end


function main(input)
    # println(root(input))
    println(make_tree(input))
end

altinput = """
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
"""

# main(split(chomp(altinput), "\n", keepempty=false))
main(readlines())
