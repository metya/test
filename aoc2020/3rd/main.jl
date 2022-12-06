forest_slope_array = open(joinpath(@__DIR__, "input")) |> readlines

function encounter_trees_array(down, step)
    trees = 0
    position = 1
    len = length(forest_slope_array[1])
    for line in forest_slope_array[1:down:end]
        trees += line[position] == '#' ? 1 : 0
        position += step
        position = position > len ? position % len : position
    end
    trees
end

println(encounter_trees_array(1, 3))

product_trees =
    encounter_trees_array(1, 1) *
    encounter_trees_array(1, 3) *
    encounter_trees_array(1, 5) *
    encounter_trees_array(1, 7) *
    encounter_trees_array(2, 1)

println(product_trees)