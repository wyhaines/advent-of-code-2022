use std::env;
use std::fs;

enum Play {
    Rock,
    Paper,
    Scissors,
    None,
}

fn main() {
    let mut filename = "input.txt".to_string();
    if let Some(arg) = env::args().nth(1) {
        filename = arg;
    }
    let text = fs::read_to_string(filename).unwrap();
    let plays = text
        .split("\n")
        .map(|line| line.trim().split_whitespace().collect::<Vec<_>>())
        .collect::<Vec<_>>();

    let (score, wins, losses, draws) = simulate_games(decode(plays));

    println!(
        "Wins: {}\nLosses: {}\nDraws: {}\nTotal Score: {}\n",
        wins, losses, draws, score
    );
}

fn decode(plays: Vec<Vec<&str>>) -> Vec<Vec<Play>> {
    plays
        .into_iter()
        .map(|play|
        // Match on the slice of the given play
        match play.as_slice() {
            ["A", "X"] => vec![Play::Rock, Play::Scissors],
            ["A", "Y"] => vec![Play::Rock, Play::Rock],
            ["A", "Z"] => vec![Play::Rock, Play::Paper],
            ["B", "X"] => vec![Play::Paper, Play::Rock],
            ["B", "Y"] => vec![Play::Paper, Play::Paper],
            ["B", "Z"] => vec![Play::Paper, Play::Scissors],
            ["C", "X"] => vec![Play::Scissors, Play::Paper],
            ["C", "Y"] => vec![Play::Scissors, Play::Scissors],
            ["C", "Z"] => vec![Play::Scissors, Play::Rock],
            _ => vec![Play::None, Play::None]
        })
        .collect()
}

fn simulate_games(plays: Vec<Vec<Play>>) -> (i32, i32, i32, i32) {
    let mut score = 0;
    let mut wins = 0;
    let mut losses = 0;
    let mut draws = 0;

    for play in plays {
        match play.as_slice() {
            [Play::Rock, Play::Rock] => {
                draws += 1;
                score += 4;
            }
            [Play::Rock, Play::Paper] => {
                wins += 1;
                score += 8;
            }
            [Play::Rock, Play::Scissors] => {
                losses += 1;
                score += 3;
            }
            [Play::Paper, Play::Rock] => {
                losses += 1;
                score += 1;
            }
            [Play::Paper, Play::Paper] => {
                draws += 1;
                score += 5;
            }
            [Play::Paper, Play::Scissors] => {
                wins += 1;
                score += 9;
            }
            [Play::Scissors, Play::Rock] => {
                wins += 1;
                score += 7;
            }
            [Play::Scissors, Play::Paper] => {
                losses += 1;
                score += 2;
            }
            [Play::Scissors, Play::Scissors] => {
                draws += 1;
                score += 6;
            }
            _ => {}
        }
    }

    (score, wins, losses, draws)
}
