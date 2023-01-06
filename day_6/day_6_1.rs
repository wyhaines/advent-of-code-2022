// use std::collections::HashSet; // Uncomment if trying the HashSet based solution.
use std::env;

struct TuningTrouble {
    data: String,
}

impl TuningTrouble {
    fn new(filename: &str) -> TuningTrouble {
        let data = Self::parse_packet_data(filename).unwrap();
        TuningTrouble { data }
    }

    fn parse_packet_data(filename: &str) -> Option<String> {
        let data = std::fs::read_to_string(filename).ok()?;
        Some(data)
    }

    fn run(&mut self) {
        println!(
            "The start of packet marker is at character #{}",
            self.find_start_of_packet()
        )
    }

    //###
    //
    // Variation 1 -- concise, ASCII-only, fastest
    //
    // This is the fastest Rust implementation. It is also the most concise. Kinda cool.
    //
    fn find_start_of_packet(&mut self) -> usize {
        self.data
            .as_bytes()
            .windows(4)
            .position(|window| {
                window
                    .iter()
                    .enumerate()
                    .all(|(idx, c)| !window[..idx].contains(c))
            })
            .unwrap()
            + 4
    }

    //###
    //
    // Variation 2 -- almost-the-most-concise, ASCII-only, slowest
    //
    // This is the slowest Rust implementation, but it is also the most concise.
    // It can borrow the `sliding_windows()` method and the `find_start_of_packet()`
    // method from variation 3 to become full-UTF8-safe, but it is still pretty slow,
    // particularly for Rust. Ruby can do full-UTF8-safe faster than this.
    //
    // fn no_duplicate_characters(&self, s: &[u8]) -> bool {
    //     let mut set = HashSet::new();
    //     for c in s {
    //         set.insert(c);
    //     }
    //     set.len() == s.len()
    // }
    //
    // fn find_start_of_packet(&mut self) -> usize {
    //     self.data
    //         .as_bytes()
    //         .windows(4)
    //         .position(|chunk| self.no_duplicate_characters(chunk))
    //         .unwrap()
    //         + 4
    // }

    //###
    //
    // Variation 3 -- very-not-concise, non-ASCII-safe, surprisingly fast
    //
    // It turns out that it is tricky to make a Rust implementation that is
    // safe for the full UTF-8 character set, for the simple reason that Rust
    // doesn't allow _character_ based indexing into strings. `foo[2..4]` returns
    // a _byte_ based slice, not a character slice, and `foo[3]` simply isn't allowed,
    // so it is extra work to build a sliding window of characters over a string.
    // This variation does that, and it is impressively faster than variation 2 because
    // of the use of a simple slice instead of a HashSet to determine if there are
    // duplicate characters.
    //
    // fn sliding_windows<'a>(&self, data: &'a str, size: usize) -> impl Iterator<Item = &'a str> {
    //     data.char_indices().flat_map(move |(from, _)| {
    //         data[from..]
    //             .char_indices()
    //             .skip(size - 1)
    //             .next()
    //             .map(|(to, chr)| &data[from..from + to + chr.len_utf8()])
    //     })
    // }
    //
    // fn no_duplicate_characters(&self, s: &str) -> bool {
    //     let chars = s.chars();
    //     let mut seen = ['\x00', '\x00', '\x00', '\x00'];
    //     let mut step = 0;
    //     for char in chars {
    //         if seen.contains(&char) {
    //             return false;
    //         }
    //         seen[step] = char;
    //         step += 1;
    //     }
    //
    //     true
    // }
    //
    // fn find_start_of_packet(&mut self) -> usize {
    //     let mut idx = 0;
    //     for window in self.sliding_windows(&self.data, 4) {
    //         if self.no_duplicate_characters(window) {
    //             return idx + 4;
    //         }
    //         idx += 1;
    //     }
    //
    //     0
    // }

    //###
    //
    // Variation 4 -- not concise, ASCII-only, third fastest
    //
    // This is the almost the fastest Rust implementation. None of the Rust variations
    // are as concise as what Crystal or Ruby are capable of, but this implementation is
    // very comparable to the second fastest Crystal implementation.
    //
    // fn no_duplicate_characters(&self, bytes: &[u8]) -> bool {
    //     !(bytes[0] == bytes[1]
    //         || bytes[0] == bytes[2]
    //         || bytes[0] == bytes[3]
    //         || bytes[1] == bytes[2]
    //         || bytes[1] == bytes[3]
    //         || bytes[2] == bytes[3])
    // }
    //
    // fn find_start_of_packet(&mut self) -> usize {
    //     self.data
    //         .as_bytes()
    //         .windows(4)
    //         .position(|window| self.no_duplicate_characters(window))
    //         .unwrap()
    //         + 4
    // }

    //###
    //
    // Variation 5 -- not concise, ASCII-only, second fastest
    //
    // This implementation is virtually identical to the fastest Crystal implementation.
    //
    // fn no_duplicate_characters(&self, idx: usize, bytes: &[u8]) -> bool {
    //     let mut seen = [bytes[idx], 0, 0, 0];
    //     let mut step = 1;
    //     while step < 4 {
    //         if seen.contains(&bytes[idx + step]) {
    //             return false;
    //         }
    //         seen[step] = bytes[idx + step];
    //         step += 1;
    //     }
    //
    //     true
    // }
    //
    // fn find_start_of_packet(&mut self) -> usize {
    //     self.data
    //         .as_bytes()
    //         .windows(4)
    //         .position(|window| self.no_duplicate_characters(0, window))
    //         .unwrap()
    //         + 4
    // }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut filename = "input.txt";
    if let Some(arg) = args.get(1) {
        filename = arg;
    }

    TuningTrouble::new(filename).run();
}
