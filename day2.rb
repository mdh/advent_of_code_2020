input = File.read('day2_input.txt').strip.lines.map &:strip

# part 1
input.find_all {|l| min, max, char, pw = l.split(/[-\s:]{1,2}/); pw.chars.find_all {|c| c == char}.size.in?((min.to_i)..(max.to_i))}.size

# part 2
input.find_all {|l| min, max, char, pw = l.split(/[-\s:]{1,2}/); (pw[min.to_i-1] == char) ^ (pw[max.to_i-1] == char)}.size

