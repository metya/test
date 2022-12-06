using BenchmarkTools

selfdir = joinpath(splitdir(@__FILE__)[1], "input")

data = readlines(selfdir)

function parse_line(line)
    main_bag, contains = split(line, " bags contain ")
    if contains == "no other bags."
        return (main_bag, ())
    else
        con = collect(match(r"^(\d+) ([a-z ]+) bags?\.?$", bag).captures for bag in split(contains, ", ")) .|>
                x -> (parse(Int, x[1]), x[2])
        return main_bag, con
    end 
end

#--------part1

function shiny_gold(bag, rules)
    if bag == "shiny gold"
        return true
    else
        return any(shiny_gold(name, rules) for (_, name) in rules[bag])
    end
end

function inside_shiny_gold(bag, rules)
    return 1 + reduce(+, (num * inside_shiny_gold(name, rules) for (num, name) in rules[bag]), init=0)
end

#---------part2

function contains_shiny_gold()
    data .|> parse_line |> Dict |> x -> [shiny_gold(name , x) for name in keys(x) if name != "shiny gold"] |> sum
end

function how_much_inside_shiny_gold()
    (data .|> parse_line |> Dict |> x -> inside_shiny_gold("shiny gold" , x)) - 1
end

#---------evaluation

part1 = @btime contains_shiny_gold()
part1 = @btime how_much_inside_shiny_gold()