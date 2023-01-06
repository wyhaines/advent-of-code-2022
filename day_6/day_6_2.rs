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

    fn no_duplicate_characters(&self, idx: usize, bytes: &[u8], seen: &mut [u8; 14]) -> bool {
        seen[0] = bytes[idx];
        for i in 1..14 {
            seen[i] = 0;
        }
        let mut step = 1;
        while step < 14 {
            if seen.contains(&bytes[idx + step]) {
                return false;
            }
            seen[step] = bytes[idx + step];
            step += 1;
        }

        true
    }

    fn find_start_of_packet(&mut self) -> usize {
        let bytes = self.data.as_bytes();
        let mut seen = [0_u8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        for idx in 0..(self.data.len() - 14) {
            if self.no_duplicate_characters(idx, &bytes, &mut seen) {
                return idx + 14;
            }
        }

        0
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut filename = "input.txt";
    if let Some(arg) = args.get(1) {
        filename = arg;
    }

    TuningTrouble::new(filename).run();
}
