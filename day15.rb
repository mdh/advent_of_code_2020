input = '16,1,0,18,12,14,19'

test_input = <<EOT
3,1,2
EOT

# part 1
numbers = input.split(',').map(&:to_i)
occurrences = Hash.new { 0 }
numbers.each { |n| occurrences[n] += 1 }
while numbers.size < 2020 do
  last_number = numbers.last
  new_number =
    if occurrences[last_number] == 1
      0
    else
      _, previous_turn = numbers.each.with_index.reverse_each.find do |number, turn|
        turn += 1
        number == last_number && turn < numbers.size
      end
      previous_turn += 1
      numbers.size - previous_turn
    end
  numbers << new_number
  occurrences[new_number] += 1
end
pp numbers.last

# part 2
numbers = input.split(',').map(&:to_i)
occurrences = Hash.new { [] }
numbers.each.with_index { |number, index| occurrences[number] = occurrences[number] << index }
while numbers.size < 30_000_000 do
  last_number = numbers.last
  new_number =
    if occurrences[last_number].size == 1
      0
    else
      prev, last = occurrences[last_number][-2,2]
      last - prev
    end
  occurrences[new_number] = occurrences[new_number] << numbers.size
  numbers << new_number
end
pp numbers.last

