using BenchmarkTools
using DataStructures

selfdir = joinpath(splitdir(@__FILE__)[1], "input")

data = parse.(Int, readlines(selfdir))
inputs=sort(vcat(data, 0, maximum(data)+3))

mini_test = parse.(Int, split("16\n10\n15\n5\n1\n11\n7\n19\n6\n12\n4\n"))
test_adapters = "28\n33\n18\n42\n31\n14\n46\n20\n48\n47\n24\n23\n49\n45\n19\n38\n39\n11\n1\n32\n25\n35\n8\n17\n7\n9\n4\n2\n34\n10\n3\n"
test_adapters = parse.(Int, split(test_adapters))


#---------part1

function diffs(adapters)
    diffs = diff(adapters)
    count_diff = counter(diffs)
    return count_diff, count_diff[1] * count_diff[3]
end

#--------part2


function count_combinations(data)
    diffs = diff(data)
    cntr = 0
    groups = []
    for i in diffs
        if i == 1
            cntr += 1
        else
            if cntr < 2
                cntr = 0
                continue
            end
            push!(groups, cntr)
            cntr = 0
        end
    end
    cntr = 1
    for k in groups
        cntr *= binomial(k, 2) + 1
    end
    return cntr
end


function dynamic_tribonacci(data)
    ad = Dict()
    ad[0] = 1
    for i in data
        ad[i] = get(ad, i-1, 0) + get(ad, i-2, 0) + get(ad, i-3, 0)
    end 
    return ad
end

memo = Dict()
function recursion_way(n)
    n ∉ inputs       ? 0 :
    n == inputs[begin] ? 1 :
    get!(() -> sum(recursion_way, n-3:n-1), memo, n)
end

#--------evaluation

part1 = @time diffs(inputs)
println(part1)
part2 = @time count_combinations(inputs)
println(part2)
part2_another = @time dynamic_tribonacci(inputs[2:end])[inputs[end]]
println(part2_another)
@time recursion_way(last(inputs))




