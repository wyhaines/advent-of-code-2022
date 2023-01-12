class NoSpaceLeftOnDevice
  @data = Deque(String).new

  def initialize(filename)
    parse_device_data(filename)
    @directory_sizes = [] of Int32
  end

  def run
    space_used = analyze_directory_contents
    space_needed = 30000000 - (70000000 - space_used)

    puts "The size of the smalled directory that can be deleted: #{small_directory_to_delete(space_needed)}"
  end

  def small_directory_to_delete(space_needed)
    @directory_sizes.select { |size| size >= space_needed }.min
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
      when {_, _, _}
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
