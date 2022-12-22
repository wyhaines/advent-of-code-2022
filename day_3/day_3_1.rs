use std::collections::HashSet;
use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut filename = "input.txt";
    if let Some(arg) = args.get(1) {
        filename = arg;
    }
    let rucksacks = parse_rucksacks(filename);
    let sum: u32 = rucksacks.into_iter().map (|rucksack| item_priority(find_duplicates(rucksack))).sum();

    print!("Priority sum of all duplicated items: {}\n", sum);
}

fn parse_rucksacks(filename: &str) -> Vec<Vec<String>> {
    let text = fs::read_to_string(filename).unwrap();
    text.split("\n")
        .map(|line| {
            let middle = line.len() / 2;
            let left = line.chars().take(middle).collect::<String>();
            let right = line.chars().skip(middle).collect::<String>();
            vec![left.to_string(), right.to_string()]
        })
        .collect::<Vec<_>>()
}

fn find_duplicates(rucksack: Vec<String>) -> HashSet<char> {
    let mut left_set = HashSet::new();
    let mut right_set = HashSet::new();

    for ch in rucksack[0].chars() {
        left_set.insert(ch);
    }

    for ch in rucksack[1].chars() {
        right_set.insert(ch);
    }

    left_set.intersection(&right_set).cloned().collect()
}

fn item_priority(items: HashSet<char>) -> u32 {
    items.iter().fold(0, |sum: u32, character| match character {
        'a'..='z' => sum + (*character as u32) - 96,
        'A'..='Z' => sum + (*character as u32) - 38,
        _ => sum,
    })
}
