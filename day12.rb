input = File.read('day12_input.txt')

test_input = <<EOT
F10
N3
F7
R90
F11
EOT

commands =
  input.strip.lines.map do |line|
    line    = line.chars
    command = line.shift
    value   = line.join.to_i
    [command, value]
  end

# part 1
Ship = Struct.new(:direction, :north, :west) do
  def f(n)
    case direction
    when :north
      self.north += n
    when :south
      self.north -= n
    when :west
      self.west += n
    when :east
      self.west -= n
    else
      raise 'unknown direction'
    end
  end

  def n(value)
    self.north += value
  end

  def s(value)
    self.north -= value
  end

  def w(value)
    self.west += value
  end

  def e(value)
    self.west -= value
  end

  def r(degrees)
    (degrees / 90).times do
      self.direction = {
        north: :east,
        east:  :south,
        south: :west,
        west:  :north
      }[self.direction]
    end
  end

  def l(degrees)
    r(360 - degrees)
  end

  def manhattan
    north.abs + west.abs
  end
end

ship = Ship.new :east, 0, 0
commands.each do |command, value|
  ship.send command.downcase, value
end
puts ship.manhattan

# part 2
Ship2 = Struct.new(:waypoint, :north, :west) do
  def f(n)
    self.north += (n * waypoint.north)
    self.west  += (n * waypoint.west)
  end

  def n(value)
    waypoint.north += value
  end

  def s(value)
    waypoint.north -= value
  end

  def w(value)
    waypoint.west += value
  end

  def e(value)
    waypoint.west -= value
  end

  def r(degrees)
    (degrees / 90).times do
      self.waypoint = Waypoint.new(waypoint.west, -waypoint.north)
    end
  end

  def l(degrees)
    r(360 - degrees)
  end

  def manhattan
    north.abs + west.abs
  end
end

Waypoint = Struct.new(:north, :west)

ship = Ship2.new Waypoint.new(1, -10), 0, 0
commands.each { |command, value| ship.send command.downcase, value }
pp ship.manhattan
