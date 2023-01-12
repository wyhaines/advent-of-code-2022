class NoSpaceLeftOnDevice
  @data = Deque(String).new

  def initialize(filename)
    parse_device_data(filename)
    @directory_sizes = [] of Int32
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

    while line = @data.shift?
      line_parts = line.split
      case {line_parts[0], line_parts[1], line_parts[2]?}
      when {"$", "cd", ".."}
        @directory_sizes << final_size
        return final_size
      when {"$", "cd", _}
        final_size += analyze_directory_contents
      when {"$", "ls", _}
      when {"dir", _, _}
      else
        final_size += line_parts.first.to_i
      end
    end

    final_size
  end

  def parse_device_data(filename)
    File.open(filename).each_line { |line| @data << line }
  end
end

NoSpaceLeftOnDevice.new(ARGV[0]? || "input.txt").run
