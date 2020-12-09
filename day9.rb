input = File.read('day9_input.txt')

# part 1
test_input =<<EOT
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
EOT

data = input.strip.lines.map &:to_i
preamble = 25
index = 0
invalid_num = nil
while true
  window = data[index, preamble]
  check  = data[index + preamble]
  pp window, check
  if check.nil?
    puts "Done"
    break
  end
  if !window.combination(2).find { |n1, n2| n1 != n2 && n1 + n2 == check }
    puts "Invalid number #{check}"
    invalid_num = check
    break
  end
  index += 1
end

# part 2
test_input =<<EOT
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
EOT

data = input.strip.lines.map &:to_i
#invalid_num = 127
preamble = 25
catch :found do
  data.size.times do |start|
    puts start
    data.size.times do |size|
      window = data[start, size]
      sum = window.sum
      if sum < invalid_num
        next
      elsif sum == invalid_num
        puts "Found #{start}, #{size}"
        puts "Min: #{ window.min }"
        puts "Max: #{ window.max }"
        puts "Result: #{ window.min + window.max}"
        throw :found
      else
        break
      end
    end
  end
end
