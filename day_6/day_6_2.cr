struct Slice(T)
  @[AlwaysInline]
  def unsafe_includes_in_window?(offset, size, value)
    size.times do |idx|
      return true if self.unsafe_fetch(offset + idx) == value
    end
    false
  end
end

class TuningTrouble
  def initialize(filename)
    @data = parse_packet_data(filename)
  end

  def run
    puts "The start of packet marker is at character ##{find_start_of_packet}"
  end

  @data : Bytes

  def parse_packet_data(filename)
    File.read(filename).to_slice
  end

  def no_duplicate_characters?(idx)
    step = 1
    while step < 14
      if @data.unsafe_includes_in_window?(idx, step, @data.unsafe_fetch(idx + step))
        return false
      end
      step += 1
    end

    true
  end

  def find_start_of_packet
    (@data.size - 14).times do |idx|
      return idx + 14 if no_duplicate_characters?(idx)
    end

    "No packet found"
  end
end

TuningTrouble.new(ARGV[0]? || "input.txt").run
