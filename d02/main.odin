package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"
import "core:strconv"
import "core:math"

tenpow :: proc(pow: i64) -> i64 {
    result : i64 = 1
    for i in 0..<pow {
        result *= 10
    }
    return result
}

tenlog :: proc(val: i64) -> i64 {
    return i64(math.log10(f32(val)))
}

solve1 :: proc(filename: string) {
    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.println("Cannot open the file!")
        return
    }
    defer delete(data, context.allocator)

    sum : i64 = 0

    datastr := string(data)
    for str in strings.split(datastr, ",") {
        from, _, to := strings.partition(str, "-")

        fromi, _ := strconv.parse_i64(from, 10)
        toi, _ := strconv.parse_i64(to, 10)
        from_digits := len(from) / 2
        to_digits := len(to) / 2
        halfval, _ := strconv.parse_i64(from[:from_digits])
        for {
            val := halfval + halfval * tenpow(tenlog(halfval) + 1)
            if val > toi {
                break
            }
            halfval += 1
            if val>= fromi {
                sum += val
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
    sum : i64 = 0

    datastr := string(data)
    for str in strings.split(datastr, ",") {
        from, _, to := strings.partition(str, "-")

        fromi, _ := strconv.parse_i64(from, 10)
        toi, _ := strconv.parse_i64(to, 10)
        to_digits := (tenlog(toi) + 1) / 2
        fmt.println("For", str)
        m := make(map[i64]bool)
        defer delete(m)
        for ndigits in 1..=to_digits{
            start_on := tenpow(ndigits - 1)
            end_on := start_on * 10 - 1
            for i in start_on..=end_on {
                val := i
                for {
                    val = i + val * tenpow(ndigits)
                    if val > toi {
                        break
                    }
                    if val >= fromi && val <= toi && !(val in m) {
                        m[val] = true
                        sum += val
                        fmt.println("   id:", val)
                    }
                }
            }
        }
    }
    fmt.println("sum:", sum)
}


main :: proc() {
    solve1("input")
    solve2("input")
}
