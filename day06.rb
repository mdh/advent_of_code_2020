input = File.read('day6_input.txt')

# part 1
input.split(/\n\n/).map { |txt| txt.chars.grep(/\w/).uniq.size }.reduce :+

# part 2
input.split(/\n\n/).map { |txt| txt.strip.lines.map {|line| line.chars.grep(/\w/) }.reduce(:&).size }.reduce(:+)
