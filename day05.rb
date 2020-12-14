input = File.read('day5_input.txt').lines.map(&:strip)

# part 1
def bin2seat(bin)
  row  = bin[0,7].chars.map.with_index {|char, index| char == 'F' ? 0 : 1 }.join.to_i(2)
  seat = bin[7,3].chars.map.with_index {|char, index| char == 'L' ? 0 : 1 }.join.to_i(2)
  { row: row, seat: seat, id: (row*8+seat) }
end

input.map { |l| bin2seat(l)[:id]}.max

# part 2
(40..980).to_a - input.map { |l| bin2seat(l)[:id]}.sort
