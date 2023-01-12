# frozen_string_literal: true

class NoSpaceLeftOnDevice
  def initialize(filename)
    @data = parse_device_data(filename)
    @directory_sizes = []
  end

  def run
    analyze_directory_contents
    puts "Sum of all directory sizes less than 100000: #{small_directories.sum}"
  end

  def small_directories
    @directory_sizes.select { |size| size <= 100000 }
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
