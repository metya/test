using BenchmarkTools
using DataStructures

selfdir = joinpath(splitdir(@__FILE__)[1], "input")

data = readlines(selfdir)

test_instr = split(
"""
F10
N3
F7
R90
F11
""")

a = collect(zip(first.(test_instr), parse.(Int, [i[2:end] for i in test_instr])))
instr = collect(zip(first.(data), parse.(Int, [i[2:end] for i in data])))

#--------part1

function get_man(instr)
    sides = ['E', 'S', 'W', 'N']
    s = 1
    direc = DefaultDict(0)
    for (dir, dis) in instr
        if dir == 'F' 
            direc[sides[s]] += dis
        elseif dir == 'R'
            s += Int(dis/90)
            s = s > 4 ? s % 4 : s
        elseif dir == 'L'
            s -= Int(dis/90)
            s = s < 1 ? 4 + s : s
        else 
            direc[dir] += dis
        end
    end
    abs(direc['E']-direc['W']) + abs(direc['N']-direc['S'])
end

#--------part2

sides = ['E', 'S', 'W', 'N']
s = 1
waypoint = DefaultDict(0)
ship = DefaultDict(0)
waypoint['E'] = 10
waypoint['N'] = 1



get_man(instr)