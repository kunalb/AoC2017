function parse_particle(input)
    pieces = map(x -> strip(split(x, "=")[2], ['<', '>', ' ']), split(input, ", "))
    p, v, a = map(x -> map(y -> parse(Int64, y), split(x, ",")), pieces)
end

function sort_particles(input)
    eqns = map(input) do particle
        (parse_particle(particle) .|> x -> map(abs, x) |> sum) |> reverse
    end |> enumerate |> collect
    sort(eqns, by=x -> x[2])[1][1] - 1
end

max_root = 0

function do_collide(p1, p2):: Bool
    debug = false

    debug && println("p1 ", p1, " | p2 ", p2)

    solutions = Set()
    overlap = 0
    for dim in 1:3
        # u0 + (u + a/2)t + (a/2)t^2
        # ax^2 + bx + c = 0
        a = .5(p1[3][dim] - p2[3][dim])
        b = p1[2][dim] - p2[2][dim] + a
        c = p1[1][dim] - p2[1][dim]

        if a == 0 && b == 0 && c == 0
            overlap += 1
            debug && println("Overlap on dim ", dim)
            continue
        end

        if a == 0 && b != 0
            sol = -c/b
            debug && println("Linear soln ", sol ," on dim ", dim)
            if isinteger(sol)
                debug && println("Is integer")
                push!(solutions, -c/b)
                continue
            else
                debug && println("Is not integer")
                return false
            end
        end

        d = b^2 - 4*a*c
        if d < 0
            debug && println("No real roots on dim ", dim)
            return false
        end

        ts = [(-b + sqrt(d)) / (2 * a), (-b - sqrt(d) / (2 * a))]
        global max_root
        if !isempty(ts) && max_root < maximum(ts)
            max_root = maximum(ts)
        end

        debug && println("Found roots on dim ", dim, " ", ts)            
        ts = filter(x -> x >= 0 && isinteger(x), ts)
        debug && println("Remaining roots: ", ts)
        if length(ts) == 0
            return false
        end

        union!(solutions, ts)
    end
    debug && println("Solutions: ", solutions)
    debug && println("Overlap: ", overlap)
    debug && println()

    return length(solutions) == 1 || overlap == 3
end

function pos(p, t)
    res = Vector(undef, 3)
    for i in 1:3
        res[i] = p[1][i] + (p[2][i] + p[3][i]/2) * t + (p[3][i]/2) * t * t
    end
    res
end

function remove_collisions(input)::UInt64
    particles = (input .|> parse_particle) |> enumerate |> collect
    collided = Set()
    for (i, p1) in particles
        for (j, p2) in particles
            if i != j 
                do_collide(p1, p2)
            end
        end
    end
    # println("Max ", max_root)

    pset = Set()
    union!(pset, particles)
    for tick in 1:(max_root + 20)
        positions = Dict()
        for p in pset
            p_pos = pos(p[2], tick)
            push!(get!(positions, p_pos, Vector()), p)
        end

        for (p_pos, parts) in positions
            if length(parts) > 1
                for part in parts
                    pop!(pset, part)
                end
            end
        end
    end

    return length(pset)
end

function main()
    if get(ARGS, 1, 1) == 1
        input = split(chomp("""
p=<     3,0,0>, v=< 2,0,0>, a=<-1,0,0>
p=<     4,0,0>, v=< 0,0,0>, a=<-2,0,0>
""")    , "\n")
        input = readlines()
        println(sort_particles(input))
    end
        input = split(chomp("""
p=<-6,0,0>, v=< 3,0,0>, a=<0,0,0>
p=<-4,0,0>, v=< 2,0,0>, a=<0,0,0>
p=<-2,0,0>, v=< 1,0,0>, a=<0,0,0> 
p=< 3,0,0>, v=<-1,0,0>, a=<0,0,0>
"""), "\n")
        input = readlines()
        println(remove_collisions(input))
end

main()