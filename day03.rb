input = File.read('day3_input.txt').strip.lines.map &:strip

# part 1
input.find_all.with_index {|_, index| input[index + 1].to_s.chars[((index + 1) * 3) % 31] == "#"}.size

# part 2
[[1,1], [3,1], [5, 1], [7,1], [1,2]].map do |right, down|
  input.find_all.with_index {|_, index| input[index * down + down].to_s.chars[((index + 1) * right) % 31] == "#"}.size
end.inject(:*)
