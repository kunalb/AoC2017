function eval(instructions, level=1)
    registers = Dict()
    max_overall = 0

    for inst in instructions
        pieces = split(inst)
        reg = pieces[1]
        action = pieces[2]
        num = parse(Int64, pieces[3])

        test_reg = pieces[5]
        comparison = pieces[6]
        test_num = parse(Int64, pieces[7])

        test_reg_val = get!(registers, test_reg, 0)
        test_result = if comparison == "=="
            test_reg_val == test_num
        elseif comparison == "<"
            test_reg_val < test_num
        elseif comparison == "<="
            test_reg_val <= test_num
        elseif comparison == ">"
            test_reg_val > test_num
        elseif comparison == ">="
            test_reg_val >= test_num
        elseif comparison == "!="
            test_reg_val != test_num
        else
            throw(InvalidStateException("Unexpected comparison " + comparison))
        end

        if test_result
            if action == "inc"
                registers[reg] = get(registers, reg, 0) + num
            elseif action == "dec"
                registers[reg] = get(registers, reg, 0) - num
            else
                throw(InvalidStateException("Unexpected action " + action))
            end 
        end 


        max_overall = max(maximum(values(registers)), max_overall)
    end 
    if level == 1
        maximum(values(registers))
    else    
        max_overall
    end 
end 

function main()
    instructions = readlines()
end 

test_input = """
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
"""

# println(eval(split(chomp(test_input), "\n", keepempty=false)))
println(eval(readlines(), get(ARGS, 1, 1)))