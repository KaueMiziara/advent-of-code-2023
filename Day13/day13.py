import numpy as np

def read_input(file: str) -> list:
    with open(file, 'r') as input_file:
        input = [char for char in input_file.read().split("\n\n")]

    return input


def parse_pattern(pattern):
    rows = pattern.split('\n')
    rows = [row for row in rows if row]

    return np.array([[element == '#' for element in row] for row in rows])


def find_mirror(pattern, has_smudge=False):
    for row in range(1, pattern.shape[0]):
        image = pattern[row : 2 * row, :]
        object = pattern[row - image.shape[0] : row, :]

        if has_smudge:
            if np.sum(object != np.flip(image, axis=0)) == 1:
                return row
        elif np.array_equal(object, np.flip(image, axis=0)):
            return row

    return 0


if __name__ == "__main__":
    input = read_input("input.txt")

    patterns = list(map(parse_pattern, input))

    row_total = col_total = 0
    for pattern in patterns:
        row_total += find_mirror(pattern)
        col_total += find_mirror(pattern.T)
    print("Part 1 answer:", (100 * row_total + col_total))

    row_total = col_total = 0
    for pattern in patterns:
        row_total += find_mirror(pattern, True)
        col_total += find_mirror(pattern.T, True)
    print("Part 2 answer:", (100 * row_total + col_total))
