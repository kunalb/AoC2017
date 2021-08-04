mutable struct Node
    val::Int32
    next::Union{Nothing, Node}

    Node() = new(0, nothing)
end


function fill_buffer(step_size, step_count=2017, end_value=2017)
    cur = Node()
    cur.val = 0
    cur.next = cur

    for i in 1:step_count
        for j in 1:step_size
            cur = cur.next
        end

        new_val = Node()
        new_val.val = i
        new_val.next = cur.next
        cur.next = new_val
        cur = new_val
    end

    while true
        if cur.val == end_value
            return cur.next.val
        else
            cur = cur.next
        end
    end
end 

function fill_buffer_fast(step_size, step_count=2017, end_value=2017)
    buffer = Vector{Int64}(undef, step_count + 1)
    buffer[1] = 0
    cur = 0

    for i in 1:step_count
        for j in 1:step_size
            cur = buffer[cur + 1]
        end

        buffer[i + 1] = buffer[cur + 1]
        buffer[cur + 1] = i
        cur = i
    end

    buffer[end_value + 1]
end

function main() 
    if get(ARGS, 1, 1) == 1
        println(fill_buffer_fast(parse(Int32, readline()), 2017, 2017))
    else    
        if get(ARGS, 2, "fast") == "fast"
            println(fill_buffer_fast(parse(Int32, readline()), 50_000_000, 0))
        else
            println(fill_buffer(parse(Int32, readline()), 50_000_000, 0))
        end
    end
end

main()
