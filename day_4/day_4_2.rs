use std::env;

struct CampCleanup {
    assignments: Vec<Vec<Assignment>>,
}

#[derive(Debug)]
struct Assignment {
    start: i32,
    end: i32,
}

impl CampCleanup {
    fn new(filename: &str) -> CampCleanup {
        let assignments = Self::parse_assignments(filename);

        CampCleanup { assignments }
    }

    fn run(&self) {
        println!(
            "Of {} assignments, {} overlap.",
            self.assignments.len(),
            self.count_redundant_assignments(&self.assignments)
        );
    }

    fn parse_assignments(filename: &str) -> Vec<Vec<Assignment>> {
        let text = std::fs::read_to_string(filename).unwrap();
        text.lines()
            .map(|line| {
                line.split(",")
                    .map(|assignment| {
                        let mut parts = assignment.split("-");
                        let min = parts.next().unwrap().parse().unwrap();
                        let max = parts.next().unwrap().parse().unwrap();
                        Assignment {
                            start: min,
                            end: max,
                        }
                    })
                    .collect::<Vec<_>>()
            })
            .collect::<Vec<_>>()
    }

    fn count_redundant_assignments(&self, assignments: &Vec<Vec<Assignment>>) -> usize {
        (*assignments)
            .iter()
            .filter(|assignment| self.any_overlap(&assignment[0], &assignment[1]))
            .count()
    }

    fn any_overlap(&self, left: &Assignment, right: &Assignment) -> bool {
        self.overlap(left, right) || self.overlap(right, left)
    }

    fn overlap(&self, left: &Assignment, right: &Assignment) -> bool {
        if (*left).start >= (*right).start && (*left).start <= (*right).end {
            true
        } else if (*left).end >= (*right).start && (*left).end <= (*right).end {
            true
        } else {
            false
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut filename = "input.txt";
    if let Some(arg) = args.get(1) {
        filename = arg;
    }

    CampCleanup::new(filename).run();
}
