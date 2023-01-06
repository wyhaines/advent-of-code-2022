# This is only used in Variation 1.
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

  #####
  #
  # Variation 1 -- not-concise, ASCII-only, faster than Rust's fastest.
  #
  # Given a slice, if there were a method on Slice that could check a subset of the Slice
  # to see if a given value is in it, and if that method did that without doing anything
  # extra, and without copying any values, it should be quite fast. This solution uses the
  # method defined at the top of this file, `Slice#unsafe_includes_in_window?`, to do just that.
  # This is the power of Crystal. Anybody can implement a core method if there is a use case
  # for it.
  #
  @data : Bytes

  def parse_packet_data(filename)
    File.read(filename).to_slice
  end

  def no_duplicate_characters?(idx)
    step = 1
    while step < 4
      if @data.unsafe_includes_in_window?(idx, step, @data.unsafe_fetch(idx + step))
        return false
      end
      step += 1
    end

    true
  end

  def find_start_of_packet
    (@data.size - 4).times do |idx|
      return idx + 4 if no_duplicate_characters?(idx)
    end

    "No packet found"
  end

  #####
  #
  # Variation 2 -- not-concise, ASCII-only, blazingly fast
  #
  # This version creates a lookup table of seen characters as it works through
  # the sliding window. It's slow in Ruby (but you could port this implementation
  # easily enough if you want to try it), but it is very fast in Crystal.
  #
  # @data : Bytes
  #
  # def parse_packet_data(filename)
  #   File.read(filename).to_slice
  # end
  #
  # def no_duplicate_characters?(idx)
  #   seen = StaticArray(UInt8, 4).new(@data[idx])
  #   step = 1
  #   while step < 4
  #     if seen.includes?(@data[idx + step])
  #       return false
  #     end
  #     seen[step] = @data[idx + step]
  #     step += 1
  #   end
  #
  #   true
  # end
  #
  # def find_start_of_packet
  #   (@data.size - 4).times do |idx|
  #     return idx + 4 if no_duplicate_characters?(idx)
  #   end
  #
  #   "No packet found"
  # end

  #####
  #
  # Variation 3 -- concise, UTF-8-safe, slow
  #
  # Crystal wins for concise.
  #
  # @data : String
  #
  # def parse_packet_data(filename)
  #   File.read(filename)
  # end
  #
  # def find_start_of_packet
  #   @data.chars.each_cons(4, reuse: true).index! {|chunk| chunk.uniq == chunk} + 4
  # end

  #####
  #
  # Variation 4 -- concise, UTF-8-safe, slow
  #
  # This one is also quite terse, but it is pretty slow.
  #
  # @data : String
  #
  # def parse_packet_data(filename)
  #   File.read(filename)
  # end
  #
  # def no_duplicate_characters?(chars)
  #   chars.split("").uniq.size == chars.size
  # end
  #
  # def find_start_of_packet
  #   (@data.size - 4).times do |idx|
  #     return idx + 4 if no_duplicate_characters?(@data[idx, 4])
  #   end
  #
  #  "No packet found"
  # end

  #####
  #
  # Variation 5 -- pretty concise, UTF-8-safe, not-the-slowest
  #
  # This is the slowest variant in the Ruby file, but it is much faster in
  # Crystal, and it is not the slowest version in Crystal.
  #
  # @data : String
  #
  # def parse_packet_data(filename)
  #   File.read(filename)
  # end
  #
  # def no_duplicate_characters?(chars)
  #   chars.chars.to_set.size == chars.size
  # end
  #
  # def find_start_of_packet
  #   (@data.size - 4).times do |idx|
  #     return idx + 4 if no_duplicate_characters?(@data[idx, 4])
  #   end
  #
  #  "No packet found"
  # end

  #####
  #
  # Variation 6 -- most concise, ASCII-only, getting faster.
  #
  # This is a minor variation on the most concise version, but also like
  # Ruby, this one is much faster.
  #
  # @data : String
  #
  # def parse_packet_data(filename)
  #   File.read(filename)
  # end
  #
  # def no_duplicate_characters?(chars)
  #   chars.bytes.uniq.size == chars.size
  # end
  #
  # def find_start_of_packet
  #   (@data.size - 4).times do |idx|
  #     return idx + 4 if no_duplicate_characters?(@data[idx, 4])
  #   end
  #
  #  "No packet found"
  # end

  #####
  #
  # Variation 7 -- not-concise, UTF-8-safe, fast
  #
  # This is the fastest UTF-8-safe version, just as in Ruby.
  #
  # @data : String
  #
  # def parse_packet_data(filename)
  #   File.read(filename)
  # end
  #
  # def no_duplicate_characters?(idx)
  #   !( @data[idx] == @data[idx + 1] ||
  #      @data[idx] == @data[idx + 2] ||
  #      @data[idx] == @data[idx + 3] ||
  #      @data[idx + 1] == @data[idx + 2] ||
  #      @data[idx + 1] == @data[idx + 3] ||
  #      @data[idx + 2] == @data[idx + 3] )
  # end
  #
  # def find_start_of_packet
  #   (@data.size - 4).times do |idx|
  #     return idx + 4 if no_duplicate_characters?(idx)
  #   end
  #
  #  "No packet found"
  # end

  #####
  #
  # Variation 8 -- not-concise, ASCII-only, fast
  #
  # This is _almost_ the fastest ASCII-only version. It operates at
  # the byte level, avoids copying or duplicating data, and runs the
  # sliding window over the original buffer of input data that was
  # read from the file.
  #
  # @data : Bytes
  #
  # def parse_packet_data(filename)
  #   File.read(filename).to_slice
  # end
  #
  # def no_duplicate_characters?(idx)
  #   !( @data[idx] == @data[idx + 1] ||
  #      @data[idx] == @data[idx + 2] ||
  #      @data[idx] == @data[idx + 3] ||
  #      @data[idx + 1] == @data[idx + 2] ||
  #      @data[idx + 1] == @data[idx + 3] ||
  #      @data[idx + 2] == @data[idx + 3] )
  # end
  #
  # def find_start_of_packet
  #   (@data.size - 4).times do |idx|
  #     return idx + 4 if no_duplicate_characters?(idx)
  #   end
  #
  #  "No packet found"
  # end

end

TuningTrouble.new(ARGV[0]? || "input.txt").run
