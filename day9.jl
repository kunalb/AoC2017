
@enum State begin
    state_group
    state_garbage
    state_cancelled
end

function calculate_score(input)
    state = state_group
    score = 0
    open_groups = 0
    garbage = 0

    for ch in input
        state = if state == state_garbage
            if ch == '>'
                state_group
            elseif ch == '!'
                state_cancelled
            else
                garbage += 1
                state_garbage
            end 
        elseif state == state_cancelled
            state_garbage
        else  # state_group
            if ch == '{'
                open_groups += 1
                state_group
            elseif ch == '<'
                state_garbage
            elseif ch == '}'
                score += open_groups
                open_groups -= 1
                state_group
            end
        end
        # print(state, " ")
    end 
    # println()

    (score, garbage)
end 

function main()
    # sample_input = "{{<a!>},{<a!>},{<a!>},{<ab>}}"
    # println(score(sample_input))
    (score, garbage) = calculate_score(readline())
    println(get(ARGS, 1, 1) == 1 ? score : garbage)
end 

main()