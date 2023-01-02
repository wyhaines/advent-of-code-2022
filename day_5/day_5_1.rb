# frozen_string_literal: true

class SupplyStacks
  attr_accessor :stacks, :instructions

  def initialize(filename)
    @instructions = []

    parse_stacks(filename)
  end

  def run
    follow_instructions

    puts 'The final layout of the stacks:'
    pp stacks.reject(&:empty?)

    puts "\nThe crates on top of the stacks are: #{stacks.reject(&:empty?).map(&:last).join}"
  end

  def parse_stacks(filename)
    stack_spec, instructions_spec = File.read(filename).split("\n\n", 2).map do |lines|
      lines.split("\n")
    end

    stack_count = stack_spec.last.split(/\s+/).size
    @stacks = Array.new(stack_count) { [] }
    
    stack_spec[..-2].reverse_each do |crate_line|
      crates = crate_line.scan(/...\s?/)
      crates.each_with_index do |crate, idx|
        stacks[idx + 1] << crate[1] if crate[1].match?(/\w/)
      end
    end

    instructions_spec.each do |line|
      instructions << line.scan(/\d+/).map(&:to_i)
    end
  end

  def follow_instructions
    instructions.each do |instruction|
      count, from, to = instruction
      count.times { stacks[to].push stacks[from].pop }
    end
  end
end

SupplyStacks.new(ARGV[0] || 'input.txt').run
