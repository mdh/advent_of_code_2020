values = File.read('day1_input.txt').strip.lines.map &:strip

values.find_all {|v| values.any? { |v2| values.any? { |v3| v3 + v2 + v == 2020 }}}.inject(&:*)
