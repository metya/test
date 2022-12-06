input = readlines(joinpath(splitdir(@__FILE__)[1], "input"))

ids = input .|> x -> foldl(replace, ["F"=>"0", "B"=>"1", "L"=>"0", "R"=>"1"], init=x) |> x-> parse(Int, x, base=2)

function max_id()
    maximum(ids)
end

function what_seat()
    setdiff(minimum(ids):maximum(ids), ids)[1]
end

println("max id: $(@btime max_id())")
println("what seat: $(@btime what_seat())")