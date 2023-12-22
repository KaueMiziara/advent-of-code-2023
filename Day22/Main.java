import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new FileReader("input.txt"));

        List<Brick> bricks = parseInput(br);

        settleBricks(bricks);

        HashMap<Brick, List<Brick>> supports = new HashMap<>();
        HashMap<Brick, List<Brick>> supportedBy = new HashMap<>();
        calculateSupportRelationships(bricks, supports, supportedBy);

        System.out.println(calculatePart1(bricks, supports, supportedBy));

        System.out.println(calculatePart2(bricks, supportedBy));
    }

    private static List<Brick> parseInput(BufferedReader br) throws IOException {
        Pattern pattern = Pattern.compile("(\\d+),(\\d+),(\\d+)~(\\d+),(\\d+),(\\d+)");
        String line;
        List<Brick> bricks = new ArrayList<>();
        char label = 'A';

        while ((line = br.readLine()) != null) {
            Matcher matcher = pattern.matcher(line);
            if (matcher.matches()) {
                int x1 = Integer.parseInt(matcher.group(1));
                int x2 = Integer.parseInt(matcher.group(4));
                int y1 = Integer.parseInt(matcher.group(2));
                int y2 = Integer.parseInt(matcher.group(5));
                int z1 = Integer.parseInt(matcher.group(3));
                int z2 = Integer.parseInt(matcher.group(6));
                bricks.add(new Brick(Math.min(x1, x2), Math.max(x1, x2),
                        Math.min(y1, y2), Math.max(y1, y2),
                        Math.min(z1, z2), Math.max(z1, z2), label++));
            } else {
                throw new IllegalArgumentException(line);
            }
        }
        return bricks;
    }

    private static void settleBricks(List<Brick> bricks) {
        boolean moved;
        do {
            moved = false;
            bricks.sort(Comparator.comparingInt((Brick b) -> b.z1));
            for (Brick moveCandidate : bricks) {
                if (moveCandidate.z1 == 1) {
                    continue;
                }
                boolean canMove = true;
                for (Brick blockCandidate : bricks) {
                    if (blockCandidate == moveCandidate) {
                        continue;
                    }
                    if (blockCandidate.blocks(moveCandidate)) {
                        canMove = false;
                        break;
                    }
                }
                if (canMove) {
                    moveCandidate.z1--;
                    moveCandidate.z2--;
                    moved = true;
                }
            }
        } while (moved);
    }

    private static void calculateSupportRelationships(List<Brick> bricks, HashMap<Brick, List<Brick>> supports,
                                                     HashMap<Brick, List<Brick>> supportedBy) {
        for (Brick brick : bricks) {
            for (Brick blockCandidate : bricks) {
                if (brick == blockCandidate) {
                    continue;
                }
                if (blockCandidate.blocks(brick)) {
                    supports.computeIfAbsent(blockCandidate, b -> new ArrayList<>()).add(brick);
                    supportedBy.computeIfAbsent(brick, b -> new ArrayList<>()).add(blockCandidate);
                }
            }
        }
    }

    private static int calculatePart1(List<Brick> bricks, HashMap<Brick, List<Brick>> supports,
                                       HashMap<Brick, List<Brick>> supportedBy) {
        int count = 0;

        for (Brick brick : bricks) {
            List<Brick> supportingBricks = supports.get(brick);

            if (supportingBricks != null && !supportingBricks.isEmpty()) {
                boolean canRemove = true;

                for (Brick supportingBrick : supportingBricks) {
                    if (supportedBy.get(supportingBrick).size() == 1) {
                        canRemove = false;
                        break;
                    }
                }
                if (canRemove) count++;
            } else count++;
        }
        return count;
    }

    private static long calculatePart2(List<Brick> bricks, HashMap<Brick, List<Brick>> supportedBy) {
        long sum = 0;

        for (Brick firstDisintegrated : bricks) {
            Set<Brick> moved = new HashSet<>();

            moved.add(firstDisintegrated);

            boolean moreMoved;
            do {
                moreMoved = false;

                for (Brick mightMove : bricks) {
                    if (moved.contains(mightMove) || mightMove.z1 == 1) {
                        continue;
                    }

                    List<Brick> supported = supportedBy.get(mightMove);
                    boolean stillSupported = false;

                    for (Brick supportingBrick : supported) {
                        if (!moved.contains(supportingBrick)) {
                            stillSupported = true;
                            break;
                        }
                    }

                    if (!stillSupported) {
                        moved.add(mightMove);
                        moreMoved = true;
                    }
                }
            } while (moreMoved);

            moved.remove(firstDisintegrated);
            sum += moved.size();
        }
        return sum;
    }

    static class Brick {
        private final char label;
        int x1, x2, y1, y2, z1, z2;

        public Brick(int x1, int x2, int y1, int y2, int z1, int z2, char label) {
            this.x1 = x1;
            this.x2 = x2;
            this.y1 = y1;
            this.y2 = y2;
            this.z1 = z1;
            this.z2 = z2;
            this.label = label;
        }

        @Override
        public String toString() {
            return String.format("%s %d,%d,%s~%d,%d,%d", label, x1, y1, z1, x2, y2, z2);
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof Brick)) return false;
            Brick brick = (Brick) o;

            return label == brick.label;
        }

        @Override
        public int hashCode() {
            return label;
        }

        public boolean blocks(Brick moveCandidate) {
            if (moveCandidate.z1 != z2 + 1) {
                return false;
            }

            for (int x = x1; x <= x2; x++) {
                for (int y = y1; y <= y2; y++) {
                    if (x >= moveCandidate.x1 && x <= moveCandidate.x2 &&
                            y >= moveCandidate.y1 && y <= moveCandidate.y2) {
                        return true;
                    }
                }
            }

            return false;
        }
    }
}
