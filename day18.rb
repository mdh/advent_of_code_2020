#input = File.read('day18_input.txt')

test_input = <<EOT
1 + 2 * 3 + 4 * 5 + 6
EOT

# part 1
grand_total = test_input.strip.each_line.map do |line|
  operator = nil
  total    = nil
  line.split.map do |word|
    pp word
    case word
    when '+', '*' then operator = word
    else # number
      number = word.to_i
      if total.nil?
        total = number
      else
        total = total.send(operator, number)
      end
    end
  end
  total
end.reduce :*
puts grand_total
