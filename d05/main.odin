package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"
import "core:strconv"
import "core:math"
import "core:slice"

tenpow :: proc(pow: int) -> i64 {
    result : i64 = 1
    for i in 0..<pow {
        result *= 10
    }
    return result
}

range :: struct {
    start: i64,
    finish: i64
}

sort_range :: proc(lhs, rhs: range) -> bool {
    return lhs.start < rhs.start
}

find_elem :: proc(r : range, v: i64) -> slice.Ordering {
    if r.start < v {
        return slice.Ordering.Less
    }
    else if r.start == v {
        return slice.Ordering.Equal
    }
    else {
        return slice.Ordering.Greater
    }
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
    procRanges := true
    ranges : [dynamic]range
    for row in rows {
        if len(row) == 0 {
            procRanges = false
            slice.sort_by(ranges[:], sort_range)
        }
        else {
            if procRanges {
                start, _, finish := strings.partition(row, "-")
                si, _ := strconv.parse_i64(start, 10)
                fi, _ := strconv.parse_i64(finish, 10)
                append(&ranges, range{si, fi})
            }
            else {
                val, _ := strconv.parse_i64(row, 10)
                idx, found := slice.binary_search_by(ranges[:], val, find_elem)
                if found {
                    sum += 1
                }
                else if idx > 0 && idx <= len(ranges) {
                    startfrom := idx - 1
                    for i := idx - 1; i >= 0; i -= 1 {
                        if ranges[i].start <= val && ranges[i].finish >= val {
                            sum += 1
                            break
                        }
                    }
                }
            }
        }
    }
    fmt.println("sum:", sum)
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
    sum : i64 = 0

    rows, _ := strings.split(string(data), "\n")
    procRanges := true
    ranges : [dynamic]range
    for row in rows {
        if len(row) == 0 {
            procRanges = false
            slice.sort_by(ranges[:], sort_range)
            // now merge!
            for i := 0; i < len(ranges); i += 1 {
                for j := i - 1; j >= 0; j -= 1 {
                    if ranges[j].finish >= ranges[i].start {
                        ranges[j].finish = ranges[i].finish if ranges[i].finish > ranges[j].finish else ranges[j].finish
                        ordered_remove(&ranges, i)
                        i -= 1
                        break // we found at least one merge
                    }
                }
            }
            for r in ranges {
                sum += r.finish - r.start + 1
            }
            break
        }
        else {
            start, _, finish := strings.partition(row, "-")
            si, _ := strconv.parse_i64(start, 10)
            fi, _ := strconv.parse_i64(finish, 10)
            append(&ranges, range{si, fi})
        }
    }
    fmt.println("sum:", sum)
}


main :: proc() {
    solve1("input")
    solve2("input")
}
