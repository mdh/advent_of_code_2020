input = File.read('day7_input.txt')

# part 1
@rules = {}
input.lines.each do |line|
  key, *values = line.split(/bag[s]{0,1}/).map {|bag| bag.split[-2,2]}.compact.map(&:join)
  @rules[key] = values
end

bags = ['shinygold']
while true do
  new_bags = @rules.find_all {|k, v| (v & bags).any? }.map(&:first)
  break if (new_bags - bags).size == 0
  bags |= new_bags
end
puts bags.size - 1
# part 2
