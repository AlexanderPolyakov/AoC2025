package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"
import "core:strconv"
import "core:math"
import "core:slice"

vec2 :: struct {
    x, y : i64
}

str_to_vec2 :: proc(str : string) -> vec2 {
    str_nums, _ := strings.split(str, ",")
    x, _ := strconv.parse_i64(str_nums[0])
    y, _ := strconv.parse_i64(str_nums[1])
    return vec2{x, y}
}

solve1 :: proc(filename: string) {
    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.println("Cannot open the file!")
        return
    }
    defer delete(data, context.allocator)

    vertices : [dynamic]vec2
    rows, _ := strings.split_lines(string(data))
    for row in rows {
        if len(row) == 0 {
            break
        }
        append(&vertices, str_to_vec2(row))
    }

    sum : i64 = 0
    for i in 0..<len(vertices) {
        for j in 0..<i {
            area := (abs(vertices[i].x - vertices[j].x) + 1) * (abs(vertices[i].y - vertices[j].y) + 1)
            if area > sum {
                sum = area
            }
        }
    }

    fmt.println("sum:", sum)
}

min :: proc(a, b: i64) -> i64 {
    return a if a < b else b
}

max :: proc(a, b: i64) -> i64 {
    return a if a > b else b
}


solve2 :: proc(filename: string) {
    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.println("Cannot open the file!")
        return
    }
    defer delete(data, context.allocator)

    vertices : [dynamic]vec2
    rows, _ := strings.split_lines(string(data))
    for row in rows {
        if len(row) == 0 {
            break
        }
        append(&vertices, str_to_vec2(row))
    }

    sum : i64 = 0
    for i in 0..<len(vertices) {
        for j in 0..<i {
            area := (abs(vertices[i].x - vertices[j].x) + 1) * (abs(vertices[i].y - vertices[j].y) + 1)
            if area <= sum {
                continue
            }
            // check for validity
            // check direction from i'th
            minVert := vec2{min(vertices[i].x, vertices[j].x), min(vertices[i].y, vertices[j].y)}
            maxVert := vec2{max(vertices[i].x, vertices[j].x), max(vertices[i].y, vertices[j].y)}
            invalid := false
            for k in 0..<len(vertices) {
                // check if any of the points inside the rectangle
                vert := vertices[k]
                inside := vert.x > minVert.x && vert.y > minVert.y && vert.x < maxVert.x && vert.y < maxVert.y
                if inside {
                    invalid = true
                    break
                }
                nextIdx := (k + 1) % len(vertices)
                prevIdx := (k - 1 + len(vertices)) % len(vertices)
                nextVert := vertices[nextIdx]
                prevVert := vertices[prevIdx]
                // Check if we transition from one side to another one
                if (vert.x <= minVert.x && (nextVert.x > minVert.x || prevVert.x > minVert.x) && vert.y > minVert.y && vert.y < maxVert.y) ||
                    (vert.x >= maxVert.x && (nextVert.x < maxVert.x || prevVert.x < maxVert.x) && vert.y > minVert.y && vert.y < maxVert.y) ||
                    (vert.y <= minVert.y && (nextVert.y > minVert.y || prevVert.y > minVert.y) && vert.x > minVert.x && vert.x < maxVert.x) ||
                    (vert.y >= maxVert.y && (nextVert.y < maxVert.y || prevVert.y < maxVert.y) && vert.x > minVert.x && vert.x < maxVert.x) {
                        invalid = true
                        break
                }
                if invalid do break
            }
            if invalid do continue
            sum = area
        }
    }

    fmt.println("sum:", sum)
}


main :: proc() {
    solve1("input")
    solve2("input")
}
