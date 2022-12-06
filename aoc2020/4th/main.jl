selfdir = joinpath(splitdir(@__FILE__)[1], "input")
required_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
optional_fields = ["cid"]

#--------part1

function valid_documents()
    valid = 0
    Document = Dict()
    for (idx, line) in enumerate(eachline(selfdir))
        if (line == "")
            valid += required_fields ⊆ keys(Document)
            Document = Dict()
        else
            line != ""
            [foreach(x -> (Document[x[1]] = x[2]), [split(i, ':')]) for i in split(line)]
        end
    end
    if ~isempty(Document)
        valid += required_fields ⊆ keys(Document)
    end
    return valid
end

function valid_documents_pipe()
    selfdir = joinpath(splitdir(@__FILE__)[1], "input")
    required_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    optional_fields = ["cid"]
    a =
        read(selfdir, String) |>
        x -> split(x, "\n\n") .|> 
        x -> split(x) .|> 
        x -> split(x, ':')

    b = 
        a .|> 
        Dict |> 
        x -> mapreduce(y -> required_fields ⊆ keys(y), +, x)

    return b
end

#---------part2

function check_fields(Document)
    checks = 0
    if required_fields ⊆ keys(Document)
        checks += 1920 <= parse(Int, Document["byr"]) <= 2002
        checks += 2010 <= parse(Int, Document["iyr"]) <= 2020
        checks += 2020 <= parse(Int, Document["eyr"]) <= 2030
        checks += if endswith(Document["hgt"], "cm")
            150 <= parse(Int, Document["hgt"][1:(end - 2)]) <= 193
        elseif endswith(Document["hgt"], "in")
            59 <= parse(Int, Document["hgt"][1:(end - 2)]) <= 76
        else
            false
        end
        checks += ~isnothing(match(r"#[0-9a-f]{6}"i, Document["hcl"]))
        checks += Document["ecl"] ∈ ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
        checks += ~isnothing((match(r"^[0-9]{9}$", Document["pid"])))
    end
    return checks == 7
end

function valid_documents2()

    valid = 0
    Document = Dict()
    for (idx, line) in enumerate(eachline(selfdir))
        if (line != "")
            [foreach(x -> (Document[x[1]] = x[2]), [split(i, ':')]) for i in split(line)]
        else
            valid += check_fields(Document)
            Document = Dict()
        end
    end
    if ~isempty(Document)
        valid += check_fields(Document)
    end
    return valid
end


function valid_documents_pipe2()
    selfdir = selfdir = joinpath(splitdir(@__FILE__)[1], "input")
    required_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    optional_fields = ["cid"]
    a =
        read(selfdir, String) |>
        x -> split(x, "\n\n") .|> 
        x -> split(x) .|> 
        x -> split(x, ':')

    b = 
        a .|> 
        Dict |> 
        x -> mapreduce(y -> check_fields(y), +, x)

    return b
end

#--------evaluation

valid2 = @btime valid_documents()
valid1 = @btime valid_documents_pipe()

valid3 = @btime valid_documents2()
valid4 = @btime valid_documents_pipe2()
