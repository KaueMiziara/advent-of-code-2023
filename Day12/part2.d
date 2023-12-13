import std;

void main()
{
    long answer = 0;

    foreach (ref line; stdin.byLineCopy)
    {
        string[] parts = line.split;
        string pattern = parts[0];
        pattern = pattern.repeat(5).join('?');
        pattern ~= '.';
        int[] allowedLengths = parts[1].strip.split(",").map!(to!(int)).array;
        allowedLengths = allowedLengths.repeat(5).join;
        int patternLength = cast(int)pattern.length;
        int numAllowedLengths = cast(int)allowedLengths.length;
        allowedLengths ~= patternLength + 1;

        long[][][] combinations = calculateCombinations(pattern, allowedLengths, patternLength, numAllowedLengths);

        answer += combinations[patternLength][numAllowedLengths][0];
    }

    writeln(answer);
}

long[][][] calculateCombinations(string pattern, int[] allowedLengths, int patternLength, int numAllowedLengths)
{
    long[][][] combinations = new long[][][](patternLength + 1, numAllowedLengths + 2, patternLength + 2);

    combinations[0][0][0] = 1;

    foreach (int i; 0..patternLength)
    {
        foreach (int j; 0..numAllowedLengths + 1)
        {
            foreach (int prevLength; 0..patternLength + 1)
            {
                long currentCombination = combinations[i][j][prevLength];

                if (!currentCombination) continue;

                if (pattern[i] == '.' || pattern[i] == '?')
                {
                    if (prevLength == 0 || prevLength == allowedLengths[j - 1])
                        combinations[i + 1][j][0] += currentCombination;
                }

                if (pattern[i] == '#' || pattern[i] == '?')
                    combinations[i + 1][j + !prevLength][prevLength + 1] += currentCombination;
            }
        }
    }

    return combinations;
}
