package miziara.kaue.aoc.day15

import java.io.File

fun main() {
    println("Part1 answer: ${part1()}")
}

fun part1() = AocHelper().inputData.sumOf { item -> AocHelper().hashAlgorithm(item) }

class AocHelper() {
    fun hashAlgorithm(input: String): Int {
        var result = 0

        for (char in input) {
            if (char != '\n' && char != ' ')
            result += char.code
            result *= 17
            result %= 256
        }

        return result
    }

    private val inputFile = File("input.txt").readText()
    val inputData = inputFile.split(",")
}
