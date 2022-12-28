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

        //CampCleanup { assignments }
        Self { assignments }
    }

    fn run(&self) {
        println!(
            "Of {} assignments, {} are redundant.",
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
        assignments
            .iter()
            .filter(|assignment| self.is_redundant(&assignment[0], &assignment[1]))
            .count()
    }

    fn is_redundant(&self, left: &Assignment, right: &Assignment) -> bool {
        let (smaller, larger) = self.sort_by_containment(left, right);
        smaller.start >= larger.start && smaller.end <= larger.end
    }

    fn sort_by_containment<'a>(
        &'a self,
        left: &'a Assignment,
        right: &'a Assignment,
    ) -> (&Assignment, &Assignment) {
        if left.start <= right.start && left.end >= right.end {
            (right, left)
        } else {
            (left, right)
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
