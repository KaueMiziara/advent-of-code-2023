import numpy as np

def read_input(file: str) -> list:
    with open(file, 'r') as input_file:
        input_data = [char for char in input_file.read().split("\n\n")]

    return input_data


def parse_pattern(pattern):
    rows = pattern.split("\n")
    rows = [row for row in rows if row]

    return np.array([[el == "#" for el in row] for row in rows])


def find_mirror(pattern, with_smudge=False):
    for row in range(1, pattern.shape[0]):
        side2 = pattern[row : row + row, :]
        side1 = pattern[row - side2.shape[0] : row, :]

        if with_smudge:
            if np.sum(side1 != np.flip(side2, axis=0)) == 1:
                return row
        elif np.array_equal(side1, np.flip(side2, axis=0)):
            return row

    return 0


if __name__ == "__main__":
    input_data = read_input("input.txt")

    patterns = list(map(parse_pattern, input_data))

    row_total = col_total = 0
    for pattern in patterns:
        row_total += find_mirror(pattern)
        col_total += find_mirror(pattern.T)
    print("Summary of reflection lines:", (100 * row_total + col_total))

    row_total = col_total = 0
    for pattern in patterns:
        row_total += find_mirror(pattern, True)
        col_total += find_mirror(pattern.T, True)
    print("Summary of reflection lines (with smudges):", (100 * row_total + col_total))
