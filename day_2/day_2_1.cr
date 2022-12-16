class CheatAtRockPaperScissors
  def initialize(filename)
    plays = File.read(filename).split("\n").map { |line| line.split(" ") }

    score, wins, losses, draws = simulate_games(decode plays)

    puts "Wins: #{wins}"
    puts "Losses: #{losses}"
    puts "Draws: #{draws}"
    puts "Total Score: #{score}"
  end

  def decode(plays)
    plays.map do |play|
      case play
      when ["A", "X"]
        %i[ROCK ROCK]
      when ["A", "Y"]
        %i[ROCK PAPER]
      when ["A", "Z"]
        %i[ROCK SCISSORS]
      when ["B", "X"]
        %i[PAPER ROCK]
      when ["B", "Y"]
        %i[PAPER PAPER]
      when ["B", "Z"]
        %i[PAPER SCISSORS]
      when ["C", "X"]
        %i[SCISSORS ROCK]
      when ["C", "Y"]
        %i[SCISSORS PAPER]
      when ["C", "Z"]
        %i[SCISSORS SCISSORS]
      end
    end
  end

  def simulate_games(plays)
    score = 0
    wins = 0
    losses = 0
    draws = 0

    plays.each do |play|
      case play
      when [:ROCK, :ROCK]
        draws += 1
        score += 4
      when [:ROCK, :PAPER]
        wins += 1
        score += 8
      when [:ROCK, :SCISSORS]
        losses += 1
        score += 3
      when [:PAPER, :ROCK]
        losses += 1
        score += 1
      when [:PAPER, :PAPER]
        draws += 1
        score += 5
      when [:PAPER, :SCISSORS]
        wins += 1
        score += 9
      when [:SCISSORS, :ROCK]
        wins += 1
        score += 7
      when [:SCISSORS, :PAPER]
        losses += 1
        score += 2
      when [:SCISSORS, :SCISSORS]
        draws += 1
        score += 6
      end
    end
    [score, wins, losses, draws]
  end
end

CheatAtRockPaperScissors.new(ARGV[0]? || "input.txt")
