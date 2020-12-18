input = File.read('day18_input.txt')

#1 + 2 * 3 + 4 * 5 + 6
#1 + (2 * 3) + (4 * (5 + 6))
#(3 * 6) * 2 * 5 * 4 + (5 * 7 * 3 * 2 + 4 * (7 * 8 * 8 + 5 + 3)) + 4
#(9 + 7 + 3 * 9 * 7) + ((9 * 7 * 6 + 8) * 4 * 6 * 8)
test_input = <<EOT
5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
EOT

# part 1

def calculate(words)
  operator = '+'
  total    = 0
  stack = []
  words.each do |word|
    case word
    when '+', '*'
      if acc = stack.last
        acc <<= word
      else
        operator = word
      end
    when '('
      stack.push []
    when ')'
      result = calculate stack.pop
      if acc = stack.last
        acc <<= result
      else
        total = total.send operator, result
      end
    else # number
      if acc = stack.last
        acc <<= word
      else
        number = word.to_i
        total = total.send(operator, number)
      end
    end
  end
  total
end

def parse(line)
  line.split(/\b/)
    .flat_map {|w| w.split(/\s/) }
    .map(&:strip)
    .reject {|w| w.size == 0}
    .flat_map {|w| w =~ /[()]/ ? w.chars : w}
end

totals = input.strip.each_line.map do |line|
  total = calculate parse(line)
  puts "#{line} becomes #{total}"
  total
end

puts totals.reduce :+
