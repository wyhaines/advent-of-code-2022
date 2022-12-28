class CampCleanup
  def initialize(filename)
    assignments = parse_assignments(filename)

    puts "Of #{assignments.size} assignments, #{count_redundant_assignments(assignments)} are redundant."
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
      redundant?(left, right)
    end.size
  end

  def redundant?(left, right)
    smaller, larger = sort_by_containment(left, right)
    smaller.min >= larger.min && smaller.max <= larger.max
  end

  def sort_by_containment(left, right)
    if left.min <= right.min && left.max >= right.max
      [right, left]
    else
      [left, right]
    end
  end
end

CampCleanup.new(ARGV[0]? || "input.txt")
