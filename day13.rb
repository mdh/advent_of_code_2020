input = File.read('day13_input.txt')

test_input = <<EOT
939
7,13,x,x,59,x,31,19
EOT

# part 1
timestamp = input.lines.first.to_i
buses     = input.lines.last.split(',').reject { |bus| bus == 'x' }.map &:to_i

answers =
  buses.map do |bus|
    earliest_time = nil
    times = (1..timestamp).each do |n|
      earliest_time = bus * n
      break if earliest_time > timestamp
    end
    [earliest_time, bus]
  end

earliest_time, bus = answers.sort_by(&:first).first
wait_time = earliest_time - timestamp
#puts wait_time * bus

# part 2
def run(test_input)
  pp bus_times = test_input.lines.last.split(',').map.with_index { |bus, offset| [bus.to_i, offset] }.reject { |bus, _| bus == 0 }
  first_bus = bus_times.first
  bus_times.sort_by!(&:first).reverse
  (0..200_000_000_000_000_0).each do |t|
    n = t * first_bus.first
    pp n if n % 1_000_000 == 0
    next if bus_times.any? { |bus, offset| (n + offset) % bus != 0 }
    puts n
    # 359050786332441954, too big
    # 41847000000
    # 12412000000
    break
  end
end

test_inputs = ['3,5', '67,7,59,61', '67,x,7,59,61', '67,7,x,59,61']
test_inputs.map do |test_input|
 run test_input
end

#run input
