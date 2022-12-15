use std::fs;

fn main() {
    let mut the_most_calories: Vec<i32> = fs::read_to_string("input.txt")
        .unwrap()
        .split("\n\n")
        .map(|group| {
            group
                .trim()
                .split("\n")
                .map(|line| line.parse::<i32>().unwrap())
                .sum()
        })
        .collect::<Vec<_>>();
    the_most_calories.sort_by(|a, b| b.cmp(a));
    the_most_calories.truncate(3);

    print!(
        "{:?}\n{}\n",
        the_most_calories,
        the_most_calories.iter().sum::<i32>()
    );
}
