function follow_diagram(diagram)
    # grid = Array{Char, 2}()
    function pt(pos)
        get(get(diagram, imag(pos), []), real(pos), ' ')
    end

    width = maximum(map(length, diagram))
    height = length(diagram)

    start_point = findall(x -> x == '|' || x == '+', diagram[1])[1]

    letters = []
    pos = start_point + im
    dir = im
    steps = 0

    while true 
        ch = pt(pos)
        # println(pos, "/", dir, " -> ", ch)
        if ch == '|' || ch == '-'
            pos += dir
        elseif ch == '+'
            if pt(pos + dir * im) != ' '
                dir = dir * im
            elseif pt(pos - dir * im) != ' '
                dir = dir * -im
            else
                throw("Unexpected place")
            end
            pos += dir
        elseif ch == ' '
            break
        else
            push!(letters, ch)
            pos += dir
        end

        steps += 1
    end

    join(letters), steps
end


function main()
    input=split(chomp("""
     |          
     |  +--+    
     A  |  C    
 F---|----E|--+ 
     |  |  |  D 
     +B-+  +--+ 
"""), "\n")
    input = readlines()
    results = follow_diagram(input)
    println(get(ARGS, 1, 1) == 1 ? results[1] : results[2])
end

main()