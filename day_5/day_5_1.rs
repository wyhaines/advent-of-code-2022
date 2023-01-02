use std::env;

struct Instruction {
    count: usize,
    from: usize,
    to: usize,
}

struct SupplyStacks {
    stacks: Vec<Vec<char>>,
    instructions: Vec<Instruction>,
}

impl SupplyStacks {
    fn new(filename: &str) -> SupplyStacks {
        let (stacks, instructions) = Self::parse_stacks(filename).unwrap();

        SupplyStacks {
            stacks: stacks,
            instructions: instructions,
        }
    }

    fn run(&mut self) {
        self.follow_instructions();

        println!("{:#?}", self.stacks);
        println!("{}", self.skim_top_crates());
    }

    fn parse_stacks(filename: &str) -> Option<(Vec<Vec<char>>, Vec<Instruction>)> {
        let text = std::fs::read_to_string(filename).ok()?;
        let (stack_spec_str, instructions_spec_str) = text.split_once("\n\n")?;
        let (stack_spec_str, stack_labels) = stack_spec_str.rsplit_once("\n")?;
        let stack_spec = stack_spec_str.lines();
        let instructions_spec = instructions_spec_str.lines();
        let stack_count = stack_labels.split_whitespace().count();

        let mut stacks = vec![Vec::<char>::new(); stack_count + 1];

        for line in stack_spec.rev() {
            for (idx, payload) in line.chars().collect::<Vec<_>>().chunks(4).enumerate() {
                let cr8 = payload[1];
                if cr8.is_alphabetic() {
                    stacks[idx + 1].push(cr8);
                }
            }
        }

        // To use a Regular Expression here seems attractive, but it ends up being
        // more work than it is worth. In addition to needing a Cargo.toml, and having
        // to deal with crate dependencies in order to get access to the Regex crate,
        // the code ends up being no cleaner, and no shorter, between the `use regex::Regex;`
        // line at the beginning of the file to the syntax for declaring, using, and accessing
        // the regular expression and its matches:

        // let re = Regex::new(r"move (\d+) from (\w+) to (\w+)").unwrap();
        //
        // let mut instructions = Vec::<Instruction>::new();
        // for line in instructions_spec {
        //     if let Some(captures) = re.captures(line) {
        //         let instruction = Instruction {
        //             count: captures[1].parse().ok()?,
        //             from: captures[2].parse().ok()?,
        //             to: captures[3].parse().ok()?,
        //         };
        //         instructions.push(instruction);
        //     }
        // }

        let mut instructions = Vec::<Instruction>::new();
        for line in instructions_spec {
            let core_information = line.strip_prefix("move ")?;
            let (count, destination_information) = core_information.split_once(" from ")?;
            let (from, to) = destination_information.split_once(" to ")?;
            instructions.push(Instruction {
                count: count.parse().ok()?,
                from: from.parse().ok()?,
                to: to.parse().ok()?,
            });
        }

        Some((stacks, instructions))
    }

    fn follow_instructions(&mut self) {
        for instruction in &self.instructions {
            for _ in 0..instruction.count {
                let item = self.stacks[instruction.from].pop().unwrap();
                self.stacks[instruction.to].push(item);
            }
        }
    }

    fn skim_top_crates(&self) -> String {
        self.stacks
            .iter()
            .filter(|stack| !stack.is_empty())
            .map(|stack| *stack.last().unwrap())
            .collect()
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut filename = "input.txt";
    if let Some(arg) = args.get(1) {
        filename = arg;
    }

    SupplyStacks::new(filename).run();
}
