# frozen_string_literal: true

class RuckSackn
  def initialize(filename)
    rucksacks = parse_rucksacks(filename)
    sum = rucksacks.map { |rucksack| item_priority(find_duplicates(*rucksack)) }.sum

    puts "Priority sum of all duplicated items: #{sum}"
  end

  def parse_rucksacks(filename)
    rucksacks = []
    File.read(filename).split("\n").each_slice(3) do |trio|
      rucksacks << trio
    end

    rucksacks
  end

  def find_duplicates(left, middle, right)
    left.split('') & middle.split('') & right.split('')
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
