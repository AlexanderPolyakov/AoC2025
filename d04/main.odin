package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"
import "core:strconv"
import "core:math"

tenpow :: proc(pow: int) -> i64 {
    result : i64 = 1
    for i in 0..<pow {
        result *= 10
    }
    return result
}

check_nei :: proc(grid : []string, i, j : int) -> int {
    if i < 0 || j < 0 || i >= len(grid) || j >= len(grid[i]) {
        return 0
    }
    return 1 if grid[i][j] == '@' else 0
}

solve1 :: proc(filename: string) {
    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.println("Cannot open the file!")
        return
    }
    defer delete(data, context.allocator)

    sum : int = 0

    rows, _ := strings.split(string(data), "\n")
    rows = rows[:len(rows)-1]
    for i in 0..<len(rows) {
        for j in 0..<len(rows[i]) {
            if rows[i][j] != '@' {
                continue
            }
            cnt := check_nei(rows, i-1, j-1)
            cnt += check_nei(rows, i-1, j)
            cnt += check_nei(rows, i-1, j+1)

            cnt += check_nei(rows, i, j-1)
            cnt += check_nei(rows, i, j+1)

            cnt += check_nei(rows, i+1, j-1)
            cnt += check_nei(rows, i+1, j)
            cnt += check_nei(rows, i+1, j+1)
            if cnt < 4 {
                sum += 1
            }
        }
    }
    fmt.println("sum:", sum)
}

check_nei_runes :: proc(grid : [dynamic][]rune, i, j : int) -> int {
    if i < 0 || j < 0 || i >= len(grid) || j >= len(grid[i]) {
        return 0
    }
    return 1 if grid[i][j] == '@' else 0
}


vec2 :: struct {
    x: int,
    y: int
}

solve2 :: proc(filename: string) {
    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.println("Cannot open the file!")
        return
    }
    defer delete(data, context.allocator)
    sum : int = 0

    rows, _ := strings.split(string(data), "\n")
    rows = rows[:len(rows)-1]
    grid : [dynamic][]rune
    for row in rows {
        append(&grid, utf8.string_to_runes(row))
    }
    for {
        toremove : [dynamic]vec2
        for i in 0..<len(grid) {
            for j in 0..<len(grid[i]) {
                if grid[i][j] != '@' {
                    continue
                }
                cnt := check_nei_runes(grid, i-1, j-1)
                cnt += check_nei_runes(grid, i-1, j)
                cnt += check_nei_runes(grid, i-1, j+1)

                cnt += check_nei_runes(grid, i, j-1)
                cnt += check_nei_runes(grid, i, j+1)

                cnt += check_nei_runes(grid, i+1, j-1)
                cnt += check_nei_runes(grid, i+1, j)
                cnt += check_nei_runes(grid, i+1, j+1)
                if cnt < 4 {
                    append(&toremove, vec2{i, j})
                }
            }
        }
        for c in toremove {
            grid[c.x][c.y] = '.'
            sum += 1
        }
        if len(toremove) == 0 {
            break
        }
    }
    fmt.println("sum:", sum)
}


main :: proc() {
    solve1("input")
    solve2("input")
}
