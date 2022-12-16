# frozen_string_literal: true

class CheatAtRockPaperScissors
  def initialize(filename)
    plays = File.read(filename).split("\n").map { |line| line.split(' ') }

    score, wins, losses, draws = simulate_games(decode plays)

    puts "Wins: #{wins}"
    puts "Losses: #{losses}"
    puts "Draws: #{draws}"
    puts "Total Score: #{score}"
  end

  def decode(plays)
    plays.collect do |play|
      case play
      in ['A', 'X']
        %i[ROCK SCISSORS]
      in ['A', 'Y']
        %i[ROCK ROCK]
      in ['A', 'Z']
        %i[ROCK PAPER]
      in ['B', 'X']
        %i[PAPER ROCK]
      in ['B', 'Y']
        %i[PAPER PAPER]
      in ['B', 'Z']
        %i[PAPER SCISSORS]
      in ['C', 'X']
        %i[SCISSORS PAPER]
      in ['C', 'Y']
        %i[SCISSORS SCISSORS]
      in ['C', 'Z']
        %i[SCISSORS ROCK]
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
      in [:ROCK, :ROCK]
        draws += 1
        score += 4
      in [:ROCK, :PAPER]
        wins += 1
        score += 8
      in [:ROCK, :SCISSORS]
        losses += 1
        score += 3
      in [:PAPER, :ROCK]
        losses += 1
        score += 1
      in [:PAPER, :PAPER]
        draws += 1
        score += 5
      in [:PAPER, :SCISSORS]
        wins += 1
        score += 9
      in [:SCISSORS, :ROCK]
        wins += 1
        score += 7
      in [:SCISSORS, :PAPER]
        losses += 1
        score += 2
      in [:SCISSORS, :SCISSORS]
        draws += 1
        score += 6
      end
    end
    [score, wins, losses, draws]
  end
end

CheatAtRockPaperScissors.new(ARGV[0] || 'input.txt')
