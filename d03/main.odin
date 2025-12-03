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

solve1 :: proc(filename: string) {
    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.println("Cannot open the file!")
        return
    }
    defer delete(data, context.allocator)

    sum : int = 0

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        runes := utf8.string_to_runes(line)
        nbat := len(runes)
        largest := 0
        for i in 0..<nbat {
            idig, _ := strconv.digit_to_int(runes[i])
            for j in i+1..<nbat {
                jdig, _ := strconv.digit_to_int(runes[j])
                val := idig * 10 + jdig
                if val > largest {
                    largest = val
                }
            }
        }
        sum += largest
    }
    fmt.println("sum:", sum)
}

recurse_joltage :: proc(runes : []rune, lsofar, base : i64, start, depth: int) -> i64 {
    if depth == 0 {
        return base
    }
    ndig := len(runes)
    largest := lsofar
    mult := tenpow(depth-1)
    for i in start..<ndig-depth+1 {
        idig, _ := strconv.digit_to_int(runes[i])
        v := base + mult * i64(idig)
        mpossible := base + mult * i64(idig+1) - 1
        if mpossible < largest {
            continue
        }
        cval := recurse_joltage(runes, largest, v, i+1, depth-1)
        if cval > largest {
            largest = cval
        }
    }
    return largest
}

solve2 :: proc(filename: string) {
    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.println("Cannot open the file!")
        return
    }
    defer delete(data, context.allocator)
    sum : i64 = 0

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        runes := utf8.string_to_runes(line)
        nbat := len(runes)
        largest := recurse_joltage(runes, 0, 0, 0, 12)
        fmt.println("Largest", largest)
        sum += largest
    }
    fmt.println("sum:", sum)
}


main :: proc() {
    solve1("input")
    solve2("input")
}
