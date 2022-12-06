using BenchmarkTools

selfdir = joinpath(splitdir(@__FILE__)[1], "input")

data = (readlines(selfdir) .|> x -> split(x, " ") |> x -> [x[1], parse(Int, x[2])]) |> enumerate |> collect

#--------part1

function check_boot(data=data)
    ind = 1
    spent_ind = []
    accumulator = 0
    while !(ind in spent_ind) & (ind <= length(data))
        ind, (instruction, number) = data[ind]
        push!(spent_ind, ind)
        if instruction == "acc"
            accumulator += number
            ind += 1
        elseif instruction == "jmp"
            ind += number
        else
            ind += 1
        end
    end
    if ind == length(data) + 1
        return accumulator, true
    else
        return accumulator, false
    end
end

#--------part2

function fix(data=data)
    c_data = deepcopy(data)
    ind = 1
    while ind <= length(c_data)
        ind, (instr, number) = c_data[ind]
        if instr == "acc"
            ind += 1
            continue
        end
        c_data[ind][2][1] = instr == "jmp" ? "nop" : "jmp"
        accumulator, check = check_boot(c_data)
        if check
            return accumulator, ind
        else
            c_data[ind][2][1] = instr
            ind += 1
        end
    end
end

#---------evaluation

part1 = @btime check_boot()

part2 = @btime fix()
