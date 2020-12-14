input = File.read('day14_input.txt')

test_input = <<EOT
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
EOT

# part 1
mem = {}

def apply_mask(value, mask)
  bvalue = value.to_s(2).rjust(36, "0")
  mask.chars.map.with_index do |char, i|
    case char
    when 'X'
      bvalue[i]
    else
      char
    end
  end.join.to_i(2)
end

mask = nil
input.lines.each do |line|
  case line.strip
  when /mask/
    mask = line.split.last
  when /mem/
    _, pos, *_, value = line.split(/[\[\]=\s]/)
    mem[pos] = apply_mask(value.to_i, mask)
  end
end
p mem.values.sum

# part 2
test_input = <<EOT
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
EOT
mem = {}

def positions(pos, mask)
  bpos         = pos.to_i.to_s(2).rjust(36, '0')
  floats       = mask.chars.grep(/X/)
  combinations = 2 ** floats.size
  combinations.times.map do |index|
    index = index.to_s(2).rjust(floats.size, '0').chars
    mask.chars.map.with_index do |char, index2|
      case char
      when 'X' then index.shift
      when '1' then '1'
      when '0' then bpos[index2]
      else
        raise "invalid char: #{char}"
      end
    end.join.to_i 2
  end
end

mask = nil
input.lines.each do |line|
  case line.strip
  when /mask/
    mask = line.split.last
  when /mem/
    _, pos, *_, value = line.split(/[\[\]=\s]/)
    positions(pos, mask).each { |new_pos| mem[new_pos] = value.to_i }
  end
end
puts mem.values.sum

