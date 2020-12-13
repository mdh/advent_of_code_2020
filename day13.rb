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
puts wait_time * bus

# part 2
def run(input)
  bus_times = input.lines.last.split(',').map.with_index { |bus, offset| [bus.to_i, offset] }.reject { |bus, _| bus == 0 }
  t = 0
  step = 1
  while (bus_time = bus_times.shift) do
    period, offset = bus_time
    while true
      if ((t + offset) % period == 0)
        break
      else
        t += step
      end
    end
    step *= period
  end
  t
end

puts run input
