package miziara.kaue.aoc.day15

import java.io.File

fun main() {
    println("Part 1 answer: ${AoCDay15().part1()}")
    println("Part 2 answer: ${AoCDay15().part2()}")
}

class AoCDay15 : AocHelper() {
    fun part1(): Int = inputData.sumOf { item -> hashAlgorithm(item) }

    fun part2(): Int = inputData.fold(Array(256) { mutableMapOf<String, Int>() }) { acc, line ->
        val (value, focalLength) = line.split("=", "-")
        when {
            "-" in line -> acc[hashAlgorithm(value)] -= value
            else -> acc[hashAlgorithm(value)][value] = focalLength.toInt()
        }
        acc
    }.withIndex().sumOf { (i, map) ->
        (i + 1) * map.values.withIndex().sumOf { (j, value) -> (j + 1) * value }
    }
}

open class AocHelper() {
    fun hashAlgorithm(input: String): Int {
        var result = 0

        for (char in input) {
            if (char != '\n' && char != ' ') {
                result += char.code
                result *= 17
                result %= 256
            }
        }

        return result
    }

    private val inputFile = File("input.txt").readText()
    val inputData: List<String> = inputFile.split(",")
}
