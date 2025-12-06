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

    sum : i64 = 0

    rows, _ := strings.split(string(data), "\n")
    operands : [dynamic][]i64
    for row in rows {
        line, _ := strings.split(row, " ")
        nums : [dynamic]i64
        i := 0
        for v in line {
            if len(v) == 0 {
                continue
            }
            if v[0] == '*' {
                mult : i64 = 1
                for op in operands {
                    mult *= op[i]
                }
                sum += mult
            }
            else if v[0] == '+' {
                for op in operands {
                    sum += op[i]
                }
            }
            else {
                v, _ := strconv.parse_i64(v)
                append(&nums, v)
            }
            i += 1
        }
        append(&operands, nums[:])
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
    sum : i64 = 0
    rows, _ := strings.split(string(data), "\n")
    runes : [dynamic][]rune
    for row in rows {
        append(&runes, utf8.string_to_runes(row))
    }
    nl := len(rows[0])
    nr := len(rows) - 1
    operands : [dynamic]i64
    for i := nl - 1; i >= 0; i -= 1 {
        operand : i64 = 0
        for j in 0..<nr-1 {
            if i < len(runes[j]) {
                v, ok := strconv.digit_to_int(runes[j][i])
                if ok {
                    operand *= 10
                    operand += i64(v)
                }
            }
        }
        if operand != 0 {
            append(&operands, operand)
        }
        if i >= len(runes[nr-1]) {
            continue
        }
        if runes[nr-1][i] == '+' {
            for op in operands {
                sum += op
            }
            clear(&operands)
        }
        else if runes[nr-1][i] == '*' {
            mult : i64 = 1
            for op in operands {
                mult *= op
            }
            sum += mult
            clear(&operands)
        }
    }

    fmt.println("sum:", sum)
}


main :: proc() {
    solve1("input")
    solve2("input")
}
