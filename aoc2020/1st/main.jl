using Combinatorics
using DelimitedFiles
using BenchmarkTools

#--------part1

function twosum(array)
    sort_a = sort(array[:, 1])
    for i in sort_a
        for j in sort_a
            if i + j == 2020
                return i * j
            end
        end
    end
end

function ocamlAnton(array)
    sort_a = sort(array[:, 1])
    i = 1
    j = length(sort_a) - 1
    while i < j
        _sum = sort_a[i] + sort_a[j]
        if _sum > 2020
            j = j - 1
        elseif _sum < 2020
            i = i + 1
        else
            return sort_a[i] * sort_a[j]
        end
    end
end

function twosumcomb(array)
    for pair in combinations(array, 2)
        if sum(pair) == 2020
            return prod(pair)
        end
    end
end

#--------part2

function threesum(array)
    sort_a = sort(array[:, 1])
    for i in sort_a
        for j in sort_a
            for a in sort_a
                if i + j + a == 2020
                    return i * j * a
                end
            end
        end
    end
end

function threesumcomb(array)
    for cort in combinations(array, 3)
        if sum(cort) == 2020
            return prod(cort)
        end
    end
end

#--------evaluation

selfdir = joinpath(@__DIR__, "input")
array = readdlm(selfdir, Int)

ocaml_result = @btime ocamlAnton(array)
println("ocaml_result = $ocaml_result")

twosum_result = @btime twosum(array)
println("twosum_result = $twosum_result")
twosumcomb_result = @btime twosumcomb(array)
println("twosumcomb_result = $twosumcomb_result")

threesum_result = @btime threesum(array)
println("threesum_result = $threesum_result")
threesumcomb_result = @btime threesumcomb(array)
println("threesumcomb_result = $threesumcomb_result")

