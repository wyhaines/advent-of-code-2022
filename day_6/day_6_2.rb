# frozen_string_literal: true

class TuningTrouble
  def initialize(filename)
    @data = parse_packet_data(filename)
  end

  def run
    puts "The start of packet marker is at character ##{find_start_of_packet}"
  end

  def parse_packet_data(filename)
    File.read(filename).bytes
  end

  def no_duplicate_characters?(idx, window = 14)
    pos = 0
    while pos < window - 1
      comp_pos = pos + 1
      while comp_pos < window
        return false if @data[idx + pos] == @data[idx + comp_pos]

        comp_pos += 1
      end
      pos += 1
    end
    true
  end

  def find_start_of_packet
    (@data.size - 14).times do |idx|
      return idx + 14 if no_duplicate_characters?(idx)
    end

    'No packet found'
  end
end

TuningTrouble.new(ARGV[0] || 'input.txt').run
