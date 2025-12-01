package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"
import "core:strconv"

solve1 :: proc(filename: string) {
    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.println("Cannot open the file!")
        return
    }
    defer delete(data, context.allocator)

    cursor := 50
    count := 0

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        runes := utf8.string_to_runes(line)
        amt, _ := strconv.parse_int(line[1:])
        cursor = (cursor + (amt if line[0] == 'R' else -amt)) % 100
        if cursor == 0 {
            count += 1
        }
    }
    fmt.println("Count:", count)
}

solve2 :: proc(filename: string) {
    data, ok := os.read_entire_file(filename)
    if !ok {
        fmt.println("Cannot open the file!")
        return
    }
    defer delete(data, context.allocator)

    cursor := 50
    count := 0

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        runes := utf8.string_to_runes(line)
        amt, _ := strconv.parse_int(line[1:])
        prev := cursor
        dir := 1 if line[0] == 'R' else -1
        for i in 0..<amt {
            cursor = (cursor + dir) % 100
            if cursor == 0 {
                count += 1
            }
        }
    }
    fmt.println("Count:", count)
}


main :: proc() {
    solve1("input")
    solve2("input")
}
