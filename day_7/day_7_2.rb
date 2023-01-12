# frozen_string_literal: true

class NoSpaceLeftOnDevice
  def initialize(filename)
    @data = parse_device_data(filename)
    @directory_sizes = []
  end

  def run
    space_used = analyze_directory_contents
    space_needed = 30000000 - (70000000 - space_used)

    puts "The size of the smalled directory that can be deleted: #{small_directory_to_delete(space_needed)}"
  end

  def small_directory_to_delete(space_needed)
    @directory_sizes.select  {|size| size >= space_needed}.min
  end

  def analyze_directory_contents
    final_size = 0

    while line = @data.shift
      line_parts = line.split
      case line_parts
        in ['$', 'cd', '..']
          @directory_sizes << final_size
          return final_size
        in ['$', 'cd', _]
          final_size += analyze_directory_contents
        in [file_size, _]
          final_size += file_size.to_i
      end
    end

    final_size
  end

  def parse_device_data(filename)
    File.read(filename).lines
  end

end

NoSpaceLeftOnDevice.new(ARGV[0] || 'input.txt').run
