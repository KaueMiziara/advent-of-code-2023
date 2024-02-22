import * as fs from 'fs';
import * as readline from 'readline';

// Input: time limit + goal distance
// You may press the button before start moving; each second increases the speed by one unit
// For part 2, the input is actually just one race(ignore the spaces between 'races')
// Answer: the number of ways you can beat the goal in the race.

class Race {
    time: number;
    goal: number;

    constructor(time: number, goal: number) {
        this.time = time;
        this.goal = goal;
    }
}

async function readInput(filePath: string): Promise<string[]> {
    const lines: string[] = [];

    const fileStream = fs.createReadStream(filePath);
    const rl = readline.createInterface({
        input: fileStream,
        crlfDelay: Infinity,
    });

    for await (const line of rl) {
        lines.push(line);
    }

    return lines;
}

function extractNumber(input: string): number {
    const matches = input.match(/\d+/g);

    if (matches) {
        const numbers: number[] = matches.map(Number);
        return Number(numbers.join(''));
    }
    return 0;
}

async function createRaces(filePath: string): Promise<Race[]> {
    var races: Race[] = [];

    var time: number;
    var goal: number;

    const input = await readInput(filePath);

    time = extractNumber(input[0]);
    goal = extractNumber(input[1]);

    races.push(new Race(time, goal));

    return races;
}

function waysToBeatGoal(race: Race): number {
    var waysToBeat: number = 0;

    for (var pressTime = 1; pressTime <= race.time; pressTime++) {
        const speed = race.time - pressTime;
        const distance = speed * pressTime;

        if (distance > race.goal) {
            waysToBeat++;
        }
    }

    return waysToBeat;
}

async function main() {
    var waysToBeatRaces: number[] = [];

    const races = await createRaces("input.txt");

    for (const race of races) {
        waysToBeatRaces.push(waysToBeatGoal(race));
    }

    const answer = waysToBeatRaces.reduce((acc, item) => acc * item, 1);
    console.log("Answer: " + answer);
}

main();
