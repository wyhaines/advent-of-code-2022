# frozen_string_literal: true

class CampCleanup
  def initialize(filename)
    assignments = parse_assignments(filename)
    
    puts "Of #{assignments.size} assignments, #{count_redundant_assignments(assignments)} are redundant."
  end

  def parse_assignments(filename)
    File.read(filename).split("\n").map do |line|
      line.split(",").map do |assignment|
        min, max = assignment.split("-").map(&:to_i)
        (min..max)
      end
    end
  end

  def count_redundant_assignments(assignments)
    assignments.select do |left, right|
      redundant?(left, right)
    end.size
  end

  def redundant?(left, right)
    smaller, larger = sort_by_containment(left, right)
    smaller.min >= larger.min && smaller.max <= larger.max
  end

  #####
  #
  # The version below is arguably a better implementation, but take a look at the Rust version.
  # It felt like it was worth it to do it this way to get an opportunity to talk about one of the
  # trickier aspects of Rust's syntax, if the solution were structured as above instead of like this.
  # So....leaving this for reference, but keeping the above solution for the writeup.
  #
  #####
  #
  # def redundant?(left, right)
  #   if left.min <= right.min && left.max >= right.max
  #     true
  #   elsif left.min >= right.min && left.max <= right.max
  #     true
  #   else
  #     false  
  #   end
  # end
  #
  #####

  def sort_by_containment(left, right)
    if left.min <= right.min && left.max >= right.max
      [right, left]
    else
      [left, right]
    end
  end
end

CampCleanup.new(ARGV[0] || 'input.txt')