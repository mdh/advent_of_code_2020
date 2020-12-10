# Add tally from ruby 2.7 (because i am lazy)
[Enumerable, Array].each do |clazz|
  clazz.class_eval do
    def tally
      each_with_object({}) do |v, acc|
        acc[v] ||= 0
        acc[v] += 1
      end
    end
  end
end

input = File.read('day10_input.txt')

# part 1
parsed = input.strip.lines.map(&:to_i).sort
data = [0] + parsed + [parsed.last + 3]
puts (data.size - 1).times.map { |i| data[i + 1] - data[i] }.tally.values.reduce :*

# part 2
list_of_ones = (parsed.size - 1).times.map { |i| parsed[i + 1] - parsed[i] }.join.split('3')
combinations = list_of_ones.map(&:size).find_all { |size| size > 0 }.map { |size| 2**(size-1) - size/4 }
puts combinations.inject(:*)

