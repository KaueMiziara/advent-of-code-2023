import * as fs from 'fs';
import * as readline from 'readline';

// Input: time limit + goal distance
// You may press the button before start moving; each second increases the speed by one unit
// Calculate the number of ways you can beat the goal in each race.
// Answer: multiply these numbers.

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

function extractNumbers(input: string): number[] {
    const matches = input.match(/\d+/g);

    if (matches) {
        const numbers: number[] = matches.map(Number);
        return numbers;
    }
    return [];
}

async function createRaces(filePath: string): Promise<Race[]> {
    var races: Race[] = [];

    var times: number[];
    var goals: number[];

    const input = await readInput(filePath);

    times = extractNumbers(input[0]);
    goals = extractNumbers(input[1]);

    for (const i in times) {
        races.push(new Race(times[i], goals[i]));
    }

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