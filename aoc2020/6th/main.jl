using DataStructures
using BenchmarkTools

selfdir = joinpath(splitdir(@__FILE__)[1], "input")

data =
read(selfdir, String) |>
x -> split(x, "\n\n") .|> 
x -> split(x) 

#--------part1

function anyone_yes()
    sum(map(x->length(x), map(unique, (map(x-> reduce(*, x), data)))))
end

function anyone_yes_sets()
    sum(data .|> x -> union(x...) |> length)
end

#--------part2

function all_yes()

    data .|> 
    (
        x -> (reduce(*, x), length(x)) |> 
        x -> (counter(x[1]), x[2]) |> 
        x -> (values(x[1]), x[2]) |> 
        x -> count(==(x[2]), x[1])
        ) |> 
        sum
        
    end
    
function all_yes_sets()
    sum(data .|> x -> intersect(x...) |> length)
end

#--------evaluation

println("first impl")
anyone_yes_count = @btime anyone_yes()
all_yes_count = @btime all_yes()

println("check sets union")
@btime anyone_yes_sets()

println("check sets intersect")
@btime all_yes_sets()

println(anyone_yes_count)
println(all_yes_count)