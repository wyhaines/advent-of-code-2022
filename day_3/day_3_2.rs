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
    let sum: u32 = rucksacks
        .into_iter()
        .map(|rucksack| item_priority(find_duplicates(rucksack)))
        .sum();

    print!("Priority sum of all duplicated items: {}\n", sum);
}

fn parse_rucksacks(filename: &str) -> Vec<Vec<String>> {
    let text = fs::read_to_string(filename).unwrap();
    text.lines()
        .collect::<Vec<_>>()
        .chunks(3)
        .map(|chunk| {
            vec![
                chunk[0].to_string(),
                chunk[1].to_string(),
                chunk[2].to_string(),
            ]
        })
        .collect()
}

// fn parse_rucksacks(filename: &str) -> Vec<Vec<String>> {
//     let text = fs::read_to_string(filename).unwrap();
//     text.lines()
//         .collect::<Vec<_>>()
//         .chunks(3)
//         .map(|chunk| chunk.iter().map(|s| s.to_string()).collect())
//         .collect()
// }

fn find_duplicates(rucksack: Vec<String>) -> HashSet<char> {
    let mut left_set = HashSet::new();
    let mut middle_set = HashSet::new();
    let mut right_set = HashSet::new();

    rucksack[0].chars().for_each(|ch| {
        left_set.insert(ch);
    });

    rucksack[1].chars().for_each(|ch| {
        middle_set.insert(ch);
    });

    rucksack[2].chars().for_each(|ch| {
        right_set.insert(ch);
    });

    let intermediary = &left_set & &middle_set;

    &intermediary & &right_set
}

fn item_priority(items: HashSet<char>) -> u32 {
    items.iter().fold(0, |sum: u32, character| match character {
        'a'..='z' => sum + (*character as u32) - 96,
        'A'..='Z' => sum + (*character as u32) - 38,
        _ => sum,
    })
}
