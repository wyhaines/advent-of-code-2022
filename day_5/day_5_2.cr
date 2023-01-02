class SupplyStacks
  property instructions = [] of Tuple(Int32, Int32, Int32)
  property stacks = [] of Array(Char)

  def initialize(filename)
    parse_stacks(filename)
  end

  def run
    follow_instructions

    puts "The final layout of the stacks:"
    pp stacks.reject(&.empty?)

    puts "\nThe crates on top of the stacks are: #{stacks.reject(&.empty?).map(&.last).join}"
  end

  def parse_stacks(filename)
    stack_spec, instructions_spec = File.read(filename).split("\n\n", 2).map do |lines|
      lines.split("\n")
    end

    stack_spec.last.rstrip.split(/\s+/).size.times { stacks << [] of Char }

    stack_spec[..-2].reverse_each do |crate_line|
      crates = crate_line.scan(/...\s?/).map(&.[0])
      crates.each_with_index do |crate, idx|
        stacks[idx + 1] << crate[1] if crate[1].letter?
      end
    end

    instructions_spec.each do |line|
      next if line.empty?
      count, from, to = line.scan(/\d+/).map(&.[0].to_i)
      instructions << {count, from, to}
    end
  end

  def follow_instructions
    instructions.each do |instruction|
      count, from, to = instruction
      stacks[to].concat stacks[from].delete_at(-count..)
    end
  end
end

SupplyStacks.new(ARGV[0]? || "input.txt").run
