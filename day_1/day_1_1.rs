use std::fs;

fn main() {
    let the_most_calories: i32 = fs::read_to_string("input.txt")
        .unwrap()
        .split("\n\n")
        .map(|group| {
            group
                .trim()
                .split("\n")
                .map(|line| line.parse::<i32>().unwrap())
        })
        .map(|numbers| numbers.sum())
        .max()
        .unwrap();

    print!("{}\n", the_most_calories);
}
