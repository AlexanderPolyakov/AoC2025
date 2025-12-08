package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"
import "core:strconv"
import "core:math"
import "core:slice"

vec3 :: struct {
    x, y, z : i64
}

dist_sq :: proc(a, b : vec3) -> i64 {
    dx := a.x - b.x
    dy := a.y - b.y
    dz := a.z - b.z
    return dx * dx + dy * dy + dz * dz
}

dist_idx :: struct {
    dist : i64,
    xmult : i64,
    i0 : int,
    i1 : int
}

sort_by_dist :: proc(lhs, rhs : dist_idx) -> bool {
    return lhs.dist < rhs.dist
}

str_to_vec :: proc(str : string) -> vec3 {
    str_nums, _ := strings.split(str, ",")
    x, _ := strconv.parse_i64(str_nums[0])
    y, _ := strconv.parse_i64(str_nums[1])
    z, _ := strconv.parse_i64(str_nums[2])
    return vec3{x, y, z}
}

solve1 :: proc(filename: string, numsteps : int) {
    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.println("Cannot open the file!")
        return
    }
    defer delete(data, context.allocator)

    vertices : [dynamic]vec3
    rows, _ := strings.split_lines(string(data))
    for row in rows {
        if len(row) == 0 {
            break
        }
        append(&vertices, str_to_vec(row))
    }

    distances : [dynamic]dist_idx
    for v0, i in vertices {
        for j in 0..<i {
            v1 := vertices[j]
            append(&distances, dist_idx{dist_sq(v0, v1), v0.x * v1.x, j, i})
        }
    }
    slice.sort_by(distances[:], sort_by_dist)

    circuits := make(map[int]int)
    defer delete(circuits)
    for i in 0..<len(vertices) {
        circuits[i] = i
    }
    for i in 0..<numsteps {
        elem := distances[0]
        ordered_remove(&distances, 0)
        connect_to := circuits[elem.i1]
        for key, val in circuits {
            if val == connect_to {
                circuits[key] = circuits[elem.i0]
            }
        }
    }
    unique_circuits := make(map[int]int)
    defer delete(unique_circuits)
    for key, val in circuits {
        if val in unique_circuits {
            unique_circuits[val] += 1
        }
        else {
            unique_circuits[val] = 1
        }
    }
    circuits_num : [dynamic]int
    for key, val in unique_circuits {
        append(&circuits_num, val)
    }
    slice.reverse_sort(circuits_num[:])
    sum := circuits_num[0] * circuits_num[1] * circuits_num[2]

    fmt.println("sum:", sum)
}

solve2 :: proc(filename: string) {
    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.println("Cannot open the file!")
        return
    }
    defer delete(data, context.allocator)

    sum : i64 = 0

    vertices : [dynamic]vec3
    rows, _ := strings.split_lines(string(data))
    for row in rows {
        if len(row) == 0 {
            break
        }
        append(&vertices, str_to_vec(row))
    }

    distances : [dynamic]dist_idx
    for v0, i in vertices {
        for j in 0..<i {
            v1 := vertices[j]
            append(&distances, dist_idx{dist_sq(v0, v1), v0.x * v1.x, j, i})
        }
    }
    slice.sort_by(distances[:], sort_by_dist)

    circuits := make(map[int]int)
    circuits_cnt := make(map[int]int)
    defer delete(circuits)
    defer delete(circuits_cnt)
    for i in 0..<len(vertices) {
        circuits[i] = i
        circuits_cnt[i] = 1
    }
    for {
        elem := distances[0]
        ordered_remove(&distances, 0)
        connect_to := circuits[elem.i1]
        for key, val in circuits {
            if val == connect_to && val != circuits[elem.i0] {
                circuits[key] = circuits[elem.i0]
                circuits_cnt[val] -= 1
                circuits_cnt[circuits[elem.i0]] += 1
            }
        }
        if circuits_cnt[circuits[elem.i0]] == len(circuits) {
            sum = elem.xmult
            break
        }
        
    }

    fmt.println("sum:", sum)
}


main :: proc() {
    solve1("input", 1000)
    solve2("input")
}
