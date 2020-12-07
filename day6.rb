input = File.read('day6_input.txt')

# part 1
input.split(/\n\n/).map { |txt| txt.chars.grep(/\w/).uniq.size }.reduce :+
