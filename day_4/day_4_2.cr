class CampCleanup
  def initialize(filename)
    assignments = parse_assignments(filename)
    
    puts "Of #{assignments.size} assignments, #{count_redundant_assignments(assignments)} overlap."
  end

  def parse_assignments(filename)
    File.read(filename).split("\n").reject(&.empty?).map do |line|
      line.split(",").map do |assignment|
        min, max = assignment.split("-").map(&.to_i)
        (min..max)
      end
    end
  end

  def count_redundant_assignments(assignments)
    assignments.select do |(left, right)|
      any_overlap?(left, right)
    end.size
  end

  def any_overlap?(left, right)
    overlap?(left, right) || overlap?(right, left)
  end

  def overlap?(left, right)
    if left.min >= right.min && left.min <= right.max
      true
    elsif left.max >= right.min && left.max <= right.max
      true
    else
      false
    end
  end
end

CampCleanup.new(ARGV[0]? || "input.txt")