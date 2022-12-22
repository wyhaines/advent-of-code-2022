# frozen_string_literal: true

class RuckSackn
  def initialize(filename)
    rucksacks = parse_rucksacks(filename)
    sum = rucksacks.map { |rucksack| item_priority(find_duplicates(*rucksack)) }.sum

    puts "Priority sum of all duplicated items: #{sum}"
  end

  def parse_rucksacks(filename)
    File.read(filename).split("\n").map do |line|
      middle = line.size / 2
      left = line[0..(middle - 1)]
      right = line[middle..]
      [left, right]
    end
  end

  def find_duplicates(left, right)
    left.split('') & right.split('')
  end

  def item_priority(items)
    items.reduce(0) do |sum, item|
      case item
      in ('a'..'z')
        sum += item.ord - 96
      in ('A'..'Z')
        sum += item.ord - 38
      end

      sum
    end
  end
end

RuckSackn.new(ARGV[0] || 'input.txt')
