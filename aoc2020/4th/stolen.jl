function part2(data)
    fields = Dict(
        "byr" => x-> (n = tryparse(Int, x); !isnothing(n) && 1920<=n<=2002),
        "iyr" => x-> (n = tryparse(Int, x); !isnothing(n) && 2010<=n<=2020),
        "eyr" => x-> (n = tryparse(Int, x); !isnothing(n) && 2020<=n<=2030),
        "hgt" => x->
        if endswith(x, "cm")
            height = parse(Int, replace(x, "cm"=>""))
            150 <= height <= 193
        elseif endswith(x, "in")
            height = parse(Int, replace(x, "in"=>""))
            59 <= height <= 76
        else
            false
        end,
        "hcl" => x->!isnothing(match(r"^#[0-9a-f]{6}$"i, x)),
        "ecl" => x->x ∈ ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"],
        "pid" => x->!isnothing(match(r"^\d{9}$", x)),
    )
    (data .|> x->all([cond(get(x, key, "")) for (key, cond) in fields])) |> sum
end

part2(b)
