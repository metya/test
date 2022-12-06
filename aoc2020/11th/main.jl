using BenchmarkTools
using DataStructures

selfdir = joinpath(splitdir(@__FILE__)[1], "input")

data = readlines(selfdir)

test_data = split(
"""
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
""")

#--------part1

function conv2d(input, filter, padding="valid")
    input_r, input_c = size(input)
    filter_r, filter_c = size(filter)

    if padding == "same"
        pad_r = (filter_r - 1) ÷ 2 # Integer division.
        pad_c = (filter_c - 1) ÷ 2 # Needed because of Type-stability feature of Julia

        input_padded = zeros(input_r+(2*pad_r), input_c+(2*pad_c))
        for i in 1:input_r, j in 1:input_c
            input_padded[i+pad_r, j+pad_c] = input[i, j]
        end
        input = input_padded
        input_r, input_c = size(input)
    elseif padding == "valid"
        # We don't need to do anything here
    else 
        throw(DomainError(padding, "Invalid padding value"))
    end

    result = zeros(input_r-filter_r+1, input_c-filter_c+1)
    result_r, result_c = size(result)

    for i in 1:result_r
        for j in 1:result_c
            for k in 1:filter_r 
                for l in 1:filter_c 
                    result[i,j] += input[i+k-1,j+l-1]*filter[k,l]
                end
            end
        end
    end
    return result
end

function step(orig_seats)
    seats = deepcopy(orig_seats)
    conv_arr = replace(seats, 'L'=>0, '#'=>1, '.'=>0) |> 
                x-> conv2d(x, [[1,1,1] [1,0,1] [1,1,1]], "same")
    for i in 1:size(seats)[1], j in 1:size(seats)[2]
        if (conv_arr[i,j] > 3) & (seats[i,j] == '#')
            seats[i,j] = 'L'
        elseif (conv_arr[i,j] == 0) & (seats[i,j] == 'L')
            seats[i,j]='#'
        end
    end
    seats
end


#--------part2

function step2(orig_state)
    b = deepcopy(orig_state)
    bd = deepcopy(orig_state)
    for i in 1:size(bd, 1), j in 1:size(bd, 2)
        cntr = count_dir(bd, i, j)
        # cntr = count_seats_part2(b,i,j,'#')
        if bd[i,j] == '#' && cntr >= 5
            b[i,j] = 'L'
        elseif bd[i,j] == 'L' && cntr == 0
            b[i,j] = '#'
        end
    end
    b
end

function count_dir(seats, i, j)
    cntr = 0
    for Δx in (-1, 0, 1), Δy in (-1, 0, 1)
        (Δx == 0 && Δy == 0) && continue
        x, y = i, j
        while true
            x += Δx
            y += Δy
            !(x >= 1 && x <= size(seats, 1)) && break
            !(y >= 1 && y <= size(seats, 2)) && break
            if seats[x, y] == '#'
                cntr += 1
                break
            elseif seats[x, y] == '.'
                continue
            else
                break
            end
        end
    end
    return cntr
end

#--------evaluation

function modeling(data, step)
    data = replace(data, 'L'=>'#')
    state = reduce(vcat, permutedims.(collect.(data)))
    num_steps = 0
    new_state = step(state)
    while state != new_state
        state = new_state
        new_state = step(new_state)
        num_steps += 1
    end
    counter(new_state), num_steps
end


part1 = @btime modeling(data, step)
part2 = @btime modeling(data, step2)





