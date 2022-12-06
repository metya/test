using DelimitedFiles
selfdir = joinpath(@__DIR__, "input")
input = readdlm(selfdir)

amount =
    [map(x -> parse(Int, x), (x, y)) for (x, y) in [split(x, "-") for x in input[:, 1]]]

function valid_passwords()
    valid = 0
    for (amount, key, password) in zip(amount, first.(input[:, 2]), input[:, 3])
        count = sum([1 for x in password if x == key])
        if amount[1] <= count <= amount[2]
            valid += 1
        end
    end
    return valid
end

function valid_passwords2()
    valid = 0
    for (amount, key, password) in zip(amount, first.(input[:, 2]), input[:, 3])
        if (password[amount[1]] == key) ⊻ (password[amount[2]] == key)
            valid += 1
        end
    end
    return valid
end

valid = valid_passwords()
valid2 = valid_passwords2()