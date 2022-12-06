using BenchmarkTools

selfdir = joinpath(splitdir(@__FILE__)[1], "input")

data = parse.(Int, readlines(selfdir))

#--------part1

function check(preambula, number)
    for i in 1:25
        for j in (i+1):25
            if preambula[i] + preambula[j] == number
                return true
            end
        end
    end
    return false
end

function get_number()
    preambula = []
    is_valid = true
    for (ind, number) in enumerate(data)
        if (length(preambula) < 25)
            push!(preambula, number)
        else
            if !check(preambula, number)
                return ind, number
            else
                popfirst!(preambula)
                push!(preambula, number)
            end
        end
    end
end

#--------part2

function get_weakness_number(ind)
    for i in 1:ind
        vv = data[i]
        for j in (1+i):ind
            vv += data[j]
            if vv == data[ind]
                min, max = minimum(data[i:j]), maximum(data[i:j])
                return i, j, min, max, min+max
            elseif vv > data[ind]
                break
            else
                continue
            end
        end
    end
end


continious_set = []
for number in data[1:549]
    _sum = reduce(+, continious_set, init=0)
    if _sum == data[549]
        return continious_set, min(continious_set) + max(continious_set)
    elseif _sum < data[549] 
        push!(continious_set, number)
        # println("$_sum fewer $(data[549])")
    else
        while _sum >= data[549]
            # println("$_sum bigger $(data[549])")
            popfirst!(continious_set)
            _sum = reduce(+, continious_set, init=0)
            if _sum == data[549]
                return continious_set, min(continious_set) + max(continious_set)
            end
        end
    end
    return "pidor"
end


#--------evaluation

part1 = @btime get_number()
part2 = @btime get_weakness_number(part1[1])
