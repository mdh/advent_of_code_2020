@input = File.read('day8_input.txt')

# part 1
test_input =<<EOT
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
EOT

def program(input=@input)
  input.strip.lines.map do |line|
    operation, number = line.split
    number = number.to_i
    [operation, number]
  end
end

def run(prog)
  index = 0
  accumulator = 0
  while true
    operation, number = prog[index]
    prog[index] = 'infloop'
    case operation
    when 'nop'
      index += 1
    when 'jmp'
      index += number
    when 'acc'
      accumulator += number
      index += 1
    when 'infloop'
      puts "Infinite loop, accumulator: #{accumulator}, line: #{index + 1}"
      success = false
      break
    when nil
      # end of program
      puts "Program ended, accumulator: #{accumulator}"
      success = true
      break
    end
  end
  success
end

run program(test_input)
run program

# part 2

catch(:done) do
  [%w[jmp nop], %w[nop jmp]].each do |from, to|
    program.each.with_index do |_, index|
      test_prog = program
      if test_prog[index][0] == from
        test_prog[index][0] = to
        puts "Trying #{from} -> #{to} on line #{index + 1}"
        throw :done if run(test_prog)
      end
    end
  end
end
