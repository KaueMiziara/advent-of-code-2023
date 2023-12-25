use regex::Regex;
use std::{fs::File, io::Read};

fn main() {
    let input = read_input("input.txt");

    let hailstones = input
        .iter()
        .map(|line| Hailstone::try_from(line.as_str()).unwrap())
        .collect::<Vec<_>>();

    let mut intersections = 0;

    let min_coord = 200000000000000f64;
    let max_coord = 400000000000000f64;

    for point_a in 0..hailstones.len() {
        for point_b in (point_a + 1)..hailstones.len() {
            match hailstones[point_a].intersect(&hailstones[point_b]) {
                Some((x, y)) => {
                    let check_x = x >= min_coord && x <= max_coord;
                    let check_y = y >= min_coord && y <= max_coord;

                    if check_x && check_y {
                        intersections += 1;
                    }
                }
                None => (),
            }
        }
    }

    println!("Part 1 answer: {intersections}");
}

#[derive(Debug, Copy, Clone)]
struct Vec3D {
    x: f64,
    y: f64,
    z: f64,
}

impl Vec3D {
    pub fn new(x: f64, y: f64, z: f64) -> Self {
        Self { x, y, z }
    }

    pub fn coords(&self) -> (f64, f64, f64) {
        (self.x, self.y, self.z)
    }
}

#[derive(Debug)]
struct Hailstone {
    coordinate: Vec3D,
    velocity: Vec3D,
}

impl TryFrom<&str> for Hailstone {
    type Error = &'static str;
    fn try_from(value: &str) -> Result<Self, Self::Error> {
        let hailstone_regex =
            Regex::new(r"^(-?\d+), +(-?\d+), +(-?\d+) @ +(-?\d+), +(-?\d+), +(-?\d+)").unwrap();

        match hailstone_regex.captures(value) {
            Some(values) => {
                let x = values[1].parse::<f64>().unwrap();
                let y = values[2].parse::<f64>().unwrap();
                let z = values[3].parse::<f64>().unwrap();

                let coordinate = Vec3D::new(x, y, z);

                let x = values[4].parse::<f64>().unwrap();
                let y = values[5].parse::<f64>().unwrap();
                let z = values[6].parse::<f64>().unwrap();

                let velocity = Vec3D::new(x, y, z);

                Ok(Hailstone {
                    coordinate,
                    velocity,
                })
            }
            None => {
                println!("{value}");
                Err("Error defining Hailstone")
            }
        }
    }
}

impl Hailstone {
    fn gen_two_points(&self) -> (Vec3D, Vec3D) {
        let coords = self.coordinate;
        let veloc = self.velocity;

        let point_a = Vec3D {
            x: coords.x,
            y: coords.y,
            z: coords.z,
        };

        let point_b = Vec3D {
            x: coords.x + veloc.x,
            y: coords.y + veloc.y,
            z: coords.z + veloc.z,
        };

        (point_a, point_b)
    }

    fn slope_and_intersect(&self) -> (f64, f64) {
        let (point_a, point_b) = self.gen_two_points();

        let (x1, y1, _) = point_a.coords();
        let (x2, y2, _) = point_b.coords();

        let m = (y2 - y1) / (x2 - x1);

        let y_intercect = y1 - (m * x1);

        (m, y_intercect)
    }

    fn is_in_future(&self, x: f64, y: f64) -> bool {
        let coords = self.coordinate;
        let veloc = self.velocity;

        let curr_x = coords.x;
        let curr_y = coords.y;

        if veloc.x > 0.0 && curr_x > x {
            return false;
        }
        if veloc.x < 0.0 && curr_x < x {
            return false;
        }

        if veloc.y > 0.0 && curr_y > y {
            return false;
        }
        if veloc.y < 0.0 && curr_y < y {
            return false;
        }

        return true;
    }

    fn intersect(&self, other: &Self) -> Option<(f64, f64)> {
        let (point_a, point_c) = self.slope_and_intersect();
        let (point_b, point_d) = other.slope_and_intersect();

        if point_a == point_b {
            return None;
        }

        let x_intersect = (point_d - point_c) / (point_a - point_b);
        let y_intersect = (point_a * ((point_d - point_c) / (point_a - point_b))) + point_c;

        if !self.is_in_future(x_intersect, y_intersect) {
            None
        } else if !other.is_in_future(x_intersect, y_intersect) {
            None
        } else {
            Some((x_intersect, y_intersect))
        }
    }
}

fn read_input(filename: &str) -> Vec<String> {
    let mut file = File::open(filename).unwrap();

    let mut file_contents = String::new();

    file.read_to_string(&mut file_contents).unwrap();

    let mut lines: Vec<String> = file_contents
        .split("\n")
        .map(|s: &str| s.to_string())
        .collect();

    lines.remove(lines.len() - 1);
    lines
}
