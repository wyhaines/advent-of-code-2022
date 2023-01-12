use std::collections::VecDeque;
use std::env;

struct NoSpaceLeftOnDevice {
    data: VecDeque<String>,
    directory_sizes: Vec<i32>,
}

impl NoSpaceLeftOnDevice {
    fn new(filename: &str) -> NoSpaceLeftOnDevice {
        let data = Self::parse_device_data(filename).unwrap();
        NoSpaceLeftOnDevice {
            data: data,
            directory_sizes: Vec::<_>::new(),
        }
    }

    fn parse_device_data(filename: &str) -> Option<VecDeque<String>> {
        let data = std::fs::read_to_string(filename).ok()?;
        Some(data.lines().map(String::from).collect())
    }

    fn run(&mut self) {
        let space_used = self.analyze_directory_contents();
        let space_needed = 30000000 - (70000000 - space_used);

        println!(
            "The size of the smalled directory that can be deleted: #{}",
            self.small_directory_to_delete(space_needed)
        );
    }

    fn small_directory_to_delete(&self, space_needed: i32) -> i32 {
        self.directory_sizes
            .iter()
            .filter(|&size| size >= &space_needed)
            .map(|size| *size)
            .min()
            .unwrap()
    }

    fn analyze_directory_contents(&mut self) -> i32 {
        let mut final_size = 0;

        while let Some(line) = self.data.pop_front() {
            let line_parts = line.split(" ").collect::<Vec<&str>>();
            match line_parts.as_slice() {
                ["$", "cd", ".."] => {
                    self.directory_sizes.push(final_size);
                    return final_size;
                }
                ["$", "cd", _] => {
                    final_size += self.analyze_directory_contents();
                }
                ["$", "ls"] => {}
                ["dir", _] => {}
                [file_size, _] => {
                    final_size += file_size.parse::<i32>().unwrap();
                }
                _ => {}
            }
        }
        final_size
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut filename = "input.txt";
    if let Some(arg) = args.get(1) {
        filename = arg;
    }

    NoSpaceLeftOnDevice::new(filename).run();
}
