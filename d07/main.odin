package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"
import "core:strconv"
import "core:math"
import "core:slice"

solve1 :: proc(filename: string) {
    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.println("Cannot open the file!")
        return
    }
    defer delete(data, context.allocator)

    rows, _ := strings.split(string(data), "\n")
    runes : [dynamic][]rune
    for row in rows {
        append(&runes, utf8.string_to_runes(row))
    }

    sum : int = 0
    for y in 1..<len(runes) {
        row := runes[y]
        for r, x in row {
            prev := runes[y-1][x]
            if prev == 'S' {
                runes[y][x] = '|'
            }
            else if r == '.' {
                if prev == '|' {
                    runes[y][x] = '|'
                }
            }
            else if r == '^' && prev == '|' {
                sum += 1
                if x > 0 {
                    runes[y][x-1] = '|'
                }
                if x < len(row) - 1 {
                    runes[y][x+1] = '|'
                }
            }
        }
    }

    fmt.println("sum:", sum)
}

solve2 :: proc(filename: string) {
    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.println("Cannot open the file!")
        return
    }
    defer delete(data, context.allocator)

    rows, _ := strings.split(string(data), "\n")
    rows = rows[:len(rows)-1]
    grid : [dynamic][]int
    for row in rows {
        gridRow : [dynamic]int
        for r in row {
            append(&gridRow, 1 if r == 'S' else 0)
        }
        append(&grid, gridRow[:])
    }

    sum : int = 0
    for y in 1..<len(rows) {
        row := rows[y]
        for r, x in row {
            prev := grid[y-1][x]
            if prev == 0 {
                continue
            }
            switch r {
            case '.':
                grid[y][x] += prev
            case '^':
                if x > 0 {
                    grid[y][x-1] += prev
                }
                if x < len(row) - 1 {
                    grid[y][x+1] += prev
                }
            }
        }
    }
    for r in grid[len(grid)-2] {
        sum += r
    }

    fmt.println("sum:", sum)
}


main :: proc() {
    solve1("input")
    solve2("input")
}
