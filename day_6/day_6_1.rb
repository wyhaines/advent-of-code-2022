# frozen_string_literal: true

class TuningTrouble
  def initialize(filename)
    @data = parse_packet_data(filename)
  end

  def run
    puts "The start of packet marker is at character ##{find_start_of_packet}"
  end

  #####
  #
  # Variation 1 -- the fastest variation
  #
  # This version operates the sliding window on the input data, as a byte array,
  # only by passing the positional index to `no_duplicate_characters?` and not ever
  # creating subslices of the sliding windows.
  #
  def parse_packet_data(filename)
    File.read(filename).bytes
  end

  def no_duplicate_characters?(idx)
    !(@data[idx] == @data[idx + 1] ||
       @data[idx] == @data[idx + 2] ||
       @data[idx] == @data[idx + 3] ||
       @data[idx + 1] == @data[idx + 2] ||
       @data[idx + 1] == @data[idx + 3] ||
       @data[idx + 2] == @data[idx + 3])
  end

  def find_start_of_packet
    (@data.size - 4).times do |idx|
      return idx + 4 if no_duplicate_characters?(idx)
    end
    'No packet found'
  end

  #####
  #
  # Variation 2 -- concise, non-ASCII-safe, slow
  #
  # This variation is the most concise UTF-8-safe version. It is also incredibly slow,
  # but it isn't the slowest version!
  #
  # Sacrifice full UTF-8 safely and settle for ASCII only by changing one line:
  #    `@data.bytes.each_cons(4) do |chunk|`
  #
  # def parse_packet_data(filename)
  #   File.read(filename)
  # end
  #
  # def find_start_of_packet
  #   idx = 0
  #   @data.chars.each_cons(4) do |chunk|
  #     return idx + 4 if chunk.uniq == chunk
  #     idx += 1
  #   end
  #
  #   'No packet found'
  # end

  #####
  #
  # Variation 3 -- concise, non-ASCII-safe, slow
  #
  # This variation is nearly as concise as variation 2, but it is much faster.
  #
  # def parse_packet_data(filename)
  #   File.read(filename)
  # end
  #
  # def no_duplicate_characters?(chars)
  #   chars.split('').uniq.size == chars.size
  # end
  #
  # def find_start_of_packet
  #   (@data.size - 4).times do |idx|
  #     return idx + 4 if no_duplicate_characters?(@data[idx, 4])
  #   end
  #   'No packet found'
  # end

  #####
  #
  # Variation 4 -- pretty concise, non-ASCII-safe, slowest
  #
  # This is the slowest version that I have provided in Ruby. It is just brutal.
  #
  # def parse_packet_data(filename)
  #   File.read(filename)
  # end
  #
  # def no_duplicate_characters?(chars)
  #   chars.chars.to_set.size == chars_array.size
  # end
  #
  # def find_start_of_packet
  #   (@data.size - 4).times do |idx|
  #     return idx + 4 if no_duplicate_characters?(@data[idx, 4])
  #   end
  #   'No packet found'
  # end

  #####
  #
  # Variation 5 -- most concise, ASCII-only, pretty fast
  #
  # This is still very concise, but it is substantially faster than variations 2 or 3.
  #
  # def parse_packet_data(filename)
  #   File.read(filename).bytes
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
  #   'No packet found'
  # end

  #####
  #
  # Variation 6 -- fastest non-ASCII-safe version
  #
  # This version is the fastest that is safe to use with non-ASCII characters.

  # def parse_packet_data(filename)
  #   File.read(filename)
  # end
  #
  # def no_duplicate_characters?(chars)
  #   !( chars[0] == chars[1] ||
  #      chars[0] == chars[2] ||
  #      chars[0] == chars[3] ||
  #      chars[1] == chars[2] ||
  #      chars[1] == chars[3] ||
  #      chars[2] == chars[3] )
  # end
  #
  # def find_start_of_packet
  #   (@data.size - 4).times do |idx|
  #     return idx + 4 if no_duplicate_characters?(@data[idx, 4])
  #   end
  #   'No packet found'
  # end

  #####
  #
  # Variation 7 -- fastest ASCII-only version
  #
  # The only change is to have parse_packet_data return the data as a byte array.
  # This makes it much faster.
  #
  # def parse_packet_data(filename)
  #   File.read(filename).bytes
  # end
  #
  # def no_duplicate_characters?(chars)
  #   !( chars[0] == chars[1] ||
  #      chars[0] == chars[2] ||
  #      chars[0] == chars[3] ||
  #      chars[1] == chars[2] ||
  #      chars[1] == chars[3] ||
  #      chars[2] == chars[3] )
  # end
  #
  # def find_start_of_packet
  #   (@data.size - 4).times do |idx|
  #     return idx + 4 if no_duplicate_characters?(@data[idx, 4])
  #   end
  #   'No packet found'
  # end
end

TuningTrouble.new(ARGV[0] || 'input.txt').run
