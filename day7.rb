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

bags.size - 1

# part 2
@rules = {}
input.lines.each do |line|
  k1, k2, _ = line.split(' ', 3)
  key = k1 + k2
  values = line.split(/bag[s]{0,1}/).map {|bag| bag.split[-3,3]}.compact.map { |number, *bag| [number, bag.join] }
  @rules[key] = values
end

def number_of_bags(bag)
  @rules[bag].map { |number, bag_name|
    bag_name == 'noother' ? 0 : number.to_i + (number.to_i * (number_of_bags(bag_name) ))
  }.reduce(:+)
end

number_of_bags('shinygold')
